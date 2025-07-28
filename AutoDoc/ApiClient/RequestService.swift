//
//  RequestService.swift
//  AutoDoc
//
//  Created by Искандер Ситдиков on 14.07.2025.
//

import Foundation

final class RequestService {
    private struct Constants {
        static let baseURL = "https://webapi.autodoc.ru/api"
    }
    
    let endpoint: AutoDocEndpoint
    
    private let pathComponents: [String]
    
    private var urlString: String {
        var string = Constants.baseURL
        string += "/"
        string += endpoint.rawValue
        
        if pathComponents.isNotEmpty {
            pathComponents.forEach({
                string += "/\($0)"
            })
        }
        return string
    }
    
    public let httpMethod = "GET"
    
    public var url: URL? {
        return URL(string: urlString)
    }
    
    public init(endpoint: AutoDocEndpoint, pathComponents: [String] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
    }
    
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseURL) {
            return nil
        }
        
        let trimmed = string.replacingOccurrences(of: Constants.baseURL + "/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if components.isNotEmpty {
                let endpointString = components[0]
                var pathComponents = [String]()
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let endpoint = AutoDocEndpoint(rawValue: endpointString) {
                    self.init(endpoint: endpoint, pathComponents: pathComponents)
                }
            }
        }
        return nil
    }
}
