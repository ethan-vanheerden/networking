//
//  URLRequestBuilder.swift
//  Networking
//
//  Created by Ethan Van Heerden on 11/23/24.
//

import Foundation

/// Utility class to build Apple's `URLRequest` in a more convenient way.
public final class URLRequestBuilder {
    private var request: URLRequest
    
    public init(url: URL) {
        self.request = URLRequest(url: url)
    }
    
    /// Returns the built `URLRequest` from the chained operations.
    /// - Returns: The built request
    public func build() -> URLRequest {
        return request
    }
    
    /// Sets the HTTP method of the request.
    /// - Parameter method: The `HTTPMethod` for the request
    /// - Returns: The same class instance to make method chaining possible
    public func setHTTPMethod(_ method: HTTPMethod) -> Self {
        request.httpMethod = method.rawValue
        return self
    }
    
    /// Sets the content type of the request to JSON.
    /// - Returns: The same class instance to make method chaining possible
    public func setJSONContent() -> Self {
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return self
    }
    
    /// Sets a Bearer Auth token in the request header.
    /// - Parameter authToken: The auth token to set
    /// - Returns: The same class instance to make method chaining possible
    public func setBearerAuth(authToken: String) -> Self {
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return self
    }
    
    /// Sets HTTP headers.
    /// **NOTE**: To set an `application/json` value for the `Content-Type` field,
    /// use the `setJSONContent()` convenience method.
    /// **NOTE** To set a Bearer Auth value for the `Authorization` field,
    /// use the `setBearerAuth(authToken:)` convenience method.
    /// - Parameter headers: A map of header field name to it's desired value
    /// - Returns: The same class isntance to make method chaining possible
    public func setHeaders(headers: [String: String]) -> Self {
        for (headerName, headerValue) in headers {
            request.setValue(headerValue, forHTTPHeaderField: headerName)
        }
        return self
    }
    
    /// Sets the HTTP request body to an `Encodable` type.
    /// - Parameter body: The object to set the body for
    /// - Returns: The same class instance to make method chaining possible
    public func setBody(_ body: Encodable) -> Self {
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
            return self
        } catch {
            return self
        }
    }
}
