//
//  Date.swift
//  AllConstant
//
//  Created by Vaibhav Agarwal on 10/04/19.
//  Copyright © 2019 Vaibhav Agarwal. All rights reserved.
//

import Foundation

enum DateFormat: String{
    
    ///"hh:mm a"
    case time = "hh:mm a"
    
    ///"HH:mm"
    case time24 = "HH:mm"
    
    ///"EEEE"
    case weekday = "EEEE"
    
    ///"dd-MMM"
    case date_month = "dd-MMM"
    
    ///"EEEE dd-MMM-yyyy"
    case dayFullMonthYear = "EEEE dd-MMM-yyyy"
    
    ///"EEE, dd MMM yyyy"
    case dayDateMonthYear = "EEE, dd MMM yyyy"
    
    ///"dd MMM, yyyy - hh:mm a"
    case full_date_time = "dd MMM, yyyy - hh:mm a"
    
    ///"MMM dd, yyyy hh:mm:ss a"
    case full_date_time2 = "MMM dd, yyyy hh:mm:ss a"
    
    ///"MMM dd, yyyy, hh:mm:ss a"
    case full_date_time3 = "MMM dd, yyyy, hh:mm:ss a"
    
    ///"yyyy-MM-dd HH:mm:ss.SSSS"
    case service_format = "yyyy-MM-dd HH:mm:ss.SSSS"
    
    ///"yyyy-MM-dd"
    case yearDash = "yyyy-MM-dd"
    
    ///"dd-MM-yyyy"
    case dayDash = "dd-MM-yyyy"
    
    ///"dd-MMM-yyyy"
    case dayMonthNameDash = "dd-MMM-yyyy"
    
    ///"dd/MM/yyyy"
    case daySlash = "dd/MM/yyyy"
    
    ///"dd MMM, yyyy"
    case monthName = "dd MMM, yyyy"
    
    ///"dd MMM yyyy"
    case appointmentDate = "dd MMM yyyy"
    
    ///"dd.MMM.yyyy"
    case dateDot = "dd.MMM.yyyy"
    
    ///"dd.MMM.yyyy HH:mm"
    case dateTimeDot = "dd.MMM.yyyy HH:mm"
    
    ///"dd.MMM.yyyy hh:mm a"
    case dateTimeDotA = "dd.MMM.yyyy hh:mm a"
    
    ///"MMM dd, yyyy"
    case monthDateYear = "MMM dd, yyyy"
    
    ///"MMM dd, yyyy hh:mm a"
    case monthDateYearTime = "MMM dd, yyyy hh:mm a"
    
    ///"yyyyMMdd_HHmmss"
    case time_stamp = "yyyyMMdd_HHmmss"
    
    ///"ddMMyyyyHHmmss"
    case ddMMyyyyHHmmss = "ddMMyyyyHHmmss"
    
    ///"MMM dd"
    case month_date = "MMM dd"
    
    ///"dd MMM"
    case dateMonth = "dd MMM"
    
    ///"dd MMM, hh:mm a"
    case dateMonth_time = "dd MMM, hh:mm a"
}

extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
    
    var isToday: Bool{
        return Calendar.current.isDateInToday(self)
    }
    
    var isTomorrow: Bool{
        return Calendar.current.isDateInTomorrow(self)
    }
    
    var isYesterday: Bool{
        return Calendar.current.isDateInYesterday(self)
    }
    
    var age: (year: Int?, month: Int?) {
        let component = Calendar.current.dateComponents([.year, .month], from: self, to: Date())
        return (component.year, component.month)
    }
    
    var toShortTime: String{
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeString = formatter.string(from: self as Date)
        
        //Return Short Time String
        return timeString
    }
    
    var dayNumber: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return NSString(string: dateFormatter.string(from: self)).integerValue
    }
    
    var monthNumber: Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return NSString(string: dateFormatter.string(from: self)).integerValue
    }
    
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        return dateFormatter.string(from: self)
    }
    
    var day: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: self)
    }
    
    var yearNumber: Int {
        return NSString(string: self.year).integerValue
    }
    
    var time: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: self)
    }
    
    var seconds: Int{
        return Calendar.current.component(.second, from: self)
    }
    
    var hourNumber: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self).toInt
    }
    
    var minuteNumber: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: self).toInt
    }
    
    var weekDay: String {
        return self.toString(format: .weekday)
    }
    
    var weekNumber: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
    
    /// This function is used to get the current time in milliseconds
    ///
    /// - Returns: the integer value of time
    var milliseconds:Int64 {
        
        let nowDouble = self.timeIntervalSince1970
        return Int64(nowDouble*1000)
    }
    
    var firstWeekDay: Int {
        
        let day = self.firstDayOfTheMonth.weekNumber
        return day
    }
    
    var numberOfDaysInMonth: Int{
        guard let days = Calendar.current.range(of: .day, in: .month, for: self) else{return 0}
        return (days.upperBound-days.lowerBound)
    }
    
    var diffstring: String?{
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [ .pad ]
        
        formatter.allowsFractionalUnits = true
        formatter.collapsesLargestUnit = true
        return formatter.string(from: self, to: Date())
    }
    
    ///to provide date as per proper format
    ///if it is of today show time
    ///if it is of same year show date and month
    ///otherwise show whole date without time
    var processDate: String{
        
        if self.isToday{
            return self.toString(format: .time)
        }
        else if self.year == Date().year{
            return self.toString(format: .dateMonth)
        }
        
        return self.toString(format: .monthName)
    }
    
    //MARK:- Comparison
    
    func isEqualTo(_ date: Date) -> Bool {
        return self == date
    }
    
    func isGreaterThan(_ date: Date) -> Bool {
        return self > date
    }
    
    func isSmallerThan(_ date: Date) -> Bool {
        return self < date
    }
    
    //MARK:- Date to Date data
    
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
    
    //MARK:- Methods
    
    func add(components: Set<Calendar.Component>, values: [Int]) -> Date{
        guard components.count == values.count else{return self}
        
        var date = self
        
        for (index, component) in components.enumerated(){
            
            if let d = Calendar.current.date(byAdding: component, value: values[index], to: date){
                date = d
            }
        }
        
        return date
    }
    
    func between(days: Int, component: Calendar.Component) -> [Date]{
        
        var dates = [Date]()
        
        for index in 1...abs(days){
            
            guard let date = Calendar.current.date(byAdding: .day, value: (days > 0) ? index : -index, to: self) else {continue}
            dates.append(date)
        }
        
        return dates
    }
    
    func number_of_days(second: String, format: DateFormat) -> Int?{
        
        guard let secondDate = Date.change(date: second, format: format) else {return nil}
        
        return self.days(from: secondDate)
    }
    
    func number_of_days(first: String, second: String, format: DateFormat) -> Int?{
        
        guard let firstDate = Date.change(date: first, format: format) else {return nil}
        guard let secondDate = Date.change(date: second, format: format) else {return nil}
        
        return firstDate.days(from: secondDate)
    }
    
    func changeDaysBy(days : Int) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = days
        return Calendar.current.date(byAdding: dateComponents, to: self)
    }
    
    func fullOffset(from date: Date) -> String{
        
        if (seconds(from: date) > 0 && seconds(from: date) < 60) {
            return "Just Now"
        }
        else if (minutes(from: date) > 0 && minutes(from: date) < 60) {
            
            let mins = minutes(from: date)
            return "\(mins)"+((mins>1) ? "mins" : "min")
        }
        else if (hours(from: date) > 0 && hours(from: date) < 24) {
            
            let hour = hours(from: date)
            return "\(hour)"+((hour>1) ? "hrs" : "hr")
        }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.year, .month, .day]
        formatter.unitsStyle = .full
        let string = formatter.string(from: date, to: self)!
        
        return string
    }
    
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        
        if years(from: date)   > 0 { return "\(years(from: date))yr"   }
        if months(from: date)  > 0 { return "\(months(from: date))mon"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) week"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) mins" }
        if seconds(from: date) > 0 { return "just now" }
        if nanoseconds(from: date) > 0 { return "\(nanoseconds(from: date))ns" }
        return ""
    }
    
    func generate(addbyUnit: Calendar.Component, value: Int) -> Date {
        
        let date = self
        let endDate = Calendar.current.date(byAdding: addbyUnit, value: value, to: date)!
        return endDate
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date), let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        return end - start
    }
    
    //MARK:- Formatter
    
    func change(format: DateFormat) -> Date?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = format.rawValue
        let str = dateFormatter.string(from: self)
        
        return dateFormatter.date(from: str)
    }
    
    func toString(format: DateFormat, isTimeZone: Bool = false) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        if isTimeZone{
            dateFormatter.timeZone = TimeZone.current
        }
        
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }
    
    static func change(first: String, fFormat: DateFormat, resultFormat: DateFormat, isTimeZone: Bool = false) -> String?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fFormat.rawValue
        
        if isTimeZone{
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        }
        
        guard let dateToConvert = dateFormatter.date(from: first) else {return nil }
        
        dateFormatter.dateFormat = resultFormat.rawValue
        
        if isTimeZone{
            dateFormatter.timeZone = TimeZone.current
        }
        
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        return dateFormatter.string(from: dateToConvert)
    }
    
    static func change(date: String, format: DateFormat, isTimeZone: Bool = false) -> Date?{
        
        let dateFormatter = DateFormatter()
        
        if isTimeZone{
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        }
        
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let dateToConvert = dateFormatter.date(from: date)
        
        return  dateToConvert
    }
    
    static func stringToDate(date: String, format: DateFormat) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.dateFormat = format.rawValue
        
        return dateFormatter.date(from: date)
    }
}

extension TimeInterval{
    
    var dateCompoFormatter: DateComponentsFormatter{
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = [ .pad ]
        return formatter
    }
    
    var diffstring: String?{
        let formatter = dateCompoFormatter
        return formatter.string(from: self)
    }
}
