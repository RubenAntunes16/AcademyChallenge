//
//  UIImageView+Spinner.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 08/11/2022.
//

import Foundation
import UIKit

extension UIImageView {
    func spinner(spinner: UIActivityIndicatorView) {

        if spinner.isAnimating {
            spinnerView.stopAnimating()
            spinnerView.removeFromSuperview()
            self.addSubview(spinner)

            let bottomMargin = World.Margin.randomImage.symmetric * frame.height

            NSLayoutConstraint.activate([
                emojiImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                emojiImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                emojiImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
                emojiImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                       constant: bottomMargin),
                emojiImageView.heightAnchor.constraint(equalTo: emojiImageView.widthAnchor, multiplier: 0.5)
            ])
        }
    }

}
