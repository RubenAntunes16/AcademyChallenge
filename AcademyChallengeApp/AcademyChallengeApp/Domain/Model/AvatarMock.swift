//
//  AvatarMock.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 13/10/2022.
//

import Foundation

class AvatarMock {
    var avatars : [Avatar] = [
        Avatar(name: "Teste", id: 21, avatarUrl: URL(string:"https://avatars.githubusercontent.com/u/1?v=4")!),
        Avatar(name: "blissapps", id: 22, avatarUrl: URL(string:"https://avatars.githubusercontent.com/u/223156?v=4")!),
        Avatar(name: "Teste2", id: 23, avatarUrl: URL(string:"https://avatars.githubusercontent.com/u/2?v=4")!),
        Avatar(name: "Teste3", id: 24, avatarUrl: URL(string:"https://avatars.githubusercontent.com/u/3?v=4")!),
    ]
}
