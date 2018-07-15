//
//  SimpleDietViewController.swift
//  SimpleDieting
//
//  Created by Bill Weatherwax on 7/5/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit

class SimpleDietViewController: UIViewController {
    // MARK: - global model controller
    var modelController : ModelController!
    // MARK: - outlets
    @IBOutlet weak var targetWeight: UITextField!
    @IBOutlet weak var targetDate: UITextField!
    // MARK: - date picker
    var datePicker = UIDatePicker()
    var toolBar = UIToolbar()
    var toolBarNumber = UIToolbar()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelController = (self.parent as! SimpleDietTabBarController).getModel()
        if modelController?.settings?.count == 0 {
            NSLog("model not ready. Fix it")
        }
        createToolBarForDatePicker()
        createToolBarForNumber()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createWeight()
        createDatePicker()
        targetDate.inputView = datePicker
        targetDate.inputAccessoryView = toolBar
        targetWeight.inputAccessoryView = toolBarNumber
        targetWeight.text = modelController.targetWeigthString()
        targetDate.text = modelController.targetDateString()
        
    }

    func createDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.date = modelController.targetDate!
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(datePicker:)), for: .valueChanged)
        
    }
    
    func createWeight()  -> Void {
        targetWeight.text = modelController.targetWeigthString()
        targetWeight.addTarget(self, action: #selector(weightTextFieldDidEnd(_:)),
                               for: UIControlEvents.editingDidEnd)
    }
    
    func createToolBarForDatePicker() {
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let todayButton = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(todayButtonPressed(sender:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed(sender:)))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: 40))
        label.text = "Choose your target date"
        let labelButton = UIBarButtonItem(customView: label)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBar.setItems([todayButton, flexibleSpace, labelButton,flexibleSpace,doneButton], animated: true)
    }
 
    func createToolBarForNumber() {
        toolBarNumber = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearButtonPressed(sender:)))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneWeightButtonPressed(sender:)))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: 40))
        label.text = "Choose your target weight"
        let labelButton = UIBarButtonItem(customView: label)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBarNumber.setItems([clearButton, flexibleSpace, labelButton,flexibleSpace,doneButton], animated: true)
    }

    @objc func doneWeightButtonPressed(sender: UIBarButtonItem) {
        if let weight = Double(targetWeight.text!) {
            modelController.targetWeight = weight
        }
        targetWeight.resignFirstResponder()
    }
    @objc func doneButtonPressed(sender: UIBarButtonItem) {
        modelController.targetDate = datePicker.date
        showTargetDate(targetDate: datePicker.date)
        targetDate.resignFirstResponder()
    }
    
    @objc func todayButtonPressed(sender: UIBarButtonItem) {
        showTargetDate(targetDate: Date())
        targetDate.resignFirstResponder()
    }
 
    @objc func clearButtonPressed(sender: UIBarButtonItem) {
        modelController.targetWeight = 0.0
        targetWeight.text = ""
    }

    func showTargetDate(targetDate date : Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        targetDate.text = dateFormatter.string(from: date)

    }
    
    @objc func weightTextFieldDidEnd(_ textField: UITextField) {
        if let weight = Double(textField.text!) {
            modelController.targetWeight = weight
        }
    }
    
    @objc func datePickerValueChanged(datePicker: UIDatePicker) {
        modelController.targetDate = datePicker.date
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
