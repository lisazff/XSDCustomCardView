//
//  SubCarditemView.h
//  XSDCustomCardView_Example
//
//  Created by mac on 2018/11/3.
//  Copyright © 2018 BetrayalPromise@gmail.com. All rights reserved.
//

#import <XSDCustomCardView/XSDCustomCardView.h>
@class XSDViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface SubCarditemView : CardItemView

- (void)configure:(XSDViewModel *)model;

@end

NS_ASSUME_NONNULL_END