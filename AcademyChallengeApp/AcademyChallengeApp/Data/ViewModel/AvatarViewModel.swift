//
//  AvatarViewModel.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 27/10/2022.
//

import Foundation

class AvatarViewModel {

    var avatarService: LiveAvatarService?

    var avatarList: Wrapper<[Avatar]?> = Wrapper([])

    func getAvatars() {
        avatarService?.fetchAvatarList({ [weak self] (result: [Avatar]) in
            guard let self = self else { return }
            self.avatarList.value = result
        })
    }

    func deleteAvatar(avatar: Avatar, at index: Int) {
        self.avatarService?.deleteAvatar(avatarToDelete: avatar)

        self.avatarList.value?.remove(at: index)
    }
}
