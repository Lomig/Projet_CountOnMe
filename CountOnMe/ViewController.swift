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

  var elements: [String] {
    return expression.elements
  }

  // Error check computed variables
  var expressionIsCorrect: Bool {
    return expression.isCorrect
  }

  var expressionHaveEnoughElement: Bool {
    return expression.hasEnoughElements
  }

  var canAddOperator: Bool {
    return expression.canAddOperator
  }

  var expressionHaveResult: Bool {
    return expression.hasResult
  }

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

    expression.add(numberText)
    if expressionHaveResult {
      expression = Expression()
      textView.text = ""
    }

    textView.text = expression.literal
  }

  @IBAction func tappedAdditionButton(_ sender: UIButton) {
    if canAddOperator {
      expression.add("+")
      textView.text = expression.literal
    } else {
      let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      self.present(alertVC, animated: true, completion: nil)
    }
  }

  @IBAction func tappedSubstractionButton(_ sender: UIButton) {
    if canAddOperator {
      expression.add("-")
      textView.text = expression.literal
    } else {
      let alertVC = UIAlertController(title: "Zéro!", message: "Un operateur est déja mis !", preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      self.present(alertVC, animated: true, completion: nil)
    }
  }

  @IBAction func tappedEqualButton(_ sender: UIButton) {
    guard expressionIsCorrect else {
      let alertVC = UIAlertController(
        title: "Zéro!",
        message: "Entrez une expression correcte !",
        preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      return self.present(alertVC, animated: true, completion: nil)
    }

    guard expressionHaveEnoughElement else {
      let alertVC = UIAlertController(title: "Zéro!", message: "Démarrez un nouveau calcul !", preferredStyle: .alert)
      alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      return self.present(alertVC, animated: true, completion: nil)
    }

    //expression.evaluate(success)

    // Create local copy of operations
    var operationsToReduce = elements

    // Iterate over operations while an operand still here
    while operationsToReduce.count > 1 {
      let left = Int(operationsToReduce[0])!
      let operand = operationsToReduce[1]
      let right = Int(operationsToReduce[2])!

      let result: Int
      switch operand {
      case "+": result = left + right
      case "-": result = left - right
      default: fatalError("Unknown operator !")
      }

      operationsToReduce = Array(operationsToReduce.dropFirst(3))
      operationsToReduce.insert("\(result)", at: 0)
    }

    textView.text.append(" = \(operationsToReduce.first!)")
  }
}
