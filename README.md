# Prism
Prism image resizer iOS library that builds prism image resizer URLs.

There are two ways to set a Prism URL. First one is by using prismURL function of URL extension. Second option is that using
the PrismURL object and its build method with parameter setters. 

The base URL that will be converted to Prism URL. If base url is nil, the method will return nil. If base url does not
contain “tryprism” or contains other queries, the method will return the base url withoud adding Prism queries. 

### URL Extension Decleration
```swift
func prismURL(quality: ImageQuality = .high,
              expectedSize: CGSize = .zero,
              resizeMode: ImageResizeMode = .crop,
              imageType: ImageType = .png,
              cropRect: CGRect = .zero,
              premultiplied: Bool = true,
              preservedRatio: Bool? = nil,
              gravity: Gravity? = nil,
              frameBackgroundColor: String? = nil
) -> URL? {
```

This method can be called through an URL instance.

### PrismURL Object Decleration
```swift
init (baseURL: URL)
```

```swift
public func setQuality(_ quality: PrismOutputImageQuality) -> PrismURL
public func setExpectedSize(_ expectedSize: CGSize) -> PrismURL
public func setResizeMode(_ resizeMode: PrismOutputImageResizeMode) -> PrismURL
public func setCropRect(_ cropRect: CGRect) -> PrismURL
public func setImageType(_ imageType: PrismOutputImageType) -> PrismURL
public func setPreservedRatio(_ preservedRatio: Bool?) -> PrismURL
public func setPremultiplied(_ premultiplied: Bool) -> PrismURL
public func setGravity(_ gravity: PrismOutputGravity) -> PrismURL
public func setFrameBackgroundColor(_ backgroundColor: String?) -> PrismURL
```

After the initialization of PrismURL, parameters can be added with setters.

### Parameters
          
#### quality
  Sets the quality of image. There are 4 different options. First option is high - 100. Second option is normal - 70. Third
option is low - 50. Last option is custom with the value user enter. Default value is none, which will return as 95 from
Prism.

#### expectedSize
  Set the output size of image. Accepts CGSize with width and height as parameter. Default value of the parameter is 320x320.

#### resizeMode
  There are four options to set resize mode of prism url. First option is resize that resizes the image. Second option is
fit that resizes the image and fits to the frame. Third option is crop that resizes the image and crops to the given rect.
Default value is none.

![resize](https://user-images.githubusercontent.com/9153482/30753662-9eec7a94-9fc8-11e7-930b-13a4d01c72e0.jpg)

Resized image with size 100x100

![resize_then_fit](https://user-images.githubusercontent.com/9153482/30753676-b2986a9e-9fc8-11e7-993d-aafc0089fb61.png)

Fit image with size 100x100

![resize_then_crop](https://user-images.githubusercontent.com/9153482/30753694-c345b55e-9fc8-11e7-9d50-1d3f4d445b4a.jpg)

Crop image with size 100x100

#### cropRect
  Determines the rectange area that will be cropped according to resize mode. Receives CGRect as parameter.

#### imageType
  Set type of output image. Options are.png and .jpg. Default value is none.

#### preservedRatio
  Determines whether ratio of the image will be preserved while resizing or not. Default value is nil.

#### premultiplied
  Configures the png image with transparent background. Default value is nil.

#### gravity
  Decides crop focus wit options top left and center. Default value is none.

#### frameBackgroundColor
  Receives frame background color as String in format of hex to set the image frame background color. Default value is nil.

### Return Value
  Returns an optional URL that contains parameters for Prism.

### Example

```swift
let url: URL = URL(string: "https://famelog-staging.tryprism.com/media/profiles/avatars/2017/09/12/7b413b9c-36c.jpg")!
```

##### Custom Quality
```swift
// Extension
let customQualityTest: URL = url.prismURL(quality: .custom(quality: 35))!
print("Custom Quality URL Test: \(customQualityTest)")
```

```swift
// Object Set
let customQualityTest: URL = Prism(baseURL: url).setQuality(.custom(quality: 35)).build()!
print("Custom Quality URL Test: \(customQualityTest)")
```

##### Low Quality
```swift
// Extension
let lowQualityTest: URL = url.prismURL(quality: .low)!
print("Low Quality URL Test: \(lowQualityTest)")
```

```swift
// Object Set
let lowQualityTest: URL = Prism(baseURL: url).setQuality(.low).build()!
print("Low Quality URL Test: \(lowQualityTest)")
```

##### Quality With Size
```swift    
// Extension
let qualityWithSizeTest: URL = url.prismURL(quality: .none, expectedSize: CGSize(width: 30, height: 30))!
print("Size URL Test: \(qualityWithSizeTest)")
```

```swift  
// Object Set
let qualityWithSizeTest: URL = Prism(baseURL: url).setQuality(.none).setExpectedSize(CGSize(width: 30, height: 30)).build()!
print("Size URL Test: \(qualityWithSizeTest)")
```

##### Command Fit With Size
```swift    
// Extension
let commandFitTest: URL = url.prismURL(quality: .none, expectedSize: CGSize(width: 150, height: 180), 
                                      resizeMode: .fit)!
print("Command Fit URL Test: \(commandFitTest)")
```

```swift   
// Object Set
let commandFitTest: URL = Prism(baseURL: url)
                            .setQuality(.none)
                            .setExpectedSize(CGSize(width: 150, height: 180))
                            .setResizeMode(.fit).build()!
print("Command Fit URL Test: \(commandFitTest)")
```

##### Output Png
```swift    
// Extension
let outputTest: URL = url.prismURL(quality: .none, expectedSize: CGSize(width: 40, height: 40), imageType: .png)!
print("Output URL Test: \(outputTest)")
```

```swift  
// Object Set
let outputTest: URL = Prism(baseURL: url)
                        .setQuality(.none)
                        .setExpectedSize(CGSize(width: 40, height: 40))
                        .setImageType(.png).build()!
print("Output URL Test: \(outputTest)")
```
