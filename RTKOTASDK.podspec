Pod::Spec.new do |spec|

  spec.name         = "RTKOTASDK"
  spec.version      = "1.5.0"
  spec.summary      = "原厂瑞昱SDK for iOS"
  spec.description  = <<-DESC
  原厂瑞昱SDK，负责OTA等功能的封装｜Original Realtek SDK, responsible for packaging of OTA and other functions
                   DESC
  spec.homepage     = "https://github.com/linwear/Fission_Sdk_iOS/tree/rtkota_v#{spec.version}/RTKOTASDK"
  spec.license      = 'MIT'
  spec.author             = { "linwear" => "2435282916@qq.com" }
  spec.social_media_url   = 'https://www.linwear.com'
  spec.platform     = :ios, '10.0'
  spec.source       = { :git => "https://github.com/linwear/Fission_Sdk_iOS.git", :tag => 'rtkota_v' + spec.version.to_s }
  spec.documentation_url = 'https://github.com/linwear/Fission_Sdk_iOS/blob/main/README.md'
  spec.requires_arc     = true
  spec.frameworks = 'Foundation', 'CoreBluetooth'
  spec.vendored_frameworks = 'SDK/RTKOTASDK.xcframework'

  spec.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

end
