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
#import <AVFoundation/AVFoundation.h>
#import "GKNetworking.h"

@interface XSDViewModel ()

@property (nonatomic, strong) NSMutableArray <XSDModel *> * datas;
@property (nonatomic, assign) pthread_mutex_t mutex;

@property (strong, nonatomic) AVPlayer * player;

@property (nonatomic, assign) NSInteger page;

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
    _page = 1;
    pthread_mutex_init(&_mutex, NULL);
    _datas = [NSMutableArray array];
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
    itemView.viewModel = self;
    [itemView configure:_datas[index] index:index];
    return itemView;
}

- (void)cardViewNeedMoreData:(CardView *)cardView {
     [self loadMore];
}

- (void)cardView:(CardView *)cardView appearCardItemView:(__kindof CardItemView *)cardItemView appearIndex:(NSInteger)index {
    [self startWithIndex:index carditemView:cardItemView];
}

- (void)cardView:(CardView *)cardView dismissCardItemView:(__kindof CardItemView *)cardItemView index:(NSInteger)index didRemoveWithDirection:(RemoveRirection)direction {
    SubCarditemView * v = (SubCarditemView *)cardItemView;
    [v.playerLayer removeFromSuperlayer];
    v.playerLayer = nil;
}

- (void)startWithIndex:(NSInteger)index carditemView:(__kindof CardItemView *)carditemView {
    if (index == -1) {
        return;
    }
    XSDModel * m = _datas[index];
    AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:m.videoURL]];
    if (self.player) {
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
    } else {
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    SubCarditemView * view = (SubCarditemView *)carditemView;
    view.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    view.playerLayer.frame = view.bounds;
    [view.layer addSublayer:view.playerLayer];
    [self.player play];
}

- (void)loadMore {
    [self loadModeDataSuccess:nil failure:nil];
}

- (void)loadModeDataSuccess:(void(^)(id s))success failure:(void(^)(id f))failure {
    NSString *url = @"http://c.tieba.baidu.com/c/f/nani/recommend/list";
    [GKNetworking get:url params:@{@"pn": @(_page)} success:^(id  _Nonnull responseObject) {
        pthread_mutex_lock(&(self->_mutex));
        for (NSInteger i = 0; i < 10; i ++) {
            XSDModel * m = [XSDModel new];
            if (i % 3 == 0) {
                m.videoURL = @"http://tb-video.bdstatic.com/tieba-smallvideo-transcode/13_ef7eb591d50666a0239f3b31587e73a7_1.mp4";
                m.imageURL = @"https://goss1.vcg.com/creative/vcg/800/new/gic19998843.jpg";
            } else if (i % 3 == 1) {
                m.videoURL = @"http://tb-video.bdstatic.com/tieba-smallvideo-transcode/3510416_59d5a0eab109faa3c92506fdb0df686a_0.mp4";
                m.imageURL = @"https://goss4.vcg.com/creative/vcg/800/new/gic15681475.jpg";
            } else if (i % 3 == 2) {
                m.videoURL = @"http://tb-video.bdstatic.com/tieba-smallvideo-transcode/10_90e3fdfacc18bb02fd70006296242150_1.mp4";
                m.imageURL = @"https://goss.vcg.com/creative/vcg/800/version23/VCG21d5d799668.jpg";
            }
            [self.datas addObject:m];
        }
        pthread_mutex_unlock(&(self->_mutex));
        !self.cardView ?: [self.cardView reloadData];
        !success ?: success(responseObject);
        self.page ++;
    } failure:^(NSError * _Nonnull error) {
        !failure ?: failure(error);
    }];
}

- (void)dealloc {
    pthread_mutex_destroy(&(_mutex));
}

@end
