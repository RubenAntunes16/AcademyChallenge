//
//  Application.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 29/09/2022.
//

import Foundation

class Application {
    static var urlSession: URLSession?
    
    static func initialize() {
//        let sessionConfiguration = URLSessionConfiguration.default
//        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        URLSession.shared.configuration.urlCache?.diskCapacity = 100 * 1024 * 1024
//        urlSession = URLSession(configuration: sessionConfiguration)
        
    }
}
