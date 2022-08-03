//
//  DatePickerRangeDataModel.swift
//  Load
//
//  Created by Timotius Leonardo Lianoto on 03/08/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation

struct DatePickerRangeDataModel {
    var title: String
    
    static func createData() -> [[DatePickerRangeDataModel]] {
        [
            [ .init(title: "00"), .init(title: "01"), .init(title: "02"), .init(title: "03"), .init(title: "04"), .init(title: "05"), .init(title: "06"), .init(title: "07"), .init(title: "08"), .init(title: "09"), .init(title: "10"), .init(title: "11"), .init(title: "12") ],
            [ .init(title: ":") ],
            [ .init(title: "00"), .init(title: "01"), .init(title: "02"), .init(title: "03"), .init(title: "04"), .init(title: "05"), .init(title: "06"), .init(title: "07"), .init(title: "08"), .init(title: "09"), .init(title: "10"), .init(title: "11"), .init(title: "12") ],
            [ .init(title: "AM"), .init(title: "PM") ],
            [ .init(title: "-") ],
            [ .init(title: "00"), .init(title: "01"), .init(title: "02"), .init(title: "03"), .init(title: "04"), .init(title: "05"), .init(title: "06"), .init(title: "07"), .init(title: "08"), .init(title: "09"), .init(title: "10"), .init(title: "11"), .init(title: "12") ],
            [ .init(title: ":") ],
            [ .init(title: "00"), .init(title: "01"), .init(title: "02"), .init(title: "03"), .init(title: "04"), .init(title: "05"), .init(title: "06"), .init(title: "07"), .init(title: "08"), .init(title: "09"), .init(title: "10"), .init(title: "11"), .init(title: "12") ],
            [ .init(title: "AM"), .init(title: "PM") ]
        ]
    }
}
