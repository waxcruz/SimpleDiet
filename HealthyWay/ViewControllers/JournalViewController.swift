//
//  JournalViewController.swift
// HealthyWay
//
//  Created by Bill Weatherwax on 7/16/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import UIKit
import MessageUI
import HealthyWayFramework

class JournalViewController: UIViewController, MFMailComposeViewControllerDelegate {
    // MARK: - global model controller
    var modelController : ModelController!
    
    // MARK: - outlets
    @IBOutlet weak var copyright: UILabel!
    
    @IBOutlet weak var mealDescription: UITextView!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var recordingDate: UITextField!
    @IBOutlet var dailyConsumptionTotals: [UILabel]!
    @IBOutlet var todayConsumptionTotals: [UILabel]!
    @IBOutlet var balanceConsumptionTotals: [UILabel]!
    @IBOutlet var dataEntryNumbers: [UITextField]!
    @IBOutlet var checkButtons: [UIButton]!
    @IBOutlet weak var scrollContent: UIScrollView!
    @IBOutlet weak var constraintMealContentHeight: NSLayoutConstraint!
    @IBOutlet weak var mealContent: UIView!
    @IBOutlet weak var chooseMeal: UISegmentedControl!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - date picker
    var datePicker = UIDatePicker()
    var toolBarDate = UIToolbar()
    var toolBarNumber = UIToolbar()
    var recordDate = Date()
    
    // MARK: - number
    var keyedNumberString = ""
    // MARK - textfield helper
    var activeTextField : UITextField?
    var lastOffset : CGPoint!
    var keyboardHeight : Double!
    // MARK - temp storage
    var firebaseJournal : [String: Any?] = [:]
    var firebaseMealContents : [String : Any?] = [:]
    var newJournal : [String: Any?] = [:]
    var newMealContents : [String: Any?] = [:]
    var firebaseSettings : [String: Any?] = [:]

    
    // MARK - Delegates and Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        copyright.text = makeCopyright()
        modelController = (self.parent as! HealthyWayTabBarController).getModel()
        lastOffset = scrollContent.contentOffset
        firebaseSettings = modelController.settingsInFirebase as! [String : Any?]
        createToolBarForDatePicker()
        createToolBarForNumber()
        formatMealChoices()
        recordDate = Date() // start with today's date
        recordingDate.text = recordDate.makeShortStringDate()
        modelController.firebaseDateKey = recordDate.makeShortStringDate()
        saveButton.isHidden = true
        cancelButton.isHidden = true
        firebaseMealContents = mealOnDate(mealDate: recordDate.makeShortStringDate())
        firebaseJournal = journalOnDate(journalDate: recordDate.makeShortStringDate())
        // Observe keyboard change
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firebaseSettings = modelController.settingsInFirebase as! [String : Any?]
        buildTotals()
        recordingDate.inputView = datePicker
        recordingDate.inputAccessoryView = toolBarDate
        bindNumberFieldsToModel()
        bindMealDateToDatePicker()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func formatMealChoices() {
        let font = UIFont.systemFont(ofSize: 12)
        chooseMeal.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                for: .normal)
    }
    
    func buildTotals() {
        // assumes firebase data retrieved
        
        // build totals
        
        // daily limits
        for tag in 0..<dailyConsumptionTotals.count {
            let mapTagToSettingIndex = dailyConsumptionTotals[tag].tag
            switch (mapTagToSettingIndex) {
            case 0:
                dailyConsumptionTotals[tag].text = String(firebaseSettings[KeysForFirebase.LIMIT_PROTEIN_LOW] as? Double ?? 0.0)
            case 1:
                dailyConsumptionTotals[tag].text = String(firebaseSettings[KeysForFirebase.LIMIT_FAT] as? Double ?? 0.0)
            case 2:
                dailyConsumptionTotals[tag].text = String(firebaseSettings[KeysForFirebase.LIMIT_STARCH] as? Double ?? 0.0)
            case 3:
                dailyConsumptionTotals[tag].text = String(firebaseSettings[KeysForFirebase.LIMIT_FRUIT] as? Double ?? 0.0)
            case 4:
                dailyConsumptionTotals[tag].text = "3.0"
            default:
                NSLog("index error in initializeView")
            }
        }
        
        // consumption on date
        for tag in 0..<todayConsumptionTotals.count {

            // dummy code for testing
                todayConsumptionTotals[tag].text = dataEntryNumbers[tag+1].text
        }
        
        // totals
        var totalLine : [Double] = []
        for _ in 0..<balanceConsumptionTotals.count {
            totalLine.append(0.0)
        }
        for tag in 0..<balanceConsumptionTotals.count {
            // dummy code for testing
            let limitTag = dailyConsumptionTotals[tag].tag
            let consumeTag = todayConsumptionTotals[tag].tag
            totalLine[limitTag] += Double(dailyConsumptionTotals[tag].text ?? "0.0") ?? 0.0
            totalLine[consumeTag] -= Double(todayConsumptionTotals[tag].text ?? "0.0") ?? 0.0
        }
        for tag in 0..<balanceConsumptionTotals.count {
            let totalsTag = balanceConsumptionTotals[tag].tag
            balanceConsumptionTotals[tag].text = String(totalLine[totalsTag] )
        }
        // add code to highlight negative numbers in red for fat, starch, and fruits
    }
    
    
    func bindMealDateToDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.date = recordDate
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(datePicker:)), for: .valueChanged)
        
    }
    
    func bindNumberFieldsToModel()  -> Void {
        for tagCollectionSequence in 0..<dataEntryNumbers.count {
            dataEntryNumbers[tagCollectionSequence].inputAccessoryView = toolBarNumber
            dataEntryNumbers[tagCollectionSequence].addTarget(self, action: #selector(JournalViewController.numberTextFieldDidEnd(_:)), for: UIControlEvents.editingDidEnd)
            dataEntryNumbers[tagCollectionSequence].addTarget(self, action: #selector(JournalViewController.textFieldDidBeginEditing(textField:)), for: UIControlEvents.editingDidBegin)
            dataEntryNumbers[tagCollectionSequence].delegate = self as? UITextFieldDelegate
            let displayTextField = dataEntryNumbers[tagCollectionSequence]
            let tag = dataEntryNumbers[tagCollectionSequence].tag
            switch (tag) {
            case 0:
                displayTextField.text = String(firebaseJournal[KeysForFirebase.WEIGHED] as? Double ?? 0.0)
            default:
                NSLog("bad tag number in storyboard (JournalViewController:bindNumberFieldsToModel")
            }
        }
    }
    
    func createToolBarForDatePicker() {
        toolBarDate = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let todayButton = UIBarButtonItem(title: "today", style: .plain, target: self, action: #selector(todayButtonPressed(sender:)))
        let doneButton = UIBarButtonItem(title: "return", style: .plain, target: self, action: #selector(doneButtonPressedForMealDate(sender:)))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: 40))
        label.text = "Choose your meal date"
        let labelButton = UIBarButtonItem(customView: label)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBarDate.setItems([todayButton, flexibleSpace, labelButton,flexibleSpace,doneButton], animated: true)
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
    
    @objc func doneButtonPressedForMealDate(sender: UIBarButtonItem) {
        recordDate = datePicker.date
        showMealDate(mealDate: datePicker.date)
        recordingDate.resignFirstResponder()
        saveButton.isHidden = false
        cancelButton.isHidden = false
        self.resignFirstResponder()
    }
    
    @objc func todayButtonPressed(sender: UIBarButtonItem) {
        showMealDate(mealDate: Date())
        recordingDate.resignFirstResponder()
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
    
    func showMealDate(mealDate date : Date) {
        recordingDate.text = date.makeShortStringDate()
    }
    
    @objc func textFieldDidBeginEditing(textField: UITextField) {
        activeTextField = textField
        lastOffset = scrollContent.contentOffset

    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo
        let kbSize : CGSize = (info![UIKeyboardFrameEndUserInfoKey] as! CGRect).size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        scrollContent.contentInset = contentInsets
        scrollContent.scrollIndicatorInsets = contentInsets
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        if !(aRect.contains((activeTextField?.frame.origin)!)) {
            scrollContent.scrollRectToVisible((activeTextField?.frame)!, animated: true)
        }
        
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        scrollContent.contentInset = contentInsets
        scrollContent.scrollIndicatorInsets = contentInsets
    }
    
    
    @objc func numberTextFieldDidEnd(_ textField: UITextField) {
        
        switch (textField.tag) {
        case MealDataEntryNumbers.numberForWeight.rawValue:
//            modelController.targetWeight = keyedNumber
            NSLog("dummy for now")
        default:
            NSLog("bad input to numberTextFieldEnd")
        }
        saveButton.isHidden = false
        cancelButton.isHidden = false
        activeTextField?.resignFirstResponder()
    }
    
    
    func journalOnDate(journalDate date: String) -> Dictionary<String, Any?> {
        return [:]
    }
    
    func mealOnDate(mealDate date: String) -> Dictionary <String, Any?>  {
        return [:]
    }
    
    
    @objc func datePickerValueChanged(datePicker: UIDatePicker) {
        recordDate = datePicker.date
        recordingDate.text = recordDate.makeShortStringDate()
    }
    // MARK: - Actions
    
    @IBAction func chooseMeal(_ sender: Any) {
    }
    
    @IBAction func clickedCancelButton(_ sender: Any) {
        cancelButton.isHidden = true
        saveButton.isHidden = true
    }
    
    @IBAction func clickedSaveButton(_ sender: Any) {
        cancelButton.isHidden = true
        saveButton.isHidden = true
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
            <h4>(Easier to read in landscape mode)</h4>
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
                <td>3</td>
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
    
    

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

