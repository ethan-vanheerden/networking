//
//  NetworkResponse.swift
//  Networking
//
//  Created by Ethan Van Heerden on 11/23/24.
//

/// Represents a response that a `NetworkRequest` can return.
public struct NetworkResponse<R: NetworkRequest> {
    public let statusCode: Int
    public let responseBody: R.Response
    
    init(requestType: R.Type,
         statusCode: Int,
         responseBody: R.Response) {
        self.statusCode = statusCode
        self.responseBody = responseBody
    }
    
    public var wasSuccessful: Bool {
        return statusCode >= 200 && statusCode <= 299
    }
}
