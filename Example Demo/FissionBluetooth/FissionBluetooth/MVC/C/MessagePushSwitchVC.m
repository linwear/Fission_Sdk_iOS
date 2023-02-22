//
//  MessagePushSwitchVC.m
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/1/21.
//

#import "MessagePushSwitchVC.h"
#import "PushSwitchCell.h"

@interface MessagePushSwitchVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *arrayData;

@property (nonatomic, retain) FBMessageModel *model;

@end

@implementation MessagePushSwitchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.model = [FBMessageModel new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"PushSwitchCell" bundle:nil] forCellReuseIdentifier:@"PushSwitchCell"];
    
    self.arrayData = @[
        @"Other",
        @"Telephone",
        @"SMS",
        @"WeChat",
        @"QQ",
        @"facebook",
        @"Twitter",
        @"linkedln",
        @"Whatsapp",
        @"line",
        @"instagram",
        @"snapchat",
        @"skype",
        @"gmail",
        @"outlook",
        @"messenger",
        @"viber",
        @"googletalk",
        @"vkontakte",
        @"imo",
        @"imobeta",
        @"imolite",
        @"chatapp",
        @"kik",
        @"skred",
        @"telegramx",
        @"beechat",
        @"teamtalk",
        @"kakao",
        @"ftalk",
        @"rimet",
        @"wework",
        @"hongbao",
        @"Missedcall",
        @"Calendar",
        @"Applemusic",
        @"Googlemaps",
        @"Likee",
        @"Messages",
        @"Mono",
        @"Odnoklassniki",
        @"Privat",
        @"Youtube",
        @"Youtubemusic",
        @"Zoom",
        @"Telegram",
        @"Tiktok",
        @"Pinterest",
        @"Master Switch"
    ];
            
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayData.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PushSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PushSwitchCell"];
    __weak typeof(self)weakSelf = self;
    cell.pushSwitchStaBlock = ^(BOOL isOn) {
        [weakSelf reloadCell:nil index:indexPath.row reloadSta:isOn];
        [weakSelf.tableView reloadData];
    };
    cell.cellLab.text = self.arrayData[indexPath.row];
    [self reloadCell:cell index:indexPath.row reloadSta:nil];
    return cell;
}
- (void)reloadCell:(PushSwitchCell*)cell index:(NSInteger)index reloadSta:(BOOL)sta{
    if (index==0) {
        if (!cell) {
            self.model.none =sta;
        }else{
            cell.cellSwi.on = self.model.none;
        }
    } else if (index==1){
        if (!cell) {
            self.model.telephone =sta;
        }else{
            cell.cellSwi.on = self.model.telephone;
        }
    } else if (index==2){
        if (!cell) {
            self.model.sms =sta;
        }else{
            cell.cellSwi.on = self.model.sms;
        }
    } else if (index==3){
        if (!cell) {
            self.model.weChat =sta;
        }else{
            cell.cellSwi.on = self.model.weChat;
        }
    } else if (index==4){
        if (!cell) {
            self.model.qq =sta;
        }else{
            cell.cellSwi.on = self.model.qq;
        }
    } else if (index==5){
        if (!cell) {
            self.model.facebook =sta;
        }else{
            cell.cellSwi.on = self.model.facebook;
        }
    } else if (index==6){
        if (!cell) {
            self.model.twitter =sta;
        }else{
            cell.cellSwi.on = self.model.twitter;
        }
    } else if (index==7){
        if (!cell) {
            self.model.linkedIn =sta;
        }else{
            cell.cellSwi.on = self.model.linkedIn;
        }
    } else if (index==8){
        if (!cell) {
            self.model.whatsapp =sta;
        }else{
            cell.cellSwi.on = self.model.whatsapp;
        }
    } else if (index==9){
        if (!cell) {
            self.model.line =sta;
        }else{
            cell.cellSwi.on = self.model.line;
        }
    } else if (index==10){
        if (!cell) {
            self.model.instagram =sta;
        }else{
            cell.cellSwi.on = self.model.instagram;
        }
    } else if (index==11){
        if (!cell) {
            self.model.snapchat =sta;
        }else{
            cell.cellSwi.on = self.model.snapchat;
        }
    } else if (index==12){
        if (!cell) {
            self.model.skype =sta;
        }else{
            cell.cellSwi.on = self.model.skype;
        }
    } else if (index==13){
        if (!cell) {
            self.model.gmail =sta;
        }else{
            cell.cellSwi.on = self.model.gmail;
        }
    } else if (index==14){
        if (!cell) {
            self.model.outlook =sta;
        }else{
            cell.cellSwi.on = self.model.outlook;
        }
    } else if (index==15){
        if (!cell) {
            self.model.messenger =sta;
        }else{
            cell.cellSwi.on = self.model.messenger;
        }
    } else if (index==16){
        if (!cell) {
            self.model.viber =sta;
        }else{
            cell.cellSwi.on = self.model.viber;
        }
    } else if (index==17){
        if (!cell) {
            self.model.googletalk =sta;
        }else{
            cell.cellSwi.on = self.model.googletalk;
        }
    } else if (index==18){
        if (!cell) {
            self.model.vkontakte =sta;
        }else{
            cell.cellSwi.on = self.model.vkontakte;
        }
    } else if (index==19){
        if (!cell) {
            self.model.imo =sta;
        }else{
            cell.cellSwi.on = self.model.imo;
        }
    } else if (index==20){
        if (!cell) {
            self.model.imobeta =sta;
        }else{
            cell.cellSwi.on = self.model.imobeta;
        }
    } else if (index==21){
        if (!cell) {
            self.model.imolite =sta;
        }else{
            cell.cellSwi.on = self.model.imolite;
        }
    } else if (index==22){
        if (!cell) {
            self.model.chatapp =sta;
        }else{
            cell.cellSwi.on = self.model.chatapp;
        }
    } else if (index==23){
        if (!cell) {
            self.model.kik =sta;
        }else{
            cell.cellSwi.on = self.model.kik;
        }
    } else if (index==24){
        if (!cell) {
            self.model.skred =sta;
        }else{
            cell.cellSwi.on = self.model.skred;
        }
    } else if (index==25){
        if (!cell) {
            self.model.telegramx =sta;
        }else{
            cell.cellSwi.on = self.model.telegramx;
        }
    } else if (index==26){
        if (!cell) {
            self.model.beechat =sta;
        }else{
            cell.cellSwi.on = self.model.beechat;
        }
    } else if (index==27){
        if (!cell) {
            self.model.teamtalk =sta;
        }else{
            cell.cellSwi.on = self.model.teamtalk;
        }
    } else if (index==28){
        if (!cell) {
            self.model.kakao =sta;
        }else{
            cell.cellSwi.on = self.model.kakao;
        }
    } else if (index==29){
        if (!cell) {
            self.model.ftalk =sta;
        }else{
            cell.cellSwi.on = self.model.ftalk;
        }
    } else if (index==30){
        if (!cell) {
            self.model.rimet =sta;
        }else{
            cell.cellSwi.on = self.model.rimet;
        }
    } else if (index==31){
        if (!cell) {
            self.model.wework =sta;
        }else{
            cell.cellSwi.on = self.model.wework;
        }
    } else if (index==32){
        if (!cell) {
            self.model.HongBao =sta;
        }else{
            cell.cellSwi.on = self.model.HongBao;
        }
    } else if (index==33){
        if (!cell) {
            self.model.missedcall =sta;
        }else{
            cell.cellSwi.on = self.model.missedcall;
        }
    } else if (index==34){
        if (!cell) {
            self.model.calendar =sta;
        }else{
            cell.cellSwi.on = self.model.calendar;
        }
    } else if (index==35){
        if (!cell) {
            self.model.applemusic =sta;
        }else{
            cell.cellSwi.on = self.model.applemusic;
        }
    } else if (index==36){
        if (!cell) {
            self.model.googlemaps =sta;
        }else{
            cell.cellSwi.on = self.model.googlemaps;
        }
    } else if (index==37){
        if (!cell) {
            self.model.likee =sta;
        }else{
            cell.cellSwi.on = self.model.likee;
        }
    } else if (index==38){
        if (!cell) {
            self.model.messages =sta;
        }else{
            cell.cellSwi.on = self.model.messages;
        }
    } else if (index==39){
        if (!cell) {
            self.model.mono =sta;
        }else{
            cell.cellSwi.on = self.model.mono;
        }
    } else if (index==40){
        if (!cell) {
            self.model.odnoklassniki =sta;
        }else{
            cell.cellSwi.on = self.model.odnoklassniki;
        }
    } else if (index==41){
        if (!cell) {
            self.model.privat =sta;
        }else{
            cell.cellSwi.on = self.model.privat;
        }
    } else if (index==42){
        if (!cell) {
            self.model.youtube =sta;
        }else{
            cell.cellSwi.on = self.model.youtube;
        }
    } else if (index==43){
        if (!cell) {
            self.model.youtubemusic =sta;
        }else{
            cell.cellSwi.on = self.model.youtubemusic;
        }
    } else if (index==44){
        if (!cell) {
            self.model.zoom =sta;
        }else{
            cell.cellSwi.on = self.model.zoom;
        }
    } else if (index==45){
        if (!cell) {
            self.model.telegram =sta;
        }else{
            cell.cellSwi.on = self.model.telegram;
        }
    } else if (index==46){
        if (!cell) {
            self.model.tiktok =sta;
        }else{
            cell.cellSwi.on = self.model.tiktok;
        }
    } else if (index==47){
        if (!cell) {
            self.model.pinterest =sta;
        }else{
            cell.cellSwi.on = self.model.pinterest;
        }
    } else if (index==48){
        if (!cell) {
            self.model.masterSwitch =sta;
        }else{
            cell.cellSwi.on = self.model.masterSwitch;
        }
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
- (IBAction)setPushSwi:(id)sender {
    WeakSelf(self);
    FBMessageModel *model = self.model;
    [FBBgCommand.sharedInstance fbSetMessagePushSwitchWithData:model withBlock:^(NSError * _Nullable error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        } else {
            weakSelf.textView.text = LWLocalizbleString(@"Success");
        }
    }] ;
}
- (IBAction)getPushSwi:(id)sender {
    WeakSelf(self);
    [FBBgCommand.sharedInstance fbGetMessagePushSwitchWithBlock:^(FB_RET_CMD status, float progress, FBMessageModel * _Nonnull responseObject, NSError * _Nonnull error) {
        if (error) {
            [NSObject showHUDText:[NSString stringWithFormat:@"%@", error]];
        } else if (status==FB_INDATATRANSMISSION) {
            weakSelf.textView.text = [NSString stringWithFormat:@"Receiving Progress: %.f%%", progress*100];
        } else if (status==FB_DATATRANSMISSIONDONE) {
            weakSelf.model = responseObject;
            weakSelf.textView.text = [NSString stringWithFormat:@"%@",[responseObject mj_JSONObject]];
            [weakSelf.tableView reloadData];
        }
    }] ;
}




@end
