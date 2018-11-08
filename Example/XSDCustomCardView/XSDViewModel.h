//
//  XSDViewModel.h
//  XSDCustomCardView_Example
//
//  Created by mac on 2018/11/3.
//  Copyright © 2018 BetrayalPromise@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@import XSDCustomCardView;

@class XSDViewController, CardItemView;

NS_ASSUME_NONNULL_BEGIN

@interface XSDViewModel : NSObject <CardViewDelegate, CardViewDataSource>

@property (nonatomic, weak) XSDViewController *controller;
@property (nonatomic, weak) CardView * cardView;

+ (instancetype)attachController:(XSDViewController *)controller;
- (void)startWithIndex:(NSInteger)index carditemView:(__kindof CardItemView *)carditemView;

@end

NS_ASSUME_NONNULL_END
