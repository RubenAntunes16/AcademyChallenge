//
//  AvatarListViewController.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/09/2022.
//

import UIKit

class AvatarListViewController: BaseGenericViewController<AvatarView> {

    var viewModel: AvatarViewModel?
    var avatarList: [Avatar] = []
    weak var delegate: BackMainDelegate?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        print("Deinit Avatar")
        self.delegate?.back()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        genericView.collectionView.delegate = self
        genericView.collectionView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)

        viewModel?.avatarList.bind(listener: { [weak self] avatarList in
            guard
                let self = self,
                let avatarList = avatarList else { return }

            self.avatarList = avatarList

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.genericView.collectionView.reloadData()
            }
        })
        viewModel?.getAvatars()
    }

//    override func viewDidDisappear(_ animated: Bool) {
//        delegate?.back()
//    }
}

extension AvatarListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return avatarList.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // CUSTOM FUNCTION WITH REUSABLE VIEW
        let cell: AvatarCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstantAvatarCell.avatarCellIdentifier,
//        for: indexPath) as! AvatarCollectionViewCell

        let url = avatarList[indexPath.row].avatarUrl

        cell.setupCell(url: url)

        return cell
    }

    // Delegate goes to view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let alert = genericView.createDeleteAlert { [weak self] in
            guard let self = self else { return }
            let avatar = self.avatarList[indexPath.row]
            self.viewModel?.avatarService?.deleteAvatar(avatarToDelete: avatar)
        }
        self.present(alert, animated: true, completion: nil)

    }
}

extension AvatarListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 16, bottom: 1, right: 16)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        let cellWidth = view.frame.width / 2 - layout.minimumInteritemSpacing
        return CGSize(width: cellWidth - 20, height: cellWidth)
    }
}
