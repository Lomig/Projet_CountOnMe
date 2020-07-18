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

  let history = CalculusHistory()

  // View actions
  @IBAction func tappedBackspaceButton(_ sender: UIButton) { history.currentCalculus.backspace(onCompletion: updateView) }
  @IBAction func tappedClearButton(_ sender: UIButton) { history.currentCalculus.clear(onCompletion: updateView) }
  @IBAction func tappedClearHistoryButton(_ sender: UIButton) { clearHistory() }
  @IBAction func tappedNumberButton(_ sender: UIButton) { addNumberToCalculus(sender) }
  @IBAction func tappedOperatorButton(_ sender: UIButton) { addOperatorToCalculus(sender) }
  @IBAction func tappedEqualButton(_ sender: UIButton) { history.currentCalculus.evaluate(onSuccess: updateView, onFailure: showErrorMessage(_:)) }

  private func addNumberToCalculus(_ sender: UIButton) {
    guard let numberText = sender.title(for: .normal) else { return }

    if history.currentCalculus.hasResult { history.addNewCalculus() }
    history.currentCalculus.add(numberText, onSuccess: updateView, onFailure: showErrorMessage(_:))
  }

  private func addOperatorToCalculus(_ sender: UIButton) {
    guard let operationSymbol = sender.title(for: .normal) else { return }

    if history.currentCalculus.hasResult { history.addNewCalculus(startingWith: history.currentCalculus.result) }
    history.currentCalculus.add(operationSymbol, onSuccess: updateView, onFailure: showErrorMessage(_:))
  }

  private func clearHistory() {
    history.clear()
    updateView()
  }

  private func updateView() {
    textView.text = history.display

    let bottomOffset = CGPoint(x: 0, y: max(0, textView.contentSize.height - textView.bounds.size.height))
    textView.setContentOffset(bottomOffset, animated: false)
  }

  private func showErrorMessage(_ errorMessage: String) {
    let alertVC = UIAlertController(title: "Zéro!", message: errorMessage, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    return self.present(alertVC, animated: true, completion: nil)
  }
}
