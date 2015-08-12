//
//  ViewController.swift
//  Calculator
//
//  Created by Brad Slaybaugh on 8/6/15.
//  Copyright (c) 2015 Brad Slaybaugh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    var userIsTyping = false

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        // ? means optional (two values - 1 is not set (nil), other is another type)
        // ! unwraps an optional to its other type, crashes if it is not set
        
        if userIsTyping {
            if digit == "." {
                if display.text!.rangeOfString(".") == nil {
                    display.text = display.text! + digit
                }
            } else {
                display.text = display.text! + digit
            }
        }
        else {
            display.text = digit
            userIsTyping = true
        }
    }
    
    let x = M_PI

    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsTyping {
            enter()
        }
        switch operation {
            // these are all the same:
            // Examples of type inferencing:
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performSingleOperation {sqrt($0) }
        case "π": performConstantOperation( M_PI )
        case "sin": performSingleOperation { sin($0) }
        case "cos": performSingleOperation { cos($0) }
        default: break
        }
    }
    
    func performConstantOperation(value: Double) {
        displayValue = value
        enter()
    }
    
    func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }

    func performSingleOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    @IBAction func enter() {
        userIsTyping = false
        operandStack.append(displayValue)
        println("operandStack = \(operandStack)")
    }
    
    var displayValue: Double {
        get {
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            display.text = "\(newValue)"
            userIsTyping = false
        }
    }
}

