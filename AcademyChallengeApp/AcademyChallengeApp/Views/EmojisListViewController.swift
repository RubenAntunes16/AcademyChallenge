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

// ------ MOCKED CLASS TO MOCKED EMOJIS COLLECTION DATA SOURCE -------
class MockedEmojiDataSource : NSObject, UICollectionViewDataSource {
    var emojiMocked: EmojiMocked = .init()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiMocked.mockedEmojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! EmojisListCollectionViewCell
        
    
        let url = emojiMocked.mockedEmojis[indexPath.row].urlImage
        
        cell.setupCell(url: url)
        
        return cell
    }
}
// -------------------------------------------------------------------

class EmojisListViewController: UIViewController {
    
    private var collectionView: UICollectionView
    private var emojiImageView: UIImageView
    
    var emojisList: [Emoji]?
    
    var emojiService: EmojiService?
    
    // ---- VARIABLE TO INJECT IN DATASOURCE PROPERTY MOCKED DATA
    var mockedDataSource = MockedEmojiDataSource()
    
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
//        view.backgroundColor = .systemBlue
        view.backgroundColor = .appColor(name: .surface)
        
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
