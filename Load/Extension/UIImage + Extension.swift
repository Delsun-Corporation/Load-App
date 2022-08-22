//
//  UIImage + Extension.swift
//  Load
//
//  Created by Timotius Leonardo Lianoto on 22/08/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func convertToBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
}
