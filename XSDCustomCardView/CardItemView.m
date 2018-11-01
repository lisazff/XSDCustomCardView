//
//  CardItemView.m
//  CardListView
//
//  Created by Johnny on 2017/4/26.
//  Copyright © 2017年 Johnny. All rights reserved.
//

#import "CardItemView.h"
#import <objc/runtime.h>

@interface CardItemView ()

@property (assign, nonatomic) CGPoint originalCenter;
@property (assign, nonatomic) CGFloat currentAngle;
@property (assign, nonatomic) BOOL isLeft;

@end

@implementation CardItemView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [self init];
    [self setValue:reuseIdentifier forKey:@"reuseIdentifier"];
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self configure];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.originalCenter = CGPointMake(frame.size.width / 2.0, frame.size.height / 2.0);
}

- (void)configure {
    [self addPanGest];
    [self configLayer];
}

- (void)addPanGest {
    self.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestHandle:)];
    [self addGestureRecognizer:pan];
}

- (void)configLayer {
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
}

- (void)panGestHandle:(UIPanGestureRecognizer *)panGest {
    if (panGest.state == UIGestureRecognizerStateChanged) {
        CGPoint superViewCenter = CGPointMake(self.superview.frame.size.width / 2.0, self.superview.frame.size.height / 2.0);
        CGPoint currentViewCenter = self.center;
        if (self.delegate && [self.delegate respondsToSelector:@selector(cardItemView:moveArea:)]) {
            if (superViewCenter.x - currentViewCenter.x > 0) {
                [self.delegate cardItemView:self moveArea:MoveAreaLeft];
            } else if (superViewCenter.x - currentViewCenter.x == 0) {
                [self.delegate cardItemView:self moveArea:MoveAreaCenter];
            } else if  (superViewCenter.x - currentViewCenter.x < 0) {
                [self.delegate cardItemView:self moveArea:MoveAreaRight];
            } else {
                NSAssert(NO, @" 未知的的位置参数");
            }
        }
        CGPoint movePoint = [panGest translationInView:self];
        _isLeft = (movePoint.x < 0);
        self.center = CGPointMake(self.center.x + movePoint.x, self.center.y + movePoint.y);

        CGFloat angle = (self.center.x - self.frame.size.width / 2.0) / self.frame.size.width / 4.0;
        _currentAngle = angle;
        self.transform = CGAffineTransformMakeRotation(-angle);

        [panGest setTranslation:CGPointZero inView:self];
        if ([self.delegate respondsToSelector:@selector(cardItemViewDidMoveRate:anmate:)]) {
            CGFloat rate = fabs(angle) / 0.15 > 1 ? 1 : fabs(angle) / 0.15;
            [self.delegate cardItemViewDidMoveRate:rate anmate:NO];
        }
    } else if (panGest.state == UIGestureRecognizerStateEnded) {
        CGPoint vel = [panGest velocityInView:self];
        CGPoint endPoint = [panGest locationInView:self.superview];
        CGPoint beginPoint = [panGest.beginPoint CGPointValue];
        if (vel.x > 1000) {
            // 右侧滑动
            if (endPoint.x - beginPoint.x) {
                _isLeft = NO;
            } else {
                _isLeft = YES;
            }
            [self remove];
        } else if (vel.x < -1000){
            // 左侧滑动
            if (endPoint.x - beginPoint.x) {
                _isLeft = YES;
            } else {
                _isLeft = NO;
            }
            [self remove];
        } else {
            if (fabs(beginPoint.x - endPoint.x) < self.frame.size.width * 2.0 / 5.0) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.center = self->_originalCenter;
                    self.transform = CGAffineTransformMakeRotation(0);
                    if ([self.delegate respondsToSelector:@selector(cardItemViewDidMoveRate:anmate:)]) {
                        [self.delegate cardItemViewDidMoveRate:0 anmate:YES];
                    }
                } completion:^(BOOL finished) {
                    if (finished && self.delegate && [self.delegate respondsToSelector:@selector(cardItemView:moveArea:)]) {
                        [self.delegate cardItemView:self moveArea:MoveAreaCenter];
                    }
                }];
            } else {
                if (vel.x <= 1000 && vel.x > 0) {
                    if (endPoint.x - beginPoint.x) {
                        _isLeft = NO;
                    } else {
                        _isLeft = YES;
                    }
                } else if (vel.x >= -1000 && vel.x < 0) {
                    if (endPoint.x - beginPoint.x) {
                        _isLeft = YES;
                    } else {
                        _isLeft = NO;
                    }
                }
                [self remove];
            }
        }
    } else if (panGest.state == UIGestureRecognizerStateBegan) {
        panGest.beginPoint = @([panGest locationInView:self.superview]);
    }
}

- (void)remove {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardItemView:moveArea:)]) {
        [self.delegate cardItemView:self moveArea:MoveAreaCenter];
    }
    [self removeWithLeft:_isLeft];
}

- (void)removeWithLeft:(BOOL)left {
    if ([self.delegate respondsToSelector:@selector(cardItemViewDidMoveRate:anmate:)]) {
        [self.delegate cardItemViewDidMoveRate:1 anmate:YES];
    }
    [UIView animateWithDuration:0.2 animations:^{
        if (!left) {
            self.center = CGPointMake([UIScreen mainScreen].bounds.size.width+self.frame.size.width, self.center.y + self->_currentAngle * self.frame.size.height + (self->_currentAngle == 0 ? 100 : 0));
        } else {
            self.center = CGPointMake(-self.frame.size.width, self.center.y - self->_currentAngle * self.frame.size.height + (self->_currentAngle == 0 ? 100 : 0));
        }
    } completion:^(BOOL finished) {
        if (finished && [self.delegate respondsToSelector:@selector(cardItemView:didRemoveWithDirection:)]) {
            [self.delegate cardItemView:self didRemoveWithDirection:_isLeft == YES ? RemoveRirectionLeft : RemoveRirectionRight];
        }
    }];
}

- (void)prepareForReuse {
    
}

@end

@implementation UIPanGestureRecognizer (Location)

- (void)setBeginPoint:(NSValue *)beginPoint {
    objc_setAssociatedObject(self, @selector(beginPoint), beginPoint, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)beginPoint {
    return objc_getAssociatedObject(self, _cmd);
}

@end
