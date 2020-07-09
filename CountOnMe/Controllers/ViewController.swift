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

  var calculuses: [Calculus]!
  var calculus: Calculus { calculuses.last! }

  // View Life cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    calculuses = [Calculus()]
  }

  // View actions
  @IBAction func tappedBackspaceButton(_ sender: UIButton) { calculus.backspace(onCompletion: updateView) }
  @IBAction func tappedClearButton(_ sender: UIButton) { calculus.clear(onCompletion: updateView) }
  @IBAction func tappedClearHistoryButton(_ sender: UIButton) { clearHistory() }
  @IBAction func tappedNumberButton(_ sender: UIButton) { addNumberToCalculus(sender) }
  @IBAction func tappedOperatorButton(_ sender: UIButton) { addOperatorToCalculus(sender) }
  @IBAction func tappedEqualButton(_ sender: UIButton) { calculus.evaluate(onSuccess: updateView, onFailure: showErrorMessage(_:)) }

  private func addNumberToCalculus(_ sender: UIButton) {
    guard let numberText = sender.title(for: .normal) else { return }

    if calculus.hasResult { startNewCalculus() }
    calculus.add(numberText, onSuccess: updateView, onFailure: showErrorMessage(_:))
  }

  private func addOperatorToCalculus(_ sender: UIButton) {
    guard let operationSymbol = sender.title(for: .normal) else { return }

    if calculus.hasResult { calculuses.append(Calculus(calculus.result)) }
    calculus.add(operationSymbol, onSuccess: updateView, onFailure: showErrorMessage(_:))
  }

  private func startNewCalculus() {
    calculuses.append(Calculus())
  }

  private func clearHistory() {
    let newCalculus = calculus.hasResult ? Calculus() : calculus

    calculuses = [newCalculus]
    updateView()
  }

  private func updateView() {
    textView.text = ""
    calculuses.forEach { calculus in
      if textView.text.isEmpty {
        textView.text = calculus.literal
      } else {
        textView.text = "\(textView.text!)\n\(calculus.literal)"
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
