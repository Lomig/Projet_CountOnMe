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

  override func setUp() {
    super.setUp()
    expression = Expression()
  }

  func testAnExpressionCanBeSplitIntoElements() {
    expression.set(to: "2 + 4 ")
    XCTAssertEqual(expression.elements[0], "2")
    XCTAssertEqual(expression.elements[1], "+")
    XCTAssertEqual(expression.elements[2], "4")
  }

  func testExpressionIsCorrectWhenFinishingByANumber() {
    expression.set(to: "2 + 4")
    XCTAssertTrue(expression.isCorrect)
  }

  func testExpressionIsIncorrectWhenFinishingByAnOperator() {
    expression.set(to: "3 - 7 +")
    XCTAssertFalse(expression.isCorrect)
  }

  func testAddingCharactersToExpression() {
    expression.add("2")
    XCTAssertEqual(expression.literal, "2")
    expression.add("+")
    XCTAssertEqual(expression.literal, "2 + ")
    expression.add("2")
    XCTAssertEqual(expression.literal, "2 + 2")
    expression.add("1")
    XCTAssertEqual(expression.literal, "2 + 21")
  }

  func testEvaluateACorrectExpressionIsASuccess() {
    expression.set(to: "2 + 4 x 5")
    expression.evaluate(
      success: { XCTAssertEqual(expression.literal, "2 + 4 x 5 = 30") },
      failure: { _ in XCTAssert(false) })
  }

  func testEvaluateAWrongExpressionReturnAnError() {
    expression.set(to: "2 + 4 ÷ 0")
    expression.evaluate(
      success: { XCTAssert(false) },
      failure: { message in XCTAssertEqual(message, "Division by zero!") })
  }

  func testACorrectlyEvaluatedExpressionHasAResult() {
    expression.set(to: "2 + 4 x 5")
    XCTAssertFalse(expression.hasResult)

    expression.evaluate(
      success: { XCTAssertTrue(expression.hasResult) },
      failure: { _ in XCTAssert(false) })
  }

  func testAnIncorrectlyEvaluatedExpressionHasNoResult() {
    expression.set(to: "2 + 4 ÷ 0")
    XCTAssertFalse(expression.hasResult)

    expression.evaluate(
      success: { XCTAssert(false) },
      failure: { _ in XCTAssertFalse(expression.hasResult) })
  }
}
