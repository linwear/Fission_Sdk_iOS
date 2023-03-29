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
        @"Facebook",
        @"Twitter",
        @"Linkedln",
        @"Whatsapp",
        @"Line",
        @"Instagram",
        @"Snapchat",
        @"Skype",
        @"Gmail",
        @"Outlook",
        @"Messenger",
        @"Viber",
        @"Googletalk",
        @"Vkontakte",
        @"Imo",
        @"Imobeta",
        @"Imolite",
        @"Chatapp",
        @"Kik",
        @"Skred",
        @"Telegramx",
        @"Beechat",
        @"Teamtalk",
        @"Kakao",
        @"Ftalk",
        @"Rimet",
        @"Wework",
        @"Hongbao",
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
        @"MissCall",
        @"Discord",
        @"Whitetb",
        @"Email",
        @"Fastrack_Reflex_World",
        @"Inshort",
        @"Amazon",
        @"Flipkart",
        @"Smartworld",
        @"Master Switch"
    ];
            
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayData.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PushSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PushSwitchCell"];
    WeakSelf(self);
    cell.pushSwitchStaBlock = ^(BOOL isOn) {
        if (indexPath.row < weakSelf.arrayData.count) {
            [weakSelf reloadCell:nil index:indexPath.row reloadSta:isOn];
            [weakSelf.tableView reloadData];
        }
    };
    if (indexPath.row < self.arrayData.count) {
        cell.cellLab.text = self.arrayData[indexPath.row];
        [self reloadCell:cell index:indexPath.row reloadSta:nil];
    }
    return cell;
}
- (void)reloadCell:(PushSwitchCell*)cell index:(NSInteger)index reloadSta:(BOOL)sta {
    
    if (index >= self.arrayData.count) return;
    
    NSString *title = self.arrayData[index];
    
    if ([title isEqualToString:@"Other"]) {
        if (!cell) {
            self.model.none =sta;
        }else{
            cell.cellSwi.on = self.model.none;
        }
    } else if ([title isEqualToString:@"Telephone"]){
        if (!cell) {
            self.model.telephone =sta;
        }else{
            cell.cellSwi.on = self.model.telephone;
        }
    } else if ([title isEqualToString:@"SMS"]){
        if (!cell) {
            self.model.sms =sta;
        }else{
            cell.cellSwi.on = self.model.sms;
        }
    } else if ([title isEqualToString:@"WeChat"]){
        if (!cell) {
            self.model.weChat =sta;
        }else{
            cell.cellSwi.on = self.model.weChat;
        }
    } else if ([title isEqualToString:@"QQ"]){
        if (!cell) {
            self.model.qq =sta;
        }else{
            cell.cellSwi.on = self.model.qq;
        }
    } else if ([title isEqualToString:@"Facebook"]){
        if (!cell) {
            self.model.facebook =sta;
        }else{
            cell.cellSwi.on = self.model.facebook;
        }
    } else if ([title isEqualToString:@"Twitter"]){
        if (!cell) {
            self.model.twitter =sta;
        }else{
            cell.cellSwi.on = self.model.twitter;
        }
    } else if ([title isEqualToString:@"Linkedln"]){
        if (!cell) {
            self.model.linkedIn =sta;
        }else{
            cell.cellSwi.on = self.model.linkedIn;
        }
    } else if ([title isEqualToString:@"Whatsapp"]){
        if (!cell) {
            self.model.whatsapp =sta;
        }else{
            cell.cellSwi.on = self.model.whatsapp;
        }
    } else if ([title isEqualToString:@"Line"]){
        if (!cell) {
            self.model.line =sta;
        }else{
            cell.cellSwi.on = self.model.line;
        }
    } else if ([title isEqualToString:@"Instagram"]){
        if (!cell) {
            self.model.instagram =sta;
        }else{
            cell.cellSwi.on = self.model.instagram;
        }
    } else if ([title isEqualToString:@"Snapchat"]){
        if (!cell) {
            self.model.snapchat =sta;
        }else{
            cell.cellSwi.on = self.model.snapchat;
        }
    } else if ([title isEqualToString:@"Skype"]){
        if (!cell) {
            self.model.skype =sta;
        }else{
            cell.cellSwi.on = self.model.skype;
        }
    } else if ([title isEqualToString:@"Gmail"]){
        if (!cell) {
            self.model.gmail =sta;
        }else{
            cell.cellSwi.on = self.model.gmail;
        }
    } else if ([title isEqualToString:@"Outlook"]){
        if (!cell) {
            self.model.outlook =sta;
        }else{
            cell.cellSwi.on = self.model.outlook;
        }
    } else if ([title isEqualToString:@"Messenger"]){
        if (!cell) {
            self.model.messenger =sta;
        }else{
            cell.cellSwi.on = self.model.messenger;
        }
    } else if ([title isEqualToString:@"Viber"]){
        if (!cell) {
            self.model.viber =sta;
        }else{
            cell.cellSwi.on = self.model.viber;
        }
    } else if ([title isEqualToString:@"Googletalk"]){
        if (!cell) {
            self.model.googletalk =sta;
        }else{
            cell.cellSwi.on = self.model.googletalk;
        }
    } else if ([title isEqualToString:@"Vkontakte"]){
        if (!cell) {
            self.model.vkontakte =sta;
        }else{
            cell.cellSwi.on = self.model.vkontakte;
        }
    } else if ([title isEqualToString:@"Imo"]){
        if (!cell) {
            self.model.imo =sta;
        }else{
            cell.cellSwi.on = self.model.imo;
        }
    } else if ([title isEqualToString:@"Imobeta"]){
        if (!cell) {
            self.model.imobeta =sta;
        }else{
            cell.cellSwi.on = self.model.imobeta;
        }
    } else if ([title isEqualToString:@"Imolite"]){
        if (!cell) {
            self.model.imolite =sta;
        }else{
            cell.cellSwi.on = self.model.imolite;
        }
    } else if ([title isEqualToString:@"Chatapp"]){
        if (!cell) {
            self.model.chatapp =sta;
        }else{
            cell.cellSwi.on = self.model.chatapp;
        }
    } else if ([title isEqualToString:@"Kik"]){
        if (!cell) {
            self.model.kik =sta;
        }else{
            cell.cellSwi.on = self.model.kik;
        }
    } else if ([title isEqualToString:@"Skred"]){
        if (!cell) {
            self.model.skred =sta;
        }else{
            cell.cellSwi.on = self.model.skred;
        }
    } else if ([title isEqualToString:@"Telegramx"]){
        if (!cell) {
            self.model.telegramx =sta;
        }else{
            cell.cellSwi.on = self.model.telegramx;
        }
    } else if ([title isEqualToString:@"Beechat"]){
        if (!cell) {
            self.model.beechat =sta;
        }else{
            cell.cellSwi.on = self.model.beechat;
        }
    } else if ([title isEqualToString:@"Teamtalk"]){
        if (!cell) {
            self.model.teamtalk =sta;
        }else{
            cell.cellSwi.on = self.model.teamtalk;
        }
    } else if ([title isEqualToString:@"Kakao"]){
        if (!cell) {
            self.model.kakao =sta;
        }else{
            cell.cellSwi.on = self.model.kakao;
        }
    } else if ([title isEqualToString:@"Ftalk"]){
        if (!cell) {
            self.model.ftalk =sta;
        }else{
            cell.cellSwi.on = self.model.ftalk;
        }
    } else if ([title isEqualToString:@"Rimet"]){
        if (!cell) {
            self.model.rimet =sta;
        }else{
            cell.cellSwi.on = self.model.rimet;
        }
    } else if ([title isEqualToString:@"Wework"]){
        if (!cell) {
            self.model.wework =sta;
        }else{
            cell.cellSwi.on = self.model.wework;
        }
    } else if ([title isEqualToString:@"Hongbao"]){
        if (!cell) {
            self.model.HongBao =sta;
        }else{
            cell.cellSwi.on = self.model.HongBao;
        }
    } else if ([title isEqualToString:@"Missedcall"]){
        if (!cell) {
            self.model.missedcall =sta;
        }else{
            cell.cellSwi.on = self.model.missedcall;
        }
    } else if ([title isEqualToString:@"Calendar"]){
        if (!cell) {
            self.model.calendar =sta;
        }else{
            cell.cellSwi.on = self.model.calendar;
        }
    } else if ([title isEqualToString:@"Applemusic"]){
        if (!cell) {
            self.model.applemusic =sta;
        }else{
            cell.cellSwi.on = self.model.applemusic;
        }
    } else if ([title isEqualToString:@"Googlemaps"]){
        if (!cell) {
            self.model.googlemaps =sta;
        }else{
            cell.cellSwi.on = self.model.googlemaps;
        }
    } else if ([title isEqualToString:@"Likee"]){
        if (!cell) {
            self.model.likee =sta;
        }else{
            cell.cellSwi.on = self.model.likee;
        }
    } else if ([title isEqualToString:@"Messages"]){
        if (!cell) {
            self.model.messages =sta;
        }else{
            cell.cellSwi.on = self.model.messages;
        }
    } else if ([title isEqualToString:@"Mono"]){
        if (!cell) {
            self.model.mono =sta;
        }else{
            cell.cellSwi.on = self.model.mono;
        }
    } else if ([title isEqualToString:@"Odnoklassniki"]){
        if (!cell) {
            self.model.odnoklassniki =sta;
        }else{
            cell.cellSwi.on = self.model.odnoklassniki;
        }
    } else if ([title isEqualToString:@"Privat"]){
        if (!cell) {
            self.model.privat =sta;
        }else{
            cell.cellSwi.on = self.model.privat;
        }
    } else if ([title isEqualToString:@"Youtube"]){
        if (!cell) {
            self.model.youtube =sta;
        }else{
            cell.cellSwi.on = self.model.youtube;
        }
    } else if ([title isEqualToString:@"Youtubemusic"]){
        if (!cell) {
            self.model.youtubemusic =sta;
        }else{
            cell.cellSwi.on = self.model.youtubemusic;
        }
    } else if ([title isEqualToString:@"Zoom"]){
        if (!cell) {
            self.model.zoom =sta;
        }else{
            cell.cellSwi.on = self.model.zoom;
        }
    } else if ([title isEqualToString:@"Telegram"]){
        if (!cell) {
            self.model.telegram =sta;
        }else{
            cell.cellSwi.on = self.model.telegram;
        }
    } else if ([title isEqualToString:@"Tiktok"]){
        if (!cell) {
            self.model.tiktok =sta;
        }else{
            cell.cellSwi.on = self.model.tiktok;
        }
    } else if ([title isEqualToString:@"Pinterest"]){
        if (!cell) {
            self.model.pinterest =sta;
        }else{
            cell.cellSwi.on = self.model.pinterest;
        }
    } else if ([title isEqualToString:@"MissCall"]){
        if (!cell) {
            self.model.missCall =sta;
        }else{
            cell.cellSwi.on = self.model.missCall;
        }
    } else if ([title isEqualToString:@"Discord"]){
        if (!cell) {
            self.model.discord =sta;
        }else{
            cell.cellSwi.on = self.model.discord;
        }
    } else if ([title isEqualToString:@"Whitetb"]){
        if (!cell) {
            self.model.whitetb =sta;
        }else{
            cell.cellSwi.on = self.model.whitetb;
        }
    } else if ([title isEqualToString:@"Email"]){
        if (!cell) {
            self.model.email =sta;
        }else{
            cell.cellSwi.on = self.model.email;
        }
    } else if ([title isEqualToString:@"Fastrack_Reflex_World"]){
        if (!cell) {
            self.model.fastrack_reflex_world =sta;
        }else{
            cell.cellSwi.on = self.model.fastrack_reflex_world;
        }
    } else if ([title isEqualToString:@"Inshort"]){
        if (!cell) {
            self.model.inshort =sta;
        }else{
            cell.cellSwi.on = self.model.inshort;
        }
    } else if ([title isEqualToString:@"Amazon"]){
        if (!cell) {
            self.model.amazon =sta;
        }else{
            cell.cellSwi.on = self.model.amazon;
        }
    } else if ([title isEqualToString:@"Flipkart"]){
        if (!cell) {
            self.model.flipkart =sta;
        }else{
            cell.cellSwi.on = self.model.flipkart;
        }
    } else if ([title isEqualToString:@"Smartworld"]){
        if (!cell) {
            self.model.smartworld =sta;
        }else{
            cell.cellSwi.on = self.model.smartworld;
        }
    } else if ([title isEqualToString:@"Master Switch"]){
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
