//
//  AvatarListViewController.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/09/2022.
//

import UIKit

class AvatarListViewController: UIViewController {
    
    var avatarService: LiveAvatarService?
    var avatarList: [Avatar] = []
    
    private var collectionView: UICollectionView
    init(){

        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 4
        
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionsView()
        addViewsToSuperview()
        setupConstraints()
        view.backgroundColor = .purple
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        avatarService?.fetchAvatarList({ (result: [Avatar]) in
            self.avatarList = result
        })
    }
    
    private func setupCollectionsView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = view.bounds
        
        collectionView.backgroundColor = .none
        collectionView.register(AvatarCollectionViewCell.self, forCellWithReuseIdentifier: Constants.avatarCellIdentifier)
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

extension AvatarListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.avatarCellIdentifier, for: indexPath) as! AvatarCollectionViewCell
        
        let url = avatarList[indexPath.row].avatarUrl
        
        cell.setupCell(url: url)
        
        return cell
    }
    
    
}

extension AvatarListViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = view.frame.width / 3
        return CGSize(width: cellWidth - 8, height: cellWidth / 2)
    }
}
