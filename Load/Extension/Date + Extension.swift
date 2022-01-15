//
//  Date + Extension.swift
//  JoeToGo
//
//  Created by Haresh on 22/03/19.
//  Copyright © 2019 Haresh. All rights reserved.
//

import Foundation

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
//        print("start - ",start)
//        print("end - ",end)
        return end - start
    }
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    func dateByAddingDays(inDays:NSInteger)->Date{
        let date = self
        return Calendar.current.date(byAdding: .day, value: inDays, to: date)!
    }
    
    //minutes difference
    
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    
    func secondDifference(to date: Date) -> Int {
        
        return Calendar.current.dateComponents([.second], from: self, to: date).second ?? 0
    }

}
func generateDatesArrayBetweenTwoDates(startDate: Date , endDate:Date) ->[Date]
{
    var datesArray: [Date] =  [Date]()
    var startDate = startDate
    let calendar = Calendar.current
    
    while startDate <= endDate {
        datesArray.append(startDate)
        startDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
    }
    return datesArray
}

