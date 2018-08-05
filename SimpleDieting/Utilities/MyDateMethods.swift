//
//  MyDateMethods.swift
//  SimpleDieting
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
