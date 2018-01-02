//
//  PrismURL.swift
//  prism-ios
//
//  Created by Göktuğ Berk Ulu on 21/09/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import Foundation
import UIKit

@objc public enum PrismOutputImageQuality: Int, RawRepresentable {
    public typealias RawValue = String
    
    case high
    case normal
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

@objc public enum PrismOutputImageType: Int, RawRepresentable {
    public typealias RawValue = String
    
    case png
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

@objc public enum PrismOutputImageResizeMode: Int, RawRepresentable {
    public typealias RawValue = String
    
    case resize
    case fit
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

@objc public enum PrismOutputGravity: Int, RawRepresentable {
    public typealias RawValue = String
    
    case topLeft
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

@objc public class PrismURL: NSObject {
    
    var baseURL: URL?
    var quality = PrismOutputImageQuality.normal
    var expectedSize = CGSize.zero
    var resizeMode: PrismOutputImageResizeMode?
    var cropRect: CGRect?
    var imageType: PrismOutputImageType?
    var isPreservingRatio: Bool?
    var isPremultiplied: Bool?
    var gravity: PrismOutputGravity?
    var frameBackgroundColor: String?
    
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public init(url: NSURL) {
        
        self.baseURL = url as URL
    }
    
    public func build() -> URL? {
        guard let url = baseURL,
            let host = url.host else {
                return nil
        }
        
        if !host.contains("tryprism") {
            return url
        }
        
        if let query = url.query, !query.isEmpty {
            return url
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryParameters = [URLQueryItem]()
        
        if let imageType = imageType {
            let imageTypeQueryItem = URLQueryItem(name: "out", value: imageType.rawValue)
            queryParameters.append(imageTypeQueryItem)
        }
        
        if let width = scaleWidthOfOutputImage() {
            let widthQueryItem = URLQueryItem(name: "w", value: width)
            queryParameters.append(widthQueryItem)
        } else {
            return nil
        }
        
        if let height = scaleHeightOfOutputImage() {
            let heightQueryItem = URLQueryItem(name: "h", value: height)
            queryParameters.append(heightQueryItem)
        } else {
            return nil
        }
        
        if expectedSize.width == 0 && expectedSize.height == 0 {
            return nil
        }
        
        if let resizeMode = resizeMode {
            let resizeQueryItem = URLQueryItem(name: "cmd", value: resizeMode.rawValue)
            queryParameters.append(resizeQueryItem)
        }
        
        let qualityQueryItem = URLQueryItem(name: "quality", value: quality.rawValue)
        queryParameters.append(qualityQueryItem)
        
        if let cropRect = cropRect, !cropRect.isEmpty {
            let cropRectXQueryItem = URLQueryItem(name: "crop_x", value: "\(Int(cropRect.origin.x))")
            queryParameters.append(cropRectXQueryItem)
            
            let cropRectYQueryItem = URLQueryItem(name: "crop_y", value: "\(Int(cropRect.origin.y))")
            queryParameters.append(cropRectYQueryItem)
            
            let cropRectWidthQueryItem = URLQueryItem(name: "crop_width", value: "\(Int(cropRect.size.width))")
            queryParameters.append(cropRectWidthQueryItem)
            
            let cropRectHeightQueryItem = URLQueryItem(name: "crop_height", value: "\(Int(cropRect.size.height))")
            queryParameters.append(cropRectHeightQueryItem)
        }
        
        if let isPreservingRatio = isPreservingRatio {
            let isPreservingRatioQueryItem = URLQueryItem(name: "preserve_ratio", value: isPreservingRatio ? "1" : "0")
            queryParameters.append(isPreservingRatioQueryItem)
        }
        
        if let isPremultiplied = isPremultiplied {
            let isPremultipliedQueryItem = URLQueryItem(name: "premultiplied", value: isPremultiplied ? "1" : "0")
            queryParameters.append(isPremultipliedQueryItem)
        }
        
        
        if let gravity = gravity {
            let gravityQueryItem = URLQueryItem(name: "gravity", value: gravity.rawValue)
            queryParameters.append(gravityQueryItem)
        }
        
        if let frameBackgroundColor = frameBackgroundColor {
            let frameBackgrounColorQueryItem = URLQueryItem(name: "frame_bg_color", value: frameBackgroundColor)
            queryParameters.append(frameBackgrounColorQueryItem)
        }
        
        urlComponents?.queryItems = queryParameters
        return urlComponents?.url
    }
    
    private func scaleWidthOfOutputImage() -> String? {
        let screenScale = UIScreen.main.scale
        
        if (expectedSize.width == 0.0) {
            expectedSize.width = 320.0
        } else {
            expectedSize.width = screenScale * expectedSize.width
        }
        
        if expectedSize.width < 0 {
            return nil
        }
        
        let stringValueOfWidth = "\(Int(expectedSize.width))"
        return stringValueOfWidth
    }
    
    private func scaleHeightOfOutputImage() -> String? {
        let screenScale = UIScreen.main.scale
        
        if (expectedSize.height == 0.0) {
            expectedSize.height = 320.0
        } else {
            expectedSize.height = screenScale * expectedSize.height
        }
        
        if expectedSize.height < 0 {
            return nil
        }
        
        let stringValueOfHeight = "\(Int(expectedSize.height))"
        return stringValueOfHeight
    }
    
    public func setImageQuality(_ quality: PrismOutputImageQuality) -> PrismURL {
        self.quality = quality
        return self
    }
    
    public func setExpectedImageSize(_ expectedSize: CGSize) -> PrismURL {
        self.expectedSize = expectedSize
        return self
    }
    
    public func setResizeMode(_ resizeMode: PrismOutputImageResizeMode?) -> PrismURL {
        self.resizeMode = resizeMode
        return self
    }
    
    public func setCropRect(_ cropRect: CGRect?) -> PrismURL {
        self.cropRect = cropRect
        return self
    }
    
    public func setImageType(_ imageType: PrismOutputImageType?) -> PrismURL {
        self.imageType = imageType
        return self
    }
    
    public func setPreservedRatio(_ preservedRatio: Bool?) -> PrismURL {
        self.isPreservingRatio = preservedRatio
        return self
    }

    public func setPremultiplied(_ premultiplied: Bool?) -> PrismURL {
        self.isPremultiplied = premultiplied
        return self
    }
    
    public func setGravity(_ gravity: PrismOutputGravity?) -> PrismURL {
        self.gravity = gravity
        return self
    }
    
    public func setImageFrameBackgroundColor(_ backgroundColor: String?) -> PrismURL {
        guard let frameBackgroundColor = backgroundColor else {
            return self
        }
        self.frameBackgroundColor = frameBackgroundColor.isValidHexNumber() ? frameBackgroundColor : nil
        return self
    }
    
}

public extension URL {
    
    func prismURL(quality: PrismOutputImageQuality = .normal,
                  expectedSize: CGSize = .zero,
                  resizeMode: PrismOutputImageResizeMode? = nil,
                  cropRect: CGRect? = nil,
                  imageType: PrismOutputImageType? = nil,
                  preservedRatio: Bool? = nil,
                  premultiplied: Bool? = nil,
                  gravity: PrismOutputGravity? = nil,
                  frameBackgroundColor: String? = nil) -> URL? {
        let prismURL = PrismURL(baseURL: self)
        return prismURL.setImageQuality(quality)
            .setExpectedImageSize(expectedSize)
            .setResizeMode(resizeMode)
            .setCropRect(cropRect)
            .setImageType(imageType)
            .setPreservedRatio(preservedRatio)
            .setPremultiplied(premultiplied)
            .setGravity(gravity)
            .setImageFrameBackgroundColor(frameBackgroundColor)
            .build()
    }
}

fileprivate extension String {
    
    fileprivate func isValidHexNumber() -> Bool {
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
