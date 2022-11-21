//
//  ViewController.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 21/09/2022.
//
import UIKit

enum World {
    struct Margin {
//        static let appMargin: CGFloat = 20
        static let app: CGFloat = 0.0535
        static let randomImage: CGFloat = 0.1
        static let appTop: CGFloat = 20
    }

    static let interItemSpacing: CGFloat = 15
    static let stackViewPositionPer: CGFloat = 0.15
}

extension CGFloat {
    var symmetric: CGFloat {
        -self
    }
}

class MainViewController: BaseGenericViewController<MainView> {

    var viewModel: MainViewModel?

    weak var delegate: MainViewDelegate?

    // 1 - CREATE VIEWS
    init() {
        // ESTE INIT É NECESSÁRIO
        super.init(nibName: nil, bundle: nil)
    }

    // IT'S NECESSARY TO STOP THE APP IN CASE THE INIT FAIL
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.imageUrl.bind(listener: { [weak self] url in
            guard let url = url, let self = self else {
                return
            }

            let dataTask = self.genericView.emojiImageView.createDownloadDataTask(from: url)

            dataTask.resume()

            self.genericView.removeSpinner()
            self.genericView.buttonRandomEmojis.isEnabled = true
            self.genericView.buttonEmojisList.isEnabled = true

            // falta colocar quando não consegue fazer um download do emoji

        })

        genericView.rxRandomEmojiTap
            .subscribe(onNext: { [weak self] _ in
                self?.buttonRandomEmojisTap()
            })
            .disposed(by: disposeBag)
        genericView.rxEmojiListTap
            .subscribe(onNext: { [weak self] _ in
                self?.buttonEmojisListTap()
            })
        genericView.rxAvatarListTap
            .subscribe(onNext: { [weak self] _ in
                self?.buttonAvatarListTap()
            })
        genericView.rxAppleReposTap
            .subscribe(onNext: { [weak self] _ in
                self?.buttonAppleReposListTap()
            })
        genericView.rxSearchTap
            .subscribe(onNext: { [weak self] _ in
                self?.buttonSearchTap()
            })

        genericView.spinnerView.startAnimating()

        viewModel?.rxEmojiImage
            .do(onNext: { [weak self] image in
                self?.genericView.spinnerView.stopAnimating()
                // Arranjar forma de mudar o state das views (com cases)
                // self?.genericView
            })
                .subscribe(genericView.emojiImageView.rx.image)
                .disposed(by: disposeBag)

        buttonRandomEmojisTap()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func buttonEmojisListTap() {
        delegate?.navigateToEmoji()
    }

    func buttonAvatarListTap() {
        delegate?.navigateToAvatar()
    }

    func buttonRandomEmojisTap() {
        viewModel?.getRandomEmoji()
    }

    func buttonSearchTap() {
        guard let searchBarText = genericView.searchBar.text else { return }
        viewModel?.searchText.value = searchBarText
    }

    func buttonAppleReposListTap() {
        delegate?.navigateToAppleRepos()
    }

}

extension Array {
    func item(at index: Int) -> Element? {
        count > index ? self[index] : nil
    }
}
