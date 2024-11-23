//
//  URLRequestBuilderTests.swift
//  Networking
//
//  Created by Ethan Van Heerden on 11/23/24.
//

import Testing
import Foundation
import Networking

struct URLRequestBuilderTests {
    
    @Test func build() throws {
        let mockURL = try #require(URL(string: "www.test.com"))
        let mockHeaders = [
            "header1": "value1",
            "header2": "value2"
        ]
        let mockAuthToken = "mock_token"
        let mockBody = ["field": "value"]
        
        let result = URLRequestBuilder(url: mockURL)
            .setHTTPMethod(.post)
            .setJSONContent()
            .setBearerAuth(authToken: mockAuthToken)
            .setHeaders(headers: mockHeaders)
            .setBody(mockBody)
            .build()
        
        let expectedHTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(mockAuthToken)",
            "header1": "value1",
            "header2": "value2"
        ]
        let expectedBody = try #require(try JSONEncoder().encode(mockBody))
        
        #expect(result.url == mockURL)
        #expect(result.httpMethod == HTTPMethod.post.rawValue)
        #expect(result.allHTTPHeaderFields == expectedHTTPHeaders)
        #expect(result.httpBody == expectedBody)
    }
}
