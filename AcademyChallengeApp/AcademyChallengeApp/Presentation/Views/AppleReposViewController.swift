//
//  AppleReposViewController.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/09/2022.
//

import UIKit

class AppleReposViewController: UIViewController {

    let tableView: UITableView

    let loadingSpinner: UIActivityIndicatorView
//
//    let loadingFooterText: UILabel

    let footerView = FooterLoadingAppleRepos(frame: .zero)

    var appleReposList: [AppleRepos] = []

    var page: Int = 0

    var finishedFetchData: Bool = true

    var isEnd: Bool = false

    var viewModel: AppleReposViewModel?

    init() {
        tableView = .init(frame: .zero)
        loadingSpinner = .init(style: .large)
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

        viewModel?.appleReposList.bind(listener: { [weak self] reposList in
            guard
                let self = self,
                let reposList = reposList else { return }
            self.appleReposList = reposList
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.finishedFetchData = true
                // THIS IS TO FILL TABLE VIEW IF THE TABLE HAS SPACE TO DO IT
                if self.tableView.contentSize.height < self.tableView.frame.size.height {
                    self.fetchDataTableView()
                }
                self.loadingSpinner.stopAnimating()
            }
        })
        viewModel?.isEnd.bind(listener: { [weak self] ended in
            guard let self = self else { return }
            self.isEnd = ended
        })
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        //        tableView.prefetchDataSource = self
        tableView.frame = view.bounds
        tableView.backgroundColor = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.automaticallyAdjustsScrollIndicatorInsets = false

        tableView.register(AppleReposViewCell.self, forCellReuseIdentifier: AppleReposViewCell.reuseCellIdentifier)
        tableView.tableFooterView = loadingSpinner
    }

    private func addToSuperView() {
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func fetchDataTableView() {
        loadingSpinner.startAnimating()
        viewModel?.getAppleRepos()
    }
}

extension AppleReposViewController: UITableViewDataSource, UITableViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offset = scrollView.contentOffset.y
        let heightVisibleScroll = scrollView.frame.size.height
        let heightTable = scrollView.contentSize.height

        // I WANT TO SCROLL WHEN SCROLL REACH 10% OF THE END OF THE VIEW
        let offsetNewFetch = heightVisibleScroll * 0.25

        if offset > 0 && (offset + heightVisibleScroll + offsetNewFetch) > heightTable && finishedFetchData && !isEnd {
            finishedFetchData = false
            fetchDataTableView()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return appleReposList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // CUSTOM FUNCTION WITH REUSABLE VIEW
        let cell: AppleReposViewCell = tableView.dequeueReusableCell(for: indexPath)

        cell.setupCell(repoName: appleReposList[indexPath.row].fullName)

        return cell
    }
}

// ------- PREFETCHING FUNCTIONS TO SCROLL AND FETCH DATA IN TABLE VIEW ------

// extension AppleReposViewController: UITableViewDataSourcePrefetching {
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        let newCells = indexPaths.filter({ $0.row >= appleReposList.count - 1})
//
//        if newCells.count > 0 {
//            self.page += 1
//            self.appleReposService?.getAppleRepos(page: self.page,
//size: Constants.AppleReposPagination.perPage, { ( result: Result<[AppleRepos], Error>) in
//                switch result {
//                case .success(let success):
//                    self.isReadyToShow = true
//                    self.reposAux.append(contentsOf: success)
//
//                    newCells.forEach({ indexPath in
//                        print(self.appleReposList.count - indexPath.row)
//                        print(self.reposAux.count)
//                        self.appleReposList.append(self.reposAux[self.appleReposList.count - indexPath.row - 1])
//                    })
//
//                    DispatchQueue.main.async { [weak self] in
//                        self?.tableView.reloadData()
//                    }
//
//                case .failure(let failure):
//                    print("[PREFETCH] Error : \(failure)")
//                }
//            })
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//
//        var auxIndex:Int = 0
//
//        indexPaths.forEach { indexPath in
//
//            // não posso remover do array porque se fizer scroll up não vou ter os valores anteriores
//            print("Indice da cell: \(indexPath.row)")
//            print("Indice da cell - auxIndex: \(indexPath.row - auxIndex)")
//            print("appleReposList count: \(self.appleReposList.count)")
//            self.appleReposList.remove(at: indexPath.row - auxIndex)
//            auxIndex += 1
//        }
//    }
// }
