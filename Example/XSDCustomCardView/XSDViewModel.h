//
//  XSDViewModel.h
//  XSDCustomCardView_Example
//
//  Created by mac on 2018/11/3.
//  Copyright © 2018 BetrayalPromise@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@import XSDCustomCardView;

@class XSDViewController;

NS_ASSUME_NONNULL_BEGIN

@interface XSDViewModel : NSObject <CardViewDelegate, CardViewDataSource>

@property (nonatomic, weak) XSDViewController *controller;

+ (instancetype)attachController:(XSDViewController *)controller;

@end

NS_ASSUME_NONNULL_END
