//
//  GeralAPI.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 03/10/2022.
//

import Foundation
import UIKit

protocol APIProtocol {
    var url: URL { get }
    var method: Method { get }
    var headers: [String: String] { get }
}

enum Method: String {
    case get = "GET"
}

enum APIError: Error {
    case unknownError
}

// RESULTTYPE GOING TO BE A GENERIC
// WITH GENERIC I CAN ABSTRACT TO USE THE METHOD TO ANYTHING I WANT
func networkCallExecution<ResultType: Decodable>(_ callParameters: APIProtocol,_ resultHandler: @escaping (Result<ResultType,Error>) -> Void){
    
    let decoder = JSONDecoder()
    var request = URLRequest(url: callParameters.url)
    // THE RAW VALUE PARAMETER WILL GIVE THE STRING FROM METHOD CASE
    request.httpMethod = callParameters.method.rawValue
    
    callParameters.headers.forEach{ (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
    }
    
    let task = URLSession.shared.dataTask(with: request){ data, response, error in
        if let data = data{
            if let result = try? decoder.decode(ResultType.self, from: data){
                resultHandler(Result<ResultType,Error>.success(result))
            }else {
                resultHandler(Result<ResultType, Error>.failure(APIError.unknownError))
            }
        } else if let error = error {
            resultHandler(Result<ResultType, Error>.failure(error))
        }
    }
    task.resume()
}

func downloadImageFromURL(from url: URL, _ resultHandler: @escaping (Result<UIImage,Error>) -> Void) {
    let task = URLSession.shared.dataTask(with: url){ data, response, error in
        if let data = data {
            if let image = UIImage(data: data) {
                resultHandler(Result<UIImage, Error>.success(image))
            }
        } else if let error = error{
            resultHandler(Result<UIImage, Error>.failure(error))
            
        }
    }
    task.resume()
}
