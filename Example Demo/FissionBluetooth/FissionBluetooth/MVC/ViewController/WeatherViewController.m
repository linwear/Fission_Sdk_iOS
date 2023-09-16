//
//  WeatherViewController.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/20.
//

#import "WeatherViewController.h"
#import "WeatherCell.h"

@interface WeatherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *num;

@property (nonatomic, retain) NSMutableArray <FBWeatherModel *>*array;

@property (nonatomic, strong) NSDictionary *param;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.array = [NSMutableArray array];
    
    UIBarButtonItem *rigItem = [[UIBarButtonItem alloc] initWithTitle:LWLocalizbleString(@"☁️Weather Data") style:UIBarButtonItemStylePlain target:self action:@selector(barButton)];
    self.navigationItem.rightBarButtonItem = rigItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"WeatherCell" bundle:nil] forCellReuseIdentifier:@"WeatherCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 101;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeatherCell"];
    if (indexPath.row<self.array.count) {
        FBWeatherModel *model = self.array[indexPath.row];
        cell.lab1.text = [NSString stringWithFormat:@"%ld",model.days];
        cell.lab2.text = [NSString stringWithFormat:@"%u",model.Weather];
        cell.lab3.text = [NSString stringWithFormat:@"%ld",model.tempMin];
        cell.lab4.text = [NSString stringWithFormat:@"%ld",model.tempMax];
        cell.lab5.text = [NSString stringWithFormat:@"%u",model.AirCategory];
        cell.lab6.text = [NSString stringWithFormat:@"%u",model.PM2p5];
    }
    return cell;
}

- (void)barButton{
    
    [self getWeatherAndAirLevel];
}


- (void)getWeatherAndAirLevel{
    WeakSelf(self);
    
    [LWNetworkingManager requestURL:@"weather/forecast" httpMethod:GET params:@{} success:^(id  _Nonnull result) {
        
        if ([result[@"code"] integerValue] == 200) {
            NSDictionary *param = result[@"data"];
            weakSelf.textView.text = [NSString stringWithFormat:@"%@", param];
            weakSelf.param = param;
        }
    } failure:^(NSError * _Nonnull error, id  _Nullable responseObject) {
        weakSelf.textView.text = [NSString stringWithFormat:@"%@", error.localizedDescription];
    }];
}


- (void)requestSetWeather {
    WeakSelf(self);
    
    NSMutableString *mutStr = NSMutableString.string;
    
    NSDictionary *current = self.param[@"current"];
    
    FBWeatherDetailsModel *currentModel = [FBWeatherDetailsModel new];
    currentModel.airTemp = [current[@"temperature"] integerValue];
    currentModel.airPressure = [current[@"pressure"] integerValue];
    currentModel.tempMax = [current[@"temp_high"] integerValue];
    currentModel.tempMin = [current[@"temp_low"] integerValue];
    currentModel.Weather = [self returnWeatherForCode:[current[@"code"] integerValue]];
    
    // Set Weather details today｜设置今天的天气详情
    [FBBgCommand.sharedInstance fbPushTodayWeatherDetailsWithModel:currentModel withBlock:^(NSError * _Nullable error) {
        if (error) {
            [mutStr appendFormat:@"%@ ERROR: %@\n\n", LWLocalizbleString(@"Set Weather details today"), error.localizedDescription];
        } else {
            [mutStr appendFormat:@"%@: %@\n\n", LWLocalizbleString(@"Set Weather details today"), LWLocalizbleString(@"Success")];
        }
        weakSelf.textView.text = mutStr;
    }];
    
    
    
    NSArray *forecastWeatherDataArr = self.param[@"forecast"];
    if (forecastWeatherDataArr.count<1) return;
    
    BOOL support_14days_Weather = FBAllConfigObject.firmwareConfig.support_14days_Weather;
    uint8_t maxCount = (support_14days_Weather ? 16 : 7) - 1;
    
    NSMutableArray *array = [NSMutableArray array];
    for (int k = 0; k < forecastWeatherDataArr.count; k++) {
        
        if (k < maxCount) {
            FBWeatherModel *model = FBWeatherModel.new;
            model.days = k+1;
            model.tempMin = [forecastWeatherDataArr[k][@"temp_low"] integerValue];
            model.tempMax = [forecastWeatherDataArr[k][@"temp_high"] integerValue];
            model.Weather = [self returnWeatherForCode:[forecastWeatherDataArr[k][@"code"] integerValue]];
            
            [array addObject:model];
        }
    }
    
    // Set future weather forecast information｜设置未来天气预报信息
    [FBBgCommand.sharedInstance fbPushWeatherMessageWithModel:array withBlock:^(NSError * _Nullable error) {
        if (error) {
            [mutStr appendFormat:@"%@ ERROR: %@\n\n", LWLocalizbleString(@"Set future weather forecast information"), error.localizedDescription];
        } else {
            [mutStr appendFormat:@"%@: %@\n\n", LWLocalizbleString(@"Set future weather forecast information"), LWLocalizbleString(@"Success")];
        }
        weakSelf.textView.text = mutStr;
    }];
}

- (FB_WEATHER)returnWeatherForCode:(NSInteger)code {
    
    switch (code) {
        case 1:// 晴天
            return WT_SUNNY;
            break;
        case 2:// 多云
            return WT_PARTLY_CLOUDY;
            break;
        case 3:// 阴天
            return WT_CLOUDY;
            break;
        case 4:// 阵雨
            return WT_SHOWER;
            break;
        case 5:// 雷阵雨、雷阵雨伴有冰雹
            return WT_THUNDER_SHOWER;
            break;
        case 6:// 小雨
            return WT_LIGHT_RAIN;
            break;
        case 7:// 中雨
            return FBAllConfigObject.firmwareConfig.supportMoreWeather ? WT_MODERATE_RAIN : WT_LIGHT_RAIN;
            break;
        case 8:// 大雨
            return WT_HEAVY_RAIN;
            break;
        case 9:// 暴雨
            return FBAllConfigObject.firmwareConfig.supportMoreWeather ? WT_RAINSTORM : WT_HEAVY_RAIN;
            break;
        case 10:// 雨夹雪、冻雨
            return WT_SLEET;
            break;
        case 11:// 小雪
            return WT_LIGHT_SNOW;
            break;
        case 12:// 大雪
            return WT_HEAVY_SNOW;
            break;
        case 13:// 暴雪
            return WT_HEAVY_SNOW;
            break;
        case 14:// 沙尘暴、浮沉
            return WT_STANDSTORM;
            break;
        case 15:// 雾、雾霾
            return WT_SMOG;
            break;
            
        default:
            return WT_UNKNOW;
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)weatherPush:(id)sender {
    WeakSelf(self);
    [weakSelf requestSetWeather];
}

@end
