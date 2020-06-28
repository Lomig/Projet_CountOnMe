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

  func testExpressionIsCorrectWhenFinishingByANumber() {
    expression = Expression("2 + 4 ")
    XCTAssertTrue(expression.isCorrect)
    XCTAssertTrue(expression.canAddOperator)
  }

  func testExpressionIsIncorrectWhenFinishingByAnOperator() {
    expression = Expression("3 - 7 +")
    XCTAssertFalse(expression.isCorrect)
    XCTAssertFalse(expression.canAddOperator)
  }

  func testAddingCharactersToExpression() {
    expression = Expression()
    expression.add("2") { XCTAssertEqual(expression.literal, "2") }
    expression.add("+") { XCTAssertEqual(expression.literal, "2 + ") }
    expression.add("2") { XCTAssertEqual(expression.literal, "2 + 2") }
    expression.add("1") { XCTAssertEqual(expression.literal, "2 + 21") }
  }

  func testEvaluateACorrectExpressionIsASuccess() {
    expression = Expression("2 + 4 x 5")
    expression.evaluate(
      onSuccess: { XCTAssertEqual(expression.literal, "2 + 4 x 5 = 30") },
      onFailure: { _ in XCTAssert(false) })
  }

  func testEvaluateAWrongExpressionReturnAnError() {
    expression = Expression("2 + 4 ÷ 0")
    expression.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "Division by zero!") })
  }

  func testACorrectlyEvaluatedExpressionHasAResult() {
    expression = Expression("2 + 4 x 5")
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
        XCTAssertEqual(errorMessage, "Division by zero!")
      })

    expression = Expression("2")
    expression.evaluate(
    onSuccess: { XCTAssert(false) },
    onFailure: { errorMessage in
      XCTAssertFalse(expression.hasResult)
      XCTAssertEqual(errorMessage, "Démarrez un nouveau calcul !")
    })

    expression = Expression("2 + 4 - ")
    expression.evaluate(
    onSuccess: { XCTAssert(false) },
    onFailure: { errorMessage in
      XCTAssertFalse(expression.hasResult)
      XCTAssertEqual(errorMessage, "Entrez une expression correcte !")
    })
  }
}
