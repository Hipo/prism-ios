//
//  Gravity.swift
//  Prism
//
//  Created by Göktuğ Berk Ulu on 9.09.2019.
//  Copyright © 2019 Hipo. All rights reserved.
//

import Foundation

/// An option that represents of an image's gravity modes as top left or center.
@objc
public enum Gravity: Int, RawRepresentable {
    public typealias RawValue = String
    
    /// A topLeft, storing `top_left` as value.
    case topLeft
    
    /// A center, storing `center` as value.
    case center
    
    public var rawValue: RawValue {
        switch self {
        case .topLeft:
            return "top_left"
        case .center:
            return "center"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "top_left":
            self = .topLeft
        case "center":
            self = .center
        default:
            self = .center
        }
    }
}
