//
//  PrismOutputImageType.swift
//  Prism
//
//  Created by Göktuğ Berk Ulu on 9.09.2019.
//  Copyright © 2019 Hipo. All rights reserved.
//

import Foundation

/// An option that represents of an image's type as png or jpg.
@objc
public enum ImageType: Int, RawRepresentable {
    public typealias RawValue = String
    
    /// A png, storing `png` as value.
    case png
    
    /// A jpg, storing `jpg` as value.
    case jpg
    
    public var rawValue: RawValue {
        switch self {
        case .png:
            return "png"
        case .jpg:
            return "jpg"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "jpg":
            self = .jpg
        case "png":
            self = .png
        default:
            self = .jpg
        }
    }
}
