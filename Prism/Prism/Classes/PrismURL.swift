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

struct PrismURL {
    
    private struct Constants {
        static let prismBase: String = "tryprism"
        static let queryOutputType: String = "out"
        static let imageOutputTypePNG: String = "png"
        static let imageOutputTypeJPG: String = "jpg"
        static let queryWidth: String = "w"
        static let queryHeight: String = "h"
        static let queryResize: String = "cmd"
        static let queryQuality: String = "quality"
        static let imageResize: String = "resize"
        static let imageResizeCrop: String = "resize_then_crop"
        static let imageResizeFit: String = "resize_then_fit"
        static let queryPremultiplied: String = "premultiplied"
        static let queryRetina: String = "retina"
        static let queryGravity: String = "gravity"
        static let queryCropRectX: String = "crop_x"
        static let queryCropRectY: String = "crop_y"
        static let queryCropRectWidth: String = "crop_width"
        static let queryCropRectHeight: String = "crop_height"
        static let queryPreserveRatio: String = "preserve_ratio"
        static let imageGravityTopLeft: String = "top_left"
        static let imageGravityCenter: String = "center"
        static let queryFrameBackgroundColor: String = "frame_bg_color"
    }
    
    var baseURL: URL? = nil
    var quality: PrismOutputImageQuality = PrismOutputImageQuality.none
    var expectedHeight: CGFloat = CGFloat.leastNormalMagnitude
    var expectedWidth: CGFloat = CGFloat.leastNormalMagnitude
    var resizeMode: PrismOutputImageResizeMode = PrismOutputImageResizeMode.none
    var cropRect: CGRect = CGRect.zero
    var imageType: PrismOutputImageType = PrismOutputImageType.none
    var isPreservingRatio: Bool? = nil
    var isPremultiplied: Bool? = nil
    var gravity: PrismOutputGravity = .none
    var frameBackgroundColor: String? = nil
    var isRetina: Bool? = nil
    var shouldResizeThenCrop: Bool? = nil
    var shouldResizeThenFit: Bool? = nil
    
    mutating func build() -> URL? {
        guard let prismBaseURL = baseURL,
            let host = prismBaseURL.host else {
                return nil
        }
        
        if !host.contains(Constants.prismBase) {
            return prismBaseURL
        }
        
        if let query = prismBaseURL.query, query != "" {
            return prismBaseURL
        }
        
        var urlComponents = URLComponents(url: prismBaseURL, resolvingAgainstBaseURL: false)
        var queryParameters = [URLQueryItem]()
        
        if imageType != .none {
            let imageTypeQueryItem = URLQueryItem(name: Constants.queryOutputType, value: setPrismOutputImageType())
            queryParameters.append(imageTypeQueryItem)
        }
        
        let widthQueryItem = URLQueryItem(name: Constants.queryWidth, value: setWidthOfOutputImage())
        queryParameters.append(widthQueryItem)
        
        let heightQueryItem = URLQueryItem(name: Constants.queryHeight, value: setHeightOfOutputImage())
        queryParameters.append(heightQueryItem)
        
        switch resizeMode {
        case .none:
            break
        case .resize:
            let resizeQueryItem = URLQueryItem(name: Constants.queryResize, value: setPrismOutputImageResizeMode())
            queryParameters.append(resizeQueryItem)
            if let shouldResizeThenFit = shouldResizeThenFit {
                let resizeThenFitQueryItem = URLQueryItem(name: Constants.imageResizeFit,
                                                          value: shouldResizeThenFit ? "1" : "0")
                queryParameters.append(resizeThenFitQueryItem)
            } else if let shouldResizeThenCrop = shouldResizeThenCrop {
                let resizeThenCropQueryItem = URLQueryItem(name: Constants.imageResizeCrop,
                                                           value: shouldResizeThenCrop ? "1" : "0")
                queryParameters.append(resizeThenCropQueryItem)
            }
        default:
            let resizeQueryItem = URLQueryItem(name: Constants.queryResize, value: setPrismOutputImageResizeMode())
            queryParameters.append(resizeQueryItem)
        }
        
        switch quality {
        case .none:
            break
        default:
            let qualityQueryItem = URLQueryItem(name: Constants.queryQuality, value: setPrismOutputImageQuality())
            queryParameters.append(qualityQueryItem)
        }
        
        if (!cropRect.isEmpty) {
            let cropRectXQueryItem = URLQueryItem(name: Constants.queryCropRectX, value: "\(Int(cropRect.origin.x))")
            queryParameters.append(cropRectXQueryItem)
            
            let cropRectYQueryItem = URLQueryItem(name: Constants.queryCropRectY, value: "\(Int(cropRect.origin.y))")
            queryParameters.append(cropRectYQueryItem)
            
            let cropRectWidthQueryItem = URLQueryItem(name: Constants.queryCropRectWidth, value: "\(Int(cropRect.size.width))")
            queryParameters.append(cropRectWidthQueryItem)
            
            let cropRectHeightQueryItem = URLQueryItem(name: Constants.queryCropRectHeight,
                                                       value: "\(Int(cropRect.size.height))")
            queryParameters.append(cropRectHeightQueryItem)
        }
        
        if let isPreservingRatio = isPreservingRatio {
            let isPreservingRatioQueryItem = URLQueryItem(name: Constants.queryPreserveRatio,
                                                          value: isPreservingRatio ? "1" : "0")
            queryParameters.append(isPreservingRatioQueryItem)
        }
        
        if let isPremultiplied = isPremultiplied {
            let isPremultipliedQueryItem = URLQueryItem(name: Constants.queryPremultiplied,
                                                        value: isPremultiplied ? "1" : "0")
            queryParameters.append(isPremultipliedQueryItem)
        }
        
        switch gravity {
        case .none:
            break
        default:
            let gravityQueryItem = URLQueryItem(name: Constants.queryGravity, value: setPrismOutputGravity())
            queryParameters.append(gravityQueryItem)
        }
        
        if let frameBackgroundColor = frameBackgroundColor {
            let frameBackgrounColorQueryItem = URLQueryItem(name: Constants.queryFrameBackgroundColor,
                                                            value: frameBackgroundColor)
            queryParameters.append(frameBackgrounColorQueryItem)
        }
        
        if let isRetina = isRetina {
            let isRetinaQueryItem = URLQueryItem(name: Constants.queryRetina, value: isRetina ? "1" : "0")
            queryParameters.append(isRetinaQueryItem)
        }
        
        urlComponents?.queryItems = queryParameters
        return urlComponents?.url
    }
    
    private mutating func setWidthOfOutputImage() -> String {
        let screenScale = UIScreen.main.scale
        
        if (expectedWidth == .leastNormalMagnitude) {
            expectedWidth = 320.0
        } else {
            expectedWidth = screenScale * expectedWidth
        }
        
        let stringValueOfWidth = "\(Int(expectedWidth))"
        return stringValueOfWidth
    }
    
    private mutating func setHeightOfOutputImage() -> String {
        let screenScale = UIScreen.main.scale
        
        if (expectedHeight == .leastNormalMagnitude) {
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
            return Constants.imageGravityCenter
        case .topLeft:
            return Constants.imageGravityTopLeft
        default:
            return nil
        }
    }
    
    private func setPrismOutputImageType() -> String? {
        switch imageType {
        case .jpg:
            return Constants.imageOutputTypeJPG
        case .png:
            return Constants.imageOutputTypePNG
        default:
            return nil
        }
    }
    
    private func setPrismOutputImageResizeMode() -> String? {
        switch resizeMode {
        case .resize:
            return Constants.imageResize
        case .crop:
            return Constants.imageResizeCrop
        case .fit:
            return Constants.imageResizeFit
        default:
            return nil
        }
    }
}

public extension URL {
    
    static func prismURL(baseURL: URL,
                         quality: PrismOutputImageQuality = .none,
                         expectedWidth: CGFloat = .leastNormalMagnitude,
                         expectedHeight: CGFloat = .leastNormalMagnitude,
                         resizeMode: PrismOutputImageResizeMode = .fit,
                         cropRect: CGRect = .zero,
                         imageType: PrismOutputImageType = .none,
                         isPreservingRatio: Bool? = nil,
                         isPremultiplied: Bool? = nil,
                         gravity: PrismOutputGravity = .none,
                         frameBackgroundColor: String? = nil,
                         isRetina: Bool? = nil,
                         shouldResizeThenFit: Bool? = nil,
                         shouldResizeThenCrop: Bool? = nil) -> URL? {
        var prismURL = PrismURL()
        prismURL.baseURL = baseURL
        prismURL.quality = quality
        prismURL.expectedWidth = expectedWidth
        prismURL.expectedHeight = expectedHeight
        prismURL.resizeMode = resizeMode
        prismURL.cropRect = cropRect
        prismURL.imageType = imageType
        prismURL.isPreservingRatio = isPreservingRatio
        prismURL.isPremultiplied = isPremultiplied
        prismURL.gravity = gravity
        prismURL.frameBackgroundColor = frameBackgroundColor
        prismURL.isRetina = isRetina
        prismURL.shouldResizeThenFit = shouldResizeThenFit
        prismURL.shouldResizeThenCrop = shouldResizeThenCrop
        
        return prismURL.build()
    }
}
