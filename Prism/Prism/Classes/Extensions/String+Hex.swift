//
//  String+Hex.swift
//  Prism
//
//  Created by Göktuğ Berk Ulu on 9.09.2019.
//  Copyright © 2019 Hipo. All rights reserved.
//

import Foundation

public extension String {
    /// Checks if the string matches with hex format.
    ///
    /// - returns: A `Bool` that says whether string is in hex format.
    func isValidHexNumber() -> Bool {
        let chars = CharacterSet(charactersIn: "0123456789ABCDEF")
        
        guard uppercased().rangeOfCharacter(from: chars) != nil else {
            return false
        }
        
        if count > 6 {
            return false
        }
        
        return true
    }
}
