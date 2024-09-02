//
//  NeonAppTracking.swift
//
//
//  Created by Tuna Öztürk on 1.09.2024.
//


import Foundation
import UIKit

class NeonAppTracking {

    private static let baseURL: String = "https://web.paywaller.io"
    
    // Set the environment based on the build configuration
    private static let environment: String = {
        #if DEBUG
        return "Sandbox"
        #else
        return "Production"
        #endif
    }()

    private static var bundleID: String {
        guard let id = Bundle.main.bundleIdentifier else {
            fatalError("Bundle Identifier is necessary but could not be accessed.")
        }
        return id
    }

    private static var deviceID: String {
        guard let id = UIDevice.current.identifierForVendor?.uuidString else {
            fatalError("Device Identifier is necessary but could not be accessed.")
        }
        return id
    }

    private static var appName: String {
        guard let name = Bundle.main.infoDictionary?["CFBundleName"] as? String else {
            fatalError("App Name is necessary but could not be accessed.")
        }
        return name
    }

    private static let deviceModel: String = NeonDeviceManager.currentDeviceModel.stringValue

    static func createDevice(completion : (() -> ())? = nil) {
        let endpoint = "/api/v1/devices/create"
        let currentDate = Date().returnString(format: "MM/dd/yyyy hh:mm:ss", timeZone: "America/New_York")
        let parameters: [String: Any] = [
            "bundle_id": bundleID,
            "device_id": deviceID,
            "app_name": appName,
            "device_model": deviceModel,
            "created_at": currentDate,
            "environment": environment
        ]
        makeRequest(endpoint: endpoint, parameters: parameters, completion: completion)
    }

    static func updateIdfa(idfa: String) {
        let endpoint = "/api/v1/devices/update"
        let parameters: [String: Any] = [
            "bundle_id": bundleID,
            "device_id": deviceID,
            "idfa": idfa,
            "environment": environment
        ]
        makeRequest(endpoint: endpoint, parameters: parameters)
    }

    static func trackTrialStart() {
        let endpoint = "/api/v1/events/trial-start"
        let parameters: [String: Any] = [
            "bundle_id": bundleID,
            "device_id": deviceID,
            "environment": environment
        ]
        makeRequest(endpoint: endpoint, parameters: parameters)
    }
    
    static func trackSession() {
        let endpoint = "/api/v1/events/track-Session"
        let parameters: [String: Any] = [
            "bundle_id": bundleID,
            "device_id": deviceID,
            "environment": environment
        ]
        makeRequest(endpoint: endpoint, parameters: parameters)
    }
    static func trackTrialConversion() {
        let endpoint = "/api/v1/events/trial-conversion"
        let parameters: [String: Any] = [
            "bundle_id": bundleID,
            "device_id": deviceID,
            "environment": environment
        ]
        makeRequest(endpoint: endpoint, parameters: parameters)
    }

    static func trackDirectSubscription() {
        let endpoint = "/api/v1/events/direct-subscription"
        let parameters: [String: Any] = [
            "bundle_id": bundleID,
            "device_id": deviceID,
            "environment": environment
        ]
        makeRequest(endpoint: endpoint, parameters: parameters)
    }

    static func trackPaywallView() {
        let endpoint = "/api/v1/events/paywall-view"
        let parameters: [String: Any] = [
            "bundle_id": bundleID,
            "device_id": deviceID,
            "environment": environment
        ]
        makeRequest(endpoint: endpoint, parameters: parameters)
    }

    static func trackOnboardingCompletion() {
        let endpoint = "/api/v1/events/onboarding-completion"
        let parameters: [String: Any] = [
            "bundle_id": bundleID,
            "device_id": deviceID,
            "environment": environment
        ]
        makeRequest(endpoint: endpoint, parameters: parameters)
    }

    private static func makeRequest(endpoint: String, parameters: [String: Any], completion : (() -> ())? = nil) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            fatalError("The URL could not be formed. Ensure the baseURL is correct.")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            fatalError("Failed to serialize JSON for the request.")
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let completion{
                completion()
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                        print("JSON Response: \(json)")
                    } else {
                        print("Invalid JSON response")
                    }
                } else {
                    print("No data returned")
                }
            }
        }

        task.resume()
    }
}

