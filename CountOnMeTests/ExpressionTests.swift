//
//  CalculusTests.swift
//  CountOnMeTests
//
//  Created by Lomig Enfroy on 27/06/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class ExpressionTests: XCTestCase {
  var expression: Expression!

  func testAnExpressionCanBeSplitIntoElements() {
    expression = Expression("2 + 4 ")
    XCTAssertEqual(expression.elements[0], "2")
    XCTAssertEqual(expression.elements[1], "+")
    XCTAssertEqual(expression.elements[2], "4")
  }

  func testNilExpressionHasAnEmptyStringLiteral() {
    expression = Expression()
    XCTAssertEqual(expression.literal, "")
    XCTAssertEqual(expression.elements, [""])
  }

  func testExpressionIsCorrectWhenFinishingByANumber() {
    expression = Expression("2 + 4 ")
    XCTAssertTrue(expression.isCorrect)
    XCTAssertTrue(expression.canAddOperator)
  }

  func testExpressionIsIncorrectWhenFinishingByAnOperator() {
    expression = Expression("3 – 7 +")
    XCTAssertFalse(expression.isCorrect)
    XCTAssertFalse(expression.canAddOperator)
  }

  func testExpressionWithCorrectNestedParenthesis() {
    expression = Expression("1 + ( 3 – 2 x ( 9 – 1 ) ) x 4")
    XCTAssertTrue(expression.parenthesisBalanced)

    expression = Expression("( 1 + 3 )")
    XCTAssertTrue(expression.parenthesisBalanced)

    expression = Expression("4 ( 1 + 3 )")
    XCTAssertTrue(expression.parenthesisBalanced)
  }

  func testExpressionWithIncorrectNestedParenthesis() {
    expression = Expression("1 + ) ( 3 – 2 x ( 9 – 1 ) x 4")
    XCTAssertFalse(expression.parenthesisBalanced)

    expression = Expression("1 + ( 3 – 2 x ( 9 – 1 ) x 4")
    XCTAssertFalse(expression.parenthesisBalanced)

    expression = Expression("( 1 + 3 ) 4")
    XCTAssertFalse(expression.parenthesisFollowedByOperator)
  }

  func testAddingCharactersToExpression() {
    expression = Expression()
    expression.add(
      "2",
      onSuccess: { XCTAssertEqual(expression.literal, "2") },
      onFailure: { _ in XCTAssert(false) })
    expression.add(
      "+",
      onSuccess: { XCTAssertEqual(expression.literal, "2 + ") },
      onFailure: { _ in XCTAssert(false) })
    expression.add(
      "2",
      onSuccess: { XCTAssertEqual(expression.literal, "2 + 2") },
      onFailure: { _ in XCTAssert(false) })
    expression.add(
      "1",
      onSuccess: { XCTAssertEqual(expression.literal, "2 + 21") },
      onFailure: { _ in XCTAssert(false) })
    expression.add(
      ".",
      onSuccess: { XCTAssertEqual(expression.literal, "2 + 21.") },
      onFailure: { _ in XCTAssert(false) })
  }

  func testEvaluateACorrectExpressionReturninAnIntegerIsASuccess() {
    expression = Expression("3 – 1 + 4 x 5")
    expression.evaluate(
      onSuccess: { XCTAssertEqual(expression.literal, "3 – 1 + 4 x 5 = 22") },
      onFailure: { _ in XCTAssert(false) })
  }

  func testEvaluateACorrectExpressionReturningAFloatIsASuccess() {
    expression = Expression("2 + 3 ÷ 2")
    expression.evaluate(
      onSuccess: { XCTAssertEqual(expression.literal, "2 + 3 ÷ 2 = 3.5") },
      onFailure: { _ in XCTAssert(false) })
  }

  func testEvaluateACorrectExpressionWithParenthesisIsASuccess() {
    expression = Expression("1.5 + 2 ( 3 – 2 x ( 9 + -1 ) ) x 4")
    expression.evaluate(
      onSuccess: { XCTAssertEqual(expression.literal, "1.5 + 2 ( 3 – 2 x ( 9 + -1 ) ) x 4 = -102.5") },
      onFailure: { _ in XCTAssert(false) })
  }

  func testEvaluateDivisionByZeroThrowsAnError() {
    expression = Expression("2 – 1 + 4 ÷ 0")
    expression.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "Division par zéro !") })
  }

  func testEvaluateMismatchedParenthesisThrowsAnError() {
    expression = Expression("1 + ) ( 3 – 2 x ( 9 – 1 ) x 4")
    expression.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "Problème de parenthèse !") })
  }

  func testEvaluateParenthesisFollowedByNumberThrowsAnError() {
    expression = Expression("( 1 + 3 ) 4")
    expression.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "Entrez une expression correcte !") })
  }

  func testEvaluateWhenLeftElementIsNotANumberThrowsAnError() {
    expression = Expression("A + 3")
    expression.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "A n'est pas un nombre !") })
  }

  func testEvaluateWhenRightElementIsNotANumberThrowsAnError() {
    expression = Expression("1 + A")
    expression.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "A n'est pas un nombre !") })
  }

  func testEvaluateWhenOperatorIsNotCorrectThrowsAnError() {
    expression = Expression("1 A 3")
    expression.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "A n'est pas un opérateur connu !") })
  }

  func testCannotAddSecondOperatorToAnExpression() {
    expression = Expression("2 + ")
    expression.add(
      "+",
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "Un operateur est déja mis !") })
  }

  func testACorrectlyEvaluatedExpressionHasAResult() {
    expression = Expression("4 ÷ 4 x 5")
    XCTAssertFalse(expression.hasResult)

    expression.evaluate(
      onSuccess: { XCTAssertTrue(expression.hasResult) },
      onFailure: { _ in XCTAssert(false) })
  }

  func testAnIncorrectlyEvaluatedExpressionHasNoResult() {
    expression = Expression("2 + 4 ÷ 0")
    XCTAssertFalse(expression.hasResult)

    expression.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { errorMessage in
        XCTAssertFalse(expression.hasResult)
        XCTAssertEqual(errorMessage, "Division par zéro !")
      })

    expression = Expression("2")
    expression.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { errorMessage in
        XCTAssertFalse(expression.hasResult)
        XCTAssertEqual(errorMessage, "Démarrez un nouveau calcul !")
      })

    expression = Expression("2 + 4 – ")
    expression.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { errorMessage in
        XCTAssertFalse(expression.hasResult)
        XCTAssertEqual(errorMessage, "Entrez une expression correcte !")
      })
  }

  func testClearExpressionWhenHasResultDoesNothing() {
    expression = Expression("2 + 4")
    expression.evaluate(
      onSuccess: {
        expression.clear { XCTAssert(false) }
        XCTAssertEqual(expression.literal, "2 + 4 = 6")
      },
      onFailure: { _ in XCTAssert(false) }
    )
  }

  func testClearExpressionWhenExpressionHasNoResultClearExpression() {
    expression = Expression("2 + 4")
    expression.clear { XCTAssertEqual(expression.literal, "") }
  }

  func testBackspaceWhenExpressionHasResultDoesNothing() {
    expression = Expression("2 + 4")
    expression.evaluate(
      onSuccess: {
        expression.backspace { XCTAssert(false) }
        XCTAssertEqual(expression.literal, "2 + 4 = 6")
      },
      onFailure: { _ in XCTAssert(false) }
    )
  }

  func testBackspaceWhenExpressionEmptyDoesNothing() {
    expression = Expression()
    expression.backspace { XCTAssertEqual(expression.literal, "") }
  }

  func testBackspaceRemoveSpacesWithLastSymbol() {
    expression = Expression("2 + ")
    expression.backspace { XCTAssertEqual(expression.literal, "2") }
  }

  func testBackspaceRemoveOneSymbolOnly() {
    expression = Expression("2 + 4")
    expression.backspace { XCTAssertEqual(expression.literal, "2 + ") }

    expression = Expression("2 + 45")
    expression.backspace { XCTAssertEqual(expression.literal, "2 + 4") }
  }
}
