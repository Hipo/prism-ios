//
//  PrismOutputImageQuality.swift
//  Prism
//
//  Created by Göktuğ Berk Ulu on 9.09.2019.
//  Copyright © 2019 Hipo. All rights reserved.
//

import Foundation

/// An option that represents of an image's quality as high, normal or low.
@objc
public enum ImageQuality: Int, RawRepresentable {
    public typealias RawValue = String
    
    /// A high, storing `100` as value.
    case high
    
    /// A normal, storing `70` as value.
    case normal
    
    /// A low, storing `50` as value.
    case low
    
    public var rawValue: RawValue {
        switch self {
        case .high:
            return "100"
        case .normal:
            return "70"
        case .low:
            return "50"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "100":
            self = .high
        case "70":
            self = .normal
        case "50":
            self = .low
        default:
            self = .normal
        }
    }
}
