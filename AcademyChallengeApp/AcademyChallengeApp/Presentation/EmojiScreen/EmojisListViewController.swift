//
//  EmojisListViewController.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 23/09/2022.
//

import Foundation
import UIKit
import RxSwift

// -------------------------------------------------------------------

class EmojisListViewController: BaseGenericViewController<EmojiView> {

    var emojisList: [Emoji]?

    var viewModel: EmojiViewModel?

    // ---- VARIABLE TO INJECT IN DATASOURCE PROPERTY MOCKED DATA
    var mockedDataSource = MockedEmojiDataSource()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

        viewModel?.getEmojisList()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] emojiList in
                guard let self = self else { return }
                self.emojisList = emojiList
                self.genericView.collectionView.reloadData()
            }, onFailure: { error in
                print("GOT ERROR: \(error)")
            }, onDisposed: {
                print("Got Disposed!!  BYEEEEEE")
            })
            .disposed(by: disposeBag)

//        viewModel?.getEmojisList()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        genericView.collectionView.dataSource = self

    }

}

extension EmojisListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // CUSTOM FUNCTION WITH REUSABLE VIEW
        let cell: EmojisListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstantEmojiCell.emojiCellIdentifier,
//        for: indexPath) as! EmojisListCollectionViewCell

        guard let url = emojisList?[indexPath.row].urlImage else { return UICollectionViewCell()}

        viewModel?.imageFromUrl(url: url)
            .asOptional()
            .subscribe(cell.emojiImageView.rx.image)
            .disposed(by: cell.reusableDisposeBag)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let numEmojis = emojisList?.count else { return 0 }

        return numEmojis
    }

}
