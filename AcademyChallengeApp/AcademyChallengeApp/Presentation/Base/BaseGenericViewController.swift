//
//  BaseGenericViewController.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 04/11/2022.
//

import Foundation
import UIKit
import RxSwift

class BaseGenericViewController<View: BaseGenericView>: UIViewController {

    var disposeBag = DisposeBag()

    var genericView: View {
        view as! View
    }

    override func loadView() {
        view = View()
    }
}
