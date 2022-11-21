//
//  EmojisListCollectionViewCell.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 27/09/2022.
//

import Foundation
import UIKit

class EmojisListCollectionViewCell: UICollectionViewCell {

    private var emojiImageView: UIImageView
    var dataTask: URLSessionTask?

    let shared = URLSession.shared

    let blurEffect: UIBlurEffect
    let blurEffectView: UIVisualEffectView

    override init(frame: CGRect) {
        emojiImageView = .init(frame: .zero)
        emojiImageView.contentMode = .scaleAspectFit
        emojiImageView.clipsToBounds = true

        blurEffect = .init(style: .light)

        blurEffectView = .init(effect: blurEffect)

        // self.emojiImageView = emoji
        super.init(frame: .zero)
        contentView.addSubview(blurEffectView)
        contentView.addSubview(emojiImageView)

        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(url: URL) {

        dataTask = self.emojiImageView.createDownloadDataTask(from: url)
        dataTask?.resume()
    }

    func setupConstraints() {
        emojiImageView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            blurEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            emojiImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            emojiImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            emojiImageView.topAnchor.constraint(equalTo: self.topAnchor),
            emojiImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    override func prepareForReuse() {
        // vamos ter que fazer aqui o cancel do download acaso a imagem não va ser mostrada
        super.prepareForReuse()
        dataTask?.cancel()
        // NOTE: - Don't forget to clear your cell before reusing it!
        // Em caso de placeholders, o nil será substituido por uma imagem que será o placeholder
        emojiImageView.image = nil
    }
}
