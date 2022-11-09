//
//  NetworkManager.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 04/10/2022.
//

import Foundation
import RxSwift

class NetworkManager {
    static func initialize() {
//        let sessionConfiguration = URLSessionConfiguration.default
//        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        URLSession.shared.configuration.urlCache?.diskCapacity = 100 * 1024 * 1024
//        urlSession = URLSession(configuration: sessionConfiguration)

    }

    func executeNetworkCall<ResultType: Decodable>(_ call: APIProtocol,
                                                   _ resultHandler: @escaping (Result<ResultType, Error>) -> Void) {
        let decoder = JSONDecoder()
        var request = URLRequest(url: call.url)
        request.httpMethod = call.method.rawValue
        call.headers.forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data {
                if let result = try? decoder.decode(ResultType.self, from: data) {
                    resultHandler(.success(result))
                } else {
                    resultHandler(.failure(APIError.unknownError))
                }
            } else if let error = error {
                resultHandler(.failure(error))
            }
        }

        task.resume()
    }

    func rxExecuteNetworkCall(_ call: APIProtocol) -> Observable<Data?> {
        
        var request = URLRequest(url: call.url)
        request.httpMethod = call.method.rawValue
        call.headers.forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return URLSession.shared.rx.response(request: request)
            .map { (response: HTTPURLResponse, data: Data) -> Data? in
                guard
                    response.statusCode == 200
                else {
                    return Data()
                    
                }
                return data
            }
    }
}

enum Method: String {
    case get = "GET"
    case post = "POST"
}

protocol APIProtocol {
    var url: URL { get }
    var method: Method { get }
    var headers: [String: String] { get }
}

enum APIError: Error {
    case unknownError
}
