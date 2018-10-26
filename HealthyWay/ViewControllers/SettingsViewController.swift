//
//  SettingsViewController.swift
// HealthyWay
//
//  Created by Bill Weatherwax on 7/14/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit
import MessageUI
import HealthyWayFramework

class SettingsViewController: UIViewController{
    
    @IBOutlet weak var copyright: UILabel!
    
    
    // MARK: - global model controller
    var modelController : ModelController!
    // MARK: - outlets
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet var dataEntryNumbers: [UITextField]!
    
//    // MARK: - date picker
//    var datePicker = UIDatePicker()
//    var toolBarDatePicker = UIToolbar()
    var toolBarNumber = UIToolbar()

    // MARK - textfield helper
    var activeTextField = UITextField()
    
    // MARK - temp storage
    var tempSettings : [String: Any?] = [:]
    var newSettings : [String: Any?] = [:]
    
    
    // MARK - Delegates and Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        copyright.text = makeCopyright()
        modelController = (self.parent as! HealthyWayTabBarController).getModel()
        tempSettings = modelController.settingsInFirebase as! [String : Any?]
//        createToolBarForDatePicker()
        createToolBarForNumber()
        saveButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindNumberFieldsToModel()
    }
    
    func bindNumberFieldsToModel() {
        for tagCollectionSequence in 0..<dataEntryNumbers.count {
            dataEntryNumbers[tagCollectionSequence].inputAccessoryView = toolBarNumber
            dataEntryNumbers[tagCollectionSequence].addTarget(self, action: #selector(SettingsViewController.numberTextFieldDidEnd(_:)), for: UIControlEvents.editingDidEnd)
            dataEntryNumbers[tagCollectionSequence].addTarget(self, action: #selector(SettingsViewController.textFieldDidBeginEditing(textField:)), for: UIControlEvents.editingDidBegin)
            let displayTextField = dataEntryNumbers[tagCollectionSequence]
            let tag = dataEntryNumbers[tagCollectionSequence].tag
            switch (tag ) {
            case 0:
                displayTextField.text = String(tempSettings[KeysForFirebase.LIMIT_PROTEIN_LOW] as? Double ?? 0)
            case 1:
                displayTextField.text = String(tempSettings[KeysForFirebase.LIMIT_FAT] as? Double ?? 0)
            case 2:
                displayTextField.text = String(tempSettings[KeysForFirebase.LIMIT_STARCH] as? Double ?? 0)
            case 3:
                displayTextField.text = String(tempSettings[KeysForFirebase.LIMIT_FRUIT] as? Double ?? 0)
            case 4:
                displayTextField.text = String(tempSettings[KeysForFirebase.LIMIT_PROTEIN_HIGH] as? Double ?? 0)
                if displayTextField.text == "0.0" {
                    displayTextField.text = ""
                }
            default :
                NSLog("bad tag number in storyboard (SettingsViewController:bindNumberFieldsToModel)")
            }
       }
    }
    
    func createToolBarForNumber() {
        toolBarNumber = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let clearButton = UIBarButtonItem(title: "clear", style: .plain, target: self, action: #selector(clearButtonPressedForNumber(sender:)))
        let doneButton = UIBarButtonItem(title: "return", style: .plain, target: self, action: #selector(doneNumber (sender:)))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: 40))
        label.text = "Enter number"
        let labelButton = UIBarButtonItem(customView: label)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBarNumber.setItems([clearButton, flexibleSpace, labelButton,flexibleSpace,doneButton], animated: true)
        
    }

    @objc func doneNumber (sender: UIBarButtonItem) {
        for tag in 0..<dataEntryNumbers.count {
            if let tf = dataEntryNumbers?[tag] {
                if tf == activeTextField {
                    tf.resignFirstResponder()
                    return
                }
            }
        }
        NSLog("mismatch in doneNumber")
    }

    
    @objc func clearButtonPressedForNumber(sender: UIBarButtonItem) {
        for tag in 0..<dataEntryNumbers.count {
            if let tf = dataEntryNumbers?[tag] {
                if tf == activeTextField {
                    tf.text = ""
                    return
                }
            }
        }
        NSLog("mismatch in clearButtonPressed")
    }

    
    @objc func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    
    @objc func numberTextFieldDidEnd(_ textField: UITextField) {
        var keyedDouble = 0.0
        if let inputIntNumber = Double(textField.text!) {
            keyedDouble = inputIntNumber
        }
        
        switch (textField.tag) {
            // adjust numberFor... by - 1 offset to match the storyboard tag. Storyboard tags start with 0
        case SettingsDataEntryNumbers.numberForProteinLow.rawValue - 1:
            newSettings[KeysForFirebase.LIMIT_PROTEIN_LOW] = keyedDouble
        case SettingsDataEntryNumbers.numberForFat.rawValue - 1:
            newSettings[KeysForFirebase.LIMIT_FAT] = keyedDouble
        case SettingsDataEntryNumbers.numberForStarch.rawValue - 1:
            newSettings[KeysForFirebase.LIMIT_STARCH] = keyedDouble
        case SettingsDataEntryNumbers.numberForFruit.rawValue - 1:
            newSettings[KeysForFirebase.LIMIT_FRUIT] = keyedDouble
        case SettingsDataEntryNumbers.numberForProteinHigh.rawValue - 1:
            newSettings[KeysForFirebase.LIMIT_PROTEIN_HIGH] = keyedDouble
        default:
            NSLog("bad input to numberTextFieldEnd")
        }
        saveButton.isHidden = false
        cancelButton.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - actions
  
//    @IBAction func selectTargetDate(_ sender: Any) {
//    }
//
    @IBAction func saveSettings(_ sender: Any) {
        for (settingsKey, settingsValue) in newSettings {
            tempSettings[settingsKey] = settingsValue
        }
        modelController.updateSettings(newSettings: self.newSettings)
        newSettings = [:]
        saveButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    @IBAction func cancelSettings(_ sender: Any) {
        newSettings = [:]
//        bindTargetDateToModel()
        bindNumberFieldsToModel()
        saveButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    // MARK - segue methods
    
    @IBAction func unwindToSettingsViewController(segue:UIStoryboardSegue) { }

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let vc = segue.destination
        if vc .isKind(of: MyAccountViewController.self) {
            (vc as! MyAccountViewController).modelController = modelController
        } else {
            print("In SettingsViewController, unknown segue: \(segue.destination.debugDescription)")
        }
    }

}
