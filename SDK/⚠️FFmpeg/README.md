Fission SDK 依赖 FFmpeg 处理视频相关。由于FFmpeg相关文件过多，这里不做集成导入。｜Fission SDK relies on FFmpeg for video processing. Since there are too many FFmpeg-related files, they are not integrated and imported here.

- CocoaPods自动集成Fission_Sdk_iOS，则无需任何处理，Fission_Sdk_iOS已经自动添加FFmpeg依赖，在终端执行 'pod install' 或 'pod update' 即可。｜- If CocoaPods automatically integrates Fission_Sdk_iOS, no processing is required. Fission_Sdk_iOS has automatically added FFmpeg dependencies. Just execute 'pod install' or 'pod update' in the terminal.

- 手动集成Fission_Sdk_iOS，则需要自行添加FFmpeg依赖。（https://github.com/arthenica/ffmpeg-kit.git，pod 'ffmpeg-kit-ios-full', '~> 6.0' 最低系统版本要求iOS12.1）｜If you manually integrate Fission_Sdk_iOS, you need to add FFmpeg dependencies yourself. (https://github.com/arthenica/ffmpeg-kit.git，pod 'ffmpeg-kit-ios-full', '~> 6.0' Minimum system version required: iOS 12.1)
