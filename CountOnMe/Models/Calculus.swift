//
//  Expression.swift
//  CountOnMe
//
//  Created by Lomig Enfroy on 27/06/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import Foundation

class Calculus {
  private static let operators = ["+", "–", "x", "÷"]
  private static let parenthesis = ["(", ")"]
  private var expression: String?

  private(set) var result: String?

  init(_ initialValue: String? = nil) {
    expression = initialValue
  }

  //----------------------------------------------------------------
  // MARK: - Public Computed Properties
  //----------------------------------------------------------------

  // Formated string for the expression
  // If it has not been evaluated yet, the expression itself
  // Else the expression followed by its result.
  var literal: String {
    guard var expression = expression else { return "" }

    // We keep sure that there are no unnecessary spaces to display:
    // Leading and trailing spaces, but also consecutive spaces
    // Example - a closing parenthesis followed by an operator or another closing parenthesis
    expression = expression
      .trimmingCharacters(in: .whitespaces)
      .replacingOccurrences(
        of: "[\\s\n]+",
        with: " ",
        options: .regularExpression,
        range: nil)

    guard let result = result else { return expression }

    // If the result is an Int, convert it to avoid ".0" to be shown
    if let result = Float(result), result == floor(result) {
      return "\(expression) = \(Int(result))"
    }

    return "\(expression) = \(result)"
  }

  // Helper to transform Optional into Boolean
  var hasResult: Bool { result != nil }

  //----------------------------------------------------------------
  // MARK: - Private Computed Properties
  //----------------------------------------------------------------

  private var hasEnoughElements: Bool { elements.count >= 3 }

  private var elements: [String] {
    guard let expression = expression else { return [] }

    // Original algorithm
    return expression.split(separator: " ").map { "\($0)" }
  }

  private var isCorrect: Bool {
    guard let lastCharacter = elements.last else { return true }

    return !Calculus.operators.contains(lastCharacter)
  }

  private var canAddOperator: Bool {
    guard let lastCharacter = elements.last else { return false }

    return !Calculus.operators.contains(lastCharacter)
  }

  private var allParenthesisMatch: Bool {
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

  private var closingParenthesisFollowedByOperator: Bool {
    // true if the closing parenthesis is the last element or followed by an operator
    // false otherwise
    return elements.enumerated().first { index, element in
      index < elements.count - 1 &&
      element == ")" &&
      !isSymbol(elements[index + 1])
    } == nil
  }

  //----------------------------------------------------------------
  // MARK: - Public Methods
  //----------------------------------------------------------------

  // Add a character to the expression
  func add(_ character: String, onSuccess success: () -> Void, onFailure failure: (_ errorMessage: String) -> Void) {
    guard !Calculus.operators.contains(character) || canAddOperator else {
      return failure("Vous ne pouvez pas mettre un opérateur !")
    }
    if let lastElement = elements.last, Float(lastElement) != nil, character == "-" {
      return failure("Ne pas confondre - et – !")
    }

    // We put spaces around symbols for readbility and to be able to split the expression for evaluation
    let char = isSymbol(character) ? " \(character) " : character
    expression = "\(expression ?? "")\(char)"

    success()
  }

  // Delete the last character
  func backspace(onCompletion complete: () -> Void) {
    if hasResult { return }
    guard let expression = expression else { return }

    // if the last character is a symbol, remove the spaces around it as well as the symbol itself
    if isSymbol(elements.last!) {
      self.expression = String(expression.dropLast(3))
    } else {
      self.expression = String(expression.dropLast())
    }
    complete()
  }

  // Delete the entire expression
  func clear(onCompletion complete: () -> Void) {
    if hasResult { return }

    expression = nil
    complete()
  }

  func evaluate(onSuccess success: () -> Void, onFailure failure: (_ errorMessage: String) -> Void) {
    guard isCorrect else { return failure("Entrez une expression correcte !") }
    guard hasEnoughElements else { return failure("Démarrez un nouveau calcul !") }
    guard allParenthesisMatch else { return failure("Problème de parenthèse !") }
    guard closingParenthesisFollowedByOperator else { return failure("Entrez une expression correcte !") }


    // Create local copy of operations`
    var elements = self.elements

    // Content of parenthesis is considered as a Calculus in itself
    // We need to propagate a Calculus Evaluation error from the new Calculus to the master one
    var internalCalculusError: String?
    elements = evaluateInternalCalculus(elements) { errorMessage in
      internalCalculusError = errorMessage
    }

    if internalCalculusError != nil {
      return failure(internalCalculusError!)
    }

    // Iterate over operations while an operand still here
    while elements.count > 1 {
      // Operator priority force us to change the original algorithm
      // Using a dynamic index for the operator instead of index 1
      // We want to deal with the first multiplication, or the first division
      // Fallback : the first other operation
      let indexOfOperand = elements.firstIndex(of: "x") ?? elements.firstIndex(of: "÷") ?? 1

      guard let left = Float(elements[indexOfOperand - 1]) else {
        return failure("\(elements[indexOfOperand - 1]) n'est pas un nombre !")
      }
      guard let right = Float(elements[indexOfOperand + 1]) else {
        return failure("\(elements[indexOfOperand + 1]) n'est pas un nombre !")
      }
      guard Calculus.operators.contains(elements[indexOfOperand]) else {
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

  //----------------------------------------------------------------
  // MARK: - Private Methods
  //----------------------------------------------------------------

  private func isSymbol(_ character: String) -> Bool {
    return Calculus.operators.contains(character) || Calculus.parenthesis.contains(character)
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

  // Each parenthesis content is made a seperate Calculus
  // It allows us not to handle anything special
  private func evaluateInternalCalculus(_ elements: [String], onFailure failure: (_ errorMessage: String) -> Void) -> [String] {
    var elements = elements
    while elements.contains("(") {
      let lastOpenParenthesis = elements.lastIndex(of: "(")!

      var success = false
      var error: String!

      let matchingCloseParenthesis = elements[lastOpenParenthesis...].firstIndex(of: ")")!
      let expression = Calculus(elements[lastOpenParenthesis + 1 ..< matchingCloseParenthesis].joined(separator: " "))
      expression.evaluate(onSuccess: { success = true }, onFailure: { errorMessage in error = errorMessage })

      elements.removeSubrange(ClosedRange(uncheckedBounds: (
        lower: lastOpenParenthesis,
        upper: matchingCloseParenthesis
      )))

      if success {
        elements.insert(expression.result!, at: lastOpenParenthesis)
        if lastOpenParenthesis >= 1 &&
          (Float(elements[lastOpenParenthesis - 1]) != nil || elements[lastOpenParenthesis - 1] == ")" ) {
            elements.insert("x", at: lastOpenParenthesis)
        }
      } else {
        failure(error)
        break
      }
    }

    return elements
  }
}
