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

  var expressions: [Expression]!
  var expression: Expression { expressions.last! }

  // View Life cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    expressions = [Expression()]
  }

  // View actions
  @IBAction func tappedBackspaceButton(_ sender: UIButton) { expression.backspace(onCompletion: updateView) }
  @IBAction func tappedClearButton(_ sender: UIButton) { expression.clear(onCompletion: updateView) }
  @IBAction func tappedClearHistoryButton(_ sender: UIButton) { clearHistory() }
  @IBAction func tappedNumberButton(_ sender: UIButton) { addNumberToExpression(sender) }
  @IBAction func tappedOperatorButton(_ sender: UIButton) { addOperatorToExpression(sender) }
  @IBAction func tappedEqualButton(_ sender: UIButton) { expression.evaluate(onSuccess: updateView, onFailure: showErrorMessage(_:)) }

  private func addNumberToExpression(_ sender: UIButton) {
    guard let numberText = sender.title(for: .normal) else { return }

    if expression.hasResult { startNewExpression() }
    expression.add(numberText, onSuccess: updateView, onFailure: showErrorMessage(_:))
  }

  private func addOperatorToExpression(_ sender: UIButton) {
    guard let operationSymbol = sender.title(for: .normal) else { return }

    if expression.hasResult { expressions.append(Expression(expression.result)) }
    expression.add(operationSymbol, onSuccess: updateView, onFailure: showErrorMessage(_:))
  }

  private func startNewExpression() {
    expressions.append(Expression())
  }

  private func clearHistory() {
    let newExpression = expression.hasResult ? Expression() : expression

    expressions = [newExpression]
    updateView()
  }

  private func updateView() {
    textView.text = ""
    expressions.forEach { expression in
      if textView.text.isEmpty {
        textView.text = expression.literal
      } else {
        textView.text = "\(textView.text!)\n\(expression.literal)"
      }
    }

    let bottomOffset = CGPoint(x: 0, y: max(0, textView.contentSize.height - textView.bounds.size.height))
    textView.setContentOffset(bottomOffset, animated: false)
  }

  private func showErrorMessage(_ errorMessage: String) {
    let alertVC = UIAlertController(title: "Zéro!", message: errorMessage, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    return self.present(alertVC, animated: true, completion: nil)
  }
}
