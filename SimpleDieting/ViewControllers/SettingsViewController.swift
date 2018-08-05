//
//  SettingsViewController.swift
//  SimpleDieting
//
//  Created by Bill Weatherwax on 7/14/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    // MARK: - global model controller
    var modelController : ModelController!
    // MARK: - outlets
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
//    @IBOutlet weak var targetDatePicker: UIDatePicker!
//    @IBOutlet weak var targetDate: UITextField!
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
        modelController = (self.parent as! SimpleDietTabBarController).getModel()
        if modelController?.settingsInFirebase?.count == 0 {
            NSLog("model not ready. Fix it")
        }
        tempSettings = modelController.settingsInFirebase as! [String : Any?]
//        createToolBarForDatePicker()
        createToolBarForNumber()
        saveButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindNumberFieldsToModel()
//        bindTargetDateToModel()
//        targetDate.inputView = datePicker
//        targetDate.inputAccessoryView = toolBarDatePicker
    }

//    func bindTargetDateToModel() {
//        datePicker.datePickerMode = .date
//        let externalDate : String = tempSettings[KeysForFirebase.TARGET_DATE] as! String
//        datePicker.date = makeDateFromString(dateAsString: externalDate)
//        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(datePicker:)), for: .valueChanged)
//        targetDate.text = externalDate
//    }
    
    func bindNumberFieldsToModel() {
        for tagCollectionSequence in 0..<dataEntryNumbers.count {
            dataEntryNumbers[tagCollectionSequence].inputAccessoryView = toolBarNumber
            dataEntryNumbers[tagCollectionSequence].addTarget(self, action: #selector(SettingsViewController.numberTextFieldDidEnd(_:)), for: UIControlEvents.editingDidEnd)
            dataEntryNumbers[tagCollectionSequence].addTarget(self, action: #selector(SettingsViewController.textFieldDidBeginEditing(textField:)), for: UIControlEvents.editingDidBegin)
            let displayTextField = dataEntryNumbers[tagCollectionSequence]
            let tag = dataEntryNumbers[tagCollectionSequence].tag
            switch (tag) {
            case 1:
                displayTextField.text = (tempSettings[KeysForFirebase.TARGET_WEIGHT] as? Double)?.description
            case 2:
                displayTextField.text = (tempSettings[KeysForFirebase.LIMIT_PROTEIN] as? Int)?.description
            case 3:
                displayTextField.text = (tempSettings[KeysForFirebase.LIMIT_FAT] as? Int)?.description
            case 4:
                displayTextField.text = (tempSettings[KeysForFirebase.LIMIT_STARCH] as? Int)?.description
            case 5:
                displayTextField.text = (tempSettings[KeysForFirebase.LIMIT_FRUIT] as? Int)?.description
            case 6:
                displayTextField.text = (tempSettings[KeysForFirebase.LIMIT_VEGGIES] as? Int)?.description
            default :
                NSLog("bad tag number in storyboard")
            }
       }
    }
    
//    func createToolBarForDatePicker() {
//        toolBarDatePicker = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
//        let todayButton = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(todayButtonPressed(sender:)))
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressedForTargetDate(sender:)))
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: 40))
//        label.text = "Choose your target weight date"
//        let labelButton = UIBarButtonItem(customView: label)
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//        toolBarDatePicker.setItems([todayButton, flexibleSpace, labelButton,flexibleSpace,doneButton], animated: true)
//    }
//
    func createToolBarForNumber() {
        toolBarNumber = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearButtonPressedForNumber(sender:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneNumber (sender:)))
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
//
//    @objc func doneButtonPressedForTargetDate(sender: UIBarButtonItem) {
//        modelController.targetDate = datePicker.date
//        showTargetDate(targetDate: datePicker.date)
//        targetDate.resignFirstResponder()
//    }
//
//    @objc func todayButtonPressed(sender: UIBarButtonItem) {
//        showTargetDate(targetDate: Date())
//        targetDate.resignFirstResponder()
//    }
    
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

//    func showTargetDate(targetDate date : Date) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .short
//        dateFormatter.timeStyle = .none
//        targetDate.text = dateFormatter.string(from: date)
//     }
//
    
    @objc func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
    }
    
    
    @objc func numberTextFieldDidEnd(_ textField: UITextField) {
        var keyedDouble = 0.0
        var keyedInt = 0
        if let inputDoubleNumber = Double(textField.text!) {
            keyedDouble = inputDoubleNumber
        }
        if let inputIntNumber = Int(textField.text!) {
            keyedInt = inputIntNumber
        }
        
        switch (textField.tag) {
        case SettingsDataEntryNumbers.numberForWeight.rawValue:
            newSettings[KeysForFirebase.TARGET_WEIGHT] = keyedDouble
        case SettingsDataEntryNumbers.numberForProtein.rawValue:
            newSettings[KeysForFirebase.LIMIT_PROTEIN] = keyedInt
        case SettingsDataEntryNumbers.numberForFat.rawValue:
            newSettings[KeysForFirebase.LIMIT_FAT] = keyedInt
        case SettingsDataEntryNumbers.numberForStarch.rawValue:
            newSettings[KeysForFirebase.LIMIT_STARCH] = keyedInt
        case SettingsDataEntryNumbers.numberForFruit.rawValue:
            newSettings[KeysForFirebase.LIMIT_FRUIT] = keyedInt
        case  SettingsDataEntryNumbers.numberForVeggies.rawValue:
            newSettings[KeysForFirebase.LIMIT_VEGGIES] = keyedInt
        default:
            NSLog("bad input to numberTextFieldEnd")
        }
        saveButton.isHidden = false
        cancelButton.isHidden = false
    }
    
    
    
    
//    @objc func datePickerValueChanged(datePicker: UIDatePicker) {
//        newSettings[KeysForFirebase.TARGET_DATE] = datePicker.date.makeShortStringDate()
//        saveButton.isHidden = false
//        cancelButton.isHidden = false
//    }

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
    
    
    @IBAction func emailJournal(_ sender: Any) {
        if !MFMailComposeViewController.canSendMail() {
            NSLog("No email")
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        
        // Configure the fields of the interface.
        composeVC.setToRecipients(["waxcruz@yahoo.com"])
        composeVC.setSubject("Journal")
        let myJournal = """
        <!DOCTYPE html>
        <html>
        <head>
        <style>
        table, th, td {
            border: 1px solid black;
            border-collapse: collapse;
        }
        </style>
        </head>
        <div style="overflow-x:auto;">
        </head>
        <body>

        <h2>Journal</h2>
        <p>08/04/2018</p>
        <table style="font-size:10px;">
          <tr>
            <th>Meal</th>
            <th>Food eaten</th>
            <th>P</th>
            <th>S</th>
            <th>V</th>
            <th>Fr</th>
            <th>F</th>
            <th>Feelings/Comments</th>
          </tr>
          <tr>
            <td>Daily Totals</td>
            <td> </td>
            <td>10</td>
            <td>3</td>
            <td>∞</td>
            <td>2</td>
            <td>4</td>
            <td> </td>
          </tr>
          <tr>
            <td>Breakfast</td>
            <td>Greek Yogurt, peach, and Ryvita cracker</td>
            <td> 2</td>
            <td> 1</td>
            <td> 1</td>
            <td> .5</td>
            <td> 0</td>
            <td>Sat down to eat! Good behavior</td>
          </tr>
          <tr>
            <td>Snack</td>
            <td>2 egg omlet, Ezek. muffin, 1/2 c. of strawberries</td>
            <td> 0</td>
            <td> 1</td>
            <td> </td>
            <td> 1</td>
            <td> 0</td>
            <td> </td>
          </tr>
          <tr>
            <td>Lunch</td>
            <td>Chicken salad, dressing</td>
            <td> 4</td>
            <td> 0</td>
            <td> 2</td>
            <td> 0</td>
            <td> 2</td>
            <td>Hungry!</td>
          </tr>
           <tr>
            <td>Snack</td>
            <td>cut up veggies, 1 string cheese</td>
            <td> 1</td>
            <td> 0</td>
            <td> 2</td>
            <td> 0</td>
            <td> 0</td>
            <td>Cravings-veg & protein helped</td>
          </tr>
          <tr>
            <td>Dinner</td>
            <td>Salmon, sweet potatoe, salad, and broccoli</td>
            <td> 3</td>
            <td> 1</td>
            <td> 2</td>
            <td> 0</td>
            <td> 2</td>
            <td> </td>
          </tr>
          <tr>
            <td>Snack</td>
            <td>1/2 orange</td>
            <td> 0</td>
            <td> 0</td>
            <td>  </td>
            <td> .5</td>
            <td> 0</td>
            <td>Tired-got thru the day without suguar</td>
          </tr>
          <tr>
            <td>Totals</td>
            <td> </td>
            <td>10</td>
            <td>3</td>
            <td>7</td>
            <td>2</td>
            <td>4</td>
            <td> </td>
          </tr>
        </table>
        <font size="1">     Water: ✔︎✔︎✔︎✔︎✔︎✔︎✔︎✔︎ Supplements: ✔︎✔︎✔︎ Exercise: ✔︎</font>
        <p>
        <font size="1">I exercised as soon as I woke up & can this works best for me. I wanted sweets today after lunch. The H.W. supplements  helped ease the craving as did the snack. I am proud I did not give int to sugar. Yeah!!!</font>
        </p>
        </div>
        </body>
        </html>
        """

        composeVC.setMessageBody(myJournal, isHTML: true)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
//    func mailComposeController(controller: MFMailComposeViewController,
//                               didFinishWithResult result: MFMailComposeResult, error: Error?) {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
              // Check the result or perform other tasks.
        NSLog("Done with email")
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
