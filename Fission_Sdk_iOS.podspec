Pod::Spec.new do |spec|

  spec.name         = "Fission_Sdk_iOS"
  spec.version      = "3.1.6"
  spec.summary      = "Fission智能手表SDK for iOS"
  spec.description  = <<-DESC
  Fission 智能手表的 iOS 框架，负责与智能手表设备通信等功能的封装｜Framework Function: iOS framework for Fission smart watch, which is responsible for the communication with the watch.
                   DESC
  spec.homepage     = "https://github.com/linwear/Fission_Sdk_iOS/tree/#{spec.version}/Fission_Sdk_iOS"
  spec.license      = 'MIT'
  spec.author             = { "linwear" => "2435282916@qq.com" }
  spec.social_media_url   = 'https://www.linwear.com'
  spec.platform     = :ios, '10.0'
  spec.source       = { :git => "https://github.com/linwear/Fission_Sdk_iOS.git", :tag => spec.version.to_s }
  spec.documentation_url = 'https://github.com/linwear/Fission_Sdk_iOS/blob/main/README.md'
  spec.requires_arc     = true
  spec.frameworks = 'Foundation', 'CoreBluetooth'
  spec.vendored_frameworks = 'SDK/Fission_Sdk_iOS.xcframework'
  spec.dependency 'SDK/RTKOTASDK.xcframework'
  spec.dependency 'SDK/RTKLEFoundation.xcframework'

  spec.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

end