//
//  CardItemView.h
//  CardListView
//
//  Created by Johnny on 2017/4/26.
//  Copyright © 2017年 Johnny. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 移除方向
typedef NS_ENUM(NSUInteger, RemoveRirection) {
    RemoveRirectionLeft,
    RemoveRirectionRight,
};
/// 拖动区域
typedef NS_ENUM(NSUInteger, MoveArea) {
    MoveAreaCenter,
    MoveAreaLeft,
    MoveAreaRight,
};

@class CardItemView;

@protocol CardItemViewDelegate <NSObject>
- (void)cardItemView:(CardItemView *)cardItemView didRemoveWithDirection:(RemoveRirection)direction;
- (void)cardItemViewDidMoveRate:(CGFloat)rate anmate:(BOOL)anmate;
- (void)cardItemView:(CardItemView *)cardItemView moveArea:(MoveArea)moveArea;

@end

@interface CardItemView : UIView

@property (weak, nonatomic) id<CardItemViewDelegate> delegate;
@property (nonatomic, readonly, copy) NSString * reuseIdentifier;

- (void)configure;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)removeWithLeft:(BOOL)left;
- (void)prepareForReuse;

@end


@interface UIPanGestureRecognizer (Location)

@property (nonatomic, strong) NSValue * beginPoint;

@end
