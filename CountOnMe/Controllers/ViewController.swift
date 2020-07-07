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
  @IBAction func tappedNumberButton(_ sender: UIButton) { addNumberToExpression(sender) }
  @IBAction func tappedAdditionButton(_ sender: UIButton) { addOperatorToExpression("+") }
  @IBAction func tappedSubstractionButton(_ sender: UIButton) { addOperatorToExpression("-") }
  @IBAction func tappedMultiplicationButton(_ sender: UIButton) { addOperatorToExpression("x") }
  @IBAction func tappedDivisionButton(_ sender: UIButton) { addOperatorToExpression("÷") }
  @IBAction func tappedEqualButton(_ sender: UIButton) { expression.evaluate(onSuccess: updateView, onFailure: showErrorMessage(_:)) }

  private func addNumberToExpression(_ sender: UIButton) {
    guard let numberText = sender.title(for: .normal) else {
      return
    }

    if expression.hasResult { startNewExpression() }
    expression.add(numberText, onSuccess: updateView, onFailure: showErrorMessage(_:))
  }

  private func addOperatorToExpression(_ operationSymbol: String) {
    if expression.hasResult { expression = Expression(expression.result) }
    expression.add(operationSymbol, onSuccess: updateView, onFailure: showErrorMessage(_:))
  }

  private func startNewExpression() {
    textView.text = ""
    expression = Expression()
  }

  private func updateView() {
    textView.text = expression.literal
  }

  private func showErrorMessage(_ errorMessage: String) {
    let alertVC = UIAlertController(title: "Zéro!", message: errorMessage, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    return self.present(alertVC, animated: true, completion: nil)
  }
}
