//
//  AvatarCollectionViewCell.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 14/10/2022.
//

import UIKit

class AvatarCollectionViewCell: UICollectionViewCell {
    
    private var emojiImageView: UIImageView
    var dataTask: URLSessionTask?
    
    override init(frame: CGRect) {
        emojiImageView = .init(frame: .zero)
        emojiImageView.contentMode = .scaleAspectFit
        emojiImageView.clipsToBounds = true
        //self.emojiImageView = emoji
        super.init(frame: .zero)
        self.contentView.addSubview(emojiImageView)
        
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(url: URL){
        self.emojiImageView.downloadImageFromURL(from: url)
    }
    
    func setupConstraints(){
        emojiImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            emojiImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            emojiImageView.topAnchor.constraint(equalTo: self.topAnchor),
            emojiImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        emojiImageView.layer.cornerRadius = 20
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
//        emojiImageView.layer.borderWidth = 4
//        emojiImageView.layer.borderColor = UIColor.black.cgColor
        
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
