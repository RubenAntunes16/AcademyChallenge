//
//  BaseGenericView.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 04/11/2022.
//

import Foundation
import UIKit
import RxSwift

class BaseGenericView: UIView {

    var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createViews() {}
}
