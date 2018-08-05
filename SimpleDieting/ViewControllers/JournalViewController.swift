//
//  MealsViewController.swift
//  SimpleDieting
//
//  Created by Bill Weatherwax on 7/16/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController {
    // MARK: - global model controller
    var modelController : ModelController!
    // MARK: - outlets
    @IBOutlet weak var targetWeight: UILabel!
    @IBOutlet weak var targetDate: UILabel!
    @IBOutlet weak var recordingDate: UITextField!
    @IBOutlet var dailyConsumptionTotals: [UILabel]!
    @IBOutlet var todayConsumptionTotals: [UILabel]!
    @IBOutlet var balanceConsumptionTotals: [UILabel]!
    @IBOutlet var dataEntryNumbers: [UITextField]!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - date picker
    var datePicker = UIDatePicker()
    var toolBar = UIToolbar()
    var toolBarNumber = UIToolbar()
    var recordDate = Date()
    
    // MARK: - number
    var keyedNumberString = ""
    // MARK - textfield helper
    var activeTextField = UITextField()
    
    // MARK - temp storage
    var firebaseJournal : [String: Any?] = [:]
    var firebaseMealContents : [String : Any?] = [:]
    var newJournal : [String: Any?] = [:]
    var newMealContents : [String: Any?] = [:]

    
    // MARK - Delegates and Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelController = (self.parent as! SimpleDietTabBarController).getModel()
        if modelController?.settingsInFirebase?.count == 0 {
            NSLog("model not ready. Fix it")
        }
        firebaseJournal = modelController.settingsInFirebase as! [String : Any?]
        createToolBarForDatePicker()
        createToolBarForNumber()
        modelController.firebaseDateKey = recordDate.makeShortStringDate()
        saveButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recordingDate.inputView = datePicker
        recordingDate.inputAccessoryView = toolBar
        bindNumberFieldsToModel()
        bindMealDateToDatePicker()
        bindTargets()
//        todayWeight.inputAccessoryView = toolBarNumber
//        todayWeight.text = modelController.targetWeigthString()
//        recordingDate.text = modelController.targetDateString()
        
    }
    
    func bindTargets() {
        targetDate.text = modelController.targetDate?.makeShortStringDate()
        targetWeight.text = modelController.targetWeight?.description
    }
    
    
    func bindMealDateToDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.date = recordDate
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(datePicker:)), for: .valueChanged)
        
    }
    
    func bindNumberFieldsToModel()  -> Void {
        for tag in 0..<dataEntryNumbers.count {
            dataEntryNumbers[tag].inputAccessoryView = toolBarNumber
            dataEntryNumbers[tag].addTarget(self, action: #selector(JournalViewController.numberTextFieldDidEnd(_:)), for: UIControlEvents.editingDidEnd)
        }
    }
    
    func createToolBarForDatePicker() {
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let todayButton = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(todayButtonPressed(sender:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressedForMealDate(sender:)))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: 40))
        label.text = "Choose your meal date"
        let labelButton = UIBarButtonItem(customView: label)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([todayButton, flexibleSpace, labelButton,flexibleSpace,doneButton], animated: true)
    }
    
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
        if let weight = Double(targetWeight.text!) {
            modelController.targetWeight = weight
        }
        self.resignFirstResponder()
    }
    @objc func doneButtonPressedForMealDate(sender: UIBarButtonItem) {
        modelController.targetDate = datePicker.date
        showTargetDate(targetDate: datePicker.date)
        recordingDate.resignFirstResponder()
    }
    
    @objc func todayButtonPressed(sender: UIBarButtonItem) {
        showTargetDate(targetDate: Date())
        recordingDate.resignFirstResponder()
    }
    
    @objc func clearButtonPressedForNumber(sender: UIBarButtonItem) {
        modelController.targetWeight = 0.0
//        todayWeight.text = ""
    }
    
    func showTargetDate(targetDate date : Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        targetDate.text = dateFormatter.string(from: date)
        
    }
    
    @objc func numberTextFieldDidEnd(_ textField: UITextField) {
        var keyedNumber = 0.0
        if let inputNumber = Double(textField.text!) {
            keyedNumber = inputNumber
        } else {
            NSLog("bad number in numberTextFieldDidEnd")
        }

        switch (textField.tag) {
        case MealDataEntryNumbers.numberForWeight.rawValue:
            modelController.targetWeight = keyedNumber
        default:
            NSLog("bad input to numberTextFieldEnd")
        }
    }
    

    
    
    @objc func datePickerValueChanged(datePicker: UIDatePicker) {
        modelController.targetDate = datePicker.date
    }
    // MARK: - Actions
    
    @IBAction func chooseMeal(_ sender: Any) {
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
