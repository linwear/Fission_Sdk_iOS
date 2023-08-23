//
//  LWDeviceListCell.m
//  LinWear
//
//  Created by lw on 2020/6/4.
//  Copyright © 2020 lw. All rights reserved.
//

#import "LWDeviceListCell.h"

@interface LWDeviceListCell ()

@property (nonatomic, strong) UILabel *nameLabel; // 手表名称
@property (nonatomic, strong) UILabel *macLabel; // mac地址

@property (nonatomic, strong) UIImageView *signalImgView;

@property (nonatomic, strong) UIButton *connectBtn;
@property (nonatomic, strong) UILabel *connectLabel;

@end

@implementation LWDeviceListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    self.backgroundColor = UIColorWhite;
    
    self.nameLabel = UILabel.new;
    self.nameLabel.font = FONT(16);
    self.nameLabel.textColor = UIColorBlack;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
    }];
    
    self.macLabel = UILabel.new;
    self.macLabel.font = FONT(15);
    self.macLabel.textColor = UIColorGray;
    [self.contentView addSubview:self.macLabel];
    [self.macLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.mas_equalTo(-10);
    }];
    
    self.signalImgView = UIImageView.new;
    [self.contentView addSubview:self.signalImgView];
    [self.signalImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(12);
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    self.connectLabel = UILabel.new;
    self.connectLabel.font = FONT(12);
    self.connectLabel.textColor = UIColorBlue;
    [self.contentView addSubview:self.connectLabel];
    [self.connectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

- (void)reloadView:(FBPeripheralModel *)model {
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ - - %@", model.device_Name, model.RSSI];
    
    self.macLabel.text = [NSString stringWithFormat:@"%@ - - %@", model.mac_Address, model.adapt_Number];

    if (model.RSSI.integerValue > -80) { // 信号好
        self.signalImgView.image = IMAGE_NAME(@"ic_signal_strong");
    } else if (model.RSSI.integerValue > -90) { // 信号中等
        self.signalImgView.image = IMAGE_NAME(@"ic_signal_mid");
    } else {
        self.signalImgView.image = IMAGE_NAME(@"ic_signal_weak");
    }
    
    NSString *pair = model.isPair ? LWLocalizbleString(@"🌺🌺Paired🌺") : @"";
    self.connectLabel.text = pair;
}

@end
