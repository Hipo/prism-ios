//
//  PrismURL.swift
//  prism-ios
//
//  Created by Göktuğ Berk Ulu on 21/09/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import Foundation
import UIKit

public enum PrismOutputImageQuality {
    case high
    case normal
    case low
    case custom(quality: Int)
    case none
}

public enum PrismOutputImageType {
    case png
    case jpg
    case none
}

public enum PrismOutputImageResizeMode {
    case resize
    case fit
    case crop
    case none
}

public enum PrismOutputGravity {
    case topLeft
    case center
    case none
}

public class PrismURL {
    
    var baseURL: URL? = nil
    var quality: PrismOutputImageQuality = PrismOutputImageQuality.none
    var expectedHeight: CGFloat = 0.0
    var expectedWidth: CGFloat = 0.0
    var resizeMode: PrismOutputImageResizeMode = PrismOutputImageResizeMode.none
    var cropRect: CGRect = CGRect.zero
    var imageType: PrismOutputImageType = PrismOutputImageType.none
    var isPreservingRatio: Bool? = nil
    var isPremultiplied: Bool? = nil
    var gravity: PrismOutputGravity = .none
    var frameBackgroundColor: String? = nil
    var isRetina: Bool? = true
    
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public func build() -> URL? {
        guard let url = baseURL,
            let host = url.host else {
                return nil
        }
        
        if !host.contains("tryprism") {
            return url
        }
        
        if let query = url.query, query != "" {
            return url
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        var queryParameters = [URLQueryItem]()
        
        if imageType != .none {
            let imageTypeQueryItem = URLQueryItem(name: "out", value: setPrismOutputImageType())
            queryParameters.append(imageTypeQueryItem)
        }
        
        let widthQueryItem = URLQueryItem(name: "w", value: setWidthOfOutputImage())
        queryParameters.append(widthQueryItem)
        
        let heightQueryItem = URLQueryItem(name: "h", value: setHeightOfOutputImage())
        queryParameters.append(heightQueryItem)
        
        switch resizeMode {
        case .none:
            break
        default:
            let resizeQueryItem = URLQueryItem(name: "cmd", value: setPrismOutputImageResizeMode())
            queryParameters.append(resizeQueryItem)
        }
        
        switch quality {
        case .none:
            break
        default:
            let qualityQueryItem = URLQueryItem(name: "quality", value: setPrismOutputImageQuality())
            queryParameters.append(qualityQueryItem)
        }
        
        if (!cropRect.isEmpty) {
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
        
        switch gravity {
        case .none:
            break
        default:
            let gravityQueryItem = URLQueryItem(name: "gravity", value: setPrismOutputGravity())
            queryParameters.append(gravityQueryItem)
        }
        
        if let frameBackgroundColor = frameBackgroundColor {
            let frameBackgrounColorQueryItem = URLQueryItem(name: "frame_bg_color", value: frameBackgroundColor)
            queryParameters.append(frameBackgrounColorQueryItem)
        }
        
        if let isRetina = isRetina {
            let isRetinaQueryItem = URLQueryItem(name: "retina", value: isRetina ? "1" : "0")
            queryParameters.append(isRetinaQueryItem)
        }
        
        urlComponents?.queryItems = queryParameters
        return urlComponents?.url
    }
    
    private func setWidthOfOutputImage() -> String {
        let screenScale = UIScreen.main.scale
        
        if (expectedWidth == 0.0) {
            expectedWidth = 320.0
        } else {
            expectedWidth = screenScale * expectedWidth
        }
        
        let stringValueOfWidth = "\(Int(expectedWidth))"
        return stringValueOfWidth
    }
    
    private func setHeightOfOutputImage() -> String {
        let screenScale = UIScreen.main.scale
        
        if (expectedHeight == 0.0) {
            expectedHeight = 320.0
        } else {
            expectedHeight = screenScale * expectedHeight
        }
        
        let stringValueOfHeight = "\(Int(expectedHeight))"
        return stringValueOfHeight
    }
    
    private func setPrismOutputImageQuality() -> String? {
        switch quality {
        case .custom(let quality):
            return "\(quality)"
        case .high:
            return "100"
        case .normal:
            return "70"
        case .low:
            return "50"
        default:
            return nil
        }
    }
    
    private func setPrismOutputGravity() -> String? {
        switch gravity {
        case .center:
            return "center"
        case .topLeft:
            return "top_left"
        default:
            return nil
        }
    }
    
    private func setPrismOutputImageType() -> String? {
        switch imageType {
        case .jpg:
            return "jpg"
        case .png:
            return "png"
        default:
            return nil
        }
    }
    
    private func setPrismOutputImageResizeMode() -> String? {
        switch resizeMode {
        case .resize:
            return "resize"
        case .crop:
            return "resize_then_crop"
        case .fit:
            return "resize_then_fit"
        default:
            return nil
        }
    }
    
    public func setQuality(_ quality: PrismOutputImageQuality) -> PrismURL {
        self.quality = quality
        return self
    }
    
    public func setExpectedSize(_ expectedSize: CGSize) -> PrismURL {
        self.expectedWidth = expectedSize.width
        self.expectedHeight = expectedSize.height
        return self
    }
    
    public func setResizeMode(_ resizeMode: PrismOutputImageResizeMode) -> PrismURL {
        self.resizeMode = resizeMode
        return self
    }
    
    public func setCropRect(_ cropRect: CGRect) -> PrismURL {
        self.cropRect = cropRect
        return self
    }
    
    public func setImageType(_ imageType: PrismOutputImageType) -> PrismURL {
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
    
    public func setGravity(_ gravity: PrismOutputGravity) -> PrismURL {
        self.gravity = gravity
        return self
    }
    
    public func setFrameBackgroundColor(_ backgroundColor: String?) -> PrismURL {
        guard let frameBackgroundColor = backgroundColor else {
            return self
        }
        self.frameBackgroundColor = frameBackgroundColor.isValidHexNumber() ? frameBackgroundColor : nil
        return self
    }
    
}


public extension URL {
    
    func prismURL(quality: PrismOutputImageQuality = .none,
                  expectedSize: CGSize = CGSize.zero,
                  resizeMode: PrismOutputImageResizeMode = .none,
                  cropRect: CGRect = .zero,
                  imageType: PrismOutputImageType = .none,
                  preservedRatio: Bool? = nil,
                  premultiplied: Bool? = nil,
                  gravity: PrismOutputGravity = .none,
                  frameBackgroundColor: String? = nil) -> URL? {
        let prismURL = PrismURL(baseURL: self)
        return prismURL.setQuality(quality)
            .setExpectedSize(expectedSize)
            .setResizeMode(resizeMode)
            .setCropRect(cropRect)
            .setImageType(imageType)
            .setPreservedRatio(preservedRatio)
            .setPremultiplied(premultiplied)
            .setGravity(gravity)
            .setFrameBackgroundColor(frameBackgroundColor)
            .build()
    }
}

fileprivate extension String {
    
    fileprivate func isValidHexNumber() -> Bool {
        let chars = CharacterSet(charactersIn: "0123456789ABCDEF")
        
        guard uppercased().rangeOfCharacter(from: chars) != nil else {
            return false
        }
        return true
    }
}
