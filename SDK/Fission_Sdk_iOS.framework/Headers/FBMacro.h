//
//  FBMacro.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/5.
//

#ifndef FBMacro_h
#define FBMacro_h

/** FBLog 日志输出通知名称｜FBLog log output notification name */
static NSString *const FBLOGNOTIFICATIONOFOUTPUT = @"FBLOGNOTIFICATIONOFOUTPUT";

#pragma mark - 错误码｜Error code
/*
 * 错误码｜Error code
 */
typedef enum {
    //协议定义的通讯错误｜Protocol defined communication error
    RET_EXEC_ER         = 3,    //执行失败｜Execution failed
    RET_DATA_INVA       = 4,    //数据无效（格式错误）｜Invalid data (format error)
    RET_COMM_BUSY       = 5,    //通信中（系统忙）｜Communication (system busy)
    RET_COMD_INVA       = 6,    //无效指令｜Invalid instruction
    RET_PVER_ER         = 7,    //协议版本不符｜Protocol version does not match
    RET_DATA_OK         = 8,    //数据正确｜The data is correct
    RET_DATA_ER         = 9,    //数据错误｜Data error
    RET_DATA_TO         = 10,   //接收超时｜Receive timeout
    RET_RAM_OF          = 11,   //内存溢出｜Out of memory
    RET_CHKS_ER         = 12,   //校验和错误｜Check sum error
    RET_PARA_ER         = 13,   //参数错误｜Parameter error
    RET_LENG_ER         = 14,   //数据长度错误｜Data length error
    
    //自定义蓝牙通信错误｜Custom Bluetooth communication error
    RET_FB_ERR_OTA      = 15,   //OTA失败，不支持OTA｜OTA failed, OTA not supported
    RET_FB_ERR_OFF      = 16,   //蓝牙未打开或不支持｜Bluetooth is not on or not supported
    RET_FB_ERR_NOT      = 17,   //尚未连接到设备｜Not yet connected to the device
    RET_FB_ERR_NOTREADY = 18,   //设备尚未初始化完成｜The device has not been initialized
    RET_FB_ERR_NET      = 19,   //写指令失败，或缺少连接参数｜Write instruction failed, or connection parameters are missing
    RET_FB_ERR_AT       = 20,   //AT指令异常，无效指令/无效参数｜At instruction exception, invalid instruction / invalid parameter
    RET_FB_ERR_DATA     = 21,   //失败，数据校验未通过｜Failed, data verification failed
    RET_FB_ERR_TIMEROUT = 22,   //应答超时｜Response timeout
    
    //自定义数据传输状态｜Data transmission status
    FB_INDATATRANSMISSION     = 101,    //数据传输中｜In data transmission
    FB_DATATRANSMISSIONDONE   = 200,    //数据传输完成｜Data transmission complete
    FB_DATATRANSMISSIONFAILED = 500,    //数据传输失败｜Data transfer failed
    
    //GPS运动状态执行错误｜GPS motion status execution error
    FB_GPS_MOTION_STATE_LOWPRESSUREERROR     = 200012, //执行失败，低压无法执行｜Execution failed, low voltage cannot be executed
    FB_GPS_MOTION_STATE_COMMANDSTATUSERROR   = 200013, //指令状态错误｜Command status error
    FB_GPS_MOTION_STATE_INREGULARMOTIONERROR = 200014, //常规运动中，请先停止当前运动｜In normal motion, please stop the current motion first
    FB_GPS_MOTION_STATE_INCALLERROR          = 200015, //正在通话中，无法执行此指令｜This command cannot be executed during a call
    FB_GPS_MOTION_STATE_CANCELS              = 200017, //手表取消开启运动｜The watch cancels the movement
    FB_GPS_MOTION_STATE_NONE                 = 200019, //本地无此运动信息｜There is no local sports information
}FB_RET_CMD;

#pragma mark - 电池电量等级｜Battery level
/*
 * 电池电量等级｜Battery level
 */
typedef enum {
    BATT_NORMAL    = 0,  //正常｜Normal
    BATT_LOW_POWER = 1,  //低压｜Low power
    BATT_CHARGING  = 2,  //充电中｜Charging
    BATT_FULL      = 3,  //电池满｜Full power
}FB_BATTERYLEVEL;

#pragma mark - 时间显示模式｜Time display mode
/*
 * 时间显示模式｜Time display mode
 */
typedef enum {
    FB_TimeDisplayMode12Hours = 12,  //12小时制｜12 hour system
    FB_TimeDisplayMode24Hours = 24,  //24小时制｜24 hour system
}FB_TIMEDISPLAYMODE;

#pragma mark - 多语种国际化 和 SDK多语言设置｜Multilingual internationalization and SDK Multilingual Settings
/*
 * 多语种国际化 和 SDK多语言设置｜Multilingual internationalization and SDK Multilingual Settings
 */
typedef enum {
    FB_SDK_zh_Hans = 0,   //中文简体｜Simplified Chinese
    FB_SDK_en      = 1,   //英文｜English
    FB_SDK_ja      = 2,   //日语｜Japanese
    FB_SDK_fr      = 3,   //法语｜French
    FB_SDK_de      = 4,   //德语｜German
    FB_SDK_es      = 5,   //西班牙语｜Spanish
    FB_SDK_it      = 6,   //意大利语｜Italian
    FB_SDK_pt      = 7,   //葡萄牙语｜Portuguese
    FB_SDK_ru      = 8,   //俄语｜Russian
    FB_SDK_cs      = 9,   //捷克语｜Czech
    FB_SDK_pl      = 10,  //波兰语｜Polish
    FB_SDK_zh_Hant = 11,  //中文繁体｜Chinese traditional
    FB_SDK_ar      = 12,  //阿拉伯语｜Arabic
    FB_SDK_tr      = 13,  //土耳其语｜Turkish
    FB_SDK_vi      = 14,  //越南语｜Vietnamese
    FB_SDK_ko      = 15,  //韩语｜Korean
    FB_SDK_he      = 16,  //希伯来语｜Hebrew
    FB_SDK_th      = 17,  //泰语｜Thai
    FB_SDK_id      = 18,  //印尼语｜Indonesian
    FB_SDK_nl      = 19,  //荷兰语｜Dutch
    FB_SDK_el      = 20,  //希腊语｜Greek
    FB_SDK_sv      = 21,  //瑞典语｜Swedish
    FB_SDK_ro      = 22,  //罗马尼亚语｜Romanian
    FB_SDK_hi      = 23,  //印地语｜Hindi
    FB_SDK_bn      = 24,  //孟加拉语｜Bangla
    FB_SDK_ur      = 25,  //乌尔都语｜Urdu
    FB_SDK_fa      = 26,  //波斯语｜Persian
}FB_LANGUAGES;

#pragma mark - 距离单位 ｜Distance unit
/*
 * 距离单位 ｜Distance unit
 */
typedef enum {
    FB_EnglishUnits = 0,  //英制单位｜English units
    FB_MetricUnit   = 1,  //公制单位｜Metric unit
}FB_DISTANCEUNIT;

#pragma mark - 女性生理状态 ｜Female physiological state
/*
 * 女性生理状态 ｜Female physiological state
 */
typedef enum {
    FB_FPS_NotUsed              = 0,  //未启用｜Not used
    FB_FPS_Pregnancy            = 1,  //怀孕期｜Pregnancy
    FB_FPS_Menstruation         = 2,  //月经期｜Menstruation
    FB_FPS_Safety               = 3,  //安全期｜Safety period
    FB_FPS_Ovulation            = 4,  //排卵期｜During ovulation
    FB_FPS_OvulationDay         = 5,  //排卵日｜Ovulation day
    FB_FPS_PregnancyPreparation = 6,  //备孕期｜Pregnancy preparation period
}FB_FEMALEPHYSIOLOGICALSTATE;

#pragma mark - 女性生理健康模式｜Female 's physical health model
/*
 * 女性生理健康模式｜Female 's physical health model
 */
typedef enum {
    FB_HealthModel_NotUsed              = 0,  //未启用｜Not used
    FB_HealthModel_Menstrual            = 1,  //月经期｜Menstrual period
    FB_HealthModel_PregnancyPreparation = 2,  //备孕期｜Pregnancy preparation period
    FB_HealthModel_Pregnancy            = 3,  //怀孕期｜Pregnancy
}FB_FEMALEPHYSIOLOGICALHEALTHMODEL;

#pragma mark - 短跑模式 ｜Sprint mode
/*
 * 短跑模式 ｜Sprint mode
 */
typedef enum {
    FB_SPRINTMODE_OFF = 0,  //关闭｜Close
    FB_SPRINTMODE_ON  = 1,  //开启｜Open
}FB_SPRINTMODE;

#pragma mark - 心率等级｜Heart rate rating
/*
 * 心率等级｜Heart rate rating
 */
typedef enum {
    FB_HR_NORMAL            = 0,  //正常的｜Normal
    FB_HR_MODERATE          = 1,  //缓和的｜Moderate
    FB_HR_VIGOROUS          = 2,  //充沛的｜Vigorous
    FB_HR_MAX_HR            = 3,  //心率过快｜The heart rate is too fast
    FB_HR_TAKE_IT_EASY      = 4,  //别紧张｜Take it easy
    FB_HR_WATCH_YOUR_LIMITS = 5,  //注意你的极限｜Watch your limits
    FB_HR_DONT_OVEREXERT    = 6,  //不要用力过猛｜Don't overdo it
}FB_CURRENTHEARTRANGE;

#pragma mark - 血氧等级｜Blood oxygen level
/*
 * 血氧等级｜Blood oxygen level
 */
typedef enum {
    FB_OXY_NORMAL   = 0,  //正常｜Normal
    FB_OXY_MILD     = 1,  //轻度缺氧｜Mild hypoxia
    FB_OXY_MODERATE = 2,  //中度缺氧｜Moderate hypoxia
    FB_OXY_SEVERE   = 3,  //重度缺氧｜Severe hypoxia
}FB_CURRENTOXYRANGE;

#pragma mark - 精神压力等级｜Stress level
/*
 * 精神压力等级｜Stress level
 */
typedef enum {
    FB_STRESS_RELAX     = 0,  //1-25放松｜1-25 Relax
    FB_STRESS_NORMAL    = 1,  //26-50正常｜26-50 normal
    FB_STRESS_SECONDARY = 2,  //51-75中等｜51-75 Medium
    FB_STRESS_HIGN      = 3   //76-99偏高｜76-99 high
}FB_CURRENTSTRESSRANGE;

#pragma mark - 睡眠状态｜Sleep state
/*
 * 睡眠状态｜Sleep state
 */
typedef enum {
    Awake_state   = 0,  //清醒状态｜Awake state
    Shallow_sleep = 1,  //浅层睡眠｜Shallow sleep
    Deep_sleep    = 2,  //深层睡眠｜Deep sleep
    
    Eye_move      = 3,  //眼动状态（结构体版本不等于0时才有此类型）｜Eye move (This type is only available when the structure version is not equal to 0)
}FB_SLEEPSTATE;

#pragma mark - 运动模式｜Movement mode
/*
 * 运动模式｜Movement mode
 */
typedef enum {
    FBNotUsed               = 0,   //不使用｜Not used
    FBRunning               = 1,   //跑步｜Running
    FBMountaineering        = 2,   //登山｜Mountaineering
    FBCycling               = 3,   //骑行｜Cycling
    FBFootball              = 4,   //足球｜Football
    FBSwimming              = 5,   //游泳｜Swimming
    FBBasketball            = 6,   //篮球｜Basketball
    FBNo_designation        = 7,   //无指定｜No designation
    FBOutdoor_running       = 8,   //户外跑步｜Outdoor running
    FBIndoor_running        = 9,   //室内跑步｜Indoor running
    FBFat_reduction_running = 10,  //减脂跑步｜Fat reduction running
    
    FBOutdoor_walking       = 11,  //户外健走｜Outdoor walking
    FBIndoor_walking        = 12,  //室内健走｜Indoor walking
    FBOutdoor_cycling       = 13,  //户外骑行｜Outdoor cycling
    FBIndoor_cycling        = 14,  //室内骑行｜Indoor cycling
    FBFree_training         = 15,  //自由训练｜Free training
    FBFitness_training      = 16,  //健身训练｜Fitness training
    FBBadminton             = 17,  //羽毛球｜Badminton
    FBVolleyball            = 18,  //排球｜Volleyball
    FBTable_Tennis          = 19,  //乒乓球｜Table Tennis
    FBElliptical_machine    = 20,  //椭圆机｜Elliptical machine
    
    FBRowing_machine        = 21,  //划船机｜Rowing machine
    FBYoga_training         = 22,  //瑜伽｜Yoga
    FBStrength_training     = 23,  //力量训练（举重）｜Strength training (weightlifting)
    FBCricket               = 24,  //板球｜Cricket
    FBRope_skipping         = 25,  //跳绳｜Rope skipping
    FBAerobic_exercise      = 26,  //有氧运动｜Aerobic exercise
    FBAerobic_dancing       = 27,  //健身舞｜Aerobic dancing
    FBTaiji_boxing          = 28,  //太极｜Tai Chi
    FBAuto_runing           = 29,  //自动识别跑步运动｜Automatically recognize running
    FBAuto_walking          = 30,  //自动识别健走运动｜Automatic recognition of walking movement
    
    FBWALK                  = 31,  //室内步行｜Indoor walking
    FBSTEP_TRAINING         = 32,  //踏步｜Step training
    FBHORSE_RIDING          = 33,  //骑马｜Ride a horse
    FBHOCKEY                = 34,  //曲棍球｜Hockey
    FBINDOOR_CYCLE          = 35,  //室内单车｜Aerodyne bike
    FBSHUTTLECOCK           = 36,  //毽球｜Shuttlecock
    FBBOXING                = 37,  //拳击｜Boxing
    FBOUTDOOR_WALK          = 38,  //户外走｜Outdoor walk
    FBTRAIL_RUNNING         = 39,  //越野跑｜Cross country running
    FBSKIING                = 40,  //滑雪｜Skiing
    
    FBGYMNASTICS            = 41,  //体操｜Artistic Gymnastics
    FBICE_HOCKEY            = 42,  //冰球｜Ice hockey
    FBTAEKWONDO             = 43,  //跆拳道｜Taekwondo
    FBVO2MAX_TEST           = 44,  //有氧运动｜Aerobic exercise
    FBAIR_WALKER            = 45,  //漫步机｜Walking machine
    FBHIKING                = 46,  //徒步｜On foot
    FBTENNIS                = 47,  //网球｜Tennis
    FBDANCE                 = 48,  //跳舞｜Dance
    FBTRACK_FIELD           = 49,  //田径｜Athletics
    FBABDOMINAL_TRAINING    = 50,  //腰腹运动｜Lumbar abdominal movement
    
    FBKARATE                = 51,  //空手道｜Karate
    FBCOOLDOWN              = 52,  //整理放松｜Organize and relax
    FBCROSS_TRAINING        = 53,  //交叉训练｜Cross training
    FBPILATES               = 54,  //普拉提｜Pilates
    FBCROSS_FIT             = 55,  //交叉配合｜Cross fit
    FBUNCTIONAL_TRAINING    = 56,  //功能性训练｜Functional training
    FBPHYSICAL_TRAINING     = 57,  //体能训练｜Physical training
    FBARCHERY               = 58,  //射箭｜Archery
    FBFLEXIBILITY           = 59,  //柔韧度｜Flexibility
    FBMIXED_CARDIO          = 60,  //混合有氧｜Mixed aerobic
    
    FBLATIN_DANCE           = 61,  //拉丁舞｜Latin dance
    FBSTREET_DANCE          = 62,  //街舞｜Hip hop
    FBKICKBOXING            = 63,  //自由搏击｜Free fight
    FBBARRE                 = 64,  //芭蕾舞｜Ballet
    FBAUSTRALIAN_FOOTBALL   = 65,  //澳式足球｜Australian football
    FBMARTIAL_ARTS          = 66,  //武术｜Australian football
    FBSTAIRS                = 67,  //爬楼｜Climb a building
    FBHANDBALL              = 68,  //手球｜Handball
    FBBASEBALL              = 69,  //棒球｜Baseball
    FBBOWLING               = 70,  //保龄球｜Bowling
    
    FBRACQUETBALL           = 71,  //壁球｜Squash
    FBCURLING               = 72,  //冰壶｜Curling
    FBHUNTING               = 73,  //打猎｜Go hunting
    FBSNOWBOARDING          = 74,  //单板滑雪｜Snowboarding
    FBPLAY                  = 75,  //休闲运动｜Leisure sports
    FBAMERICAN_FOOTBALL     = 76,  //美式橄榄球｜American football
    FBHAND_CYCLING          = 77,  //手摇车｜Handcart
    FBFISHING               = 78,  //钓鱼｜Go fishing
    FBDISC_SPORTS           = 79,  //飞盘｜Frisbee
    FBRUGBY                 = 80,  //橄榄球｜Rugby
    
    FBGOLF                  = 81,  //高尔夫｜Golf
    FBFOLK_DANCE            = 82,  //民族舞｜Folk dance
    FBDOWNHILL_SKIING       = 83,  //高山滑雪｜Alpine skiing
    FBSNOW_SPORTS           = 84,  //雪上运动｜Snow Sports
    FBMIND_BODY             = 85,  //舒缓冥想类运动｜Soothing meditation exercise
    FBCORE_TRAINING         = 86,  //核心训练｜Core training
    FBSKATING               = 87,  //滑冰｜Core training
    FBFITNESS_GAMING        = 88,  //健身游戏｜Fitness games
    FBAEROBICS              = 89,  //健身操｜Aerobics
    FBGROUP_TRAINING        = 90,  //团体操｜Group Gymnastics
    
    FBKENDO                 = 91,  //搏击操｜Kickboxing
    FBLACROSSE              = 92,  //长曲棍球｜Lacrosse
    FBROLLING               = 93,  //泡沫轴筋膜放松｜Foam shaft fascia relax
    FBWRESTLING             = 94,  //摔跤｜Wrestling
    FBFENCING               = 95,  //击剑｜Fencing
    FBSOFTBALL              = 96,  //垒球｜Softball
    FBSINGLE_BAR            = 97,  //单杠｜Horizontal bar
    FBPARALLEL_BARS         = 98,  //双杠｜Parallel bars
    FBROLLER_SKATING        = 99,  //轮滑｜Roller-skating
    FBHULA_HOOP             = 100, //呼啦圈｜Hu la hoop
    
    FBDARTS                 = 101, //飞镖｜Darts
    FBPICKLEBALL            = 102, //匹克球｜Pickleball
    FBSIT_UP                = 103, //仰卧起坐｜Abdominal curl
    FBHIIT                  = 104, //HIIT｜HIIT
    FBWAIST_TRAINING        = 105, //腰腹训练｜Waist and abdomen training
    FBTREADMILL             = 106, //跑步机｜Treadmill
    FBBOATING               = 107, //划船｜Rowing
    FBJUDO                  = 108, //柔道｜rowing
    FBTRAMPOLINE            = 109, //蹦床｜Trampoline
    FBSKATEBOARDING         = 110, //滑板｜Skate
    
    FBHOVERBOARD            = 111, //平衡车｜Balance car
    FBBLADING               = 112, //溜旱冰｜Roller skating
    FBPARKOUR               = 113, //跑酷｜Parkour
    FBDIVING                = 114, //跳水｜Diving
    FBSURFING               = 115, //冲浪｜Surfing
    FBSNORKELING            = 116, //浮潜｜Snorkeling
    FBPULL_UP               = 117, //引体向上｜Pull up
    FBPUSH_UP               = 118, //俯卧撑｜Push up
    FBPLANKING              = 119, //平板支撑｜Plate support
    FBROCK_CLIMBING         = 120, //攀岩｜Rock Climbing
    
    FBHIGHTJUMP             = 121, //跳高｜High jump
    FBBUNGEE_JUMPING        = 122, //蹦极｜Bungee jumping
    FBLONGJUMP              = 123, //跳远｜Long jump
    FBSHOOTING              = 124, //射击｜Shooting
    FBMARATHON              = 125, //马拉松｜Marathon
    FBVO2MAXTEST            = 126, //最大摄氧量测试｜VO2max test
    FBKITE_FLYING           = 127, //放风筝｜Kite Flying
    FBBILLIARDS             = 128, //台球｜Billiards
    FBCARDIO_CRUISER        = 129, //有氧运动巡洋舰｜Cardio Cruiser
    FBTUGOFWAR              = 130, //拔河比赛｜Tug of war
    
    FBFREESPARRING          = 131, //免费的陪练｜Free Sparring
    FBRAFTING               = 132, //漂流｜Rafting
    FBSPINNING              = 133, //旋转｜Spinning
    FBBMX                   = 134, //BMX｜BMX
    FBATV                   = 135, //ATV｜ATV
    FBDUMBBELL              = 136, //哑铃｜Dumbbell
    FBBEACHFOOTBALL         = 137, //沙滩足球｜Beach Football
    FBKAYAKING              = 138, //皮划艇｜Kayaking
    FBSAVATE                = 139, //法国式拳击｜Savate
    
    FBOther_reservation     = 255, //其他预留｜Other reservation
}FB_MOTIONMODE;

#pragma mark - 记录类型｜Record type
/*
 * 记录类型｜Record type
 */
typedef enum {
    FB_HeartRecord     = 0,  //心率记录｜Heart rate recording
    FB_StepRecord      = 1,  //计步记录｜Step count record
    FB_BloodOxyRecord  = 2,  //血氧记录｜Blood oxygen recording
    FB_BloodPreRecord  = 3,  //血压记录｜Blood pressure recording
    FB_SportsRecord    = 4,  //运动详情记录｜Sports detail record
    FB_MotionGpsRecord = 5,  //运动定位记录｜Motion location record
    FB_HFHeartRecord   = 6,  //运动高频心率记录(1秒1次)｜Sports high-frequency heart rate recording (1 time per second)
    FB_StressRecord    = 7,  //精神压力记录｜Stress Record
}FB_RECORDTYPE;

#pragma mark - 用户性别｜User gender
/*
 * 用户性别｜User gender
 */
typedef enum {
    FB_UserMale   = 0,  //男性｜Male
    FB_UserFemale = 1,  //女性｜Female
}FB_USERGENDER;

#pragma mark - 闹铃类别｜Alarm category
/*
 * 闹铃类别｜Alarm category
 */
typedef enum {
    FB_Reminders  = 0,  //备忘提醒｜Reminders
    FB_AlarmClock = 1,  //定时闹钟｜Alarm clock
}FB_ALARMCATEGORY;

#pragma mark - 天气｜Weather
/*
 * 天气｜Weather
 */
typedef enum {
    WT_SUNNY               = 0,   //晴｜Sunny
    WT_PARTLY_CLOUDY       = 1,   //多云｜Cloudy
    WT_WIND                = 2,   //风｜Wind
    WT_CLOUDY              = 3,   //阴天｜Overcast
    WT_LIGHT_RAIN          = 4,   //小雨｜Light rain
    WT_HEAVY_RAIN          = 5,   //大雨｜Heavy rain
    WT_SNOW                = 6,   //雪｜Snow
    WT_THUNDER_SHOWER      = 7,   //雷阵雨｜Thunder shower
    WT_SUNNY_NIGHT         = 8,   //晴晚上｜Sunny night
    WT_PARTLY_CLOUDY_NIGHT = 9,   //多云晚上｜Cloudy night
    WT_STANDSTORM          = 10,  //沙尘暴｜Sand storm
    WT_SHOWER              = 11,  //阵雨｜Shower
    WT_SHOWER_NIGHT        = 12,  //阵雨晚上｜Shower night
    WT_SLEET               = 13,  //雨夹雪｜Sleet
    WT_SMOG                = 14,  //雾、霾｜Fog and haze
    WT_LIGHT_SNOW          = 15,  //小雪｜Light snow
    WT_HEAVY_SNOW          = 16,  //大雪｜Heavy snow
    WT_MODERATE_RAIN       = 17,  //中雨｜Moderate rain
    WT_RAINSTORM           = 18,  //暴雨｜Rainstorm
    
    WT_UNKNOW              = 255, //未知天气｜Unknown weather
}FB_WEATHER;

#pragma mark - 空气质量等级｜Air quality level
/*
 * 空气质量等级｜Air quality level
 */
typedef enum {
    AL_BAD     = 0,  //差｜Bad
    AL_GOOD    = 1,  //良｜Good
    AL_WONDFUL = 2,  //优｜Wonderful
}FB_AIRLEVEL;

#pragma mark - PM2.5等级｜PM2.5 grade
/*
 * PM2.5等级｜PM2.5 grade
 */
typedef enum {
    PM_LEVEL1 = 0,  //优｜Wonderful
    PM_LEVEL2 = 1,  //良｜Good
    PM_LEVEL3 = 2,  //轻度污染｜Light pollution
    PM_LEVEL4 = 3,  //中度污染｜Moderate pollution
    PM_LEVEL5 = 4,  //重度污染｜Heavy pollution
}FB_PM25;

#pragma mark - 风向｜Wind direction
/*
 * 风向｜Wind direction
 */
typedef enum{
    WD_0 = 0,  //无风｜No wind
    WD_1 = 1,  //东风｜East wind
    WD_2 = 2,  //东南风｜Southeast wind
    WD_3 = 3,  //南风｜South wind
    WD_4 = 4,  //西南风｜Southwest wind
    WD_5 = 5,  //西风｜Westerly
    WD_6 = 6,  //西北风｜Northwest wind
    WD_7 = 7,  //北风｜North wind
    WD_8 = 8,  //东北风｜Northeasterly wind
}EM_WINDDIRECTION;

#pragma mark - OTA类型通知｜OTA type notification
/*
 * OTA类型通知｜OTA type notification
 */
typedef enum {
    FB_OTANotification_Firmware                 = 0,    //升级固件｜Update Firmware
    FB_OTANotification_ClockDial                = 1,    //升级默认动态表盘｜Upgrade default dynamic dial
    FB_OTANotification_SmallFont                = 2,    //升级小字库｜Upgrade small font
    FB_OTANotification_BigFont                  = 3,    //升级大字库｜Upgrade big font
    FB_OTANotification_UIPictureResources       = 4,    //升级UI图片资源｜Upgrade UI image resources
    FB_OTANotification_2_3_4AtTheSameTime       = 5,    //同时升级2,3,4｜Upgrade 2, 3, 4 at the same time
    FB_OTANotification_Motion                   = 6,    //推送运动模式｜Push motion mode
    FB_OTANotification_UI                       = 7,    //增量升级UI图片｜Incrementally upgrade UI images
    FB_OTANotification_Multi_Dial               = 8,    //多表盘压缩数据包｜Multi-dial compressed data package
    FB_OTANotification_Multi_Sport              = 9,    //多运动类型压缩数据包｜Multi-sport type compressed data package
    FB_OTANotification_DynamicClockDial         = 10,   //+n，升级动态表盘n｜+n. Upgrade dynamic dial n
    FB_OTANotification_CustomClockDial          = 20,   //+n，升级自定义表盘n｜+n. Upgrade custom dial n
    
    FB_OTANotification_Multi_Dial_Built_in      = 200,  //厂线推送内置表盘压缩数据包｜The factory line pushes the built-in dial compressed data package
    FB_OTANotification_Multi_Sport_Built_in     = 201,  //厂线推送内置多运动类型压缩数据包｜The factory line pushes the built-in multi-sport type compressed data package
    FB_OTANotification_Busy                     = 254,  //设备处于禁止OTA状态，稍后再试｜The device is in OTA prohibited state, please try again later
    FB_OTANotification_Cancel                   = 255,  //放弃当前升级｜Discard current upgrade
}FB_OTANOTIFICATION;

#pragma mark - 获取多个记录报告｜Get multiple record reports
/*
 * 获取多个记录报告｜Get multiple record reports
 */
typedef enum {
    FB_CurrentDayActivityData           = 1<<0,   //当日实时测量数据｜Real time measurement data of the day
    FB_HeartRateRecording               = 1<<1,   //心率记录｜Heart rate recording
    FB_StepCountRecord                  = 1<<2,   //计步记录｜Step counting record
    FB_BloodOxygenRecording             = 1<<3,   //血氧记录｜Blood oxygen record
    FB_BloodPressureRecording           = 1<<4,   //血压记录｜Blood pressure record
    FB_HFHeartRateRecording             = 1<<5,   //运动高频心率记录(1秒1次)｜Sports high-frequency heart rate recording (1 time per second)
    FB_StressRecording                  = 1<<6,   //精神压力记录｜Stress Record
    FB_SportsDetailsRecord              = 1<<7,   //运动详情记录｜Sports detail record
    FB_SportsPositioningRecord          = 1<<8,   //运动定位记录｜Sports positioning record
    FB_DailyActivityReport              = 1<<9,   //每日活动报告｜Daily activity report
    FB_OnHourActivityReport             = 1<<10,  //整点活动报告｜On hour activity report
    FB_SleepStatisticsReport            = 1<<11,  //睡眠统计报告｜Sleep statistics report
    FB_SleepStateRecording              = 1<<12,  //睡眠状态记录｜Sleep state recording
    FB_CurrentSleepStatisticsReport     = 1<<13,  //当前睡眠实时统计报告｜Current sleep real time statistics report
    FB_CurrentSleepStateRecording       = 1<<14,  //当前睡眠实时状态记录｜Current sleep real time status record
    FB_SportsRecordList                 = 1<<15,  //运动记录列表｜Sports record list
    FB_SportsStatisticsReport           = 1<<16,  //运动统计报告｜Sports statistics report
    FB_Sports_Statistics_Details_Report = 1<<17,  //运动统计报告+运动详情纪录｜Sports statistics report + sports details record
    FB_ManualMeasurementData            = 1<<18,  //手动测量数据｜Manual measurement data
}FB_MULTIPLERECORDREPORTS;

#pragma mark - 功能开关状态同步｜Function switch state synchronization
/*
 * 功能开关状态同步｜Function switch state synchronization
 */
typedef enum {
    FS_NULL                    = 0,   //无｜Nothing
    FS_SENSOR_GATHER           = 1,   //体征数据采集总开关状态，0关1开｜Sign data acquisition master switch status, 0 off and 1 on
    FS_MOTOR_ENABLE            = 2,   //振动开关状态，0关1开｜Vibration switch status, 0 off, 1 on
    FS_DONT_DISTURB_WARN       = 3,   //勿扰开关状态，0关1开｜Do not disturb switch status, 0 off and 1 on
    FS_CLOCK_1_WARN            = 4,   //闹钟 1 的开关状态，0关1开｜Alarm 1 switch status, 0 off and 1 on
    FS_CLOCK_2_WARN            = 5,   //闹钟 2 的开关状态，0关1开｜Alarm 2 switch status, 0 off and 1 on
    FS_CLOCK_3_WARN            = 6,   //闹钟 3 的开关状态，0关1开｜Alarm 3 switch status, 0 off and 1 on
    FS_CLOCK_4_WARN            = 7,   //闹钟 4 的开关状态，0关1开｜Alarm 4 switch status, 0 off and 1 on
    FS_CLOCK_5_WARN            = 8,   //闹钟 5 的开关状态，0关1开｜Alarm 5 switch status, 0 off and 1 on
    FS_LOWBATTERY_WARN         = 9,   //低压提醒功能开关状态，0关1开｜Low voltage reminder function switch status, 0 off and 1 on
    FS_TARGET_DAY_WARN         = 10,  //日目标提醒检测总开关状态，0关1开｜Daily target alert detection master switch status, 0 off and 1 on
    FS_TARGET_WEEK_WARN        = 11,  //周目标提醒检测总开关状态，0关1开｜Weekly target alert detection master switch status, 0 off and 1 on
    FS_TARGET_SELF_WARN        = 12,  //自我鼓励目标提醒检测总开关状态，0关1开｜Self encouragement target alert detection master switch status, 0 off and 1 on
    FS_HEARTRATE_LEVEL_WARN    = 13,  //心率超标提醒开关状态，为0关 非0开｜The heart rate exceeds the limit reminder switch status, which is 0 off and not 0 on
    FS_WEARING_STATE_WARN      = 14,  //佩戴状态，0未佩戴1佩戴｜Wearing status, 0 not wearing, 1 wearing
    FS_TAKEPHOTOS_WARN         = 15,  //拍照模式开关状态，0关1开｜Photo mode switch status, 0 off and 1 on
    FS_STATEOFCHARGE_WARN      = 16,  //设备充电状态更新，0放电状态、1低压状态、2充电状态、3充满状态｜The charging state of the equipment is updated, including 0 discharge state, 1 low voltage state, 2 charging state and 3 full state
    FS_MUSICINTERFACESTATUS    = 17,  //进入音乐界面状态｜Music interface status
    FS_BRIGHTSCREENTIMECHANGES = 18,  //亮屏时长改变｜The duration of bright screen changes
    FS_WRISTLIFT_WARN          = 19,  //抬腕开关状态，0关1开｜Wrist lifting switch status, 0 off and 1 on
    FS_PERCENTAGE_BATTERY      = 20,  //当前电池电量百分比｜Current battery power percentage
    FS_WATER_DRINKING_WARN     = 21,  //喝水提醒开关状态，0关1开｜Water drinking reminder switch status, 0 off and 1 on
    FS_SEDENTARY_WARN          = 22,  //久坐提醒开关状态，0关1开｜Sedentary reminder switch status, 0 off and 1 on
    FS_OTA_PERCENTAGE          = 23,  //OTA百分比｜OTA percentage
    FS_MUTE_SWITCH             = 24,  //静音开关同步（安卓专用）｜Mute switch synchronization (Android only)
    FS_OTA_INTERFACE_STATUS    = 25,  //手表OTA升级界面状态，1进入OTA界面，0退出OTA界面｜Watch OTA upgrade interface status, 1 enters the OTA interface, 0 exits the OTA interface
    FS_ALARMCLOCK_CHANGENOTICE = 26,  //手表记事提醒/闹钟信息变更通知事件｜Watch reminder / alarm clock information change notification event
    
    FS_TIMING_HR_WARN          = 28, //定时心率检测开关状态，0关1开｜Timing heart rate detection switch status, 0 off 1 on
    FS_TIMING_SPO2_WARN        = 29, //定时血氧检测开关状态，0关1开｜Timing blood oxygen detection switch status, 0 off 1 on
    FS_TIMING_STRESS_WARN      = 30, //定时精神压力检测开关状态，0关1开｜Timing mental stress detection switch status, 0 off 1 on
    FS_CALLAUDIO_WARN          = 31, //通话音频开关状态，0关1开｜Call audio switch status, 0 off 1 on
    FS_MULTIMEDIAAUDIO_WARN    = 32, //多媒体音频开关状态，0关1开｜Multimedia audio switch status, 0 off 1 on
    
    FS_OTHER_EXPAND            = 255  //更多功能待拓展｜More functions to be expanded
}EM_FUNC_SWITCH;

#pragma mark - 温度单位｜Temperature unit
/*
 * 温度单位｜Temperature unit
 */
typedef enum {
    FB_Centigrade       = 0,  //摄氏度C｜Centigrade(C)
    FB_FahrenheitDegree = 1,  //华氏度F｜Fahrenheit degree(F)
}FB_TEMPERATUREUNIT;

#pragma mark - 自定义表盘时间显示位置｜Custom dial time display position
/*
 * 自定义表盘时间显示位置｜Custom dial time display position
 */
typedef enum {
    FB_DialTimePositionStyleTop    = 0,  //上｜Top
    FB_DialTimePositionStyleBottom = 1,  //下｜Bottom
    FB_DialTimePositionStyleLeft   = 2,  //左｜Left
    FB_DialTimePositionStyleRight  = 3,  //右｜Right
    FB_DialTimePositionStyleMiddle = 4,  //中｜Middle
}FB_CUSTOMDIALTIMEPOSITION;

#pragma mark - 指定提示功能｜Specify prompt function
/*
 * 指定提示功能｜Specify prompt function
 */
typedef enum {
    FB_ExerciseHeartRate = 1,  //运动心率超高提示｜Exercise heart rate ultra-high prompt
    // 更多... 待拓展｜More... To be expanded
}FB_PROMPTFUNCTION;

#pragma mark - GPS运动状态｜GPS Motion status
/*
 * GPS运动状态｜GPS Motion status
 */
typedef enum {
    FB_SettingStopMotion  = 0,  //停止运动｜Stop motion
    FB_SettingStartMotion = 1,  //开始运动｜Start motion
    FB_SettingPauseMotion = 2,  //暂停运动｜Pause motion
    FB_SettingKeepMotion  = 3,  //继续运动｜Keep motion
}FB_GPS_MOTION_STATE;

#pragma mark - 运动心率区间｜Motion heart rate interval
/*
 * 运动心率区间｜Motion heart rate interval
 * @note 从上往下 等级越高｜The higher the level from top to bottom
 */
typedef enum {
    FB_Motion_WarmUp     = 0,  //热身｜warm-up
    FB_Motion_FatBurning = 1,  //燃脂｜Fat burning
    FB_Motion_Aerobic    = 2,  //有氧耐力｜Aerobic endurance
    FB_Motion_Limit      = 3,  //高强有氧｜High strength aerobic
    FB_Motion_Anaerobic  = 4,  //无氧｜anaerobic
}FB_MOTIONHEARTRATERANGE;

#pragma mark - 自定义表盘算法类型｜Custom dial algorithm type
/*
 * 自定义表盘算法类型｜Custom dial algorithm type
 */
typedef enum {
    FB_OrdinaryAlgorithm = 0,  //普通算法｜Ordinary algorithm
    FB_CompressAlgorithm = 1   //压缩算法｜Compression algorithm
}FB_ALGORITHMGENERATION;

#endif /* FBMacro_h */
