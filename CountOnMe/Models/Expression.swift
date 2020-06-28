//
//  Expression.swift
//  CountOnMe
//
//  Created by Lomig Enfroy on 27/06/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Expression {
  private static let operators = ["+", "-", "x", "÷"]
  private var expression: String?
  private var result: String?

  var literal: String {
    let literalResult = result != nil ? " = \(result!)" : ""
    return "\(expression ?? "")\(literalResult)"
  }

  var elements: [String] {
    guard let expression = expression else { return [""] }

    return expression.split(separator: " ").map { "\($0)" }
  }

  var isCorrect: Bool { !Expression.operators.contains(elements.last!) }
  var hasEnoughElements: Bool { elements.count >= 3 }
  var canAddOperator: Bool { !Expression.operators.contains(elements.last!) }
  var hasResult: Bool { result != nil }

  func add(_ character: String) {
    let char = Expression.operators.contains(character) ? " \(character) " : character
    expression = "\(literal)\(char)"
  }

  func evaluate(success: () -> Void, failure: (_ errorMessage: String) -> Void) {
    // Create local copy of operations
    var operationsToReduce = elements

    // Iterate over operations while an operand still here
    while operationsToReduce.count > 1 {
      let left = Int(operationsToReduce[0])!
      let operand = operationsToReduce[1]
      let right = Int(operationsToReduce[2])!

      let result: Int
      switch operand {
      case "+": result = left + right
      case "-": result = left - right
      case "x": result = left * right
      case "÷":
        guard right != 0 else { return failure("Division by zero!") }
        result = left / right
      default: fatalError("Unknown operator !")
      }

      operationsToReduce = Array(operationsToReduce.dropFirst(3))
      operationsToReduce.insert("\(result)", at: 0)
    }

    self.result = operationsToReduce.first!
    success()
  }
}

// For testing purpose only
// Let us set the expression directly for unit testing
#if DEBUG
extension Expression {
  func set(to expression: String) {
    self.expression = expression.isEmpty ? nil : expression
  }
}
#endif
