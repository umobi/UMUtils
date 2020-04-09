//
//  APIError.swift
//  TokBeauty
//
//  Created by Ramon Vicente on 18/03/17.
//  Copyright © 2017 TokBeauty. All rights reserved.
//

import Foundation

public struct APIError: Codable {
    private let type: APIErrorType

    public var code: Int {
        return self.type.code
    }

    public var title: String {
        return self.type.message
    }

    public var messages: [String]? {
        return self.type.messages
    }
    
    public let exception: APIException?
    
    public var message: String {
        if code == 401 {
            return "Sua sessão expirou, faça o login novamente."
        }
        if let messages = self.messages {
            return "- " + messages.joined(separator: "\n- ")
        }
        return ""
    }
    
    public init(code: Int, title: String, messages: [String]? = nil, exception: APIException? = nil) {
        self.type = .api(.init(code: code, message: title, messages: messages))
        self.exception = exception
    }

    public init(error: Swift.Error) {
        self.type = .error(error)
        self.exception = nil
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = .api(try container.decode(.error))
        self.exception = try? container.decode(.exception)
    }

    public func encode(to encoder: Encoder) {
        let container = try encoder.container(keyedBy: EncodingKeys.self).wrapper

        if case .api(let error) = type {
            error >- container[.error]
        }
        self.exception >- container[.exception]
        self.message >- container[.message]
    }

    public var nsError: NSError {
        NSError(
            domain: "\(Bundle.main.bundleIdentifier ?? "com.umobi.umutils").apierror",
            code: self.code,
            userInfo: {
                switch self.type {
                case .api:
                    return self.toJSON()
                case .error(let error):
                    return (error as NSError).userInfo
                }
            }()
        )
    }
}

extension APIError {
    enum CodingKeys: String, CodingKey {
        case error
        case exception
    }

    enum EncodingKeys: String, CodingKey {
        case error
        case exception
        case message
    }
}

extension APIError {
    private struct Error: Codable {
        let code: Int
        let message: String
        let messages: [String]?

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.code = (try? container.decode(.code)) ?? 0
            self.message = (try? container.decode(.message)) ?? ""
            self.messages = try? container.decode(.messages)
        }

        init(code: Int, message: String, messages: [String]?) {
            self.code = code
            self.message = message
            self.messages = messages
        }

        enum CodingKeys: String, CodingKey {
            case code
            case message
            case messages
        }
    }

    private enum APIErrorType {
        case api(APIError.Error)
        case error(Swift.Error)

        var code: Int {
            switch self {
            case .api(let error):
                return error.code
            case .error(let error):
                return (error as NSError).code
            }
        }

        var message: String {
            switch self {
            case .api(let error):
                return error.message
            case .error(let error):
                return (error as NSError).localizedDescription
            }
        }

        var messages: [String] {
            switch self {
            case .api(let error):
                return error.messages ?? []
            case .error(let error):
                return []
            }
        }
    }
}

public struct MessageError: Swift.Error {
    public let content: String

    public init(content: String) {
        self.content = content
    }
}
