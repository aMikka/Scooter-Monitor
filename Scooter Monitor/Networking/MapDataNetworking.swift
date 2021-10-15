//
//  MapDataNetworking.swift
//  Scooter Monitor
//
//  Created by Miklos Aron on 2021. 10. 11.
//

import Foundation

protocol MapDataNetworking {
    func fetchMapData(completion: @escaping (Result<MapResponse, NetworkError>) -> Void)
}

class MapDataNetworkingImpl: MapDataNetworking {

    private let session: URLSession
    private let endpoint = "https://api.jsonbin.io/b/5fa8ff8dbd01877eecdb898f"

    init() {
        self.session = URLSession(configuration: .default)
    }

    func fetchMapData(completion: @escaping (Result<MapResponse, NetworkError>) -> Void) {

        var urlRequest = URLRequest(url: URL(string: endpoint)!)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        urlRequest.allHTTPHeaderFields = getHeaders()

        session.dataTask(with: urlRequest) { data, response, error in

            if let error = error {
                completion(.failure(self.errorResponse(error: error)))
                return
            }

            guard let response = response, let data = data else {
                completion(.failure(.nilError))
                return
            }

            // Note: for the sake of simplicity, all other status codes are mapped to '.other' error
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                completion(.failure(.other))
                return
            }

            do {
                let mapResponse = try JSONDecoder().decode(MapResponse.self, from: data)
                completion(.success(mapResponse))
            } catch {
                completion(.failure(.decodeError))
            }
        }
        .resume()
    }
}

// MARK: - Private helpers
extension MapDataNetworkingImpl {

    private func getHeaders() -> [String: String] {
        var headers = [String: String]()

        headers[HeadersKeys.ContentType.name] = HeadersKeys.ContentType.value
        headers[HeadersKeys.SecretKey.name] = HeadersKeys.APIKey()

        return headers
    }

    private func getRequest() -> HTTPRequest {
        return HTTPRequest(url: endpoint,
                           method: .get,
                           parameters: nil,
                           headers: getHeaders())
    }

    private func errorResponse(error: Error) -> NetworkError {
        let code = (error as NSError).code
        switch code {
        case ErrorCodes.notConnectedToInternet:
            return .nointernet
        case ErrorCodes.timeout:
            return .timeout
        default:
            return .unknown
        }
    }
}

// NOTE: Enhance error handling with API error messages
// Error message struct
//{"message":"Need to provide a secret-key to READ private bins","success":false}
