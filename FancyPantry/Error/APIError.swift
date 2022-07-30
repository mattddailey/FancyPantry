//
//  APIError.swift
//  FancyPantry
//
//  Created by Matt Dailey on 7/30/22.
//

import Foundation

public enum APIError: Error, LocalizedError {
    case encodeError
    case decodeError
    case invalidURL
    case serverFetchError
    case serverUpdateError
    case unknownError
    
    public var errorDescription: String? {
        switch self {
        case .encodeError:
            return NSLocalizedString("Error encountered while encoding", comment: "")
        case .decodeError:
            return NSLocalizedString("Error encountered while decoding", comment: "")
        case .invalidURL:
            return NSLocalizedString("The specifiedURL is not valid", comment: "")
        case .serverFetchError:
            return NSLocalizedString("Error encountered while fetching from server", comment: "")
        case .serverUpdateError:
            return NSLocalizedString("Error encountered while updating server", comment: "")
        case .unknownError:
            return NSLocalizedString("Unknown error occured.", comment: "")
        }
    }
}

public struct ErrorType: Identifiable {
    public let id = UUID()
    let error: APIError
}
