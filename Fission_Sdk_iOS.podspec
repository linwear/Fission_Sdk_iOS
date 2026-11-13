Pod::Spec.new do |spec|
  spec.name         = 'Fission_Sdk_iOS'
  spec.version      = '3.3.6'
  spec.summary      = 'Fission智能手表SDK for iOS'
  spec.description  = 'Fission 智能手表 iOS 框架，负责与手表设备通信等功能的封装｜iOS framework for Fission smart watch communication.'
  spec.homepage     = "https://github.com/linwear/Fission_Sdk_iOS/tree/#{spec.version}"
  spec.license      = 'MIT'
  spec.author       = { 'wsr1949' => '921903719@qq.com' }
  spec.platform     = :ios, '15.0'
  spec.source       = { :git => 'https://github.com/linwear/Fission_Sdk_iOS.git', :tag => spec.version.to_s }

  spec.default_subspecs = 'Core', 'RTK', 'HS'
  spec.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

  spec.subspec 'Core' do |s|
    s.frameworks           = 'Foundation', 'CoreBluetooth'
    s.vendored_frameworks  = 'SDK/core/Fission_Sdk_iOS.framework'
    s.dependency             'Protobuf'
  end

  spec.subspec 'RTK' do |s|
    s.vendored_frameworks  = 'SDK/rtk/RTKOTASDK.xcframework',
                             'SDK/rtk/RTKLEFoundation.xcframework',
                             'SDK/rtk/RTKRealChatConnection.xcframework',
                             'SDK/rtk/RTKAudioStreaming.xcframework',
                             'SDK/rtk/libRTKCompression.xcframework'
  end

  spec.subspec 'HS' do |s|
    s.vendored_frameworks  = 'SDK/hs/SCompressLib.framework',
                             'SDK/hs/opus.framework',
                             'SDK/hs/FFmpeg/ffmpegkit.xcframework',
                             'SDK/hs/FFmpeg/libavfilter.xcframework',
                             'SDK/hs/FFmpeg/libswscale.xcframework',
                             'SDK/hs/FFmpeg/libswresample.xcframework',
                             'SDK/hs/FFmpeg/libavcodec.xcframework',
                             'SDK/hs/FFmpeg/libavutil.xcframework',
                             'SDK/hs/FFmpeg/libavformat.xcframework',
                             'SDK/hs/FFmpeg/libavdevice.xcframework',
                             'SDK/hs/slm_remote_iOS.framework'
  end
end
