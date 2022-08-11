//
//  String+Validations.swift
//  JoeToGo
//
//  Created by Haresh on 22/03/19.
//  Copyright © 2019 haresh. All rights reserved.
//

import Foundation
import SwiftyJSON
public extension String
{
    public var length: Int { return self.count }
    
    public func toURL() -> URL? {
        return URL(string: self)
    }
    
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    func encodedURLString() -> String
    {
        let escapedString = self.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        return escapedString ?? self
    }
    func encodedNameString() -> String
    {
        
        /*
 
         String newUrl = finalUrl.replaceAll(" ", "%20");
         newUrl = newUrl.replaceAll("\\r", "");
         newUrl = newUrl.replaceAll("\\t", "");
         newUrl = newUrl.replaceAll("\\n\\n", "%20");
         newUrl = newUrl.replaceAll("\\n", "%20");
         newUrl = newUrl.replaceAll("\\|", "%7C");
         newUrl = newUrl.replaceAll("\\+", "%2B");
         
         newUrl = newUrl.replaceAll("\\#", "%23");
 
        */
        
        let allowedCharacterSet = (CharacterSet(charactersIn: "@#$*^&+= ").inverted)

        let escapedString = self.addingPercentEncoding(withAllowedCharacters:allowedCharacterSet)

        return escapedString ?? self
    }
    
    func encodeString() -> String
    {
        var str = self
        str = str.replacingOccurrences(of: " ", with: "%20")
        str = str.replacingOccurrences(of: "\\r", with: "")
        str = str.replacingOccurrences(of: "\\t", with: "")
        str = str.replacingOccurrences(of: "\\n\\n", with: "%20")
        str = str.replacingOccurrences(of: "\\n", with: "%20")
        str = str.replacingOccurrences(of: "\\|", with: "%7C")
        str = str.replacingOccurrences(of: "\\+", with: "%2B")
        str = str.replacingOccurrences(of: "\\#", with: "%23")

        return str
        
    }
    
    func isAlphaSpace() throws -> Bool {
        let regex = try NSRegularExpression(pattern: "^[A-Za-z ]*$", options: [])
        return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    func isRegistrationNumber() throws -> Bool {
        let regex = try NSRegularExpression(pattern: "^[A-Za-z0-9 ]*$", options: [])
        
        return regex.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) != nil
    }
    
    var floatValue: Float {
        return (self as NSString).floatValue
    }
    
    func separate(every stride: Int = 2, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }
    
    func withBoldText(text: String, font: UIFont? = nil) -> NSAttributedString {
        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: themeFont(size: 11, fontname: .ProximaNovaThin)])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: themeFont(size: 11, fontname: .ProximaNovaRegular)]
        
        let range = (self as NSString).range(of: text)
//
        
        fullString.addAttributes(boldFontAttribute, range: range)
        return fullString
    }

}

public extension String {
    
    
    func validateFirstName() -> Bool {
        do {
            if !(try self.isAlphaSpace()) {
                return false
            }
        } catch {
            return false
        }
        
        return true
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"

        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)

        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }

        return (self as NSString).substring(with: result.range)
    }

}


