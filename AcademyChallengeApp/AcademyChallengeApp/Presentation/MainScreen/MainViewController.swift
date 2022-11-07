//
//  ViewController.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 21/09/2022.
//

import UIKit
import Alamofire

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

    private var emojisListCoordinator: EmojisListCoordinator?
    private var avatarListCoordinator: AvatarListCoordinator?
    private var appleReposCoordinator: AppleReposCoordinator?

    var viewModel: MainViewModel?

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

        // --------- ADD TARGETS -----------
        genericView.buttonRandomEmojis.addTarget(self, action: #selector(buttonRandomEmojisTap), for: .touchUpInside)
        genericView.buttonRandomEmojis.isEnabled = false

        // TouchUpInside - é o gesto vulgar de carregar no botão
        genericView.buttonEmojisList.addTarget(self, action: #selector(buttonEmojisListTap(_:)), for: .touchUpInside)
        genericView.buttonEmojisList.isEnabled = false

        genericView.buttonAvatarList.addTarget(self, action: #selector(buttonAvatarListTap(_:)), for: .touchUpInside)

        genericView.buttonSearch.addTarget(self, action: #selector(buttonSearchTap), for: .touchUpInside)

        genericView.buttonAppleRepos.addTarget(self, action: #selector(buttonAppleReposListTap), for: .touchUpInside)

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

        genericView.spinnerView.startAnimating()

        buttonRandomEmojisTap()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }

    @objc func buttonEmojisListTap(_ sender: UIButton) {

        guard let emojiService = viewModel?.application.emojiService else { return }
        let emojiListCoordinator = EmojisListCoordinator(presenter: navigationController!, emojiService: emojiService)

        emojiListCoordinator.start()

        self.emojisListCoordinator = emojiListCoordinator
    }

    @objc func buttonAvatarListTap(_ sender: UIButton) {

        guard let avatarService = viewModel?.application.avatarService else { return }
        let avatarListCoordinator = AvatarListCoordinator(presenter: navigationController!,
                                                          avatarService: avatarService)

        avatarListCoordinator.start()

        self.avatarListCoordinator = avatarListCoordinator
    }

    @objc func buttonRandomEmojisTap() {
        viewModel?.getRandomEmoji()
    }

    @objc func buttonSearchTap() {
        guard let searchBarText = genericView.searchBar.text else { return }
        viewModel?.searchText.value = searchBarText
    }

    @objc func buttonAppleReposListTap(_ sender: UIButton) {

        guard let appleReposService = viewModel?.application.appleReposService else { return }
        let appleReposListCoordinator = AppleReposCoordinator(presenter: navigationController!,
                                                              appleReposService: appleReposService)

        appleReposListCoordinator.start()

        self.appleReposCoordinator = appleReposListCoordinator
    }

}

extension Array {
    func item(at index: Int) -> Element? {
        count > index ? self[index] : nil
    }
}
