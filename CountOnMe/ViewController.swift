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
    // Do any additional setup after loading the view.
    expression = Expression()
  }


  // View actions
  @IBAction func tappedNumberButton(_ sender: UIButton) {
    guard let numberText = sender.title(for: .normal) else {
      return
    }

    if expression.hasResult {
      startNewExpression()
    }
    expression.add(numberText)

    textView.text = expression.literal
  }

  @IBAction func tappedAdditionButton(_ sender: UIButton) {
    if expression.canAddOperator {
      expression.add("+")
      textView.text = expression.literal
    } else {
      let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      self.present(alertVC, animated: true, completion: nil)
    }
  }

  @IBAction func tappedSubstractionButton(_ sender: UIButton) {
    if expression.canAddOperator {
      expression.add("-")
      textView.text = expression.literal
    } else {
      let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      self.present(alertVC, animated: true, completion: nil)
    }
  }

  @IBAction func tappedEqualButton(_ sender: UIButton) {
    guard expression.isCorrect else {
      let alertVC = UIAlertController(
        title: "Zéro!",
        message: "Entrez une expression correcte !",
        preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      return self.present(alertVC, animated: true, completion: nil)
    }

    guard expression.hasEnoughElements else {
      let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      return self.present(alertVC, animated: true, completion: nil)
    }

    expression.evaluate(success: showExpressionEvaluation, failure: showErrorMessage(_:))
  }

  func startNewExpression() {
    textView.text = ""
    expression = Expression()
  }

  func showExpressionEvaluation() {
    textView.text = expression.literal
  }

  func showErrorMessage(_ errorMessage: String) {
    let alertVC = UIAlertController(title: "Zéro!", message: errorMessage, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    return self.present(alertVC, animated: true, completion: nil)
  }
}
