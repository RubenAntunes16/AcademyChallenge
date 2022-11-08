//
//  EmojiListMockDataSource.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 07/11/2022.
//

import Foundation
import UIKit

// ------ MOCKED CLASS TO MOCKED EMOJIS COLLECTION DATA SOURCE -------
class MockedEmojiDataSource: NSObject, UICollectionViewDataSource {
    var emojiMocked: EmojiMocked = .init()

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojiMocked.mockedEmojis.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        // CUSTOM FUNCTION WITH REUSABLE VIEW
        let cell: EmojisListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)

        let url = emojiMocked.mockedEmojis[indexPath.row].urlImage

        cell.setupCell(url: url)

        return cell
    }
}
