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
    case strach
    case veggies
    case free
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
    let targetWeight : Double
    let targetDate: Date
}

struct Consumed {
    let mealDate : Date
    let mealType : Meal
    let mealName : String
    let mealDescription : String
    let mealMeasurements : [FoodComponent : (Food, Double)]
}

struct Food {
    let foodName : String
    let foodBaseQuantity : Double
    let foodComponents :  [FoodComponent : Double]
}

