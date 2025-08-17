# Networking

[![CI](https://github.com/ethan-vanheerden/Networking/actions/workflows/tests.yml/badge.svg)](https://github.com/ethan-vanheerden/Networking/actions/workflows/tests.yml)

🛜 A lightweight, modern HTTP networking library for Swift with support for async/await, automatic JSON encoding/decoding, and comprehensive testing utilities.

## Features

- 🚀 **Modern Swift**: Built with async/await and generics
- 🔄 **Automatic JSON handling**: Built-in encoding and decoding
- 🏗️ **Builder pattern**: Intuitive URL request construction
- 🧪 **Testing support**: Comprehensive mocking utilities
- 📱 **Cross-platform**: iOS 16+ and macOS 12+
- 🪶 **Lightweight**: Zero dependencies beyond Foundation

## Installation

### Swift Package Manager

Add this to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ethan-vanheerden/Networking.git", from: "1.0.0")
]
```

Or add it through Xcode: File → Add Package Dependencies → Enter the repository URL.

## Quick Start

### 1. Define your request

```swift
import Networking

struct GetUserRequest: NetworkRequest {
    typealias Response = User
    
    let userId: Int
    
    func createRequest() throws -> URLRequest {
        guard let url = URL(string: "https://api.example.com/users/\(userId)") else {
            throw NetworkError.invalidURL
        }
        
        return URLRequestBuilder(url: url)
            .setHTTPMethod(.get)
            .setJSONContent()
            .setBearerAuth(authToken: "your-token")
            .build()
    }
}

struct User: Codable {
    let id: Int
    let name: String
    let email: String
}
```

### 2. Make the request

```swift
let interactor = APIInteractor()
let request = GetUserRequest(userId: 123)

do {
    let response = try await interactor.performRequest(with: request)
    if response.wasSuccessful {
        print("User: \(response.responseBody.name)")
    } else {
        print("Error: Status code \(response.statusCode)")
    }
} catch {
    print("Network error: \(error)")
}
```

## Core Components

### APIInteractor

The main class for performing network requests. Automatically handles JSON decoding and provides structured responses.

```swift
let interactor = APIInteractor()
let response = try await interactor.performRequest(with: yourRequest)
```

### NetworkRequest Protocol

Define your API endpoints by conforming to `NetworkRequest`:

```swift
protocol NetworkRequest {
    associatedtype Response: Decodable
    func createRequest() throws -> URLRequest
}
```

### NetworkResponse

Every request returns a `NetworkResponse<R>` containing:
- `statusCode: Int` - HTTP status code
- `responseBody: R.Response` - Decoded response object
- `wasSuccessful: Bool` - Convenience property (200-299 status codes)

### URLRequestBuilder

Fluent API for building URLRequest objects:

```swift
let request = URLRequestBuilder(url: url)
    .setHTTPMethod(.post)
    .setJSONContent()
    .setBearerAuth(authToken: "token")
    .setHeaders(["Custom-Header": "Value"])
    .setBody(requestBody)
    .build()
```

#### Available Methods:
- `setHTTPMethod(_ method: HTTPMethod)` - Set HTTP method (GET, POST, PUT, DELETE)
- `setJSONContent()` - Set Content-Type to application/json
- `setBearerAuth(authToken: String)` - Set Bearer authorization header
- `setHeaders(headers: [String: String])` - Set custom headers
- `setBody(_ body: Encodable)` - Set request body (automatically JSON encoded)

## Advanced Usage

### POST Request with Body

```swift
struct CreateUserRequest: NetworkRequest {
    typealias Response = User
    
    let userData: UserData
    
    func createRequest() throws -> URLRequest {
        guard let url = URL(string: "https://api.example.com/users") else {
            throw NetworkError.invalidURL
        }
        
        return URLRequestBuilder(url: url)
            .setHTTPMethod(.post)
            .setJSONContent()
            .setBody(userData)
            .build()
    }
}
```

### Requests Without Response Data

For requests where you don't need the response body:

```swift
struct DeleteUserRequest: NetworkRequest {
    typealias Response = NoResponse  // Built-in empty response type
    
    let userId: Int
    
    func createRequest() throws -> URLRequest {
        // ... implementation
    }
}
```

### Error Handling

The library provides these error types:
- `NetworkError.invalidURL` - Invalid URL construction
- `NetworkError.unsupportedResponse` - Non-HTTP response received
- Standard URLSession errors (network connectivity, etc.)
- JSON decoding errors

```swift
do {
    let response = try await interactor.performRequest(with: request)
    // Handle response
} catch NetworkError.invalidURL {
    // Handle invalid URL
} catch {
    // Handle other errors (network, JSON decoding, etc.)
}
```

## Testing

The library includes comprehensive testing utilities in the `NetworkingMocks` target.

### MockAPIInteractor

```swift
import NetworkingMocks

let mockInteractor = MockAPIInteractor()

// Configure mock response
let mockUser = User(id: 1, name: "John Doe", email: "john@example.com")
let mockResponse = MockResponse(statusCode: 200, responseBody: mockUser)
mockInteractor.mockResponses = [mockResponse]

// Use in tests
let response = try await mockInteractor.performRequest(with: request)
XCTAssertTrue(mockInteractor.calledPerformRequest)
```

### MockResponse

Create mock responses with custom status codes and response bodies:

```swift
// Successful response
let successResponse = MockResponse(statusCode: 200, responseBody: user)

// Error response
let errorResponse = MockResponse(statusCode: 404, responseBody: NoResponse())

// Configure multiple responses for sequential calls
mockInteractor.mockResponses = [successResponse, errorResponse]
```

### Mock Error States

```swift
// Configure mock to throw errors
mockInteractor.shouldThrow = true

// Reset mock state
mockInteractor.reset()
```

## Requirements

- iOS 16.0+ / macOS 12.0+
- Swift 6.0+
- Xcode 14.0+

## License

This project is licensed under the terms found in the [LICENSE](LICENSE) file.
