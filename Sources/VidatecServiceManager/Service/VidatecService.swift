import Foundation
import Combine

public protocol VidatecServiceType {
    func getRooms() -> AnyPublisher<[Room], VidatecService.Error>
    func getPeoples() -> AnyPublisher<[Person], VidatecService.Error>
}

public class VidatecService: VidatecServiceType {
    
    public enum Configuration {
        case dev
        case prod
    }
    
    public var baseUrl: URL {
        guard let url = URL(string: VidatecService.baseHost) else {
            fatalError("baseHost URL format is wrong?!")
        }
        return url
    }
    
    // MARK: - Properties
    /// Session
    fileprivate let session: URLSession
    
    /// A shared JSON decoder to use in calls.
    let decoder: JSONDecoder
    
    let configuration: Configuration
    
    /// Session Queue
    private let apiQueue = DispatchQueue(label: "VidatecService", qos: .default, attributes: .concurrent)
    static var baseHost: String = ""
    
    public init(session: URLSession = .shared, decoder: JSONDecoder = .init(), with configuration: VidatecService.Configuration = .prod) {
        self.session = session
        self.decoder = decoder
        self.configuration = configuration
        
        configureEnvironment(configuration: configuration)
    }
    
    func configureEnvironment(configuration: Configuration) {
        switch configuration {
        case .dev:
            VidatecService.baseHost = "5cc736f4ae1431001472e333.mockapi.io/api/v1"
        case .prod:
            VidatecService.baseHost = "5cc736f4ae1431001472e333.mockapi.io/api/v1"
        }
    }
    
    /// MARK: Network Errors.
    public enum Error: LocalizedError, Identifiable {
        public var id: String { localizedDescription }
        
        case unknownNetwork
        case networkResponse(NSError)
        case addressUnreachable(URL)
        case invalidResponse
        case decoding
        case stubData
        
        public var errorDescription: String? {
            switch self {
            case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
            case .invalidResponse: return "The server responded with garbage."
            case .decoding: return "Some decoding error occured"
            case .networkResponse(let error): return error.localizedDescription
            case .unknownNetwork: return "Some unknown network error occured"
            case .stubData: return "Stub data error occured"
            }
        }
    }
    
    /// MARK: Network endpoints.
    private enum EndPoint {
        
        case getRooms
        case getPeoples
        
        var url: URL {
            switch self {
            case .getRooms:
                return getRoomsComponent.url!
            case .getPeoples:
                return getPeopleComponent.url!
            }
        }
        
        private var getRoomsComponent: URLComponents {
            var components = URLComponents()
            components.scheme = "http"
            components.host = VidatecService.baseHost
            components.path = "/rooms"
            return components
        }
        
        private var getPeopleComponent: URLComponents {
            var components = URLComponents()
            components.scheme = "http"
            components.host = VidatecService.baseHost
            components.path = "/people"
            return components
        }
        
    }
    
    public func getRooms() -> AnyPublisher<[Room], VidatecService.Error> {
        executeRequest(url: URL(string: VidatecService.EndPoint.getRooms.url.absoluteString.removingPercentEncoding!)!)
    }
    
    public func getPeoples() -> AnyPublisher<[Person], VidatecService.Error> {
        executeRequest(url: URL(string: VidatecService.EndPoint.getPeoples.url.absoluteString.removingPercentEncoding!)!)
    }
}

public extension VidatecService {
    
    func executeRequest<T: Decodable>(urlRequest: URLRequest) -> AnyPublisher<T, VidatecService.Error> {
        return session.dataTaskPublisher(for: urlRequest)
            .receive(on: apiQueue)
            .tryMap { data, response -> Data in
                let httpResponse = response as? HTTPURLResponse
                if let httpResponse = httpResponse, 200..<399 ~= httpResponse.statusCode {
                    return data
                }
                else if let httpResponse = httpResponse {
                    let nserror = NSError(domain: httpResponse.description, code: httpResponse.statusCode, userInfo: httpResponse.allHeaderFields as? [String : Any])
                    throw VidatecService.Error.networkResponse(nserror)
                }     else {
                    throw VidatecService.Error.unknownNetwork
                }
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                switch error {
                case is URLError:
                    return VidatecService.Error.addressUnreachable(urlRequest.url!)
                case is DecodingError:
                    return VidatecService.Error.decoding
                default:
                    if let error = error as? VidatecService.Error {
                        return error
                    }
                    return VidatecService.Error.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
    
    func executeRequest<T: Decodable>(url: URL) -> AnyPublisher<T, VidatecService.Error> {
        return session.dataTaskPublisher(for: url)
            .receive(on: apiQueue)
            .tryMap { data, response -> Data in
                let httpResponse = response as? HTTPURLResponse
                if let httpResponse = httpResponse, 200..<399 ~= httpResponse.statusCode {
                    return data
                }
                else if let httpResponse = httpResponse {
                    let nserror = NSError(domain: httpResponse.description, code: httpResponse.statusCode, userInfo: httpResponse.allHeaderFields as? [String : Any])
                    throw VidatecService.Error.networkResponse(nserror)
                }     else {
                    throw VidatecService.Error.unknownNetwork
                }
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                switch error {
                case is URLError:
                    return Error.addressUnreachable(url)
                case is DecodingError:
                    return Error.decoding
                default:
                    return Error.invalidResponse
                }
            }
            .eraseToAnyPublisher()
    }
}

public extension Publisher {
    func unwrap<T>() -> Publishers.CompactMap<Self, T> where Output == Optional<T> {
        compactMap { $0 }
    }
}

fileprivate extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
