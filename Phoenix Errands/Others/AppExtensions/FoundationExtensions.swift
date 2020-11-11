//
//  FoundationExtensions.swift
//  LastingVideoMemories
//
//  Created by  Software Llp on 05/10/18.
//  Copyright © 2018 iOS Dev. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


extension Notification.Name {
    static let flagsChanged = Notification.Name("FlagsChanged")
    static let topicAdded = Notification.Name("TopicAdded")
}
extension String {
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9]{10,14}$";
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
        return valid
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isPasswordValid() -> Bool{
        // Password length should be minimum of 6 characters
        return self.count >= 6
        //        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[$@$#!%*?&])(?=.*[0-9]).{8,32}$")
        //        return passwordTest.evaluate(with: self)
    }
    
    func isInputTextValid() -> Bool {
        let textRegEx = "[A-Z a-z]{0,20}"
        let textResult = NSPredicate(format: "SELF MATCHES %@", textRegEx)
        return textResult.evaluate(with:self)
    }
    
    
    func getDateFromString(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.date(from: self)
    }
    
    func createThumbnailOfVideoFromRemoteURLString() -> UIImage? {
        let asset = AVAsset(url: URL(string: self)!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //Can set this to improve performance if target size is known before hand
        //assetImgGenerate.maximumSize = CGSize(width,height)
        let videoDuration = asset.duration
        let time = CMTimeMakeWithSeconds(Float64(videoDuration.value/2), preferredTimescale: videoDuration.timescale)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func containsIgnoreCase(_ string: String) -> Bool {
        return self.lowercased().contains(string.lowercased())
    }
    
    func findTopicTitleToSetImage(string: String) -> String? {
        let birthdayToFind = "BIRTHDAY"
        if string.containsIgnoreCase(birthdayToFind) {
            return "BIRTHDAY"
        }
        let marriageToFind = "MARRIAGE"
        if string.containsIgnoreCase(marriageToFind) {
            return "MARRIAGE"
        }
        let graduationToFind = "GRADUATION"
        if string.containsIgnoreCase(graduationToFind) {
            return "GRADUATION"
        }
        let careerToFind = "CAREER"
        if string.containsIgnoreCase(careerToFind) {
            return "CAREER"
        }
        return "DEFAULT"
    }
    
    func converNumberToMonthString(month: String)-> String {
        var convertMonth: String = ""
        switch month {
        case "1":
            convertMonth = "January"
            break
        case "2":
            convertMonth = "February"
            break
        case "3":
            convertMonth = "March"
            break
        case "4":
            convertMonth = "April"
            break
        case "5":
            convertMonth = "May"
            break
        case "6":
            convertMonth = "June"
            break
        case "7":
            convertMonth = "July"
            break
        case "8":
            convertMonth = "August"
            break
        case "9":
            convertMonth = "September"
            break
        case "10":
            convertMonth = "October"
            break
        case "11":
            convertMonth = "November"
            break
        case "12":
            convertMonth = "December"
            break
        default:
            print("wrong choice")
        }
        return convertMonth
    }
    
    func converNumberToDateString(date: String)-> String {
        var convertDate: String = ""
        switch (date) {
        case ("01"):
            convertDate = "1st"
            break
        case ("02"):
            convertDate = "2nd"
            break
        case ("03"):
            convertDate = "3rd"
            break
        case ("04"):
            convertDate = "4th"
            break
        case ("05"):
            convertDate = "5th"
            break
        case ("06"):
            convertDate = "6th"
            break
        case ("07"):
            convertDate = "7th"
            break
        case ("08"):
            convertDate = "8th"
            break
        case ("09"):
            convertDate = "9th"
            break
        case ("10"):
            convertDate = "10th"
            break
        case ("11"):
            convertDate = "11th"
        case ("12"):
            convertDate = "12th"
            break
        case ("13"):
            convertDate = "13th"
            break
        case ("14"):
            convertDate = "14th"
            break
        case ("15"):
            convertDate = "15th"
            break
        case ("16"):
            convertDate = "16th"
        case ("17"):
            convertDate = "17th"
            break
        case ("18"):
            convertDate = "18th"
            break
        case ("19"):
            convertDate = "19th"
            break
        case ("20"):
            convertDate = "20th"
            break
        case ("21"):
            convertDate = "21st"
            break
        case ("22"):
            convertDate = "22nd"
            break
        case ("23"):
            convertDate = "23rd"
            break
        case ("24"):
            convertDate = "24th"
            break
        case ("25"):
            convertDate = "25th"
            break
        case ("26"):
            convertDate = "26th"
            break
        case ("27"):
            convertDate = "27th"
            break
        case ("28"):
            convertDate = "28th"
            break
        case ("29"):
            convertDate = "29th"
            break
        case ("30"):
            convertDate = "30th"
            break
        case ("31"):
            convertDate = "31st"
            break
        default:
            print("wrong choice")
        }
        return convertDate
    }
}

extension Data {
    mutating func append(string: String) {
        let data = string.data(
            using: String.Encoding.utf8,
            allowLossyConversion: true)
        append(data!)
    }
    
    func sizeString(units: ByteCountFormatter.Units = [.useAll], countStyle: ByteCountFormatter.CountStyle = .file) -> String {
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = units
        bcf.countStyle = .file
        return bcf.string(fromByteCount: Int64(count))
    }
    
    func sizeInMB(units: ByteCountFormatter.Units = [.useAll], countStyle: ByteCountFormatter.CountStyle = .file) -> Double {
        return Double(Double(count)/Double(1024*1024))
    }
}


extension Date {
    func getDateInString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.string(from: self)
    }
    func getNextYear() -> Date? {
        if let oneYear = Calendar.current.date(byAdding: .year, value: 1, to: self) {
            return oneYear
        }
        return nil
    }
    func getPreviousYear() -> Date? {
        if let oneYear = Calendar.current.date(byAdding: .year, value: -1, to: self) {
            return oneYear
        }
        return nil
    }
    func checkIFDifferenceGreaterThanOneYear(date: Date) -> Bool {
        if self.isLeapYear() && (self.days(from: date) > 366) {
            return true
        } else if self.days(from: date) > 365 {
            return true
        }
        return false
    }
    
    func isLeapYear() -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: self)
        if let year = components.year {
            return isLeapYear(year)
        }
        return false
    }
    func isLeapYear(_ year: Int) -> Bool {
        let isLeapYear = ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
        return isLeapYear
    }
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the amount of nanoseconds from another date
    func nanoseconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.nanosecond], from: date, to: self).nanosecond ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        if nanoseconds(from: date) > 0 { return "\(nanoseconds(from: date))ns" }
        return ""
    }
}

extension String {
    func getDataBeforeSpace(data: String) ->String {
        var returnString = ""
        if let range = data.range(of: " ") {
            let substring = data[..<range.lowerBound]
            returnString = String(substring)
        }
        return returnString
    }
}

extension String {
    func timeConvater24hrTo12hr(date: String, inputFormat: String, outputFormat: String)-> String{
        let inFormatter = DateFormatter()
        inFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        //inFormatter.dateFormat = "HH:mm"
        inFormatter.dateFormat = inputFormat
        
        let outFormatter = DateFormatter()
        outFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
//        outFormatter.dateFormat = "hh:mm"
         outFormatter.dateFormat = outputFormat
        
//        let inStr = "16:50"
        let inStr = date
        let date = inFormatter.date(from: inStr)!
        let outStr = outFormatter.string(from: date)
        print(outStr)
        return outStr
    }
}

