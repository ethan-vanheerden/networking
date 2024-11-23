//
//  MockAPIInteractor.swift
//  Networking
//
//  Created by Ethan Van Heerden on 11/23/24.
//

@testable import Networking

// MARK: - MockAPIInteractor

/// Mocked implementation of `APIInteractor` to aid in testability.
public final class MockAPIInteractor: APIInteracting {
    public init() { }
    
    // MARK: - Mock Properties
    
    // List of mock responses in the event multiple network requests are called in a row
    public var mockResponses: [MockResponse] = []
    public var shouldThrow = false
    public private(set) var calledPerformRequest = false
    
    // MARK: - performRequest
    
    public func performRequest<R: NetworkRequest>(with: R) async throws -> NetworkResponse<R> {
        calledPerformRequest = true
        
        guard !shouldThrow,
              let mockResponse = mockResponses.first,
              let mockResponseBody = mockResponse.responseBody as? R.Response else { throw MockAPIError.someError }
        
        mockResponses.removeFirst()
        
        return NetworkResponse(requestType: R.self,
                               statusCode: mockResponse.statusCode,
                               responseBody: mockResponseBody)
    }
    
    /// Resets the mock back to its starting state
    public func reset() {
        mockResponses = []
        shouldThrow = false
        calledPerformRequest = false
    }
}

// MARK: - MockResponse

public struct MockResponse {
    fileprivate let statusCode: Int
    fileprivate let responseBody: Decodable
    
    public init(statusCode: Int = 200,
                responseBody: Decodable = NoResponse()) {
        self.statusCode = statusCode
        self.responseBody = responseBody
    }
}


// MARK: - MockAPIError

enum MockAPIError: Error {
    case someError
}
