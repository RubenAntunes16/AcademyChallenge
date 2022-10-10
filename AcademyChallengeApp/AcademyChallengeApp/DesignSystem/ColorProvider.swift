//
//  ColorProvider.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 07/10/2022.
//

import Foundation
import UIKit


enum ColorProvider: String {
    case primary
    case secondary
    case surface
}

extension UIColor {
    static func appColor(name: ColorProvider) -> UIColor?{
        return UIColor(named: name.rawValue)
    }
}
