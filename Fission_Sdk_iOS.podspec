Pod::Spec.new do |spec|

  spec.name                     = "Fission_Sdk_iOS"
  spec.version                  = "3.1.6"
  spec.summary                  = "Fission智能手表SDK for iOS"
  spec.description              = <<-DESC
                                  Fission 智能手表的 iOS 框架，负责与智能手表设备通信等功能的封装｜Framework Function: iOS framework for Fission smart watch, which is responsible for the communication with the watch.
                                  DESC
  spec.homepage                 = "https://github.com/linwear/Fission_Sdk_iOS/tree/#{spec.version}/Fission_Sdk_iOS"
  spec.license                  = 'MIT'
  spec.author                   = { "WSR" => "921903719@qq.com" }
  spec.social_media_url         = 'https://www.linwear.com'
  spec.platform                 = :ios, '10.0'
  spec.source                   = { :git => "https://github.com/linwear/Fission_Sdk_iOS.git", :tag => spec.version.to_s }
  spec.documentation_url        = 'https://github.com/linwear/Fission_Sdk_iOS/blob/main/README.md'
  spec.requires_arc             = true
  spec.frameworks               = 'Foundation', 'CoreBluetooth'
  spec.vendored_frameworks      = 'SDK/Fission_Sdk_iOS.xcframework'

  public_header_files           = 'SDK/Fission_Sdk_iOS.xcframework/ios-arm64/Fission_Sdk_iOS.framework/Headers/*.{h,m}'

  spec.subspec 'Headers' do |spec|
    spec.source_files           = public_header_files
    spec.public_header_files    = public_header_files
  end

  spec.subspec 'RTKOTASDK' do |rtkota|
    rtkota.vendored_frameworks  = 'SDK/RTKOTASDK.xcframework'
  end

  spec.subspec 'RTKLEFoundation' do |rtkle|
    rtkle.vendored_frameworks   = 'SDK/RTKLEFoundation.xcframework'
  end

  spec.pod_target_xcconfig      = { 
                                  'OTHER_LDFLAGS' => '-lObjC',
                                  }
  
end
