Pod::Spec.new do |s|

  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.name         = "Prism-iOS"
  s.version      = "0.0.1"
  s.summary      = "Prism image resizer iOS library."

  s.description  = <<-DESC
                    Prism image resizer iOS library.
                   DESC

  s.homepage     = "https://github.com/Hipo/prism-ios"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "goktugberkulu" => "goktugberkulu@gmail.com" }
  s.source       = { :git => "https://github.com/Hipo/prism-ios.git" }
  s.source_files = "Prism/Prism/Classes/**/*.{swift}"

end
