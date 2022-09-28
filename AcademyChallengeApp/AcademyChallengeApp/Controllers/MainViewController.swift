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
    
    //private
    
    private var buttonEmojisList: UIButton
    private var buttonRandomEmojis: UIButton
    private var buttonSearch: UIButton
    private var searchBar: UISearchBar
    private var buttonAvatarList: UIButton
    private var buttonAppleRepos: UIButton
    
    private var emojisList: [Emoji]
    
    
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
        
        emojisList = []
        
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
        getEmojisList()
        
        let url = URL(string: "https://github.githubassets.com/images/icons/emoji/unicode/1f947.png?v8")!
        downloadImage(from: url)
        
        setupViews()
        addViewsToSuperview()
        setupConstraints()
        //getAllEmojis()
    }
    
    private func setupViews(){
        // FAZER O SETUP DAS STACKVIEWS
        title = "Main Screen"
        
        //emojiImageView.backgroundColor = .orange
        //emojiImageView.image = UIImage(named: "emoji_Test")
        //emojiImageView.contentMode = UIView.ContentMode.scaleToFill
        
        mainStackView.axis = .vertical
        mainStackView.spacing = CGFloat(World.K.interItemSpacing)
        
        searchStackView.axis = .horizontal
        searchStackView.spacing = CGFloat(World.K.interItemSpacing)
        
        // FAZER O SETUP DOS BUTTONS
        buttonRandomEmojis.setTitle("RANDOM EMOJI", for: .normal)
        buttonRandomEmojis.configuration = .filled()
        //buttonRandomEmojis.tintColor = .secondarySystemBackground
        
        buttonEmojisList.setTitle("EMOJIS LIST", for: .normal)
        buttonEmojisList.configuration = .filled()
        //buttonRandomEmojis.tintColor = .secondarySystemBackground
        
        buttonSearch.setTitle("SEARCH", for: .normal)
        buttonSearch.configuration = .filled()
        //buttonRandomEmojis.tintColor = .systemGray3
        
        buttonAvatarList.setTitle("AVATARS LIST", for: .normal)
        buttonAvatarList.configuration = .filled()
        //buttonRandomEmojis.tintColor = .systemGray4
        
        buttonAppleRepos.setTitle("APPLE REPOS", for: .normal)
        buttonAppleRepos.configuration = .filled()
        
        buttonRandomEmojis.addTarget(self, action: #selector(buttonRandomEmojisTap(_:)), for: .touchUpInside)
        
        // TouchUpInside - é o gesto vulgar de carregar no botão
        buttonEmojisList.addTarget(self, action: #selector(buttonEmojisListTap(_:)), for: .touchUpInside)
        
        buttonAvatarList.addTarget(self, action: #selector(buttonEmojisListTap(_:)), for: .touchUpInside)
        
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
            
            emojiImageView.centerXAnchor.constraint(equalTo: viewEmojiRandom.centerXAnchor),
            emojiImageView.centerYAnchor.constraint(equalTo: viewEmojiRandom.centerYAnchor)
            
        ])
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func buttonEmojisListTap(_ sender: UIButton){
        // SUBSTITUTE WITH COORDINATOR
//        let emojisListView = EmojisListViewController()
//
//        navigationController?.pushViewController(emojisListView, animated: true)
        
        let emojiListCoordinator = EmojisListCoordinator(presenter: navigationController!, emojisList: emojisList)
        
        emojiListCoordinator.start()
        
        self.emojisListCoordinator = emojiListCoordinator
        //self.present(emojisListView, animated: true)
    }
    
    @objc func buttonAvatarListTap(_ sender: UIButton){
        // SUBSTITUTE WITH COORDINATOR
//        let emojisListView = EmojisListViewController()
//
//        navigationController?.pushViewController(emojisListView, animated: true)
        
//        let emojiListCoordinator = EmojisListCoordinator(presenter: navigationController!)
//
//        emojiListCoordinator.start()
//
//        self.emojisListCoordinator = emojiListCoordinator
        //self.present(emojisListView, animated: true)
    }
    
    @objc func buttonRandomEmojisTap(_ sender: UIButton){
        getRandomEmoji()
    }
    
    func getRandomEmoji(){
        let random = Int.random(in: 0...emojisList.count)
        
        guard let emoji = emojisList.item(at: random) else { return }
        
        let url = URL(string: emoji.urlImage)
        downloadImage(from: url!)
    }
    
    // -------------- NETWORKING ---------------
    
    
    // -------- SWIFT VERSION ------
    // --------- 1
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

   func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            // always update the UI from the main thread
            DispatchQueue.main.async() { () in
                self.emojiImageView.image = UIImage(data: data)
            }
        }
    }
    
    // --------- 2
    //ir buscar ao playground networking
    
    //-------- ALAMOFIRE VERSION -------
//    func getAllEmojis(){
//        let response = AF.request("https://api.github.com/emojis")
//
//        response.responseJSON { (data) in print(data)}
//    }
    
    private func getEmojisList(){
        let url = URL(string: "https://api.github.com/emojis")!

        var request = URLRequest(url: url)

        print(request)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String,String>
        //        print(json!)
        //        print(data)
                //print(String(data: data, encoding: .utf8))
                if let array = json {
                    print(array.count)
                    for (emojiName,emojiUrl) in array {
                        self.emojisList.append(Emoji(name: emojiName, urlImage: emojiUrl))
                        //print("Item \(emojiName) - URL: \(emojiUrl)\n")
                    }
                    self.getRandomEmoji()
                }
                
                //print(String(data: data, encoding: .utf8))
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }

        task.resume()
    }
     
}

extension Array{
    func item(at: Int) -> Element?{
        count > at ? self[at] : nil
    }
}

