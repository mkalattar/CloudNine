//
//  NetworkManager.swift
//  CloudNine
//
//  Created by Mohamed Attar on 25/03/2025.
//

import Foundation
import Combine
import Foundation

// MARK: - Network Protocols
protocol NetworkManagerProtocol {
    func performRequest<T: Decodable>(with networkBuilder: NetworkRequestBuilder, dataType: T.Type) async throws -> T?
}

protocol NetworkBuilderProtocol {
    func set(urlPath: URLPaths) -> Self
    func set(httpMethod: HTTPMethod) -> Self
    func addQueryParameters(_ parameters: [String: String]) -> Self
    func addHeaders(_ headers: [String: String]) -> Self
}

// MARK: - Enums
enum URLPaths: String {
    case products = "/products"
}

enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
}

enum CloudNineError: LocalizedError {
    case invalidURL
    case invalidServer(statusCode: Int)
    case decodingError(underlying: Error)
    case badRequest
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL provided is invalid."
        case .invalidServer(let statusCode):
            return "Server returned an invalid response with status code: \(statusCode)."
        case .decodingError(let underlying):
            return "Failed to decode response: \(underlying.localizedDescription)"
        case .badRequest:
            return "Invalid request. Please check your parameters."
        case .unknownError:
            return "Something wrong happened, Retry again."
        }
    }
}

// MARK: - Network Request Builder
class NetworkRequestBuilder: NetworkBuilderProtocol {
    private let baseURL = "https://fakestoreapi.com"
    private var urlPath: URLPaths?
    private var httpMethod: HTTPMethod = .get
    private var queryParams: [String: String] = [:]
    private var headers: [String: String] = [:]
    
    func set(urlPath: URLPaths) -> Self {
        self.urlPath = urlPath
        return self
    }
    
    func set(httpMethod: HTTPMethod) -> Self {
        self.httpMethod = httpMethod
        return self
    }
    
    func addQueryParameters(_ parameters: [String: String]) -> Self {
        queryParams.merge(parameters) { _, new in new }
        return self
    }
    
    func addHeaders(_ headers: [String: String]) -> Self {
        self.headers.merge(headers) { _, new in new }
        return self
    }
    
    func buildRequest() throws -> URLRequest {
        guard let urlPath else { throw CloudNineError.invalidURL }
        
        var components = URLComponents(string: baseURL + urlPath.rawValue)
        if !queryParams.isEmpty {
            components?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components?.url else { throw CloudNineError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        return request
    }
}

// MARK: - Network Manager

class NetworkManager: NetworkManagerProtocol {
    private let session: URLSession
    private var isFetchingTracker: [String: Bool] = [:] // Handles not calling the same API while it's fetching still.
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func performRequest<T: Decodable>(with networkBuilder: NetworkRequestBuilder, dataType: T.Type) async throws -> T? {
        let request = try networkBuilder.buildRequest()

        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw CloudNineError.invalidServer(statusCode: -1)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw CloudNineError.invalidServer(statusCode: httpResponse.statusCode)
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw CloudNineError.decodingError(underlying: error)
            }
            
        } catch {
            throw CloudNineError.unknownError
        }
    }
}
