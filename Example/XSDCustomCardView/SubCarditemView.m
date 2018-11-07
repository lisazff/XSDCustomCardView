//
//  SubCarditemView.m
//  XSDCustomCardView_Example
//
//  Created by mac on 2018/11/3.
//  Copyright © 2018 BetrayalPromise@gmail.com. All rights reserved.
//

#import "SubCarditemView.h"
@import Masonry;

@implementation SubCarditemView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
        [self initView];
        [self createUserInterface];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self createUserInterface];
    }
    return self;
}

- (void)createUserInterface {
    self.backgroundColor = [UIColor colorWithRed:arc4random() % 255/ 255.0 green:arc4random() % 255/ 255.0 blue:arc4random() % 255/ 255.0 alpha:1.0];
    UIImageView * headImageView = [[UIImageView alloc] init];
    [self addSubview:headImageView];
    headImageView.backgroundColor = UIColor.redColor;
    
    UILabel * infoLabel = [[UILabel alloc] init];
    [self addSubview:infoLabel];
    infoLabel.backgroundColor = UIColor.blueColor;
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(30);
    }];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImageView.mas_bottom).mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 30));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}

- (void)configure:(XSDViewModel *)model {
    
}

@end