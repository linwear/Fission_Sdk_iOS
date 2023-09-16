//
//  FBBluetoothManager.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/6.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

/*
 FB蓝牙管理器｜FB Bluetooth Manager
*/
@interface FBBluetoothManager : NSObject

/** SDK 版本号｜SDK version number */
+ (NSString *)sdkVersion;
 /** SDK Build版本号｜SDK Build version number */
+ (NSString *)sdkBuild;

/**
 初始化单个实例对象｜Initializes a single instance object
 */
+ (FBBluetoothManager *)sharedInstance;


/** SDK语言设置，默认跟随系统语言｜SDK language settings, following the system language by default */
@property (nonatomic, assign) FB_LANGUAGES SDK_Language;

/** MTU值，蓝牙连接成功后由设备与手机自动确认，默认初始化20｜MTU value, which is automatically confirmed by the device and mobile phone after the Bluetooth connection is successful. The default initialization value is 20  */
@property (nonatomic, assign, readonly) NSInteger FB_MTU;

/** 当前协议版本号｜Current agreement version number  */
@property (nonatomic, assign, readonly) NSInteger protocolVersion;

/** 断开是否自动重连，默认YES｜Is the disconnection automatically reconnected,Default YES  */
@property (nonatomic, assign) BOOL isAutoReconnect;

/** 连接设备初始化超时时间（单位秒），至少15，默认15｜The initialization timeout of the connected device (in seconds), at least 15, the default is 15 */
@property (nonatomic, assign) uint8_t readyTimedOut;

/** at指令、bg指令响应超时（单位秒），至少10，默认10｜at command, bg command response timeout (in seconds), at least 10, default 10 */
@property (nonatomic, assign) uint8_t sendTimerOut;

/**
 调试模式（默认YES，即输出日志记录）｜debug mode (default YES, i.e. output logging)
 
 @note 如需接收日志信息请实现监听方法 [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(logOutput:) name:FBLOGNOTIFICATIONOFOUTPUT object:nil]｜If you need to receive log information, please implement the monitoring method [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(logOutput:) name:FBLOGNOTIFICATIONOFOUTPUT object:nil]
 */
@property (nonatomic, assign) BOOL debugging;



/**
 蓝牙状态改变回调方法｜Bluetooth status change callback method
*/
- (void)fbOnCentralManagerDidUpdateStateWithBlock:(FBOnCentralManagerDidUpdateStateBlock)fbBlock;

/**
 扫描到设备回调方法｜Scan to device callback method
*/
- (void)fbDiscoverPeripheralsWithBlock:(FBDiscoverPeripheralsBlock)fbBlock;

/**
 设备连接成功/失败回调方法｜Callback method for device connection success / failure
*/
- (void)fbOnConnectedAtChannelWithBlock:(FBOnConnectedAtChannelBlock)fbBlock;

/**
 设备断开连接回调方法｜Device disconnection callback method
*/
- (void)fbOnDisconnectAtChannelWithBlock:(FBOnDisconnectAtChannelBlock)fbBlock;

/**
 蓝牙系统错误回调方法｜Bluetooth system error callback method
*/
- (void)fbBluetoothSystemErrorWithBlock:(FBBluetoothSystemErrorBlock)fbBlock;




/**
 获取蓝牙状态｜Get Bluetooth status
*/
- (CBManagerState)getFBCentralManagerDidUpdateState API_AVAILABLE(ios(10.0));

/**
 开始扫描设备｜Start scanning device
*/
- (void)scanForPeripherals;

/**
 停止扫描外设｜Stop scanning peripherals
*/
- (void)cancelScan;

/**
 连接设备｜Connecting devices
 @param peripheral                        连接的设备｜Connected devices
*/
- (void)connectToPeripheral:(CBPeripheral * _Nonnull)peripheral;

/**
 断开连接设备｜Disconnect device
*/
- (void)disconnectPeripheral;

/**
 获取当前连接的设备｜Gets the currently connected device
*/
- (CBPeripheral * _Nullable)getConnectedPeripheral;

/**
 获取当前连接设备的名称｜Gets the name of the currently connected device
*/
- (NSString * _Nullable)getConnectedDeviceName;

/**
 获取当前连接设备的 mac 地址｜Gets the MAC address of the currently connected device
*/
- (NSString * _Nullable)getConnectedDeviceMacAddress;

/**
 设备是否已连接｜Is the device connected
*/
- (BOOL)IsTheDeviceConnected;

/**
 设备是否初始化完成（初始化完成则可以进行通信交互）｜Whether the initialization of the device is completed (communication interaction can be carried out after initialization)
 */
- (BOOL)IsTheDeviceReady;

/**
 尝试重连上次连接，一般无需主动调用，SDK内部自动管理｜Try to reconnect to the last connection. Generally, there is no need to actively call it, and it is automatically managed within the SDK
*/
- (void)tryLastConnection;


/**
 🆕获取所有配置信息｜Get all configuration information
 
 @note 递交密钥绑定成功后，需发送必要指令 fbGetHardwareInformationDataWithBlock: ，成功后有值｜After submitting the key binding successfully, you need to send the necessary instruction fbGetHardwareInformationDataWithBlock:, and there is a value after success
 @see  使用方法示例：FBAllConfigObject.firmwareConfig｜Usage example: FBAllConfigObject.firmwareConfig;
 @return FBFirmwareVersionObject
*/

@end

NS_ASSUME_NONNULL_END
