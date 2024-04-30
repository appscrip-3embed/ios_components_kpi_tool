//
//  Networking.swift
//  DemoProject
//
//  Created by Appscrip 3Embed on 30/04/24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
}

struct NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetchData<T: Codable>(from urlString: String, responseType: T.Type, header: [String: String]? = nil) async throws -> T {
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            // Add headers if provided
            if let header = header {
                for (key, value) in header {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(for: request)
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            } catch {
                throw NetworkError.requestFailed
            }
        }
}
