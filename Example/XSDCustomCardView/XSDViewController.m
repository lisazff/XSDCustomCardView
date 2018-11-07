//
//  XSDViewController.m
//  XSDCustomCardView
//
//  Created by BetrayalPromise@gmail.com on 11/03/2018.
//  Copyright (c) 2018 BetrayalPromise@gmail.com. All rights reserved.
//

#import "XSDViewController.h"
#import "XSDViewModel.h"
#import "SubCarditemView.h"

@import XSDCustomCardView;
@import Masonry;

@interface XSDViewController () 

@property (nonatomic, strong) XSDViewModel * viewModel;
@property (nonatomic, strong) CardView * cardView;

@end

@implementation XSDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewModel = [XSDViewModel attachController:self];
    
    CardView * cardView = [CardView new];
    _cardView = cardView;
    [self.view addSubview:cardView];
    cardView.backgroundColor = [UIColor lightGrayColor];
    cardView.delegate = _viewModel;
    cardView.dataSource = _viewModel;
    _viewModel.cardView = cardView;
    
    UIButton * button0 = [[UIButton alloc] init];
    button0.tag = 0;
    button0.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:button0];
    [button0 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIButton * button1 = [[UIButton alloc] init];
    button1.tag = 1;
    button1.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(handleButtonEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300, 400));
        make.top.equalTo(self.view).mas_offset(80);
        make.centerX.equalTo(self.view);
    }];
    
    [button0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cardView.mas_bottom).mas_offset(50);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.equalTo(self.view.mas_centerX).mas_offset(-50);
    }];
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cardView.mas_bottom).mas_offset(50);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.equalTo(self.view.mas_centerX).mas_offset(50);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)handleButtonEvent:(UIButton *)button {
    if (button.tag == 0) {
        [_cardView reloadData];
    } else {
        [_viewModel startWithIndex:0];
    }
}

- (void)updateDataSource {
    [_cardView reloadData];
}

- (void)animationForButton {
    
}

@end
