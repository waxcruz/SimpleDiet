//
//  GlobalConstants.swift
//  Healthy Way
//
//  Created by Bill Weatherwax on 9/10/18.
//  Copyright © 2018 waxcruz. All rights reserved.
//

import Foundation
public enum Constants {
    //MARK: - Segues
    public static let MAIN = "Main"
    public static let SIGNIN_VC = "SignInVC"
    public static let SEGUE_FROM_SIGNIN_TO_TAB_CONTROLLER = "segueFromSigninToTabController"
    public static let UNWIND_TO_SIGNIN_VIEW_CONTROLLER_WITH_SEGUE = "unwindToSignInViewControllerWithSegue"

    // MARK - Message text
    static let CHART_DESCRIPTION = "The Healthy Way Maintenance Chart"
    static let CHART_DATA_DESCRIPTION = "Weight Loss/Gain"
    static let NOTICE_RESET_PASSWORD  = "Enter your account email address. You'll receive an email with instructions to reset your account password. Once you finish the reset of your password, login again"
    static let JOURNAL_DAY_HEADER = """
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
            <h2>Journal </h2>
            <h3>(easier to read in landscape mode)</h3>
            """
    static let JOURNAL_DAILY_TOTALS_ROW = """
            <p>HW_RECORDED_DATE</p>
            <table style="font-size:10px;">
                <col width="20">
                <col width="125">
                <col width="15">
                <col width="15">
                <col width="15">
                <col width="15">
                <col width="15">
                <col width="100">
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
                <td>HW_DAILY_TOTAL_PROTEIN_VALUE</td>
                <td>HW_DAILY_TOTAL_STARCH_VALUE</td>
                <td>HW_DAILY_TOTAL_VEGGIES_VALUE</td>
                <td>HW_DAILY_TOTAL_FRUIT_VALUE</td>
                <td>HW_DAILY_TOTAL_FAT_VALUE</td>
                <td> </td>
              </tr>
            """
    static let JOURNAL_MEAL_ROW = """
              <tr>
                <td>HW_MEAL_NAME</td>
                <td>HW_MEAL_CONTENTS_DESCRIPTION</td>
                <td>HW_MEAL_PROTEIN_COUNT</td>
                <td>HW_MEAL_STARCH_COUNT</td>
                <td>HW_MEAL_VEGGIES_COUNT</td>
                <td>HW_MEAL_FRUIT_COUNT</td>
                <td>HW_MEAL_FAT_COUNT</td>
                <td>HW_MEAL_COMMENTS</td>
              </tr>
            """
    static let JOURNAL_DATE_TOTALS = """
                <td>Totals</td>
                <td> </td>
                <td>HW_DATE_TOTAL_PROTEIN</td>
                <td>HW_DATE_TOTAL_STARCH</td>
                <td>HW_DATE_TOTAL_VEGGIES</td>
                <td>HW_DATE_TOTAL_FRUIT</td>
                <td>HW_DATE_TOTAL_FAT</td>
                <td> </td>
              </tr>
            </table>
            """
    static let JOURNAL_DATE_STATS = """
            <font size="1">     Water: HW_DATE_WATER_CHECKS Supplements: HW_DATE_SUPPLEMENTS_CHECKS Exercise: HW_DATE_EXERCISE_CHECKS</font>
            <p>
            """
    static let JOURNAL_DATE_COMMENTS = """
            <font size="1">HW_COMMENTS</font>
            """
    static let JOURNAL_DATE_TRAILER = """
            </p>
            </div>
            </body>
            </html>
            """
}
