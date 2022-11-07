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

    var mainView = MainView()

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

    override func loadView() {
        view = mainView

        // --------- ADD TARGETS -----------
        mainView.buttonRandomEmojis.addTarget(self, action: #selector(buttonRandomEmojisTap), for: .touchUpInside)
        mainView.buttonRandomEmojis.isEnabled = false

        // TouchUpInside - é o gesto vulgar de carregar no botão
        mainView.buttonEmojisList.addTarget(self, action: #selector(buttonEmojisListTap(_:)), for: .touchUpInside)
        mainView.buttonEmojisList.isEnabled = false

        mainView.buttonAvatarList.addTarget(self, action: #selector(buttonAvatarListTap(_:)), for: .touchUpInside)

        mainView.buttonSearch.addTarget(self, action: #selector(buttonSearchTap), for: .touchUpInside)

        mainView.buttonAppleRepos.addTarget(self, action: #selector(buttonAppleReposListTap), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.imageUrl.bind(listener: { [weak self] url in
            guard let url = url, let self = self else {
                return
            }

            let dataTask = self.mainView.emojiImageView.createDownloadDataTask(from: url)

            dataTask.resume()

            self.mainView.removeSpinner()
            self.mainView.buttonRandomEmojis.isEnabled = true
            self.mainView.buttonEmojisList.isEnabled = true

            // falta colocar quando não consegue fazer um download do emoji

        })

        mainView.spinnerView.startAnimating()

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
        guard let searchBarText = mainView.searchBar.text else { return }
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
