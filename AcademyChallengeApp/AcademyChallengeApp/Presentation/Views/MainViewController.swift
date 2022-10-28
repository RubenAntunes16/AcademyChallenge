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
        static let randomImage: CGFloat = 0.25
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

class MainViewController: UIViewController {

    private var emojisListCoordinator: EmojisListCoordinator?
    private var avatarListCoordinator: AvatarListCoordinator?
    private var appleReposCoordinator: AppleReposCoordinator?

    private var viewEmojiRandom: UIView
    private var spinnerView: UIActivityIndicatorView
    private var emojiImageView: UIImageView

    private var mainStackView: UIStackView
    private var searchStackView: UIStackView

    private var buttonEmojisList: UIButton
    private var buttonRandomEmojis: UIButton
    private var buttonSearch: UIButton
    private var searchBar: UISearchBar
    private var buttonAvatarList: UIButton
    private var buttonAppleRepos: UIButton

    var viewModel: MainViewModel?

    // --------- HOW TO START ---------
    // 1 - CREATE THE VIEWS
    // 2 - ADDVIEWS TO SUPERVIEW
    // 3 - SET THE CONSTRAINTS
    // --------------------------------

    // 1 - CREATE VIEWS
    init() {
        viewEmojiRandom = .init(frame: .zero)
        spinnerView = .init(style: .large)
        emojiImageView = .init(frame: .zero)

        buttonEmojisList = .init(type: .system)
        buttonRandomEmojis = .init(type: .system)
        buttonAvatarList = .init(type: .system)
        buttonAppleRepos = .init(type: .system)

        buttonSearch = .init(type: .system)
        searchBar = .init()
        searchStackView = .init(arrangedSubviews: [searchBar, buttonSearch])

        mainStackView = .init(arrangedSubviews: [
            buttonRandomEmojis,
            buttonEmojisList,
            searchStackView,
            buttonAvatarList,
            buttonAppleRepos
        ])

        // ESTE INIT É NECESSÁRIO
        super.init(nibName: nil, bundle: nil)
    }

    // IT'S NECESSARY TO STOP THE APP IN CASE THE INIT FAIL
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel?.imageUrl.bind(listener: { url in
            guard let url = url else {
                return
            }
            // falta colocar quando não consegue fazer um download do emoji
            let dataTask = self.emojiImageView.createDownloadDataTask(from: url)

            dataTask.resume()
            DispatchQueue.main.async {
                self.removeSpinner()
            }

        })

        setupViews()
        addViewsToSuperview()
        setupConstraints()

        spinnerView.startAnimating()

        buttonRandomEmojisTap()
    }

    private func setupViews() {
        // FAZER O SETUP DAS STACKVIEWS

//        emojiImageView.backgroundColor = .orange
        // emojiImageView.image = UIImage(named: "emoji_Test")
        // emojiImageView.contentMode = UIView.ContentMode.scaleToFill

        mainStackView.axis = .vertical
        mainStackView.spacing = CGFloat(World.interItemSpacing)

        searchStackView.axis = .horizontal
        searchStackView.spacing = CGFloat(World.interItemSpacing)

        // FAZER O SETUP DOS BUTTONS
        let buttonArray = [buttonRandomEmojis, buttonEmojisList, buttonSearch, buttonAvatarList, buttonAppleRepos]
        buttonArray.forEach {
            $0.configuration = .filled()
            $0.configuration?.baseBackgroundColor = .appColor(name: .primary)
        }

        buttonRandomEmojis.setTitle("RANDOM EMOJI", for: .normal)
        buttonEmojisList.setTitle("EMOJIS LIST", for: .normal)
        buttonSearch.setTitle("SEARCH", for: .normal)
        buttonAvatarList.setTitle("AVATARS LIST", for: .normal)
        buttonAppleRepos.setTitle("APPLE REPOS", for: .normal)

        // --------- ADD TARGETS -----------
        buttonRandomEmojis.addTarget(self, action: #selector(buttonRandomEmojisTap), for: .touchUpInside)

        // TouchUpInside - é o gesto vulgar de carregar no botão
        buttonEmojisList.addTarget(self, action: #selector(buttonEmojisListTap(_:)), for: .touchUpInside)

        buttonAvatarList.addTarget(self, action: #selector(buttonAvatarListTap(_:)), for: .touchUpInside)

        buttonSearch.addTarget(self, action: #selector(buttonSearchTap), for: .touchUpInside)

        buttonAppleRepos.addTarget(self, action: #selector(buttonAppleReposListTap), for: .touchUpInside)

    }

    // 2 - ADD TO THE SUPERVIEW
    private func addViewsToSuperview() {
        viewEmojiRandom.addSubview(spinnerView)
        view.addSubview(mainStackView)
        view.addSubview(viewEmojiRandom)
    }

    // 3 - SETUP THE CONSTRAINTS
    private func setupConstraints() {
        // THIS IS ALWAYS NECESSARY TO THE UI OBJECTS APPEAR IN THE VIEW
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        viewEmojiRandom.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        emojiImageView.translatesAutoresizingMaskIntoConstraints = false

        // THIS WILL CENTER IN THE SUPERVIEW THE STACK VIEW
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor,
                                                   constant: World.stackViewPositionPer * view.frame.height),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: World.Margin.app * view.frame.width),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant: World.Margin.app.symmetric * view.frame.width),

            viewEmojiRandom.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                     constant: World.Margin.app * view.frame.width),
            viewEmojiRandom.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                      constant: World.Margin.app.symmetric * view.frame.width),
            viewEmojiRandom.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: World.Margin.appTop),
            viewEmojiRandom.bottomAnchor.constraint(equalTo: mainStackView.topAnchor,
                                                    constant: World.interItemSpacing.symmetric),

            spinnerView.centerXAnchor.constraint(equalTo: viewEmojiRandom.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: viewEmojiRandom.centerYAnchor)

        ])

        emojiImageView.contentMode = .scaleAspectFit
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }

    @objc func buttonEmojisListTap(_ sender: UIButton) {

        guard let emojiService = viewModel?.application.emojiSource else { return }
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
        guard let searchBarText = searchBar.text else { return }
        viewModel?.searchText.value = searchBarText
    }

    @objc func buttonAppleReposListTap(_ sender: UIButton) {

        guard let appleReposService = viewModel?.application.appleReposService else { return }
        let appleReposListCoordinator = AppleReposCoordinator(presenter: navigationController!,
                                                              appleReposService: appleReposService)

        appleReposListCoordinator.start()

        self.appleReposCoordinator = appleReposListCoordinator
    }

    private func removeSpinner() {
        if spinnerView.isAnimating {
            spinnerView.stopAnimating()
            spinnerView.removeFromSuperview()
            viewEmojiRandom.addSubview(emojiImageView)

            NSLayoutConstraint.activate([
                emojiImageView.leadingAnchor.constraint(equalTo: viewEmojiRandom.leadingAnchor,
                                                        constant: World.Margin.randomImage * viewEmojiRandom.frame.width),
                emojiImageView.trailingAnchor.constraint(equalTo: viewEmojiRandom.trailingAnchor,
                                                         constant: World.Margin.randomImage.symmetric * viewEmojiRandom.frame.width),
                emojiImageView.topAnchor.constraint(equalTo: viewEmojiRandom.topAnchor,
                                                    constant: World.Margin.randomImage * viewEmojiRandom.frame.height),
                emojiImageView.bottomAnchor.constraint(equalTo: viewEmojiRandom.bottomAnchor,
                                                       constant: World.Margin.randomImage.symmetric * viewEmojiRandom.frame.height)
            ])
        }
    }
}

extension Array {
    func item(at index: Int) -> Element? {
        count > index ? self[index] : nil
    }
}
