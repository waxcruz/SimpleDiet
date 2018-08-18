//
//  Model.swift
// HealthyWay
//
//  Created by Bill Weatherwax on 7/5/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import Foundation
enum KeysForFirebase {
    //MARK: - Firebase NONSQL Segment Names
    static let TABLE_JOURNAL = "Journal"
    static let TABLE_MEAL_CONTENTS = "MealContents"
    static let TABLE_SETTINGS = "Settings"
    //MARK: - Settings fields
    static let LIMIT_FAT = "LIMIT_FAT"
    static let LIMIT_FRUIT = "LIMIT_FRUIT"
    static let LIMIT_PROTEIN_LOW = "LIMIT_PROTEIN_LOW"
    static let LIMIT_PROTEIN_HIGH = "LIMIT_PROTEIN_HIGH"
    static let LIMIT_STARCH = "LIMIT_STARCH"
    static let LIMIT_VEGGIES = "LIMIT_VEGGIES"
    //MARK: - Stats fields
    static let GLASSES_OF_WATER = "GLASSES_OF_WATER"
    static let EXERCISED = "MINUTES_EXERCISED"
    static let SUPPLEMENTS = "SUPPLEMENTS"
    static let WEIGHED = "WEIGHED"
    //MARK: - Consume fields
    static let MEAL_DESCRIPTION = "MEAL_DATE"
    static let BREAKFAST_MEAL_KEY = "MEAL_DESCRIPTION"
    static let MORNING_SNACK_MEAL_KEY = "MORNING_SNACK_MEAL_KEY"
    static let LUNCH_MEAL_KEY = "LUNCH_MEAL_KEY"
    static let AFTERNOON_SNACK_MEAL_KEY = "AFTERNOON_SNACK_MEAL_KEY"
    static let DINNER_MEAL_KEY = "DINNER_MEAL_KEY"
    static let EVENING_SNACK_MEAL_KEY = "EVENING_SNACK_MEAL_KEY"
    //MARK: - MealContents fields
    static let MEAL_PROTEIN_QUANTITY = "MEAL_PROTEIN_QUANTITY"
    static let MEAL_FAT_QUANTITY = "MEAL_FAT_QUANTITY"
    static let MEAL_STARCH_QUANTITY = "MEAL_STARCH_QUANTITY"
    static let MEAL_FRUIT_QUANTITY = "MEAL_FRUIT_QUANTITY"
    static let MEAL_VEGGIES_QUANTITY = "MEAL_VEGGIES_QUANTITY"
}

enum FirebaseHandleIdentifiers : Int {
    case settings = 0
    case journal
    case mealContents
}


enum FoodComponent {
    case protein
    case fat
    case starch
    case fruit
    case veggies
    case free
}

enum MealDataEntryNumbers : Int {
    case firstPlaceholder = 0
    case numberForWeight
    case numberForWater
    case numberForExercise
    case numberForProteinLow
    case numberForFat
    case numberForStarch
    case numberForFruit
    case numberForVeggies
    case lastPlaceHolder
}

enum SettingsDataEntryNumbers : Int {
    case firstPlaceholder = 0
    case numberForProteinLow
    case numberForFat
    case numberForStarch
    case numberForFruit
    case numberForProteinHigh
    case lastPlaceHolder
}
enum MealTotalColumns : Int {
    case first = 0
    case columnProtein
    case columnFat
    case columnStarch
    case columnFruit
    case columnVeggies
    case last
}
enum Meal{
    case breakfast
    case morningSnack
    case lunch
    case afternoonSnack
    case dinner
    case eveningSnack
}

//struct Goal {
//    var targetWeight : Double
//    var targetDate: String
//
//    init() {
//        self.targetWeight = 0.0
//        self.targetDate = Date().makeShortStringDate()
//    }
//
//    init(weightTarget targetWeight : Double,
//         dateGoalForWeight targetDate : String) {
//        self.targetDate = targetDate
//        self.targetWeight = targetWeight
//    }
//}
//
//struct Limits {
//    var protein : Int
//    var fat : Int
//    var fruit : Int
//    var starch : Int
//    var veggies : Int
//
//    init() {
//        protein = 0
//        fat = 0
//        fruit = 0
//        starch = 0
//        veggies = 0
//    }
//
//    init(dailyProtein protein: Int,
//         dailyFat fat: Int,
//         dailyStarch starch: Int,
//         dailyFruit fruit: Int,
//         dailyVeggies veggies: Int
//         ) {
//        self.fat = fat
//        self.fruit = fruit
//        self.starch = starch
//        self.veggies = veggies
//        self.protein = protein
//    }
//}
//
//struct Settings {
//    var targets : Goal
//    var limits : Limits
//
//    init() {
//        targets = Goal()
//        limits = Limits()
//    }
//
//    init(goalforWeight goal : Goal,
//         dailyLimits limits : Limits) {
//        self.targets = goal
//        self.limits = limits
//    }
//}
//
//struct Stats {
//    var recordedDate : String // key YYYY-MM-Dd
//    var glassesOfWater : Int
//    var weighed : Double
//    var exercisedMinutes : Int
//
//    init() {
//        self.recordedDate = Date().description
//        self.glassesOfWater = 0
//        self.weighed = 0.0
//        self.exercisedMinutes = 0
//    }
//
//    init(recordForDate date: String,
//        glassesOfWaterConsumed water: Int,
//        weightOnDate weight : Double,
//        minutesExercising exercise : Int) {
//        self.recordedDate = date
//        self.glassesOfWater = water
//        self.exercisedMinutes = exercise
//        self.weighed  = weight
//    }
//}
//struct Consume {
//    var mealDate : String // key YYYY-MM-DD
//    var breakfastMealKey : String
//    var morningSnackMealKey : String
//    var lunchMealKey : String
//    var afternoonSnackMealKey : String
//    var dinnerMealKey : String
//    var eveningSnackMealKey : String
//
//    init() {
//        self.mealDate = Date().makeShortStringDate()
//        self.breakfastMealKey = ""
//        self.morningSnackMealKey = ""
//        self.lunchMealKey = ""
//        self.afternoonSnackMealKey = ""
//        self.dinnerMealKey = ""
//        self.eveningSnackMealKey = ""
//    }
//
//    init(dateMealConsumed mealDate : String,
//    keyForBreakfastMeal breakfastMealKey : String,
//    keyForMorningSnackMeal morningSnackMealKey : String,
//    keyForLunchkMeal lunchMealKey : String,
//    keyForAfternoonSnackMeal afternoonSnackMealKey : String,
//    keyForDinnerMeal dinnerMealKey : String,
//    keyForEveningSnackMeal eveningSnackMealKey : String
//    ) {
//        self.mealDate = mealDate;
//        self.breakfastMealKey = breakfastMealKey
//        self.morningSnackMealKey = morningSnackMealKey
//        self.lunchMealKey = lunchMealKey
//        self.afternoonSnackMealKey = afternoonSnackMealKey
//        self.dinnerMealKey = dinnerMealKey
//        self.eveningSnackMealKey = eveningSnackMealKey
//    }
//}
//
//struct MealContents {
//    var mealKey : String // YYYY-MM-DD-T where T = 0 to 5
//    var mealDescription : String
//    var mealProteinQuantity : Double
//    var mealFatQuantity : Double
//    var mealStarchQunatity : Double
//    var mealFruitQuantity : Double
//    var mealVeggiesQuantity : Double
//
//    init() {
//        self.mealKey = Date().makeShortStringDate()
//        self.mealDescription = ""
//        self.mealProteinQuantity = 0.0
//        self.mealFatQuantity = 0.0
//        self.mealFruitQuantity = 0.0
//        self.mealStarchQunatity = 0.0
//        self.mealVeggiesQuantity = 0.0
//    }
//
//    init(dateMealConsumed mealKey : String,
//         descriptionOfMeal mealDescription : String,
//         quantityOfProteinInMeal mealProteinQuantity : Double,
//         quantityOfFatInMeal mealFatQuantity : Double,
//         quantityOfFruitInMeal mealFruitQuantity : Double,
//         quantityOfStarchInMeal mealStarchQuantity : Double,
//         quantityOfVeggiesInMeal mealVeggiesQuantity : Double) {
//        self.mealKey = mealKey
//        self.mealDescription = mealDescription
//        self.mealProteinQuantity = mealProteinQuantity
//        self.mealFatQuantity = mealFatQuantity
//        self.mealFruitQuantity = mealFruitQuantity
//        self.mealStarchQunatity = mealStarchQuantity
//        self.mealVeggiesQuantity = mealVeggiesQuantity
//
//    }
//}
