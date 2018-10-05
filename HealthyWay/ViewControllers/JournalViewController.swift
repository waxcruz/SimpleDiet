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

class JournalViewController: UIViewController, UITextViewDelegate,
MFMailComposeViewControllerDelegate {
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
    @IBOutlet weak var mealComments: UITextView!
    @IBOutlet weak var chooseMeal: UISegmentedControl!
    @IBOutlet weak var waiting: UIActivityIndicatorView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var messageBox: UITextView!
    
    // MARK: - date picker
    var datePicker = UIDatePicker()
    var toolBarDate = UIToolbar()
    var toolBarNumber = UIToolbar()
    var toolBarText = UIToolbar()
    var recordDate = Date()
    
    // MARK: - number
    var keyedNumberString = ""
    // MARK - textfield helper
    var activeNumberTextField : UITextField?
    var activeTextView : UITextView?
    var lastOffset : CGPoint!
    var keyboardHeight : Double!
    // MARK - temp storage
    var journalNode : [String: Any?] = [:]
    var mealContentsNode : [String : Any?] = [:]
    var settingsNode : [String: Any?] = [:]
    var userDataNode : [String : Any?] = [:]
    var isViewInNeedOfModelData : Bool = true
    var mealSelected : MealTypeStrings = MealTypeStrings.mealTypeBreakfast
    // MARK - controls
    var isWaitingVisible : Bool = false
    // MARK - check boxes
    var mapTagsToButtons : [UIButton] = []  // tag is index, button is a check button
    // MARK - number fields
    var mapTagsToNumbers : [UITextField] = [] // tag is index, text field is a number field
    // MARK - Delegates and Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildTagMaps()
        copyright.text = makeCopyright()
        modelController = (self.parent as! HealthyWayTabBarController).getModel()
        lastOffset = scrollContent.contentOffset
        createToolBarForDatePicker()
        createToolBarForNumber()
        createToolBarForText()
        formatMealChoices()
        // testing only
        recordDate = makeDateFromString(dateAsString: "2018-09-01") // Date()
        recordingDate.text = recordDate.makeShortStringDate()
        modelController.firebaseDateKey = recordDate.makeShortStringDate()
        saveButton.isHidden = true
        cancelButton.isHidden = true
        // Observe keyboard change
        notes.delegate = self
        mealDescription.delegate = self
        mealComments.delegate = self
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // assemble data for journal and meals
        if isViewInNeedOfModelData {
            waiting.isHidden = false
            waiting.isUserInteractionEnabled = false
            waiting.startAnimating()
            modelController.getNodeUserData(errorHandler: errorMessage, handler: buildDataEntryFields)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    func buildTagMaps() {
        // map a tag ID to its button
        mapTagsToButtons = [UIButton](repeatElement(UIButton(), count: checkButtons.count))
        for button in checkButtons {
            let tag = button.tag
            mapTagsToButtons[tag] = button
        }
        // map a tag ID to its button
        mapTagsToNumbers = [UITextField](repeatElement(UITextField(), count: dataEntryNumbers.count))
        for number in dataEntryNumbers {
            let tag = number.tag
            mapTagsToNumbers[tag] = number
        }

    }
    func buildDataEntryFields() {
        userDataNode = modelController.signedinUserDataNode
        isViewInNeedOfModelData = false
        mealContentsNode = mealOnDate(mealDate: recordDate.makeShortStringDate())
        journalNode = journalOnDate(journalDate: recordDate.makeShortStringDate())
        settingsNode = userDataNode[KeysForFirebase.NODE_SETTINGS] as? [String : Any?] ?? [:]
        buildTotals()
        recordingDate.inputView = datePicker
        recordingDate.inputAccessoryView = toolBarDate
        bindNumberFieldsToModel()
        bindMealDateToDatePicker()
        bindTextViewsToModel()
        bindChecksToModel()
        waiting.isHidden = true
        waiting.isUserInteractionEnabled = true
        waiting.stopAnimating()
        messageBox.isHidden = true
    }
 
    func changeMeal(){
        
        buildTotals()
        bindNumberFieldsToModel()
        bindTextViewsToModel()
        messageBox.isHidden = true
    }
    
    func errorMessage(message : String) {
        messageBox.text = message
        messageBox.isHidden = false
        waiting.isHidden = true
        waiting.isUserInteractionEnabled = true
        waiting.stopAnimating()
    }
    
    
    
    
    
    func formatMealChoices() {
        let font = UIFont.systemFont(ofSize: 12)
        chooseMeal.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                for: .normal)
    }
    func identity<T>(_ t: T) -> T { return t }
    
    
    func buildTotals() {
        // assumes firebase data retrieved
        
        // build totals
        
        // daily limits
        for tag in 0..<dailyConsumptionTotals.count {
            let mapTagToSettingIndex = dailyConsumptionTotals[tag].tag
            switch (mapTagToSettingIndex) {
            case 0:
                dailyConsumptionTotals[tag].text = String(settingsNode[KeysForFirebase.LIMIT_PROTEIN_LOW] as? Double ?? 0.0)
            case 1:
                dailyConsumptionTotals[tag].text = String(settingsNode[KeysForFirebase.LIMIT_FAT] as? Double ?? 0.0)
            case 2:
                dailyConsumptionTotals[tag].text = String(settingsNode[KeysForFirebase.LIMIT_STARCH] as? Double ?? 0.0)
            case 3:
                dailyConsumptionTotals[tag].text = String(settingsNode[KeysForFirebase.LIMIT_FRUIT] as? Double ?? 0.0)
            case 4:
                dailyConsumptionTotals[tag].text = "3.0"
            default:
                NSLog("index error in initializeView")
            }
        }

        // consumption on date
        var consumptionForTheDay = Array(repeating: 0.0, count: QuantityTypeStrings.allCases.count)
        for (_, mealDict) in mealContentsNode {
            let mealCounts = mealDict as? [String : Any?] ?? [:]
            for (foodKey, foodValue) in mealCounts {
                let foodKeyValue = QuantityTypeStrings(rawValue: foodKey)
                let amount = foodValue as? Double ?? 0.0
                switch foodKeyValue {
                case identity(QuantityTypeStrings.mealProteinQuantity):
                    consumptionForTheDay[0] += amount
                case identity(QuantityTypeStrings.mealFatQuantity):
                    consumptionForTheDay[1] += amount
                case identity(QuantityTypeStrings.mealStarchQuantity):
                    consumptionForTheDay[2] += amount
                case identity(QuantityTypeStrings.mealFruitQuantity):
                    consumptionForTheDay[3] += amount
                case identity(QuantityTypeStrings.mealVeggiesQuantity):
                    consumptionForTheDay[4] += amount
                default:
                    continue
                }
            }
            
            
        }
        
        for tag in 0..<todayConsumptionTotals.count {

            // dummy code for testing
                todayConsumptionTotals[tag].text = String(consumptionForTheDay[tag])
        }
        
        // totals
        var totalLine = Array(repeating: 0.0, count: balanceConsumptionTotals.count)

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
            if totalLine[totalsTag] < 0.0 {
                if totalsTag > 0 && totalsTag < 4 {
                    balanceConsumptionTotals[tag].textColor = UIColor.red
                } else {
                    balanceConsumptionTotals[tag].textColor = UIColor.black
                }
            } else {
                balanceConsumptionTotals[tag].textColor = UIColor.black
            }
        }
    }
    
    
    func bindMealDateToDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.date = recordDate
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(datePicker:)), for: .valueChanged)
        
    }
    
    func bindNumberFieldsToModel()  -> Void {
        var theMeal = mealContentsNode[mealSelected.rawValue] as? [String : Any?] ?? [:]
        for tagCollectionSequence in 0..<dataEntryNumbers.count {
            dataEntryNumbers[tagCollectionSequence].inputAccessoryView = toolBarNumber
            dataEntryNumbers[tagCollectionSequence].addTarget(self, action: #selector(JournalViewController.numberTextFieldDidEnd(_:)), for: UIControlEvents.editingDidEnd)
            dataEntryNumbers[tagCollectionSequence].addTarget(self, action: #selector(JournalViewController.numberTextFieldDidBeginEditing(textField:)), for: UIControlEvents.editingDidBegin)
            dataEntryNumbers[tagCollectionSequence].delegate = self as? UITextFieldDelegate
            let displayTextField = dataEntryNumbers[tagCollectionSequence]
            let tag = dataEntryNumbers[tagCollectionSequence].tag
            switch (tag) {
            case 0:
                displayTextField.text = String(journalNode[KeysForFirebase.WEIGHED] as? Double ?? 0.0)
            case 1:
                displayTextField.text = String(theMeal[KeysForFirebase.MEAL_PROTEIN_QUANTITY] as? Double ?? 0.0)
                mealContentsNode[mealSelected.rawValue] = theMeal
            case 2:
                displayTextField.text = String(theMeal[KeysForFirebase.MEAL_FAT_QUANTITY] as? Double ?? 0.0)
                mealContentsNode[mealSelected.rawValue] = theMeal
            case 3:
                displayTextField.text = String(theMeal[KeysForFirebase.MEAL_STARCH_QUANTITY] as? Double ?? 0.0)
                mealContentsNode[mealSelected.rawValue] = theMeal
            case 4:
                displayTextField.text = String(theMeal[KeysForFirebase.MEAL_FRUIT_QUANTITY] as? Double ?? 0.0)
                mealContentsNode[mealSelected.rawValue] = theMeal
            case 5:
                displayTextField.text = String(theMeal[KeysForFirebase.MEAL_VEGGIES_QUANTITY] as? Double ?? 0.0)
                mealContentsNode[mealSelected.rawValue] = theMeal
            default:
                NSLog("bad tag number in storyboard (JournalViewController:bindNumberFieldsToModel")
            }
        }
    }
    
    func bindTextViewsToModel() -> Void {
        notes.text = journalNode[KeysForFirebase.NOTES] as? String ?? ""
        notes.inputAccessoryView = toolBarText
        let theMealDetails = mealContentsNode[mealSelected.rawValue] as? [String : Any?] ?? [:]
        mealDescription.text = theMealDetails[KeysForFirebase.MEAL_DESCRIPTION] as? String ?? ""
        mealDescription.inputAccessoryView = toolBarText
        mealComments.text = theMealDetails[KeysForFirebase.MEAL_COMMENTS] as? String ?? ""
        mealComments.inputAccessoryView = toolBarText
    }
    
    func bindChecksToModel() -> Void {
        for check in checkButtons {
            check.setTitle("", for: .normal)
        }
        let countWaterChecks = journalNode[KeysForFirebase.GLASSES_OF_WATER] as? Double ?? 0.0
        if  countWaterChecks == 0.0 {
            for tag in Constants.WATER_CHECKS_START_TAG...Constants.WATER_CHECKS_END_TAG {
                mapTagsToButtons[tag].setTitle(" ", for: .normal)
            }
        } else {
            for tag in Constants.WATER_CHECKS_START_TAG..<Int(countWaterChecks) {
                mapTagsToButtons[tag].setTitle("✔︎", for: .normal)
            }
            if Int(countWaterChecks) <= Constants.WATER_CHECKS_END_TAG {
                for tag in Int(countWaterChecks)...Constants.WATER_CHECKS_END_TAG {
                    mapTagsToButtons[tag].setTitle(" ", for: .normal)
                }
            }
        }
        let countSupplementChecks = journalNode[KeysForFirebase.SUPPLEMENTS] as? Double ?? 0.0
        if countSupplementChecks == 0.0 {
            for tag in Constants.SUPPLEMENTS_CHECKS_START_TAG...Constants.SUPPLEMENTS_CHECKS_END_TAG {
                mapTagsToButtons[tag].setTitle(" ", for: .normal)
            }
        } else {
            for tag in Constants.SUPPLEMENTS_CHECKS_START_TAG..<(Constants.SUPPLEMENTS_CHECKS_START_TAG + Int(countSupplementChecks)) {
                mapTagsToButtons[tag].setTitle("✔︎", for: .normal)
            }
            let maxSupplementCount = Constants.SUPPLEMENTS_CHECKS_END_TAG - Constants.SUPPLEMENTS_CHECKS_END_TAG + 1
            if Int(countSupplementChecks) < maxSupplementCount {
                for tag in (Constants.SUPPLEMENTS_CHECKS_START_TAG + Int(countSupplementChecks))...Constants.SUPPLEMENTS_CHECKS_END_TAG {
                    mapTagsToButtons[tag].setTitle(" ", for: .normal)
                }
            }
        }
        let countExerciseCheck = journalNode[KeysForFirebase.EXERCISED] as? Double ?? 0.0
        if countExerciseCheck == 1.0 {
            mapTagsToButtons[Constants.EXERCISE_CHECK_TAG].setTitle("✔︎", for: .normal)
        } else {
            mapTagsToButtons[Constants.EXERCISE_CHECK_TAG].setTitle(" ", for: .normal)
        }
    }
    
    
    
    func createToolBarForDatePicker() {
        toolBarDate = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let todayButton = UIBarButtonItem(title: "today", style: .plain, target: self, action: #selector(todayButtonPressed(sender:)))
        let doneButton = UIBarButtonItem(title: "finished", style: .plain, target: self, action: #selector(doneButtonPressedForMealDate(sender:)))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: 40))
        label.text = "Choose your meal date"
        let labelButton = UIBarButtonItem(customView: label)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBarDate.setItems([todayButton, flexibleSpace, labelButton,flexibleSpace,doneButton], animated: true)
    }
    
    
    @objc func doneButtonPressedForMealDate(sender: UIBarButtonItem) {
        recordDate = datePicker.date
        showMealDate(mealDate: datePicker.date)
        recordingDate.resignFirstResponder()
//        saveButton.isHidden = false
//        cancelButton.isHidden = false
        self.resignFirstResponder()
    }
    
    @objc func todayButtonPressed(sender: UIBarButtonItem) {
        showMealDate(mealDate: Date())
        recordingDate.resignFirstResponder()
    }
    
    

    func createToolBarForNumber() {
        toolBarNumber = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let clearButton = UIBarButtonItem(title: "clear", style: .plain, target: self, action: #selector(clearButtonPressedForNumber(sender:)))
        let doneButton = UIBarButtonItem(title: "finished", style: .plain, target: self, action: #selector(doneNumber (sender:)))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: 40))
        label.text = "Enter number"
        let labelButton = UIBarButtonItem(customView: label)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBarNumber.setItems([clearButton, flexibleSpace, labelButton,flexibleSpace,doneButton], animated: true)

    }
    
    @objc func doneNumber (sender: UIBarButtonItem) {
        for tag in 0..<dataEntryNumbers.count {
            if let tf = dataEntryNumbers?[tag] {
                if tf == activeNumberTextField {
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
                if tf == activeNumberTextField {
                    tf.text = ""
                    return
                }
            }
        }
        NSLog("mismatch in clearButtonPressed")
    }

    func createToolBarForText() {
        toolBarText = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        let clearButton = UIBarButtonItem(title: "clear", style: .plain, target: self, action: #selector(clearButtonPressedForTextView(sender:)))
        let doneButton = UIBarButtonItem(title: "finished", style: .plain, target: self, action: #selector(doneText (sender:)))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: 40))
        label.text = "Enter text"
        let labelButton = UIBarButtonItem(customView: label)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolBarText.setItems([clearButton, flexibleSpace, labelButton,flexibleSpace,doneButton], animated: true)
    }

    @objc func doneText (sender: UITextView) {
        var tf = mealDescription
        if tf == activeTextView {
            tf?.resignFirstResponder()
        } else {
            tf = notes
            if tf == activeTextView {
                tf?.resignFirstResponder()
            } else {
                tf = mealComments
                if tf == activeTextView {
                    tf?.resignFirstResponder()
                } else {
                    print("mismatch in doneText")
                }
            }
        }
        return
    }



    
    @objc func clearButtonPressedForTextView(sender: UIBarButtonItem) {
        if activeTextView == notes {
            notes.text = ""
        } else {
            if activeTextView == mealDescription {
               mealDescription.text = ""
            } else {
                mealComments.text = ""
            }
        }
    }
    
    func showMealDate(mealDate date : Date) {
        recordingDate.text = date.makeShortStringDate()
    }
    
    @objc func numberTextFieldDidBeginEditing(textField: UITextField) {
        activeNumberTextField = textField
        activeTextView = nil
        lastOffset = scrollContent.contentOffset
    }
  
    @objc func numberTextFieldDidEnd(_ textField: UITextField) {
        let amount = Double(textField.text ?? "0.0")
        var meal = mealContentsNode[mealSelected.rawValue] as? [String : Any?] ?? [:]
        switch (textField.tag) {
        case MealDataEntryTags.numberForWeight.rawValue:
            journalNode[KeysForFirebase.WEIGHED] = amount
        case MealDataEntryTags.numberForProteinLow.rawValue:
            meal[QuantityTypeStrings.mealProteinQuantity.rawValue] = amount
            mealContentsNode[mealSelected.rawValue] = meal
        case MealDataEntryTags.numberForStarch.rawValue:
            meal[QuantityTypeStrings.mealStarchQuantity.rawValue] = amount
            mealContentsNode[mealSelected.rawValue] = meal
        case MealDataEntryTags.numberForFat.rawValue:
            meal[QuantityTypeStrings.mealFatQuantity.rawValue] = amount
            mealContentsNode[mealSelected.rawValue] = meal
        case MealDataEntryTags.numberForFruit.rawValue:
            meal[QuantityTypeStrings.mealFruitQuantity.rawValue] = amount
            mealContentsNode[mealSelected.rawValue] = meal
        case MealDataEntryTags.numberForVeggies.rawValue:
            meal[QuantityTypeStrings.mealVeggiesQuantity.rawValue] = amount
            mealContentsNode[mealSelected.rawValue] = meal
        default:
            print("invalid tag number")
        }
        saveButton.isHidden = false
        cancelButton.isHidden = false
        activeNumberTextField?.resignFirstResponder()
        buildTotals()
    }


    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeTextView = textView
        activeNumberTextField = nil
        lastOffset = scrollContent.contentOffset
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        let keyedText = textView.text
        let tag = textView.tag
        var meal = mealContentsNode[mealSelected.rawValue] as? [String : Any?] ?? [:]
        switch tag {
        case 0: // Notes
            journalNode[KeysForFirebase.NOTES] = keyedText
        case 1: // meal description
            meal[KeysForFirebase.MEAL_DESCRIPTION] = keyedText
            mealContentsNode[mealSelected.rawValue] = meal
        case 2: // meal comment
            meal[KeysForFirebase.MEAL_COMMENTS] = keyedText
            mealContentsNode[mealSelected.rawValue] = meal
        default:
            print("tag error on UITextViews")
        }
        
        
        
        
        saveButton.isHidden = false
        cancelButton.isHidden = false
        activeTextView?.resignFirstResponder()
        return true
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        let info = notification.userInfo
        let kbSize : CGSize = (info![UIKeyboardFrameEndUserInfoKey] as! CGRect).size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
        scrollContent.contentInset = contentInsets
        scrollContent.scrollIndicatorInsets = contentInsets
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        if activeNumberTextField != nil {
            if !(aRect.contains((activeNumberTextField?.frame.origin)!)) {
                scrollContent.scrollRectToVisible((activeNumberTextField?.frame)!, animated: true)
                return
            }
        }

        if activeTextView != nil {
            let absoluteActiveTextViewOrigin = activeTextView?.convert(activeTextView!.bounds.origin, to: nil)
            let checkRect = CGRect.init(x: absoluteActiveTextViewOrigin?.x ?? 0.0, y: absoluteActiveTextViewOrigin?.y ?? 0.0, width: activeTextView?.frame.width ?? 0.0, height: activeTextView?.frame.height ?? 0.0)
            if !(aRect.contains(checkRect.origin)) {
                let adjustActiveTextViewFrame = CGRect.init(x: activeTextView?.frame.origin.x ?? 0.0, y: (activeTextView?.frame.origin.y ?? 0.0) + checkRect.origin.y - kbSize.height + (activeTextView?.frame.size.height ?? 0.0) , width: activeTextView?.frame.width ?? 0.0, height: activeTextView?.frame.height ?? 0.0)
                scrollContent.scrollRectToVisible(adjustActiveTextViewFrame, animated: true) // adjustActiveTextViewFrame
                return
            }
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        scrollContent.contentInset = contentInsets
        scrollContent.scrollIndicatorInsets = contentInsets
    }
    
 
    
    func journalOnDate(journalDate date: String) -> Dictionary<String, Any?> {
        let userJournalContents = userDataNode[KeysForFirebase.NODE_JOURNAL] as? [String : Any?] ?? [:]
        let userJournalContentsOnDate = userJournalContents[date] as? [String : Any?] ?? [:]
        return userJournalContentsOnDate
    }
    
    func mealOnDate(mealDate date: String) -> Dictionary <String, Any?>  {
        let userMealContents = userDataNode[KeysForFirebase.NODE_MEAL_CONTENTS] as? [String : Any?] ?? [:]
        let userMealOnDate = userMealContents[date] as? [String : Any?] ?? [:]
        return userMealOnDate
    }
 
    func updateJournalOnDate(journalDate date : String, node : [String : Any?]) {
        var userJournalContents = userDataNode[KeysForFirebase.NODE_JOURNAL] as? [String : Any?] ?? [:]
        var userJournalContentsOnDate = userJournalContents[date] as? [String : Any?] ?? [:]
        userJournalContentsOnDate = node
        userJournalContents[date] = userJournalContentsOnDate
        userDataNode[KeysForFirebase.NODE_JOURNAL] = userJournalContents
    }
    
    func updateMealOnDate(mealDate date : String, node : [String : Any?]) {
        var userMealContents = userDataNode[KeysForFirebase.NODE_MEAL_CONTENTS] as? [String : Any?] ?? [:]
        var userMealOnDate = userMealContents[date] as? [String : Any?] ?? [:]
        userMealOnDate = node
        userMealContents[date] = userMealOnDate
        userDataNode[KeysForFirebase.NODE_MEAL_CONTENTS] = userMealContents
    }
    
    
    
    
    
    @objc func datePickerValueChanged(datePicker: UIDatePicker) {
        if saveButton.isHidden {
            recordDate = datePicker.date
            recordingDate.text = recordDate.makeShortStringDate()
            isViewInNeedOfModelData = true
            buildDataEntryFields()
        } else {
            let alert = UIAlertController(title: "Keyed data not saved", message: "Selecting a new journal date will cause you to loose information that you recently keyed. Click cancel to abandon date change. Save your information before changing the  date", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Change the date", style: .default, handler: { action in
                switch action.style{
                case .default:
                    self.recordDate = datePicker.date
                    self.recordingDate.text = self.recordDate.makeShortStringDate()
                    self.isViewInNeedOfModelData = true
                    self.buildDataEntryFields()
                    self.saveButton.resignFirstResponder()
                    self.cancelButton.resignFirstResponder()
                case .cancel:
                    print("Error in datepicker Alert because cancel returned")
                    
                case .destructive:
                    print("Error in datepicker Alert because destructive returned")
                    
                    
                }}))
            alert.addAction(UIAlertAction(title: "Cancel date change", style: .cancel, handler: { action in
                switch action.style{
                case .default:
                    print("Error in datepicker Alert because default returned")
                    
                case .cancel:
                    break
                    
                case .destructive:
                    print("Error in datepicker Alert because destructive returned")
                }}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    // MARK: - Actions
    
    @IBAction func waterClick(_ sender: Any) {
        var waterCount = journalNode[KeysForFirebase.GLASSES_OF_WATER] as? Double ?? 0.0
        waterCount += checkMarkClick(checkButton: sender as! UIButton)
        journalNode[KeysForFirebase.GLASSES_OF_WATER] = waterCount
        bindChecksToModel()
    }
    
    
    @IBAction func supplementClick(_ sender: Any) {
        var supplementCount = journalNode[KeysForFirebase.SUPPLEMENTS] as? Double ?? 0.0
        supplementCount += checkMarkClick(checkButton: sender as! UIButton)
        journalNode[KeysForFirebase.SUPPLEMENTS] = supplementCount
        bindChecksToModel()
    }
    
    @IBAction func exerciseClick(_ sender: Any) {
        var exerciseCount = journalNode[KeysForFirebase.EXERCISED] as? Double ?? 0.0
        exerciseCount += checkMarkClick(checkButton: sender as! UIButton)
        journalNode[KeysForFirebase.EXERCISED] = exerciseCount
        bindChecksToModel()
    }
    
    func checkMarkClick(checkButton : UIButton) -> Double {
        var result = 0.0
        if checkButton.currentTitle == " " {
            checkButton.setTitle("✔︎", for: .normal)
            result = 1.0
        } else {
            checkButton.setTitle(" ", for: .normal)
            result = -1.0
        }
        saveButton.isHidden = false
        cancelButton.isHidden = false
        return result
    }
    
    @IBAction func chooseMeal(_ sender: Any) {
        let mealSelection = sender as? UISegmentedControl
        let selectedMeal = (mealSelection?.selectedSegmentIndex)!
        switch selectedMeal {
        case 0:
            mealSelected = .mealTypeBreakfast
        case 1:
            mealSelected = .mealTypeMorningSnack
        case 2:
            mealSelected = .mealTypeLunch
        case 3:
            mealSelected = .mealTypeAfternoonSnack
        case 4:
            mealSelected = .mealTypeDinner
        case 5:
            mealSelected = .mealTypeEveningSnack
        default:
            print("invalid segement index")
        }
        changeMeal()
    }
    
    func createMealContentsNodeFromView(mealName meal : Meal) -> [String : Any?] {
        var node : [String : Any?] = [:]
        node[Constants.KEY_NAME] = meal
        node[KeysForFirebase.MEAL_DESCRIPTION] = mealDescription.text
        node[KeysForFirebase.MEAL_COMMENTS] = mealComments.text
        node[String(Constants.CONSUMPTION_NUMBER_PROTEIN)] = Double(mapTagsToNumbers[Constants.CONSUMPTION_NUMBER_PROTEIN].text!) ?? 0.0
        node[String(Constants.CONSUMPTION_NUMBER_STARCH)] = Double(mapTagsToNumbers[Constants.CONSUMPTION_NUMBER_STARCH].text!) ?? 0.0
        node[String(Constants.CONSUMPTION_NUMBER_FAT)] = Double(mapTagsToNumbers[Constants.CONSUMPTION_NUMBER_FAT].text!) ?? 0.0
        node[String(Constants.CONSUMPTION_NUMBER_FRUIT)] = Double(mapTagsToNumbers[Constants.CONSUMPTION_NUMBER_FRUIT].text!) ?? 0.0
        node[String(Constants.CONSUMPTION_NUMBER_VEGGIES)] = Double(mapTagsToNumbers[Constants.CONSUMPTION_NUMBER_VEGGIES].text!) ?? 0.0
        return node
    }
    
    func postViewFromMealContentsNode(mealContentsNode node : [String : Any?]) {
        switch node[Constants.KEY_NAME] as! Meal {
        case Meal.breakfast:
            chooseMeal.selectedSegmentIndex = 0
        case Meal.morningSnack:
            chooseMeal.selectedSegmentIndex = 1
        case Meal.lunch:
            chooseMeal.selectedSegmentIndex = 2
        case Meal.afternoonSnack:
            chooseMeal.selectedSegmentIndex = 3
        case Meal.dinner:
            chooseMeal.selectedSegmentIndex = 4
        case Meal.eveningSnack:
            chooseMeal.selectedSegmentIndex = 5
        }
    }
    
    @IBAction func clickedCancelButton(_ sender: Any) {
        cancelButton.isHidden = true
        saveButton.isHidden = true
        userDataNode = [:]
        mealContentsNode = [:]
        journalNode = [:]
        isViewInNeedOfModelData = true
        buildDataEntryFields()
    }
    
    
    
    @IBAction func clickedSaveButton(_ sender: Any) {
        cancelButton.isHidden = true
        saveButton.isHidden = true
        waiting.isHidden = false
        waiting.isUserInteractionEnabled = false
        waiting.startAnimating()
        updateJournalOnDate(journalDate: recordDate.makeShortStringDate(), node: journalNode)
        updateMealOnDate(mealDate: recordDate.makeShortStringDate(), node: mealContentsNode)
        modelController.setNodeUserData(userDataNode: userDataNode, errorHandler: errorMessage, handler: updateUserSuccess)
    }
    
    func updateUserSuccess() {
        waiting.isHidden = true
        waiting.isUserInteractionEnabled = true
        waiting.stopAnimating()
        messageBox.isHidden = true
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
        let myJournal = formatJournal(clientNode: userDataNode, isEmail: true)
        composeVC.setMessageBody(myJournal ?? " ", isHTML: true)
        
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

