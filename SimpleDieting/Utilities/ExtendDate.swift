//
//  ExtendDate.swift
//  SimpleDieting
//
//  Created by Bill Weatherwax on 7/9/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import Foundation

extension Date {
    
    func makeShortStringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        return dateFormatter.string(from: self)
    }
    
    
}
