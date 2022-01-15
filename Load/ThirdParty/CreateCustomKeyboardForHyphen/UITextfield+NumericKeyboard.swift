//
//  UITextfield+NumericKeyboard.swift
//  Zipwire Location Validator
//
//  Created by Ignacio Nieto Carvajal on 13/10/16.
//  Copyright © 2016 Zipwire. All rights reserved.
//

import UIKit

private var numericKeyboardDelegate: NumericKeyboardDelegate? = nil

extension UITextField: NumericKeyboardDelegate {
    // MARK: - Public methods to set or unset this uitextfield as NumericKeyboard.
    
    func setAsNumericKeyboard(delegate: NumericKeyboardDelegate?,isUseHyphen:Bool,withoutAnything:Bool = false) {
        
        var value = 0
        
        if DEVICE_TYPE.SCREEN_MAX_LENGTH <= 736 {
            value = 220
            
        }else{
            value = 280
        }
                 
        let numericKeyboard = NumericKeyboard(frame: CGRect(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: value))
        self.inputView = numericKeyboard
        numericKeyboardDelegate = delegate
        numericKeyboard.delegate = self
        
        if DEVICE_TYPE.SCREEN_MAX_LENGTH <= 736 {
            numericKeyboard.bottomConstantOfView.constant = 5
            numericKeyboard.heightConstantOfView.constant = 48
            
        }else{
            numericKeyboard.bottomConstantOfView.constant = 18
            numericKeyboard.heightConstantOfView.constant = 50
        }
        
        if withoutAnything{
            numericKeyboard.buttonKeyHyphen.setTitle(str: "")
        }else{
            if isUseHyphen {
                numericKeyboard.buttonKeyHyphen.setTitle(str: " - ")
            }else{
                numericKeyboard.buttonKeyHyphen.setTitle(str: ".")
            }
        }
        
    }
    
    
    
    func unsetAsNumericKeyboard() {
        if let numericKeyboard = self.inputView as? NumericKeyboard {
            numericKeyboard.delegate = nil
        }
        self.inputView = nil
        numericKeyboardDelegate = nil
    }
    
    // MARK: - NumericKeyboardDelegate methods

    internal func numericKeyPressed(key: Int) {
        self.text?.append("\(key)")
        numericKeyboardDelegate?.numericKeyPressed(key: key)
        
    }
    
    internal func numericBackspacePressed() {
        if var text = self.text, text.count > 0 {
            _ = text.remove(at: text.index(before: text.endIndex))
            self.text = text
        }
        numericKeyboardDelegate?.numericBackspacePressed()
    }
    
    internal func numericSymbolPressed(symbol: String) {
        
        if self.text?.contains(".") ?? false{
            print(". available")
        }else{
            self.text?.append(symbol)
        }
        
        numericKeyboardDelegate?.numericSymbolPressed(symbol: symbol)
    }
}
