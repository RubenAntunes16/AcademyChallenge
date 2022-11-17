//
//  ViewControllerTest.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 16/11/2022.
//

import Foundation
import UIKit

class TestViewController: UIViewController {

    weak var delegate: BackMainDelegate?

    deinit {
        print("Deinit Test")
        delegate?.back()
    }

    override func viewDidLoad() {
        view.backgroundColor = .purple
    }

//    override func viewDidDisappear(_ animated: Bool) {
//        if isMovingToParent {
//            delegate?.back()
//        }
//    }
}
