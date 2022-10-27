//
//  TableViewFooterLoading.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 25/10/2022.
//

import Foundation
import UIKit

class FooterLoadingAppleRepos: UITableViewHeaderFooterView {
    
//    var stackView : UIStackView
    var loadingSpinner: UIActivityIndicatorView
    var loadingText : UILabel
    
    override init(reuseIdentifier: String?) {
        
        self.loadingSpinner = .init(style: .large)
        self.loadingText = .init(frame: .zero)
        super.init(reuseIdentifier: reuseIdentifier)
        setupFooter()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupFooter(){
//        stackView.axis = .horizontal
//        stackView.spacing = CGFloat(10.0)
        loadingText.text = "Loading new Data..."
        loadingText.font = .systemFont(ofSize: 16)
        loadingText.textColor = UIColor.white
        loadingText.backgroundColor = UIColor.blue
        loadingText.textAlignment = .center
        addSubview(loadingSpinner)
        addSubview(loadingText)
        
    }
    
    func setupConstraints() {
        loadingText.translatesAutoresizingMaskIntoConstraints = false
        loadingSpinner.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            loadingSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            loadingText.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingText.topAnchor.constraint(equalTo: loadingSpinner.bottomAnchor),
            loadingText.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
