//
//  Wrapper.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/10/2022.
//

import Foundation

final class Wrapper<T> {
  typealias Listener = (T) -> Void

  // LISTENER USED TO NOTIFIES THE CHANGE OF THE VALUE
  var listener: Listener?

  // DID SET IS TRIGGERED WHEN THE VALUE IS UPDATED, AND WILL NOTIFIES LISTENER OF THE NEW CHANGE
  var value: T {
    didSet {
      listener?(value)
    }
  }

  init(_ value: T) {
    self.value = value
  }

  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
