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

@interface XSDViewModel ()

@property (nonatomic, strong) NSMutableArray <XSDModel *> * datas;
@property (nonatomic, assign) pthread_mutex_t mutex;

@property (strong, nonatomic) AVPlayer * player;

@property (nonatomic, weak) SubCarditemView * itemView;

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
    for (NSInteger i = 0; i < 500; i ++) {
        XSDModel * m = [XSDModel new];
        
        if (i % 2 == 0) {
            m.videoURL = @"https://ugcbsy.qq.com/uwMRJfz-r5jAYaQXGdGnC2_ppdhgmrDlPaRvaV7F2Ic/y0363cqqo2d.mp4?sdtfrom=v1010&guid=75a4ffa11295d492b16c20b716aa51ef&vkey=2C9111D94D20D5D2361D77F45593567A0F41708C276BD8C70E786A04D05F3542BBF97E1641767F860FCE556B43336DB482A7C4921092738FEE96ABC7CF18CAF11D31FC44CBD91C80C9BE3182AD509E61764D2AE30C2F187377925A9F6326CF4D64B57C4AC4D547954A450CEAABD29FE1A9A08360F7409042";
        } else if (i % 2 == 1) {
            m.videoURL = @"https://ugcydzd.qq.com/uwMRJfz-r5jAYaQXGdGnC2_ppdhgmrDlPaRvaV7F2Ic/j0305bx8sf1.mp4?sdtfrom=v1010&guid=75a4ffa11295d492b16c20b716aa51ef&vkey=D5BC1A3B8625E605A42A26D7301ACC632D7DEB2BB95AF12A020647EBFA88450D1C168944D0116BA44ED4C3A66E0A3C2202856BF2A4D9A674EED53A1D82F8AAFA45E45C3EBD957F6177260EA68691455B7832537A8C4CECF7A4E28A6C6101793EB12527D5643FCA1D738B13503E51035A6880599F63605E2C";
        }
        [_datas addObject:m];
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
    [itemView configure:_datas[index]];
    return itemView;
}

- (void)cardViewNeedMoreData:(CardView *)cardView {

}

- (void)cardView:(CardView *)cardView cardItemView:(CardItemView *)cardItemView index:(NSInteger)index didRemoveWithDirection:(RemoveRirection)direction {
}

- (void)cardView:(CardView *)cardView didClickItemAtIndex:(NSInteger)index {
    
}

- (void)cardView:(CardView *)cardView cardItemView:(CardItemView *)cardItemView moveArea:(MoveArea)moveArea {
    NSLog(@"%lu", (unsigned long)moveArea);
}

- (void)startWithIndex:(NSInteger)index {
    XSDModel * m = _datas[index];
    AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:m.videoURL]];
    if (self.player) {
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
    } else {
        self.player = [AVPlayer playerWithPlayerItem:playerItem];
    }
    if (_cardView) {
        SubCarditemView * itemView = (SubCarditemView *)[self cardView:_cardView itemViewAtIndex:index];
        itemView.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        itemView.playerLayer.frame = itemView.bounds;
        [itemView.layer addSublayer:itemView.playerLayer];
        [self.player play];
    }
}

@end
