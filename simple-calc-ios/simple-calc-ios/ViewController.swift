//
//  ViewController.swift
//  simple-calc-ios
//
//  Created by Kiwon Jeong on 2017. 10. 20..
//  Copyright © 2017년 Kiwon Jeong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    private var operation: String = ""
    private var prevInput = ""
    private var numbers = [Double]()
    private var operations = [String]()
    private var calcHistory = [String]()
    private var opInvalid: Bool = false
    private var resetState: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier! == "HistorySegue") {
            let dest = segue.destination as! HistoryViewController
            dest.calcHistory = self.calcHistory
        }
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        textField.text = "0"
        reset()
    }
    
    @IBAction func textExited(_ sender: UITextField) {
        var formattedText = ""
        var prevChar = ""
        if (sender.text != "") {
            for _ in 1...sender.text!.count {
                let char = String(sender.text!.removeFirst())
                if (Int.init(char) != nil && Int.init(prevChar) != nil) {
                    formattedText = formattedText + char
                    prevChar = char
                } else if (char == "+" || char == "-" || char == "*" || char == "/" || char == "%") {
                    formattedText = formattedText + " " + char
                    prevChar = char
                } else if (Int.init(char) != nil && Int.init(prevChar) == nil) {
                    formattedText = formattedText + " " + char
                    prevChar = char
                } else {
                    if (Int.init(prevChar) != nil) {
                        formattedText += " "
                    }
                    formattedText = formattedText + char
                    prevChar = char
                }
            }
        }
        textField.text = formattedText
    }
    
    @IBAction func btnPressed(_ sender: UIButton) {
        let btnValue = sender.title(for: .normal)!
        if (resetState) {
            textField.text = " " + btnValue
            prevInput = btnValue
            resetState = false
        } else {
            if (Int.init(btnValue) != nil && Int.init(prevInput) != nil) {
                textField.text = textField.text! + btnValue
                prevInput = btnValue
            } else if (btnValue == ".") {
                textField.text = textField.text! + btnValue
            } else {
                textField.text = textField.text! + " " + btnValue
                prevInput = btnValue
            }
        }
    }
    
    @IBAction func enterPressed(_ sender: UIButton) {
        calcHistory.append(textField.text!)
        let inputs = textField.text!.components(separatedBy: " ")
        var oddCounter = 0
        for each in inputs {
            oddCounter += 1
            if (Double.init(each) != nil) {
                numbers.append(Double.init(each)!)
            } else {
                let isOP = oddCounter - ((oddCounter/2) * 2)
                if (each == "count" || each == "avg" || each == "fact") {
                    if (operation == "") {
                        operation = each
                    }
                }
                // error testing
                if (isOP != 1 || operation != "" && operation != each) {
                    opInvalid = true
                }
                operations.append(each)
            }
        }
        // error testing
        if (!operations.isEmpty) {
            if (operations[operations.count - 1] != "fact" && Double.init(inputs[inputs.count - 1]) == nil) {
                opInvalid = true
            }
        }
        if (opInvalid) {
            textField.text = "Invalid Input"
            let _ = calcHistory.popLast()
            reset()
        } else {
            calculate()
            reset()
        }
    }
    
    private func calculate() {
        var currIndex = 0
        var result = 0.0
        if (operation == "") {
            // calculate multiply, divide, and mod first
            for each in operations {
                switch each {
                case "*":
                    let eval = numbers[currIndex - 1] * numbers[currIndex]
                    numbers[currIndex - 1] = eval
                    numbers[currIndex] = eval
                    result = eval
                case "/":
                    let eval = numbers[currIndex - 1] / numbers[currIndex]
                    numbers[currIndex - 1] = eval
                    numbers[currIndex] = eval
                    result = eval
                case "%":
                    let eval = numbers[currIndex - 1] - (numbers[currIndex] * Double(Int(numbers[currIndex - 1]/numbers[currIndex])))
                    numbers[currIndex - 1] = eval
                    numbers[currIndex] = eval
                    result = eval
                default:
                    result += 0
                }
                currIndex += 1
            }
            
            // calculate plus & minus after 
            currIndex = 0
            for each in operations {
                switch each {
                case "+":
                    let eval = numbers[currIndex - 1] + numbers[currIndex]
                    numbers[currIndex - 1] = eval
                    numbers[currIndex] = eval
                    result = eval
                case "-":
                    let eval = numbers[currIndex - 1] - numbers[currIndex]
                    numbers[currIndex - 1] = eval
                    numbers[currIndex] = eval
                    result = eval
                default:
                    result += 0
                }
                currIndex += 1
            }
        } else {
            switch operation {
            case "count":
                result = Double(numbers.count)
            case "avg":
                for each in numbers {
                    result += each
                }
                result = result / Double(numbers.count)
            case "fact":
                result = calcFactorial(numbers[0])
            default:
                result += 0
            }
        }
        var calcRequest = calcHistory.popLast()!
        if (result - Double(Int(result)) == 0) {
            textField.text = "\(Int(result))"
            calcRequest = calcRequest + " = \(Int(result))"
        } else {
            textField.text = "\(result)"
            calcRequest = calcRequest + " = \(result)"
        }
        calcHistory.append(calcRequest)
    }

    private func calcFactorial(_ input: Double) -> Double {
        var inputValue = input
        var resultValue = 1.0
        let isDividable:Bool = (inputValue - (Double(Int(inputValue/2.0)) * 2.0)) == 0
        if (isDividable) {
            while inputValue > 1 {
                resultValue = resultValue * inputValue
                inputValue -= 1
            }
            return resultValue
        } else {
            return tgamma(inputValue + 1.0)
        }
    }
    
    private func reset() {
        prevInput = ""
        numbers = []
        operations = []
        opInvalid = false
        operation = ""
        resetState = true
    }
}

