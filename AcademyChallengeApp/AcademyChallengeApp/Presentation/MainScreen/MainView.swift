//
//  MainView.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 04/11/2022.
//

import Foundation
import UIKit

//
import RxCocoa
import RxSwift

class MainView: BaseGenericView {

    private var containerView: UIView
    var spinnerView: UIActivityIndicatorView
    var emojiImageView: UIImageView

    private var mainStackView: UIStackView
    private var searchStackView: UIStackView

    var buttonEmojisList: UIButton
    var buttonRandomEmojis: UIButton
    var buttonSearch: UIButton
    var searchBar: UISearchBar
    var buttonAvatarList: UIButton
    var buttonAppleRepos: UIButton

    //  Code for RxSwift
    var rxRandomEmojiTap: Observable<Void> { buttonRandomEmojis.rx.tap.asObservable() }
    var rxEmojiListTap: Observable<Void> { buttonEmojisList.rx.tap.asObservable() }
    var rxAvatarListTap: Observable<Void> { buttonAvatarList.rx.tap.asObservable() }
    var rxAppleReposTap: Observable<Void> { buttonAppleRepos.rx.tap.asObservable() }
    var rxSearchTap: Observable<Void> { buttonSearch.rx.tap.asObservable() }
    var rxSearchQuery: Observable<String?> { searchBar.rx.text.asObservable() }

    // --------- HOW TO START ---------
    // 1 - CREATE THE VIEWS
    // 2 - ADDVIEWS TO SUPERVIEW
    // 3 - SET THE CONSTRAINTS
    // --------------------------------

    override init(frame: CGRect) {

        containerView = .init(frame: .zero)
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
            containerView,
            buttonRandomEmojis,
            buttonEmojisList,
            searchStackView,
            buttonAvatarList,
            buttonAppleRepos
        ])

        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createViews() {
        setupViews()
        addViewsToSuperview()
        setupConstraints()
    }

    private func setupViews() {
        // FAZER O SETUP DAS STACKVIEWS

//        containerView.backgroundColor = .orange
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

    }

    // 2 - ADD TO THE SUPERVIEW
    private func addViewsToSuperview() {
        containerView.addSubview(spinnerView)
        addSubview(mainStackView)
//        addSubview(containerView)
    }

    // 3 - SETUP THE CONSTRAINTS
    private func setupConstraints() {
        // THIS IS ALWAYS NECESSARY TO THE UI OBJECTS APPEAR IN THE VIEW
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        emojiImageView.translatesAutoresizingMaskIntoConstraints = false

        let centerYAnchorMargin = World.stackViewPositionPer * frame.height

        // THIS WILL CENTER IN THE SUPERVIEW THE STACK VIEW
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYAnchorMargin),
            mainStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85),

            spinnerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)

        ])

        emojiImageView.contentMode = .scaleAspectFit
    }

    func removeSpinner() {
        if spinnerView.isAnimating {
            spinnerView.stopAnimating()
            spinnerView.removeFromSuperview()
            containerView.addSubview(emojiImageView)

            let bottomMargin = World.Margin.randomImage.symmetric * frame.height
            NSLayoutConstraint.activate([
                emojiImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                emojiImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                emojiImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
                emojiImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                       constant: bottomMargin),
                emojiImageView.heightAnchor.constraint(equalTo: emojiImageView.widthAnchor, multiplier: 0.5)
            ])
        }
    }

}
