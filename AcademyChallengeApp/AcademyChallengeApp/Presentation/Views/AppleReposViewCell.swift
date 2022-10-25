//
//  AppleReposViewCell.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 18/10/2022.
//

import Foundation
import UIKit

class AppleReposViewCell: UITableViewCell{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.textLabel?.numberOfLines = 0
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(repoName: String){
        
        let splittedString = repoName.split(separator: "/")
        
        self.textLabel?.text = String(splittedString[splittedString.count-1])
        
    }
}
