//
//  AvatarService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 14/11/2022.
//

import Foundation

import RxSwift

protocol AvatarService {

    func getAvatar() -> Observable<Avatar>
}
