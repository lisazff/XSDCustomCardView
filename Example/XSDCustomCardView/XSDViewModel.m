//
//  XSDViewModel.m
//  XSDCustomCardView_Example
//
//  Created by mac on 2018/11/3.
//  Copyright © 2018 BetrayalPromise@gmail.com. All rights reserved.
//

#import "XSDViewModel.h"
#import "XSDModel.h"
#import "SubCarditemView.h"
#import <pthread.h>
#import "XSDViewController.h"

@interface XSDViewModel ()

@property (nonatomic, strong) NSMutableArray <XSDModel *> * datas;
@property (nonatomic, assign) pthread_mutex_t mutex;

@end

@implementation XSDViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [self handleValue];
    }
    return self;
}

- (void)handleValue {
    pthread_mutex_init(&_mutex, NULL);
    
     _datas = [NSMutableArray array];
    for (NSInteger i = 0; i < 100; i ++) {
        [_datas addObject:[XSDModel new]];
    }
}

- (void)updateCardDataSouce {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-value"
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        _controller ?: [_controller performSelector:@selector(updateDataSource)];
#pragma clang diagnostic pop
#pragma clang diagnostic pop
}


+ (instancetype)attachController:(__kindof UIViewController *)controller {
    XSDViewModel * viewModel = [[[self class] alloc] init];
    viewModel.controller = controller;
    return viewModel;
}

- (NSInteger)numberOfItemViewsInCardView:(CardView *)cardView {
    return _datas.count;
}

- (CardItemView *)cardView:(CardView *)cardView itemViewAtIndex:(NSInteger)index {
    SubCarditemView *itemView = (SubCarditemView *)[cardView dequeueReusableCellWithIdentifier:NSStringFromClass(SubCarditemView.class)];
    if (itemView == nil) {
        itemView = [[SubCarditemView alloc] initWithReuseIdentifier:NSStringFromClass(SubCarditemView.class)];
    }
    return itemView;
}

- (void)cardViewNeedMoreData:(CardView *)cardView {

}

- (void)cardItemViewDidRemoveFromSuperView:(CardItemView *)CardItemView {
    [_controller animationForButton];
}

- (void)cardItemViewDidMoveRate:(CGFloat)rate anmate:(BOOL)anmate {
    
}


@end
