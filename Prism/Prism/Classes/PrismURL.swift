//
//  PrismURL.swift
//  prism-ios
//
//  Created by Göktuğ Berk Ulu on 21/09/2017.
//  Copyright © 2017 Hipo. All rights reserved.
//

import Foundation
import UIKit

@objc
public class PrismURL: NSObject {
    var baseURL: URL?
    
    /// Sets the quality of image. Default value is high.
    var quality = ImageQuality.high
    
    /// Sets the output size of image. Accepts CGSize with width and height as parameter. Default value of the parameter is 320x320.
    var expectedSize = CGSize.zero
    
    /// Sets the resize mode of an image. Default value is crop.
    var resizeMode = ImageResizeMode.crop
    
    /// Determines the rectange area that will be cropped according to resize mode. Receives CGRect as parameter.
    var cropRect = CGRect.zero
    
    /// Set type of output image. Options are.png and .jpg. Default value is png.
    var imageType = ImageType.png
    
    /// Determines whether ratio of the image will be preserved while resizing or not. Default value is nil.
    var isPreservingRatio: Bool?
    
    /// Configures the png image with transparent background. Default value is true.
    var isPremultiplied = true
    
    /// Decides crop focus wit options top left and center. Default value is nil.
    var gravity: Gravity?
    
    /// Receives frame background color as String in format of hex to set the image frame background color. Default value is nil.
    var frameBackgroundColor: String?
    
    // MARK: Initialization
    
    public init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    public init(url: NSURL) {
        self.baseURL = url as URL
    }
}

// MARK: API

extension PrismURL {
    /// Creates a `URL` using the base URL and checks whether it is prism url.
    /// Adds image type, expected size, resize mode, quality, crop frame, ratio preservation, premultiplied value,
    /// gravity, and background color to the url.
    ///
    /// - returns: The created `URL` from PrismURL.
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
        
        let imageTypeQueryItem = URLQueryItem(name: PrismConstants.type, value: imageType.rawValue)
        queryParameters.append(imageTypeQueryItem)
        
        if let width = scaleWidthOfOutputImage() {
            let widthQueryItem = URLQueryItem(name: PrismConstants.width, value: width)
            queryParameters.append(widthQueryItem)
        } else {
            return nil
        }
        
        if let height = scaleHeightOfOutputImage() {
            let heightQueryItem = URLQueryItem(name: PrismConstants.height, value: height)
            queryParameters.append(heightQueryItem)
        } else {
            return nil
        }
        
        if expectedSize.width == 0 && expectedSize.height == 0 {
            return nil
        }
        
        let resizeQueryItem = URLQueryItem(name: PrismConstants.resizeMode, value: resizeMode.rawValue)
        queryParameters.append(resizeQueryItem)
        
        let qualityQueryItem = URLQueryItem(name: PrismConstants.quality, value: quality.rawValue)
        queryParameters.append(qualityQueryItem)
        
        if !cropRect.isEmpty {
            let cropRectXQueryItem = URLQueryItem(name: PrismConstants.cropX, value: "\(Int(cropRect.origin.x))")
            queryParameters.append(cropRectXQueryItem)
            
            let cropRectYQueryItem = URLQueryItem(name: PrismConstants.cropY, value: "\(Int(cropRect.origin.y))")
            queryParameters.append(cropRectYQueryItem)
            
            let cropRectWidthQueryItem = URLQueryItem(name: PrismConstants.cropWidth, value: "\(Int(cropRect.size.width))")
            queryParameters.append(cropRectWidthQueryItem)
            
            let cropRectHeightQueryItem = URLQueryItem(name: PrismConstants.cropHeight, value: "\(Int(cropRect.size.height))")
            queryParameters.append(cropRectHeightQueryItem)
        }
        
        if let isPreservingRatio = isPreservingRatio {
            let isPreservingRatioQueryItem = URLQueryItem(name: PrismConstants.ratioPreservation, value: isPreservingRatio ? "1" : "0")
            queryParameters.append(isPreservingRatioQueryItem)
        }
        
        let isPremultipliedQueryItem = URLQueryItem(name: PrismConstants.premultiplied, value: isPremultiplied ? "1" : "0")
        queryParameters.append(isPremultipliedQueryItem)
        
        if let gravity = gravity {
            let gravityQueryItem = URLQueryItem(name: PrismConstants.gravity, value: gravity.rawValue)
            queryParameters.append(gravityQueryItem)
        }
        
        if let frameBackgroundColor = frameBackgroundColor {
            let frameBackgrounColorQueryItem = URLQueryItem(name: PrismConstants.backgroundColor, value: frameBackgroundColor)
            queryParameters.append(frameBackgrounColorQueryItem)
        }
        
        urlComponents?.queryItems = queryParameters
        return urlComponents?.url
    }
}

// MARK: Helpers {

extension PrismURL {
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
}

// MARK: Set Prism

extension PrismURL {
    /// Sets image quality of a PrismURL.
    ///
    /// - parameter quality: ImageQuality. quality value from ImageQuality enum.
    ///
    /// - returns: PrismURL with image quality.
    public func setImageQuality(_ quality: ImageQuality) -> PrismURL {
        self.quality = quality
        return self
    }
    
    /// Sets expected image size of a PrismURL.
    ///
    /// - parameter expectedSize: CGSize. expectedSize of the image.
    ///
    /// - returns: PrismURL with expected width and height.
    public func setExpectedImageSize(_ expectedSize: CGSize) -> PrismURL {
        self.expectedSize = expectedSize
        return self
    }
    
    /// Sets resize mode of a PrismURL.
    ///
    /// - parameter resizeMode: ImageResizeMode. resizeMode value from ImageResizeMode enum.
    ///
    /// - returns: PrismURL with resize mode.
    public func setResizeMode(_ resizeMode: ImageResizeMode) -> PrismURL {
        self.resizeMode = resizeMode
        return self
    }
    
    /// Sets crop rect value of a PrismURL.
    ///
    /// - parameter cropRect: CGRect. cropRect value of image.
    ///
    /// - returns: PrismURL with crop rect.
    public func setCropRect(_ cropRect: CGRect) -> PrismURL {
        self.cropRect = cropRect
        return self
    }
    
    /// Sets image type of a PrismURL.
    ///
    /// - parameter imageType: ImageType. imageType value from ImageType enum.
    ///
    /// - returns: PrismURL with image type.
    public func setImageType(_ imageType: ImageType) -> PrismURL {
        self.imageType = imageType
        return self
    }
    
    /// Sets preverse ratio option of a PrismURL.
    ///
    /// - parameter preservedRatio: Gravity. Optional preservedRatio value.
    ///
    /// - returns: PrismURL with preserved ratio check.
    public func setPreservedRatio(_ preservedRatio: Bool?) -> PrismURL {
        self.isPreservingRatio = preservedRatio
        return self
    }

    /// Sets premultiplied value of a PrismURL.
    ///
    /// - parameter premultiplied: Bool.
    ///
    /// - returns: PrismURL with premultiplied value.
    public func setPremultiplied(_ premultiplied: Bool) -> PrismURL {
        self.isPremultiplied = premultiplied
        return self
    }
    
    /// Sets gravity of a PrismURL.
    ///
    /// - parameter gravity: Gravity. Optional gravity value from Gravity enum.
    ///
    /// - returns: PrismURL with gravity.
    public func setGravity(_ gravity: Gravity?) -> PrismURL {
        self.gravity = gravity
        return self
    }
    
    /// Sets frame background color of a PrismURL.
    ///
    /// - parameter backgroundColor: String. Optional background color value as a hex color.
    ///
    /// - returns: PrismURL with background color.
    public func setImageFrameBackgroundColor(_ backgroundColor: String?) -> PrismURL {
        guard let frameBackgroundColor = backgroundColor else {
            return self
        }
        self.frameBackgroundColor = frameBackgroundColor.isValidHexNumber() ? frameBackgroundColor : nil
        return self
    }
}
