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
    func convertToBase64(compression: JPEGQuality = .medium) -> String? {
        guard let imageData = self.jpeg(compression) else { return nil }
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
}
