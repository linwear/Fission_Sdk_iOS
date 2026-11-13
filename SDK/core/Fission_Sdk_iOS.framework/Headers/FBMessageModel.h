//
//  FBMessageModel.h
//  FissionBluetooth
//
//  Created by 裂变智能 on 2021/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 消息推送开关信息｜Message push switch information
*/
@interface FBMessageModel : NSObject

/**
 没有，其他类型｜No, other types
*/
@property (nonatomic, assign) BOOL none;

/**
 电话｜Telephone
*/
@property (nonatomic, assign) BOOL telephone;

/**
 短信｜SMS
*/
@property (nonatomic, assign) BOOL sms;

/**
 微信｜WeChat
*/
@property (nonatomic, assign) BOOL weChat;

/**
 QQ
*/
@property (nonatomic, assign) BOOL qq;

/**
 脸书｜Facebook
*/
@property (nonatomic, assign) BOOL facebook;

/**
 推特｜Twitter
*/
@property (nonatomic, assign) BOOL twitter;

/**
 领英 | LinkedIn
*/
@property (nonatomic, assign) BOOL linkedIn;

/**
 Whatsapp
*/
@property (nonatomic, assign) BOOL whatsapp;

/**
 Line
*/
@property (nonatomic, assign) BOOL line;

/**
 照片墙｜Instagram
*/
@property (nonatomic, assign) BOOL instagram;

/**
 色拉布｜Snapchat
*/
@property (nonatomic, assign) BOOL snapchat;

/**
 Skype
*/
@property (nonatomic, assign) BOOL skype;

/**
 谷歌邮箱｜Gmail
*/
@property (nonatomic, assign) BOOL gmail;

/**
 Outlook
*/
@property (nonatomic, assign) BOOL outlook;

/**
 Messenger
*/
@property (nonatomic, assign) BOOL messenger;

/**
 Viber
*/
@property (nonatomic, assign) BOOL viber;

/**
 Googletalk
*/
@property (nonatomic, assign) BOOL googletalk;

/**
 Vkontakte
*/
@property (nonatomic, assign) BOOL vkontakte;

/**
 Imo
*/
@property (nonatomic, assign) BOOL imo;

/**
 Imobeta
*/
@property (nonatomic, assign) BOOL imobeta;

/**
 Imolite
*/
@property (nonatomic, assign) BOOL imolite;

/**
 Chatapp
*/
@property (nonatomic, assign) BOOL chatapp;

/**
 Kik
*/
@property (nonatomic, assign) BOOL kik;

/**
 Skred
*/
@property (nonatomic, assign) BOOL skred;

/**
 Telegramx
*/
@property (nonatomic, assign) BOOL telegramx;

/**
 Beechat
*/
@property (nonatomic, assign) BOOL beechat;

/**
 Teamtalk
*/
@property (nonatomic, assign) BOOL teamtalk;

/**
 Kakao
*/
@property (nonatomic, assign) BOOL kakao;

/**
 Ftalk
*/
@property (nonatomic, assign) BOOL ftalk;

/**
 Rimet
*/
@property (nonatomic, assign) BOOL rimet;

/**
 Wework
*/
@property (nonatomic, assign) BOOL wework;

/**
 红包｜Red envelope/Hong Bao
*/
@property (nonatomic, assign) BOOL HongBao;

/**
 Missedcall
*/
@property (nonatomic, assign) BOOL missedcall;

/**
 Calendar
*/
@property (nonatomic, assign) BOOL calendar;

/**
 Applemusic
*/
@property (nonatomic, assign) BOOL applemusic;

/**
 Googlemaps
*/
@property (nonatomic, assign) BOOL googlemaps;

/**
 Likee
*/
@property (nonatomic, assign) BOOL likee;

/**
 Messages
*/
@property (nonatomic, assign) BOOL messages;

/**
 Mono
*/
@property (nonatomic, assign) BOOL mono;

/**
 Odnoklassniki
*/
@property (nonatomic, assign) BOOL odnoklassniki;

/**
 Privat
*/
@property (nonatomic, assign) BOOL privat;

/**
 Youtube
*/
@property (nonatomic, assign) BOOL youtube;

/**
 Youtubemusic
*/
@property (nonatomic, assign) BOOL youtubemusic;

/**
 Zoom
*/
@property (nonatomic, assign) BOOL zoom;

/**
 Telegram
*/
@property (nonatomic, assign) BOOL telegram;

/**
 Tiktok
*/
@property (nonatomic, assign) BOOL tiktok;

/**
 Pinterest
*/
@property (nonatomic, assign) BOOL pinterest;

/**
 未接来电｜Missed call
*/
@property (nonatomic, assign) BOOL missCall;

/**
 discord
*/
@property (nonatomic, assign) BOOL discord;

/**
 whitetb
*/
@property (nonatomic, assign) BOOL whitetb;

/**
 email
*/
@property (nonatomic, assign) BOOL email;

/**
 fastrack_reflex_world
*/
@property (nonatomic, assign) BOOL fastrack_reflex_world;

/**
 inshort
*/
@property (nonatomic, assign) BOOL inshort;

/**
 amazon
*/
@property (nonatomic, assign) BOOL amazon;

/**
 flipkart
*/
@property (nonatomic, assign) BOOL flipkart;

/**
 smartworld
*/
@property (nonatomic, assign) BOOL smartworld;

/**
 postal
*/
@property (nonatomic, assign) BOOL postal;

/**
 Drive
*/
@property (nonatomic, assign) BOOL drive;

/**
 Prime Video
*/
@property (nonatomic, assign) BOOL primeVideo;

/**
 Slack
*/
@property (nonatomic, assign) BOOL slack;

/**
 Spotify
*/
@property (nonatomic, assign) BOOL spotify;

/**
 Uber
*/
@property (nonatomic, assign) BOOL uber;

/**
 Wynk Music
*/
@property (nonatomic, assign) BOOL wynkMusic;

/**
 Yahoo Mail
*/
@property (nonatomic, assign) BOOL yahooMail;

/**
 总开关｜Maste rSwitch
*/
@property (nonatomic, assign) BOOL masterSwitch;

@end

NS_ASSUME_NONNULL_END
