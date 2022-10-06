//
//  EmojisListViewController.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 23/09/2022.
//

import Foundation
import UIKit
import SwiftUI

enum Constants {
    static let cellIdentifier = "emojiCell"
}

class EmojisListViewController: UIViewController {
    
    private var collectionView: UICollectionView
    private var emojiImageView: UIImageView
    
    var emojisList: [Emoji]?
    
    var emojiService: EmojiService?
    
    init(){
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 4
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
        emojiImageView = .init(frame: .zero)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        emojiService?.getEmojisList({ [weak self] (result: Result<[Emoji],Error>) in
            switch result{
            case .success(let success):
                self?.emojisList = success
                self?.emojisList?.sort()
                DispatchQueue.main.async { [weak self] in
                    self?.collectionView.reloadData()
                }
                
            case .failure(let failure):
                print("Failure: \(failure)")
            }
            

        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Emojis List"
        // Do any additional setup after loading the view.
        setupCollectionsView()
        addViewsToSuperview()
        setupConstraints()
        view.backgroundColor = .systemBlue
        
    }
    
    private func setupCollectionsView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = view.bounds
        
        collectionView.backgroundColor = .none
        collectionView.register(EmojisListCollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
    }
    
    // 2 - ADD TO THE SUPERVIEW
    private func addViewsToSuperview(){
        view.addSubview(collectionView)
    }
    
    private func setupConstraints(){
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    
    
}

extension EmojisListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! EmojisListCollectionViewCell
        
    
        guard let url = emojisList?[indexPath.row].urlImage else { return UICollectionViewCell()}
        
        cell.setupCell(url: url)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let numEmojis = emojisList?.count else { return 0 }
        
        return numEmojis
    }
    
    
}

extension EmojisListViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = view.frame.width / 3
        return CGSize(width: cellWidth - 8, height: cellWidth / 2)
    }
}

extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
