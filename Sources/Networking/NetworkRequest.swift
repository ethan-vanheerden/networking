//
//  NetworkRequest.swift
//  Networking
//
//  Created by Ethan Van Heerden on 11/23/24.
//

import Foundation

/// Represents an HTTP request that can be sent.
public protocol NetworkRequest {
    /// The expected deserialized type of the network request.
    associatedtype Response: Decodable
    
    /// Creates a `URLRequest` used for the networking call.
    /// - Returns: The `URLRequest` to make
    /// - Throws: An error if creating the `URLRequest` fails
    func createRequest() throws -> URLRequest
}

public enum NetworkError: Error {
    case invalidURL
    case unsupportedResponse
}

/// Used for requests where we don't require/care about the response
public struct NoResponse: Codable {
    public init() { }
}
