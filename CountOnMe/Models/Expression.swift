//
//  Expression.swift
//  CountOnMe
//
//  Created by Lomig Enfroy on 27/06/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Expression {
  private static let operators = ["+", "–", "x", "÷"]
  private static let numberSymbols = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".", "-"]
  private var expression: String?
  var result: String?

  init(_ initialValue: String? = nil) {
    expression = initialValue
  }

  var literal: String {
    guard let expression = expression else { return "" }
    guard let result = result else { return expression }

    if let result = Float(result), result == floor(result) {
      return "\(expression) = \(Int(result))"
    }

    return "\(expression) = \(result)"
  }

  var elements: [String] {
    guard let expression = expression else { return [""] }

    return expression.split(separator: " ").map { "\($0)" }
  }

  var isCorrect: Bool { !Expression.operators.contains(elements.last!) }
  var hasEnoughElements: Bool { elements.count >= 3 }
  var canAddOperator: Bool { !Expression.operators.contains(elements.last!) && expression != nil }
  var hasResult: Bool { result != nil }

  var parenthesisBalanced: Bool {
    var parenthesisCount = 0

    for element in elements {
      if element == "(" {
        parenthesisCount += 1
      } else if element == ")" {
        parenthesisCount -= 1
      }

      if parenthesisCount < 0 { return false }
    }

    if parenthesisCount > 0 { return false }

    return true
  }

  // true if the closing parenthesis is the last element or followed by an operator
  // false if followed by a number
  var parenthesisFollowedByOperator: Bool {
    return elements.enumerated().first { index, element in
      index < elements.count - 1 && element == ")" && Float(elements[index + 1]) != nil
    } == nil
  }

  func add(_ character: String, onSuccess success: () -> Void, onFailure failure: (_ errorMessage: String) -> Void) {
    guard !Expression.operators.contains(character) || canAddOperator else {
      return failure("Un operateur est déja mis !")
    }

    let char = !Expression.numberSymbols.contains(character) ? " \(character) " : character
    expression = "\(literal)\(char)"
      .replacingOccurrences(of: "[\\s\n]+", with: " ", options: .regularExpression, range: nil)

    success()
  }

  func backspace(onCompletion complete: () -> Void) {
    if hasResult { return }
    guard let expression = expression else { return }
    guard let lastCharacter = elements.last else { return }

    if Float(lastCharacter) == nil {
      self.expression = String(expression.dropLast(3))
    } else {
      self.expression = String(expression.dropLast())
    }
    complete()
  }

  func clear(onCompletion complete: () -> Void) {
    if hasResult { return }

    expression = nil
    complete()
  }

  func evaluate(onSuccess success: () -> Void, onFailure failure: (_ errorMessage: String) -> Void) {
    guard isCorrect else { return failure("Entrez une expression correcte !") }
    guard hasEnoughElements else { return failure("Démarrez un nouveau calcul !") }
    guard parenthesisBalanced else { return failure("Problème de parenthèse !") }
    guard parenthesisFollowedByOperator else { return failure("Entrez une expression correcte !") }


    // Create local copy of operations`
    var elements = self.elements

    elements = evaluateInternalExpressions(elements)

    // Iterate over operations while an operand still here
    while elements.count > 1 {
      // We want to deal with the first multiplication, or the first division
      // Fallback : the first other operation
      let indexOfOperand = elements.firstIndex(of: "x") ?? elements.firstIndex(of: "÷") ?? 1
      guard let left = Float(elements[indexOfOperand - 1]) else {
        return failure("\(elements[indexOfOperand - 1]) n'est pas un nombre !")
      }
      guard let right = Float(elements[indexOfOperand + 1]) else {
        return failure("\(elements[indexOfOperand + 1]) n'est pas un nombre !")
      }
      guard Expression.operators.contains(elements[indexOfOperand]) else {
        return failure("\(elements[indexOfOperand]) n'est pas un opérateur connu !")
      }
      guard !(elements[indexOfOperand] == "÷" && right == 0) else {
        return failure("Division par zéro !")
      }

      let result = compute(left: left, operand: elements[indexOfOperand], right: right)

      elements.insert("\(result)", at: indexOfOperand - 1)
      elements.removeSubrange(ClosedRange(uncheckedBounds: (lower: indexOfOperand, upper: indexOfOperand + 2)))
    }

    self.result = elements.first!
    success()
  }

  private func compute(left: Float, operand: String, right: Float) -> Float {
    switch operand {
    case "+": return left + right
    case "–": return left - right
    case "x": return left * right
    case "÷": return left / right
    // Default case was an error, that is now already handled in the evaluate method.
    // I would have used an enum to avoid this dummy default, but it was asked not to change the main algorithm
    default: return 0
    }
  }

  private func evaluateInternalExpressions(_ elements: [String]) -> [String] {
    var elements = elements
    while elements.contains("(") {
      guard let lastOpenParenthesis = elements.lastIndex(of: "(") else { return elements }

      let matchingCloseParenthesis = elements[lastOpenParenthesis...].firstIndex(of: ")")!
      let expression = Expression(elements[lastOpenParenthesis + 1 ..< matchingCloseParenthesis].joined(separator: " "))
      expression.evaluate(onSuccess: {}, onFailure: { _ in })
      elements.removeSubrange(ClosedRange(uncheckedBounds: (
        lower: lastOpenParenthesis,
        upper: matchingCloseParenthesis
      )))
      elements.insert(expression.result!, at: lastOpenParenthesis)
      if lastOpenParenthesis >= 1 && Float(elements[lastOpenParenthesis - 1]) != nil {
        elements.insert("x", at: lastOpenParenthesis)
      }
    }

    return elements
  }
}
