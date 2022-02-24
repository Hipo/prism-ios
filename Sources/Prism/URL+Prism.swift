//
//  URL+Prism.swift
//  Prism
//
//  Created by Göktuğ Berk Ulu on 9.09.2019.
//  Copyright © 2019 Hipo. All rights reserved.
//

import Foundation
import CoreGraphics

public extension URL {
    /// Creates a `URL` using the base URL and adds configurations setted below.
    ///
    /// - parameter quality: ImageQuality.
    /// - parameter expectedSize: CGSize.
    /// - parameter resizeMode: ImageResizeMode.
    /// - parameter imageType: ImageType.
    /// - parameter cropRect: CGRect.
    /// - parameter premultiplied: Bool.
    /// - parameter preservedRatio: Bool.
    /// - parameter gravity: Gravity.
    /// - parameter frameBackgroundColor: String.
    ///
    /// - returns: The created `URL` from PrismURL.
    func prismURL(
        quality: ImageQuality = .high,
        expectedSize: CGSize = .zero,
        resizeMode: ImageResizeMode = .crop,
        imageType: ImageType = .png,
        cropRect: CGRect = .zero,
        premultiplied: Bool = true,
        preservedRatio: Bool? = nil,
        gravity: Gravity? = nil,
        frameBackgroundColor: String? = nil
    ) -> URL? {
        let prismURL = PrismURL(baseURL: self)
        return prismURL
            .setImageQuality(quality)
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
