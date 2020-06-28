//
//  ViewController.swift
//  SimpleCalc
//
//  Created by Vincent Saluzzo on 29/03/2019.
//  Copyright © 2019 Vincent Saluzzo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var textView: UITextView!
  @IBOutlet var numberButtons: [UIButton]!

  var expression: Expression!

  // View Life cycles
  override func viewDidLoad() {
    super.viewDidLoad()

    // Keeping the algorithm,
    // we need to reflect the initial view content in the model
    expression = Expression("1 + 1")
    expression.evaluate(onSuccess: updateView, onFailure: showErrorMessage(_:))
  }

  // View actions
  @IBAction func tappedNumberButton(_ sender: UIButton) {
    guard let numberText = sender.title(for: .normal) else {
      return
    }

    if expression.hasResult {
      startNewExpression()
    }
    expression.add(numberText, onCompletion: updateView)
  }

  @IBAction func tappedAdditionButton(_ sender: UIButton) {
    addOperatorToExpression("+")
  }

  @IBAction func tappedSubstractionButton(_ sender: UIButton) {
    addOperatorToExpression("-")
  }

  @IBAction func tappedMultiplicationButton(_ sender: UIButton) {
    addOperatorToExpression("x")
  }

  @IBAction func tappedDivisionButton(_ sender: UIButton) {
    addOperatorToExpression("÷")
  }

  @IBAction func tappedEqualButton(_ sender: UIButton) {
    expression.evaluate(onSuccess: updateView, onFailure: showErrorMessage(_:))
  }

  func addOperatorToExpression(_ operationSymbol: String) {
    if expression.hasResult {
      expression = Expression(expression.result)
    }

    if expression.canAddOperator {
      expression.add(operationSymbol, onCompletion: updateView)
    } else {
      showErrorMessage("Un operateur est déja mis !")
    }
  }

  func startNewExpression() {
    textView.text = ""
    expression = Expression()
  }

  func updateView() {
    textView.text = expression.literal
  }

  func showErrorMessage(_ errorMessage: String) {
    let alertVC = UIAlertController(title: "Zéro!", message: errorMessage, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    return self.present(alertVC, animated: true, completion: nil)
  }
}