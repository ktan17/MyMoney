//
//  AddEntryViewController.swift
//  MyMoney
//
//  Created by Kevin Tan on 2/15/18.
//  Copyright © 2018 ACM Hack. All rights reserved.
//

import UIKit

protocol AddEntryDelegate: class {
    func didAddEntry(_ entry: MoneyEntry)
}

class AddEntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var moneyTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    
    private var m_textFieldTests = [false, false]
    weak var delegate: AddEntryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.action = #selector(tappedDone)
        doneButton.isEnabled = false
        
        moneyTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    @objc func tappedDone(_ sender: UIBarButtonItem!) {
        let entry = MoneyEntry(money: Double(moneyTextField.text!)!, description: descriptionTextField.text!)
        
        delegate?.didAddEntry(entry)
        navigationController?.popViewController(animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        m_textFieldTests[textField.tag-1] = !textField.text!.isEmpty
        
        if m_textFieldTests[0] && m_textFieldTests[1] {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
        }
    }
    
}
