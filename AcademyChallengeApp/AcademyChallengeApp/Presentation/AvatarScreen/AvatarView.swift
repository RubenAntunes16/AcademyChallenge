//
//  AvatarView.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 07/11/2022.
//

import Foundation
import UIKit

class AvatarView: BaseGenericView {

    var collectionView: UICollectionView

    override init(frame: CGRect) {

        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 4

        collectionView = .init(frame: .zero, collectionViewLayout: layout)

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
        collectionView.backgroundColor = .none
        collectionView.register(AvatarCollectionViewCell.self,
                                forCellWithReuseIdentifier: AvatarCollectionViewCell.reuseCellIdentifier)
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

    func createDeleteAlert(_ deleteFunction: @escaping () -> Void) -> UIAlertController {
        let alert = UIAlertController(title: "Delete Avatar",
                                      message: "Are you sure you want delete the avatar?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .default))

        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {(_: UIAlertAction!) in

            deleteFunction()

        }))

        return alert
    }
}
