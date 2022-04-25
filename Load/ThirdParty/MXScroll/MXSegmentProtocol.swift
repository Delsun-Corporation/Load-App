//
//  MXSegmentProtocol.swift
//  Load
//
//  Created by Timotius Leonardo Lianoto on 24/04/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation

@objc public protocol MXSegmentProtocol {
    typealias didIndexChange = (Int)->Void
    //self change to tell other
    var change:didIndexChange{get set}
    // other change to tell self
    func setSelected(index: Int, animator: Bool)
}
