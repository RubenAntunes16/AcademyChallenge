//
//  AvatarViewModel.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 27/10/2022.
//

import Foundation
import RxSwift

class AvatarViewModel {

    var avatarService: LiveAvatarService?

    var avatarList: Wrapper<[Avatar]?> = Wrapper([])

    func getAvatars() -> Single<[Avatar]> {
        guard let avatarService = avatarService else {
            return Single<[Avatar]>.error(ServiceError.cannotInstanciate)
        }

        return avatarService.fetchAvatarList()
    }

    func deleteAvatar(avatar: Avatar, at index: Int) {
        self.avatarService?.deleteAvatar(avatarToDelete: avatar)

        self.avatarList.value?.remove(at: index)
    }
}
