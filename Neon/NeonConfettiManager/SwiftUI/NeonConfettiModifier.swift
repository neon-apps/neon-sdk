// The MIT License (MIT)
// Copyright © 2021 Ivan Vorobei (hello@ivanvorobei.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// Thanks for @gongzhang for PR!

#if canImport(SwiftUI)
import SwiftUI

/// An empty placeholder view that used to retrieve current window and trigger confetti.
@available(iOS 13.0, tvOS 13.0, *)
struct ConfettiPlaceholderView: UIViewRepresentable {
    
    @Binding var isPresented: Bool
    
    var animation: NeonConfettiAnimation
    var particles: [NeonConfettiParticle]
    var duration: TimeInterval?
    
    func makeUIView(context: Context) -> UnderlyingView {
        UnderlyingView(isPresented: $isPresented)
    }
    
    func updateUIView(_ view: UnderlyingView, context: Context) {
        view.animation = animation
        view.particles = particles
        view.duration = duration
        view.particleConfig = context.environment.confettiParticlesConfiguration
        
        if isPresented && !view.isReleasesParticles {
            view.play()
            
        } else if !isPresented && view.isReleasesParticles {
            view.stop()
        }
    }
    
    class UnderlyingView: UIView {
        
        var isPresented: Binding<Bool>
        
        var animation: NeonConfettiAnimation = .centerWidthToDown
        var particles: [NeonConfettiParticle] = []
        var duration: TimeInterval? = nil
        var particleConfig: NeonConfettiParticlesConfig = .defaultValue
        
        private(set) var isReleasesParticles: Bool
        
        init(isPresented: Binding<Bool>) {
            self.isPresented = isPresented
            isReleasesParticles = false
            super.init(frame: .zero)
            backgroundColor = .clear
            isUserInteractionEnabled = false
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func play() {
            isReleasesParticles = true
            
            NeonConfettiConfiguration.particlesConfig = particleConfig
            
            if let duration = duration {
                NeonConfettiManager.startAnimating(animation,
                                          particles: particles,
                                          duration: duration,
                                          in: self.window)
                
                delay(duration) { [weak self] in
                    self?.stop()
                }
            } else {
                NeonConfettiManager.startAnimating(animation,
                                          particles: particles,
                                          in: self.window)
            }
        }
        
        func stop() {
            isReleasesParticles = false
            NeonConfettiManager.stopAnimating()
            isPresented.wrappedValue = false
        }
    }
    
}

@available(iOS 13.0, *)
extension NeonConfettiParticlesConfig: EnvironmentKey {
    public static let defaultValue: Self = .init()
}

@available(iOS 13.0, tvOS 13.0, *)
extension EnvironmentValues {
    public var confettiParticlesConfiguration: NeonConfettiParticlesConfig {
        get { self[NeonConfettiParticlesConfig.self] }
        set { self[NeonConfettiParticlesConfig.self] = newValue }
    }
}

@available(iOS 13.0, tvOS 13.0, *)
extension View {
    
    /**
     NeonConfettiManager: Start animating with selected animation and particles style.
     
     - parameter isPresented: A boolean binding used to start/stop animation.
     - parameter animation: Kind of animation, position and direction of particles.
     - parameter particles: Particles style. Can be custom image.
     - parameter duration: Automatically stop animation after this time interval.
     */
    public func confetti(isPresented: Binding<Bool>, animation: NeonConfettiAnimation, particles: [NeonConfettiParticle], duration: TimeInterval?) -> some View {
        self.background(
            ConfettiPlaceholderView(isPresented: isPresented, animation: animation, particles: particles, duration: duration)
                .allowsHitTesting(false)
        )
    }
    
    public func confettiParticle<T>(_ keyPath: WritableKeyPath<NeonConfettiParticlesConfig, T>, _ value: T) -> some View {
        self.transformEnvironment(\.confettiParticlesConfiguration) {
            $0[keyPath: keyPath] = value
        }
    }
}
#endif
