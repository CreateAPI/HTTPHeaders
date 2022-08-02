import Foundation

public struct HTTPHeader<T> {
    public let field: String
    private let _parse: (String) -> T?
    
    public init(field: String, parse: @escaping (String) -> T?) {
        self.field = field
        self._parse = parse
    }
    
    public func parse(from response: HTTPURLResponse) throws -> T {
        guard let value = response.value(forHTTPHeaderField: field) else {
            throw ParsingError.keyNotFound(field: field)
        }
        return try parse(value)
    }
    
    public func parseIfPresent(from response: HTTPURLResponse) throws -> T? {
        guard let value = response.value(forHTTPHeaderField: field) else {
            return nil
        }
        return try parse(value)
    }
    
    private func parse(_ value: String) throws -> T {
        guard let value = _parse(value) else {
            throw ParsingError.typeMismatch(field: field, value: value, type: T.self)
        }
        return value
    }
    
    public enum ParsingError: Error {
        case keyNotFound(field: String)
        case typeMismatch(field: String, value: String, type: Any.Type)
    }
}

extension HTTPHeader where T == String {
    public init(field: String) {
        self.init(field: field) { $0 }
    }
}

extension HTTPHeader where T == [String] {
    public init(field: String) {
        self.init(field: field) {
            $0.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        }
    }
}

extension HTTPHeader where T == Int {
    public init(field: String) {
        self.init(field: field) { Int($0) }
    }
}

extension HTTPHeader where T == Int32 {
    public init(field: String) {
        self.init(field: field) { Int32($0) }
    }
}

extension HTTPHeader where T == Int64 {
    public init(field: String) {
        self.init(field: field) { Int64($0) }
    }
}

extension HTTPHeader where T == Date {
    public init(field: String, options: ISO8601DateFormatter.Options? = nil) {
        self.init(field: field) {
            let formatter = ISO8601DateFormatter()
            if let options = options {
                formatter.formatOptions = options
            }
            return formatter.date(from: $0)
        }
    }
}

extension HTTPHeader where T == Double {
    public init(field: String) {
        self.init(field: field) { Double($0) }
    }
}

extension HTTPHeader where T == URL {
    public init(field: String) {
        self.init(field: field) { URL(string: $0) }
    }
}

extension HTTPHeader where T == Bool {
    public init(field: String) {
        self.init(field: field) { Bool($0) }
    }
}
