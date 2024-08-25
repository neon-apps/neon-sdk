//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 24.08.2024.
//

import Foundation

public class NeonEachLabsManager {
    
    public static func startTask(apiKey: String, flowId: String, parameters: [String: Any], completion: @escaping (String?) -> Void) {
        let wrappedParameters = ["parameters": parameters]  // Wrap the parameters in another dictionary
        let endpoint = NeonEachLabsEndpoint.startTask(flowId: flowId, parameters: wrappedParameters, apiKey: apiKey)
        
        sendRequest(endpoint: endpoint) { json in
            guard let json = json else {
                completion(nil)
                return
            }
            let triggerId = self.parseTriggerId(from: json)
            completion(triggerId)
        }
    }
    
    public static func getStatus(apiKey: String, flowId: String, triggerId: String, completion: @escaping ([String:Any]?) -> Void) {
        let endpoint = NeonEachLabsEndpoint.getStatus(flowId: flowId, triggerId: triggerId, apiKey: apiKey)
        sendRequest(endpoint: endpoint) { json in
            completion(json)
        }
    }
    
    private static  func sendRequest(endpoint: NeonEachLabsEndpoint, completion: @escaping ([String : Any]?) -> Void) {
        let request = endpoint.request()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  let data = data else {
                completion(nil)
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            completion(json)
        }
        
        task.resume()
    }
    
    private static func parseTriggerId(from json: [String: Any]?) -> String? {
        return json?["trigger_id"] as? String
    }
}

enum NeonEachLabsEndpoint {
    
    case startTask(flowId: String, parameters: [String: Any], apiKey: String)
    case getStatus(flowId: String, triggerId: String, apiKey: String)
    
    var baseURL: String {
        return "https://flows.eachlabs.ai/api/v1/"
    }
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    var method: HTTPMethod {
        switch self {
        case .startTask:
            return .post
        case .getStatus:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .startTask(let flowId, _, _):
            return "\(flowId)/trigger"
        case .getStatus(let flowId, let triggerId, _):
            return "\(flowId)/executions/\(triggerId)"
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .startTask(_, _, let apiKey), .getStatus(_, _, let apiKey):
            return [
                "X-API-Key": apiKey,
                "Content-Type": "application/json"
            ]
        }
    }
    
    func request() -> URLRequest {
        guard let url = URL(string: baseURL + path) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        switch self {
        case .startTask(_, let parameters, _):
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        case .getStatus:
            break
        }
        
        return request
    }
}
