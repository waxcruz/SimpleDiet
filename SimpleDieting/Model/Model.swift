//
//  Model.swift
//  SimpleDieting
//
//  Created by Bill Weatherwax on 7/5/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import Foundation

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
    case numberForProtein
    case numberForFat
    case numberForStarch
    case numberForFruit
    case numberForVeggies
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

struct Goal {
    var targetWeight : Double
    var targetDate: String
    
    init() {
        self.targetWeight = 0.0
        self.targetDate = Date().makeShortStringDate()
    }
    
    init(weightTarget targetWeight : Double,
         dateGoalForWeight targetDate : String) {
        self.targetDate = targetDate
        self.targetWeight = targetWeight
    }
}

struct Limits {
    var protein : Int
    var fat : Int
    var fruit : Int
    var starch : Int
    var veggies : Int
    
    init() {
        protein = 0
        fat = 0
        fruit = 0
        starch = 0
        veggies = 0
    }
    
    init(dailyProtein protein: Int,
         dailyFat fat: Int,
         dailyStarch starch: Int,
         dailyFruit fruit: Int,
         dailyVeggies veggies: Int
         ) {
        self.fat = fat
        self.fruit = fruit
        self.starch = starch
        self.veggies = veggies
        self.protein = protein
    }
}

struct Settings {
    var targets : Goal
    var limits : Limits
    
    init() {
        targets = Goal()
        limits = Limits()
    }
    
    init(goalforWeight goal : Goal,
         dailyLimits limits : Limits) {
        self.targets = goal
        self.limits = limits
    }
}

struct Stats {
    var recordedDate : String // key YYYY-MM-Dd
    var glassesOfWater : Int
    var weighed : Double
    var exercisedMinutes : Int
    
    init() {
        self.recordedDate = Date().description
        self.glassesOfWater = 0
        self.weighed = 0.0
        self.exercisedMinutes = 0
    }
    
    init(recordForDate date: String,
        glassesOfWaterConsumed water: Int,
        weightOnDate weight : Double,
        minutesExercising exercise : Int) {
        self.recordedDate = date
        self.glassesOfWater = water
        self.exercisedMinutes = exercise
        self.weighed  = weight
    }
}
struct Consume {
    var mealDate : String // key YYYY-MM-DD
    var mealDescription : String
    var breakfastMealKey : String
    var morningSnackMealKey : String
    var lunchMealKey : String
    var afternoonSnackMealKey : String
    var dinnerMealKey : String
    var eveningSnackMealKey : String
    
    init() {
        self.mealDate = Date().makeShortStringDate()
        self.mealDescription = ""
        self.breakfastMealKey = ""
        self.morningSnackMealKey = ""
        self.lunchMealKey = ""
        self.afternoonSnackMealKey = ""
        self.dinnerMealKey = ""
        self.eveningSnackMealKey = ""
    }
    
    init(dateMealConsumed mealDate : String,
    descriptionOfMeal mealDescription : String,
    keyForBreakfastMeal breakfastMealKey : String,
    keyForMorningSnackMeal morningSnackMealKey : String,
    keyForLunchkMeal lunchMealKey : String,
    keyForAfternoonSnackMeal afternoonSnackMealKey : String,
    keyForDinnerMeal dinnerMealKey : String,
    keyForEveningSnackMeal eveningSnackMealKey : String
    ) {
        self.mealDate = mealDate;
        self.mealDescription = mealDescription
        self.breakfastMealKey = breakfastMealKey
        self.morningSnackMealKey = morningSnackMealKey
        self.lunchMealKey = lunchMealKey
        self.afternoonSnackMealKey = afternoonSnackMealKey
        self.dinnerMealKey = dinnerMealKey
        self.eveningSnackMealKey = eveningSnackMealKey
    }
}

struct MealContents {
    var mealKey : String // YYYY-MM-DD-T where T = 0 to 5
    var mealProteinQuantity : Double
    var mealFatQuantity : Double
    var mealStarchQunatity : Double
    var mealFruitQuantity : Double
    var mealVeggiesQuantity : Double
    
    init() {
        self.mealKey = Date().makeShortStringDate()
        self.mealProteinQuantity = 0.0
        self.mealFatQuantity = 0.0
        self.mealFruitQuantity = 0.0
        self.mealStarchQunatity = 0.0
        self.mealVeggiesQuantity = 0.0
    }
    
    init(dateMealConsumed mealKey : String,
         QuantityOfProteinInMeal mealProteinQuantity : Double,
         QuantityOfFatInMeal mealFatQuantity : Double,
         QuantityOfFruitInMeal mealFruitQuantity : Double,
         QuantityOfStarchInMeal mealStarchQuantity : Double,
         QuantityOfVeggiesInMeal mealVeggiesQuantity : Double) {
        self.mealKey = mealKey
        self.mealProteinQuantity = mealProteinQuantity
        self.mealFatQuantity = mealFatQuantity
        self.mealFruitQuantity = mealFruitQuantity
        self.mealStarchQunatity = mealStarchQuantity
        self.mealVeggiesQuantity = mealVeggiesQuantity
        
    }
}
