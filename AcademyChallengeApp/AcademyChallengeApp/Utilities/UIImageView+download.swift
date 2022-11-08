//
//  UIImageView+download.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 04/10/2022.
//

import Foundation
import UIKit

extension UIImageView {

    func createDownloadDataTask(from url: URL) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async { [weak self] in
                        self?.image = image
                    }
                }
            } else if let error = error {
                print("UIImage Download ERROR: \(error)")
            }
        }
        return task

    }
}
