//
//  EmojiView.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 04/11/2022.
//

import Foundation
import UIKit

class EmojiView: BaseGenericView {

    var collectionView: UICollectionView
    private var emojiImageView: UIImageView

    override init(frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 4
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
        emojiImageView = .init(frame: .zero)
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
    }

    // 2 - ADD TO THE SUPERVIEW
    private func addViewsToSuperview() {
        addSubview(collectionView)
    }

    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
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
