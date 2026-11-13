//
//  FBBluetoothManager.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/6.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

/**
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

/** 连接设备、初始化超时时间（单位秒），至少90，默认90｜The timeout for connecting to the device and initializing it (in seconds) is at least 90 seconds, and the default value is 90 seconds. */
@property (nonatomic, assign) uint8_t connect_readyTimedOut;

/** at指令、bg指令响应超时（单位秒），至少10，默认10｜at command, bg command response timeout (in seconds), at least 10, default 10 */
@property (nonatomic, assign) uint8_t sendTimerOut;

/**
 调试模式（默认YES，即输出日志记录）｜debug mode (default YES, i.e. output logging)
 
 @note 如需接收日志信息请实现监听方法 [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(logOutput:) name:FBLOGNOTIFICATIONOFOUTPUT object:nil]，建议在初始化FBBluetoothManager前实现监听｜If you need to receive log information, please implement the listening method [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(logOutput:) name:FBLOGNOTIFICATIONOFOUTPUT object:nil]. It is recommended to implement listening before initializing FBBluetoothManager.
 */
@property (nonatomic, assign) BOOL debugging;

/**
 是否允许 CBConnectPeripheralOptionNotifyOnNotificationKey，默认YES
 */
@property (nonatomic, assign) BOOL allowNotificationKey;


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
 断开连接设备，同时是否清除连接历史记录｜Disconnect the device and clear the connection history
 @param clearHistory                   清除连接历史记录｜Clear connection history
 
 @note NO不清除连接历史记录，仅仅是临时断开连接，不清除设备相关信息、密钥等数据，在需要的时候可调用 @see tryLastConnection 尝试恢复连接。YES清除连接历史记录，清除设备相关信息、密钥等数据，完全断开连接。｜NO does not clear the connection history, it only temporarily disconnects, and does not clear device-related information, keys and other data. You can call @see tryLastConnection to try to restore the connection when needed. YES clears the connection history, clears device-related information, keys and other data, and completely disconnects.
*/
- (void)disconnectPeripheralAndClearHistory:(BOOL)clearHistory;

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


/**
 获取指令队列当前是否空闲｜Get whether the command queue is currently idle
*/
- (BOOL)commandQueueIdle;

/**
 回调指令队列当前处于空闲｜The callback command queue is currently idle
*/
- (void)commandQueueIdleWithCallback:(FBCommandQueueIdleBlock)callback;

@end

NS_ASSUME_NONNULL_END
