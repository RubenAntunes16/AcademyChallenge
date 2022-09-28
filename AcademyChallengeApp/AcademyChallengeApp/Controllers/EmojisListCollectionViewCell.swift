//
//  EmojisListCollectionViewCell.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 27/09/2022.
//

import Foundation
import UIKit

class EmojisListCollectionViewCell : UICollectionViewCell{
    
    private var emojiImageView: UIImageView!
    
    func setupCell(emoji: UIImageView){
        self.emojiImageView = emoji
        self.addSubview(emojiImageView)
        setupConstraints()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            emojiImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emojiImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // NOTE: - Don't forget to clear your cell before reusing it!
        self.backgroundColor = .clear
    }
}
