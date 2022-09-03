//
//  TrainingSettingsCellViewData.swift
//  Load
//
//  Created by Timotius Leonardo Lianoto on 03/09/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation

struct TrainingSettingsCellViewData {
    var cellTag: Int
    var btnCellTag: Int
    var txtValueTag: Int
    var delegate: TrainingSettingsDelegate?
    var height: String
    var weight: String
    var isVO2Estimated: Bool
    var hrMax: CGFloat
    var hrRest: CGFloat
    var model: [String]
    var indexPath: IndexPath
    var text: [String]
}
