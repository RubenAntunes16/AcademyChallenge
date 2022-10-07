//
//  ViewController.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 21/09/2022.
//

import UIKit
import Alamofire

enum World {
    struct K {
//        static let appMargin: CGFloat = 20
        static let appMargin: CGFloat = 0.0535
        static let appMarginTop: CGFloat = 20
        static let interItemSpacing: CGFloat = 15
    }
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
    private var emojiImageView: UIImageView
    
    private var mainStackView: UIStackView
    private var searchStackView: UIStackView
    
    private var buttonEmojisList: UIButton
    private var buttonRandomEmojis: UIButton
    private var buttonSearch: UIButton
    private var searchBar: UISearchBar
    private var buttonAvatarList: UIButton
    private var buttonAppleRepos: UIButton
    
    var emojiService: EmojiService?
    
    
    // --------- HOW TO START ---------
    // 1 - CREATE THE VIEWS
    // 2 - ADDVIEWS TO SUPERVIEW
    // 3 - SET THE CONSTRAINTS
    // --------------------------------
    
    // 1 - CREATE VIEWS
    init(){
        viewEmojiRandom = .init(frame: .zero)
        emojiImageView = .init(frame: .zero)
        
        buttonEmojisList = .init(type: .system)
        buttonRandomEmojis = .init(type: .system)
        buttonAvatarList = .init(type: .system)
        buttonAppleRepos = .init(type: .system)
        
        buttonSearch = .init(type: .system)
        searchBar = .init()
        searchStackView = .init(arrangedSubviews: [searchBar,buttonSearch])
        
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
       
        view.backgroundColor = .systemBlue
        view.tintColor = .lightGray
        
        setupViews()
        addViewsToSuperview()
        setupConstraints()
        
        buttonRandomEmojisTap()
    }
    
    private func setupViews(){
        // FAZER O SETUP DAS STACKVIEWS
        
//        emojiImageView.backgroundColor = .orange
        //emojiImageView.image = UIImage(named: "emoji_Test")
        //emojiImageView.contentMode = UIView.ContentMode.scaleToFill
        
        mainStackView.axis = .vertical
        mainStackView.spacing = CGFloat(World.K.interItemSpacing)
        
        searchStackView.axis = .horizontal
        searchStackView.spacing = CGFloat(World.K.interItemSpacing)
        
        // FAZER O SETUP DOS BUTTONS
        let buttonArray = [buttonRandomEmojis, buttonEmojisList, buttonSearch, buttonAvatarList, buttonAppleRepos]
        buttonArray.forEach {
            $0.configuration = .filled()
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
        
    }
    
    // 2 - ADD TO THE SUPERVIEW
    private func addViewsToSuperview(){
        viewEmojiRandom.addSubview(emojiImageView)
        view.addSubview(mainStackView)
        view.addSubview(viewEmojiRandom)
    }
    
    // 3 - SETUP THE CONSTRAINTS
    private func setupConstraints(){
        // THIS IS ALWAYS NECESSARY TO THE UI OBJECTS APPEAR IN THE VIEW
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        viewEmojiRandom.translatesAutoresizingMaskIntoConstraints = false
        emojiImageView.translatesAutoresizingMaskIntoConstraints = false
       
        
        // THIS WILL CENTER IN THE SUPERVIEW THE STACK VIEW
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: 50),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: World.K.appMargin * view.frame.width),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: World.K.appMargin.symmetric * view.frame.width),
            
            viewEmojiRandom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: World.K.appMargin * view.frame.width),
            viewEmojiRandom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: World.K.appMargin.symmetric * view.frame.width),
            viewEmojiRandom.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: World.K.appMarginTop),
            viewEmojiRandom.bottomAnchor.constraint(equalTo: mainStackView.topAnchor,constant: World.K.interItemSpacing.symmetric),
            
//            emojiImageView.leadingAnchor.constraint(equalTo: viewEmojiRandom.leadingAnchor, constant: World.K.appMarginTop),
//            emojiImageView.trailingAnchor.constraint(equalTo: viewEmojiRandom.trailingAnchor, constant: World.K.appMarginTop.symmetric),
//            emojiImageView.topAnchor.constraint(equalTo: viewEmojiRandom.topAnchor, constant: World.K.appMarginTop),
//            emojiImageView.bottomAnchor.constraint(equalTo: viewEmojiRandom.bottomAnchor, constant: World.K.appMarginTop.symmetric)
            
            emojiImageView.centerXAnchor.constraint(equalTo: viewEmojiRandom.centerXAnchor),
            emojiImageView.centerYAnchor.constraint(equalTo: viewEmojiRandom.centerYAnchor)
            
        ])
        
//        emojiImageView.contentMode = .scaleAspectFit
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    @objc func buttonEmojisListTap(_ sender: UIButton){

        let emojiListCoordinator = EmojisListCoordinator(presenter: navigationController!)
        
        emojiListCoordinator.start()

        self.emojisListCoordinator = emojiListCoordinator
    }
    
    @objc func buttonAvatarListTap(_ sender: UIButton){
        
        let avatarListCoordinator = AvatarListCoordinator(presenter: navigationController!)

        avatarListCoordinator.start()

        self.avatarListCoordinator = avatarListCoordinator
    }
    
    @objc func buttonRandomEmojisTap(){
        emojiService?.getEmojisList({ [weak self] (result: Result<[Emoji],Error>) in
            switch result{
            case .success(let success):
                
               guard let randomUrl = success.randomElement()?.urlImage else { return }
                
                self?.emojiImageView.downloadImageFromURL(from: randomUrl)
                
            case .failure(let failure):
                print("Failure: \(failure)")
                self?.emojiImageView.image = UIImage(named: "noEmoji")
            }
            
        })
    }
}

extension Array{
    func item(at: Int) -> Element?{
        count > at ? self[at] : nil
    }
}

