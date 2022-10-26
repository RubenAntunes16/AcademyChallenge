//
//  Coordinator.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 23/09/2022.
//

import Foundation

protocol Coordinator {
    func start()
}

let emojiSource = LiveEmojiService()
let avatarService = LiveAvatarService()
let appleReposService = LiveAppleReposService()
