//
//  EmojisListCollectionViewCell.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 27/09/2022.
//

import Foundation
import UIKit

class EmojisListCollectionViewCell : UICollectionViewCell{
    
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
        //downloadImage(from: url)
        self.emojiImageView.downloadImageFromURL(from: url)
//        downloadImageFromURL(from: url) { (result: Result<UIImage, Error>) in
//            switch result {
//            case .success(let success):
//                DispatchQueue.main.async {
//                    self.emojiImageView.image = success
//                }
//                
//            case .failure(let failure):
//                print("Cannot get image from url: \(failure)")
//            }
//        }
    }
    
    func setupConstraints(){
        emojiImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            emojiImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            emojiImageView.topAnchor.constraint(equalTo: self.topAnchor),
            emojiImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        dataTask?.cancel()
        dataTask = Application.urlSession?.dataTask(with: url, completionHandler: completion)
        dataTask?.resume()
    }
    
    func downloadImage(from url: URL) {
        // CALL DOWNLOAD IMAGE FUNCTION (CLASS EMOJI API)
        getData(from: url) { [weak self] data, response, error in
            if let error = error {
                DispatchQueue.main.async() {
                    self?.emojiImageView.image = nil
                    self?.dataTask = nil
                }
                return
            }
            DispatchQueue.main.async() { () in
                self?.emojiImageView.image = nil
                self?.dataTask = nil
                guard let data = data, error == nil else { return }
                // always update the UI from the main thread
                self?.emojiImageView.image = UIImage(data: data)
            }
        }
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
