//
//  CardView.h
//  CardView
//
//  Created by Johnny on 2017/4/26.
//  Copyright © 2017年 Johnny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardItemView.h"

@class CardView;

@protocol CardViewDelegate <NSObject>

@optional
- (void)cardView:(CardView *)cardView didClickItemAtIndex:(NSInteger)index;
- (void)cardView:(CardView *)cardView cardItemView:(CardItemView *)cardItemView index:(NSInteger)index didRemoveWithDirection:(RemoveRirection)direction;
- (void)cardView:(CardView *)cardView cardItemView:(CardItemView *)cardItemView moveArea:(MoveArea)moveArea;

// TODO: 待添加的钩子
- (void)cardView:(CardView *)cardView appearIndex:(NSInteger)index;
- (void)cardView:(CardView *)cardView dismissIndex:(NSInteger)index;

@end

@protocol CardViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemViewsInCardView:(CardView *)cardView;
- (CardItemView *)cardView:(CardView *)cardView itemViewAtIndex:(NSInteger)index;
- (void)cardViewNeedMoreData:(CardView *)cardView;

@optional
- (CGSize)cardView:(CardView *)cardView sizeForItemViewAtIndex:(NSInteger)index;

@end

@interface CardView : UIView

@property (nonatomic, weak) id <CardViewDataSource> dataSource;
@property (nonatomic, weak) id <CardViewDelegate> delegate;

- (__kindof CardItemView *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)deleteTheTopItemViewWithLeft:(BOOL)left;
- (void)reloadData;

@end
