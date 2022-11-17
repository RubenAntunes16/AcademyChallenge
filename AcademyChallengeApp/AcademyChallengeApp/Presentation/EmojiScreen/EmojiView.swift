//
//  EmojiView.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 04/11/2022.
//

import Foundation
import UIKit
import RxSwift

class EmojiView: BaseGenericView {

    var collectionView: UICollectionView
    private var emojiImageView: UIImageView
    private var button: UIButton!

    var rxButtonTap: Observable<Void> { button.rx.tap.asObservable() }

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 4
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
        emojiImageView = .init(frame: .zero)
        button = .init(configuration: .filled())
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createViews() {
        setupCollectionsView()
        addViewsToSuperview()
        setupConstraints()
        backgroundColor = .appColor(name: .surface)
    }

    private func setupCollectionsView() {
        collectionView.frame = bounds
        collectionView.delegate = self

        collectionView.backgroundColor = .none
        collectionView.register(EmojisListCollectionViewCell.self,
                                forCellWithReuseIdentifier: EmojisListCollectionViewCell.reuseCellIdentifier)

        button.addTarget(self, action: #selector(tapTest), for: .touchDown)
    }

    // 2 - ADD TO THE SUPERVIEW
    private func addViewsToSuperview() {
        addSubview(button)
        addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.topAnchor.constraint(equalTo: button.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc func tapTest() {
        
    }
}

extension EmojiView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 8, bottom: 1, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        let cellWidth = frame.width / 5 - layout.minimumInteritemSpacing
        return CGSize(width: cellWidth - 8, height: cellWidth)
    }
}
