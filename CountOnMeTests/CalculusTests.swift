//
//  CalculusTests.swift
//  CountOnMeTests
//
//  Created by Lomig Enfroy on 27/06/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculusTests: XCTestCase {
  var calculus: Calculus!

  func testGivenEmptyCalculus_WhenDisplayed_ThenEmptyString() {
    calculus = Calculus()
    XCTAssertEqual(calculus.literal, "")
  }

  func testGivenEmptyCalculus_WhenEvaluated_ThenThrowsError() {
    calculus = Calculus()
    calculus.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { errorMessage in
        XCTAssertFalse(calculus.hasResult)
        XCTAssertEqual(errorMessage, "Démarrez un nouveau calcul !")
      })
  }

  func testGivenEmptyCalculus_WhenNumberPressed_ThenAddedToCalculus() {
    calculus = Calculus()
    calculus.add(
      "2",
      onSuccess: { XCTAssertEqual(calculus.literal, "2") },
      onFailure: { _ in XCTAssert(false) })
  }

  func testGivenEmptyCalculus_WhenOperatorPressed_ThenThrowsError() {
    calculus = Calculus()
    calculus.add(
      "+",
      onSuccess: { XCTAssert(false) },
      onFailure: { errorMessage in XCTAssertEqual(errorMessage, "Vous ne pouvez pas mettre un opérateur !") })
  }

  func testGivenEmptyCalculus_WhenOpenParenthesisPressed_ThenAddedToCalculus() {
    calculus = Calculus()
    calculus.add(
      "(",
      onSuccess: { XCTAssertEqual(calculus.literal, " ( ") },
      onFailure: { _ in XCTAssert(false) })
  }

  func testGivenCalculusWithJustANumber_WhenEvaluated_ThenThrowsError() {
    calculus = Calculus("2")
    calculus.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { errorMessage in
        XCTAssertFalse(calculus.hasResult)
        XCTAssertEqual(errorMessage, "Démarrez un nouveau calcul !")
      })
  }

  func testGivenCalculusWithTwoElements_WhenEvaluated_ThenThrowsError() {
    calculus = Calculus("2 + ")
    calculus.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { errorMessage in
        XCTAssertFalse(calculus.hasResult)
        XCTAssertEqual(errorMessage, "Entrez une expression correcte !")
      })
  }

  func testGivenCalculusWithJustANumber_WhenNumberPressed_ThenAddedToNumber() {
    calculus = Calculus("2")
    calculus.add(
    "2",
    onSuccess: { XCTAssertEqual(calculus.literal, "22") },
    onFailure: { _ in XCTAssert(false) })
  }

  func testGivenCalculusWithJustANumber_WhenDotPressed_ThenAddedToNumber() {
    calculus = Calculus("2")
    calculus.add(
    ".",
    onSuccess: { XCTAssertEqual(calculus.literal, "2.") },
    onFailure: { _ in XCTAssert(false) })
  }

  func testGivenCalculusWithANumberAndADot_WhenNumberPressed_ThenAddedToNumber() {
    calculus = Calculus("2.")
    calculus.add(
    "2",
    onSuccess: { XCTAssertEqual(calculus.literal, "2.2") },
    onFailure: { _ in XCTAssert(false) })
  }

  func testGivenCalculusWithJustANumber_WhenOpenParenthesisPressed_ThenAddedAndConsideredMultiplication() {
    calculus = Calculus("2")
    calculus.add(
    "(",
    onSuccess: { XCTAssertEqual(calculus.literal, "2 ( ") },
    onFailure: { _ in XCTAssert(false) })

    calculus = Calculus("2 ( 3 + 4 )")
    calculus.evaluate(
    onSuccess: { XCTAssertEqual(calculus.literal, "2 ( 3 + 4 ) = 14") },
    onFailure: { _ in XCTAssert(false) })
  }

  func testGivenCalculusWithJustANumber_WhenOperatorPressed_ThenAddedtoCalculus() {
    calculus = Calculus("2")
    calculus.add(
    "+",
    onSuccess: { XCTAssertEqual(calculus.literal, "2 + ") },
    onFailure: { _ in XCTAssert(false) })
  }

  func testGivenAddition_WhenMultiplication_ThenMultiplicationIsPrimary() {
    calculus = Calculus("2 x 3 + 4")
    calculus.evaluate(
    onSuccess: { XCTAssertEqual(calculus.literal, "2 x 3 + 4 = 10") },
    onFailure: { _ in XCTAssert(false) })

    calculus = Calculus("2 + 3 x 4")
    calculus.evaluate(
    onSuccess: { XCTAssertEqual(calculus.literal, "2 + 3 x 4 = 14") },
    onFailure: { _ in XCTAssert(false) })
  }

  func testGivenSubstraction_WhenDivision_ThenDivisionIsPrimary() {
    calculus = Calculus("6 ÷ 3 – 4")
    calculus.evaluate(
    onSuccess: { XCTAssertEqual(calculus.literal, "6 ÷ 3 – 4 = -2") },
    onFailure: { _ in XCTAssert(false) })

    calculus = Calculus("6 – 3 ÷ 4")
    calculus.evaluate(
    onSuccess: { XCTAssertEqual(calculus.literal, "6 – 3 ÷ 4 = 5.25") },
    onFailure: { _ in XCTAssert(false) })
  }

  func testGivenDivision_WhenDividingByZero_ThenThrowsError() {
    calculus = Calculus("4 ÷ 0")
    calculus.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "Division par zéro !") })
  }

  func testGivenParenthesis_WhenNotEnoughOpenParenthesis_ThenThrowsError() {
    calculus = Calculus("1 + ) ( 3 – 2 x ( 9 – 1 ) x 4)")
    calculus.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "Problème de parenthèse !") })
  }

  func testGivenParenthesis_WhenNotEnoughCloseParenthesis_ThenThrowsError() {
    calculus = Calculus("1 + ( 3 – 2 x ( 9 – 1 ) x 4")
    calculus.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "Problème de parenthèse !") })
  }

  func testGivenParenthesis_WhenInvertedParenthesis_ThenThrowsError() {
    calculus = Calculus("1 + ) 3 – ( 2 x ( 9 – 1 ) x 4")
    calculus.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "Problème de parenthèse !") })
  }

  func testGivenParenthesis_WhenNestedParenthesis_ThenEvaluatedInTheRightOrder() {
    calculus = Calculus("1.5 + 2 ( 3 – 2 x ( 9 + -1 ) ) x 4")
    calculus.evaluate(
      onSuccess: { XCTAssertEqual(calculus.literal, "1.5 + 2 ( 3 – 2 x ( 9 + -1 ) ) x 4 = -102.5") },
      onFailure: { _ in XCTAssert(false) })
  }

  func testGivenParenthesis_WhenIncorrectCalculusInside_ThenThrowsError() {
    calculus = Calculus("7 + ( 8 + )")
    calculus.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "Entrez une expression correcte !") })
  }

  func testGivenCloseParenthesis_WhenFollowedByNumber_ThenThrowsError() {
    calculus = Calculus("( 1 + 3 ) 4")
    calculus.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "Entrez une expression correcte !") })
  }

  func testGivenCalculus_WhenLeftElementIsNotANumber_ThenThrowsError() {
    calculus = Calculus("A + 3")
    calculus.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "A n'est pas un nombre !") })
  }

  func testGivenCalculus_WhenRightElementIsNotANumber_ThenThrowsError() {
    calculus = Calculus("1 + A")
    calculus.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "A n'est pas un nombre !") })
  }

  func testGivenCalculus_WhenUnknownOperator_ThenThrowsError() {
    calculus = Calculus("1 A 3")
    calculus.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "A n'est pas un opérateur connu !") })
  }

  func testGivenOperator_WhenOperatorPressed_ThenThrowsError() {
    calculus = Calculus("2 + ")
    calculus.add(
      "+",
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "Vous ne pouvez pas mettre un opérateur !") })
  }

  func testGivenCalculusEndingWithOperator_WhenEvaluated_ThenThrowsError() {
    calculus = Calculus("2 + 3 x ")
    calculus.evaluate(
      onSuccess: { XCTAssert(false) },
      onFailure: { message in XCTAssertEqual(message, "Entrez une expression correcte !") })
  }

  func testGivenCorrectCalculus_WhenEvaluated_ThenHasResult() {
    calculus = Calculus("4 ÷ 4 x 5")
    XCTAssertFalse(calculus.hasResult)

    calculus.evaluate(
      onSuccess: { XCTAssertTrue(calculus.hasResult) },
      onFailure: { _ in XCTAssert(false) })
  }

  func testGivenEvaluatedCalculus_WhenCleared_ThenNothing() {
    calculus = Calculus("2 + 4")
    calculus.evaluate(
      onSuccess: {
        calculus.clear { XCTAssert(false) }
        XCTAssertEqual(calculus.literal, "2 + 4 = 6")
      },
      onFailure: { _ in XCTAssert(false) }
    )
  }

  func testGivenCalculusWithoutResult_WhenCleared_ThenCleared() {
    calculus = Calculus("2 + 4")
    calculus.clear { XCTAssertEqual(calculus.literal, "") }
  }

  func testGivenEvaluatedCalculus_WhenBackspace_ThenNothing() {
    calculus = Calculus("2 + 4")
    calculus.evaluate(
      onSuccess: {
        calculus.backspace { XCTAssert(false) }
        XCTAssertEqual(calculus.literal, "2 + 4 = 6")
      },
      onFailure: { _ in XCTAssert(false) }
    )
  }

  func testGivenEmptyCalculus_WhenBackspace_ThenNothing() {
    calculus = Calculus()
    calculus.backspace { XCTAssert(false) }
    XCTAssertEqual(calculus.literal, "")
  }

  func testGivenLastCharacterSymbol_WhenBackspace_ThenRemoved() {
    calculus = Calculus("2 + ")
    calculus.backspace { XCTAssertEqual(calculus.literal, "2") }

    calculus = Calculus()
    calculus.add("2", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    calculus.add("x", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    calculus.add("(", onSuccess: {}, onFailure: { _ in XCTAssert(false) })

    calculus.backspace { XCTAssertEqual(calculus.literal, "2 x ") }
  }

  func testGivenLastCharacterNumber_WhenBackspace_ThenRemoved() {
    calculus = Calculus("45")
    calculus.backspace { XCTAssertEqual(calculus.literal, "4") }
  }
}
