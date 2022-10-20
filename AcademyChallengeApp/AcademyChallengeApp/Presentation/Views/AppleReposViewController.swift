//
//  AppleReposViewController.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/09/2022.
//

import UIKit

class AppleReposViewController: UIViewController {
    
    let tableView: UITableView
    
    var appleReposService: AppleReposService?
    
    var appleReposList: [AppleRepos] = []
    
    var page: Int = 1
    
    var reposAux: [AppleRepos] = []
    
    init(){
        tableView = .init(frame: .zero)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
        addToSuperView()
        setupConstraints()
        view.backgroundColor = .appColor(name: .surface)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        appleReposService?.getAppleRepos(page: page, size: Constants.AppleReposPagination.perPage){ (result: Result<[AppleRepos], Error>) in
            switch result {
            case .success(let success):
                self.appleReposList = success
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
                
            case .failure(let failure):
                print("[APPLE REPOS] Error to get List: \(failure)")
            }
        }
        
        
    }
    
    private func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.prefetchDataSource = self
        tableView.frame = view.bounds
        tableView.backgroundColor = .none
        tableView.rowHeight = 64
        tableView.register(AppleReposViewCell.self, forCellReuseIdentifier: Constants.CellIdentifiers.appleReposCellIdentifier)
    }
    
    private func addToSuperView() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints(){
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension AppleReposViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appleReposList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.appleReposCellIdentifier, for: indexPath) as! AppleReposViewCell
        
        cell.setupCell(repoName: appleReposList[indexPath.row].fullName)
        
        return cell
    }
    
    
}

extension AppleReposViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let newCells = indexPaths.filter({ $0.row >= appleReposList.count - 1})
               
        self.page += 1
        self.appleReposService?.getAppleRepos(page: self.page, size: Constants.AppleReposPagination.perPage, { ( result: Result<[AppleRepos], Error>) in
            switch result {
            case .success(let success):
                self.reposAux.append(contentsOf: success)

                newCells.forEach({ indexPath in
                    
                    self.appleReposList.append(self.reposAux[self.appleReposList.count - indexPath.row])
                })
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
                
            case .failure(let failure):
                print("[PREFETCH] Error : \(failure)")
            }
        })

        
        // NÃO SEI SE AQUI ESTÁ CERTO, PORQUE ASSIM POR CADA NOVA CELL A SER PREFETCHED VAI SER FEITA UM NOVO REQUEST À API
        
        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("ESTOU ALIIIII!!!! :)")
        indexPaths.forEach { indexPath in
            self.appleReposList.remove(at: indexPath.row)
        }
    }
}

//class AppleReposDataSourceMocked: NSObject, UITableViewDataSourcePrefetching {
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        let filtered = indexPaths.filter({ $0.row >= appleReposList.count - 1})
//
//        filtered.forEach({_ in
//            self.page += 1
//            self.appleReposService?.getAppleRepos(page: self.page, size: Constants.AppleReposPagination.perPage, { ( result: Result<[AppleRepos], Error>) in
//                switch result {
//                case .success(let success):
//                    self.appleReposList.append(contentsOf: success)
//                    DispatchQueue.main.async { [weak self] in
//                        self?.tableView.reloadData()
//                    }
//
//                case .failure(let failure):
//                    print("[PREFETCH] Error : \(failure)")
//                }
//            })
//        })
//
//    }
//
//    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//        print("ESTOU ALIIIII!!!! :)")
//    }
//}
