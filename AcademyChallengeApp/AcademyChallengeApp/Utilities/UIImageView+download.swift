//
//  UIImageView+download.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 04/10/2022.
//

import Foundation
import UIKit

extension UIImageView {
//    func downloadImageFromURL(from url: URL, _ resultHandler: @escaping (Result<UIImage,Error>) -> Void) {
//        let task = URLSession.shared.dataTask(with: url){ data, response, error in
//            if let data = data {
//                if let image = UIImage(data: data) {
//                    resultHandler(Result<UIImage, Error>.success(image))
//                }
//            } else if let error = error{
//                resultHandler(Result<UIImage, Error>.failure(error))
//    
//            }
//        }
//        task.resume()
//    }
    
    func downloadImageFromURL(from url: URL) {
        let task = URLSession.shared.dataTask(with: url){ data, response, error in
            if let data = data {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = image
                    }
                }
            } else if let error = error{
                print("UIImage Download ERROR: \(error)")
    
            }
        }
        task.resume()
    }
    
    
}
