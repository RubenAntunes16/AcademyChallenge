//
//  AppleReposView.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 07/11/2022.
//

import Foundation
import UIKit

class AppleReposView: BaseGenericView {

    let tableView: UITableView

    let loadingSpinner: UIActivityIndicatorView

    override init(frame: CGRect) {
        tableView = .init(frame: .zero)
        loadingSpinner = .init(style: .large)

        super.init(frame: frame)
        
        backgroundColor = .appColor(name: .surface)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createViews() {
        setupTableView()
        addToSuperView()
        setupConstraints()
    }

    private func setupTableView() {
        //        tableView.prefetchDataSource = self
        tableView.frame = bounds
        tableView.backgroundColor = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.automaticallyAdjustsScrollIndicatorInsets = false

        tableView.register(AppleReposViewCell.self, forCellReuseIdentifier: AppleReposViewCell.reuseCellIdentifier)
        tableView.tableFooterView = loadingSpinner
    }

    private func addToSuperView() {
        addSubview(tableView)
    }

    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
