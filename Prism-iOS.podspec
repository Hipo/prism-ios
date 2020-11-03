Pod::Spec.new do |s|
  s.name                  = "Prism-iOS"
  s.version               = "1.0.1"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.homepage              = "https://github.com/Hipo/prism-ios"
  s.summary               = "Prism URL Builder"
  s.source                = { :git => 'https://github.com/Hipo/prism-ios.git', :tag => s.version.to_s }
  s.author                = { "Hipo" => "hello@hipolabs.com" }
  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = '10.15'
  s.swift_version         = '5.0'
  s.source_files          = "Prism/Prism/Classes/**/*.{swift}"
end
