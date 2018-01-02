Pod::Spec.new do |s|

  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name         = "Prism-iOS"
  s.version      = "1.0.0"
  s.summary      = "URL builder iOS library for Prism image resizer."

  s.description  = <<-DESC
                    URL builder iOS library for Prism image resizer.
                   DESC

  s.homepage     = "https://github.com/Hipo/prism-ios"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Hipo" => "hello@hipolabs.com" }
  s.source       = { :git => "https://github.com/Hipo/prism-ios.git" }
  s.source_files = "Prism/Prism/Classes/**/*.{swift}"

end
