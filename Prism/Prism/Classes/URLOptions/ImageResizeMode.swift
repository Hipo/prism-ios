//
//  PrismOutputImageResizeMode.swift
//  Prism
//
//  Created by Göktuğ Berk Ulu on 9.09.2019.
//  Copyright © 2019 Hipo. All rights reserved.
//

import Foundation

/// An option that represents of an image's resize modes as resize, fit or crop.
@objc
public enum ImageResizeMode: Int, RawRepresentable {
    public typealias RawValue = String
    
    /// A resize, storing `resize` as value.
    case resize
    
    /// A fit, storing `resize_then_fit` as value.
    case fit
    
    /// A crop, storing `resize_then_crop` as value.
    case crop
    
    public var rawValue: RawValue {
        switch self {
        case .resize:
            return "resize"
        case .fit:
            return "resize_then_fit"
        case .crop:
            return "resize_then_crop"
        }
    }
    
    public init?(rawValue: RawValue) {
        switch rawValue {
        case "resize":
            self = .resize
        case "resize_then_fit":
            self = .fit
        case "resize_then_crop":
            self = .crop
        default:
            self = .resize
        }
    }
}
