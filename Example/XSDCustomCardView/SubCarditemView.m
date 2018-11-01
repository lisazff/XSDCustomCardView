//
//  SubCarditemView.m
//  XSDCustomCardView_Example
//
//  Created by mac on 2018/11/3.
//  Copyright © 2018 BetrayalPromise@gmail.com. All rights reserved.
//

#import "SubCarditemView.h"
@import Masonry;
#import <AVFoundation/AVFoundation.h>
#import "XSDModel.h"
@import SDWebImage;
#import "XSDViewModel.h"

@interface SubCarditemView ()

@property (nonatomic, strong) UIImageView * headImageView;

@end

@implementation SubCarditemView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createUserInterface];
        [self configure];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)createUserInterface {
    self.backgroundColor = [UIColor colorWithRed:arc4random() % 255/ 255.0 green:arc4random() % 255/ 255.0 blue:arc4random() % 255/ 255.0 alpha:1.0];
    UIImageView * headImageView = [[UIImageView alloc] init];
    _headImageView = headImageView;
    [self addSubview:headImageView];
    headImageView.backgroundColor = UIColor.redColor;
    
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(20, 10, 20, 10));
    }];
}

- (void)configure:(XSDModel *)model index:(NSInteger)index {
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
}

- (void)prepareForReuse {

}

@end
