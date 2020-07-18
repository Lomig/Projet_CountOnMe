//
//  CalculusHistory.swift
//  CountOnMe
//
//  Created by Lomig Enfroy on 18/07/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class CalculusHistory {
  private var history = [Calculus()]

  var currentCalculus: Calculus { history.last! }

  var display: String {
    var result = ""

    history.forEach { calculus in
      if result.isEmpty {
        result = calculus.literal
      } else {
        result = "\(result)\n\(calculus.literal)"
      }
    }

    return result
  }

  func addNewCalculus(startingWith expression: String? = nil) {
    guard currentCalculus.hasResult else { return }

    history.append(Calculus(expression))
  }

  func clear() {
    history = [currentCalculus.hasResult ? Calculus() : currentCalculus]
  }
}
