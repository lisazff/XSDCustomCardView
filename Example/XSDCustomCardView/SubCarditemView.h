//
//  SubCarditemView.h
//  XSDCustomCardView_Example
//
//  Created by mac on 2018/11/3.
//  Copyright © 2018 BetrayalPromise@gmail.com. All rights reserved.
//

#import <XSDCustomCardView/XSDCustomCardView.h>
@class XSDModel, XSDViewModel;
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubCarditemView : CardItemView

@property (nonatomic, weak) XSDViewModel * viewModel;
@property (nonatomic, strong, nullable) AVPlayerLayer *playerLayer;
- (void)configure:(XSDModel *)model index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
