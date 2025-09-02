//
//  File.swift
//  Neon
//
//  Created by Tyler Blackford on 2/19/25.
//

import Foundation
import AIProxy

public class NeonGPTManager {
    private static var partialKey: String = ""
    private static var serviceURL: String = ""
    private static var isConfigured: Bool = false
    
    public static func configure(partialKey: String, serviceURL: String) {
        self.partialKey = partialKey
        self.serviceURL = serviceURL
        self.isConfigured = true
    }
    
    public static func sendRequest(
        model: String,
        messages: [NeonGPTMessage],
        completion: @escaping (String?) -> Void
    ) {
        guard isConfigured else {
            fatalError("NeonGPTManager is not configured. Call configure(partialKey:serviceURL:) before sending requests.")
        }
        
        Task {
            do {
                let response = try await sendRequestAsync(model: model, messages: messages)
                DispatchQueue.main.async {
                    completion(response)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    private static func sendRequestAsync(
        model: String,
        messages: [NeonGPTMessage]
    ) async throws -> String {
        let openAIService = AIProxy.openAIService(
            partialKey: partialKey,
            serviceURL: serviceURL
        )
        
        let response = try await openAIService.chatCompletionRequest(body: .init(
            model: model,
            messages: wrapMessagesForAIProxy(messages: messages)
        ))
        
        return response.choices.first?.message.content ?? "No response"
    }
}

func wrapMessagesForAIProxy(messages: [NeonGPTMessage]) -> [OpenAIChatCompletionRequestBody.Message] {
    return messages.map { sender in
        switch sender {
        case .user(let text):
            return .user(content: .text(text))
        case .system(let text):
            return .system(content: .text(text))
        case .assistant(let text):
            return .assistant(content: .text(text))
        }
    }
}

public enum NeonGPTMessage {
    case user(message: String)
    case system(message: String)
    case assistant(message: String)
}
