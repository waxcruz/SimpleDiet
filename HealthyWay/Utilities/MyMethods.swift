//
//  MyDateMethods.swift
// HealthyWay
//
//  Created by Bill Weatherwax on 7/31/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import Foundation

func makeDateFromString(dateAsString: String) -> Date{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
    let check = dateFormatter.date(from: dateAsString)
    if check != nil {
        return check!
    } else {
        return Date(timeIntervalSince1970: 0)
    }
}

func makeCopyright() -> String {
    let today = Date()
    return "Copyright @ " +  today.makeYearStringFromDate() +
    " The Healthy Way"
}

func makeFirebaseEmailKey(email : String) -> String {
    let firebaseEmail = email.replacingOccurrences(of: "[.]", with: ",", options: .regularExpression)
    return firebaseEmail
}

func restoreEmail(firebaseEmailKey email : String) -> String {
    let validEmail = email.replacingOccurrences(of: "[,]", with: ".", options: .regularExpression)
    return validEmail
}
