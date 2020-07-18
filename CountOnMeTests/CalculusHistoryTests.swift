//
//  CalculusHistory.swift
//  CountOnMeTests
//
//  Created by Lomig Enfroy on 18/07/2020.
//  Copyright © 2020 Vincent Saluzzo. All rights reserved.
//

import XCTest
@testable import CountOnMe

class CalculusHistoryTests: XCTestCase {
  var history: CalculusHistory!

  override func setUpWithError() throws {
    history = CalculusHistory()
  }

  func testGivenNewHistory_thenShowShouldBeEmpty() {
    XCTAssertTrue(history.display.isEmpty)
  }

  func testGivenNewHistory_thenLastCalculusCanBeenAccessed() {
    history.currentCalculus.add(
      "2",
      onSuccess: { XCTAssertEqual(history.currentCalculus.literal, "2") },
      onFailure: { _ in XCTAssert(false) })
  }

  func testGivenHistoryWithNoResultForLastCalculus_whenAddCalculus_thenNothingAdded() {
    let previousCalculus = history.currentCalculus
    history.currentCalculus.add(
      "1",
      onSuccess: {
        history.addNewCalculus()
        XCTAssert(previousCalculus === history.currentCalculus)
      },
      onFailure: { _ in XCTAssert(false) }
    )
  }

  func testGivenHistoryWithResultForLastCalculus_whenAddedCAlculus_thenWeDisplayBothCalculus() {
    history.currentCalculus.add("1", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    history.currentCalculus.add("+", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    history.currentCalculus.add("1", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    history.currentCalculus.evaluate(
      onSuccess: {
        history.addNewCalculus()
        history.currentCalculus.add("1", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
        XCTAssertEqual(history.display, "1 + 1 = 2\n1")
      },
      onFailure: { _ in XCTAssert(false) }
    )
  }

  func testGivenHistoryWithCompletedCalculuses_whenCleared_thenClearsHistoryCompletely() {
    history.currentCalculus.add("1", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    history.currentCalculus.add("+", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    history.currentCalculus.add("1", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    history.currentCalculus.evaluate(onSuccess: {}, onFailure: { _ in XCTAssert(false) })

    history.addNewCalculus()
    history.currentCalculus.add("1", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    history.currentCalculus.add("+", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    history.currentCalculus.add("1", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    history.currentCalculus.evaluate(onSuccess: {}, onFailure: { _ in XCTAssert(false) })

    history.clear()
    XCTAssertEqual(history.display, "")
  }

  func testGivenHistoryWithIncompleteCalculus_whenCleared_thenKeepsIt() {
    history.currentCalculus.add("1", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    history.currentCalculus.add("+", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    history.currentCalculus.add("1", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    history.currentCalculus.evaluate(onSuccess: {}, onFailure: { _ in XCTAssert(false) })

    history.addNewCalculus()
    history.currentCalculus.add("1", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    history.currentCalculus.add("+", onSuccess: {}, onFailure: { _ in XCTAssert(false) })
    history.currentCalculus.add("1", onSuccess: {}, onFailure: { _ in XCTAssert(false) })

    history.clear()
    XCTAssertEqual(history.display, "1 + 1")
  }
}
