//
//  ExchangeMainViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/11/30.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "ExchangeMainViewController.h"
#import "ExchangeViewController.h"
#import "ExchangeStatusViewController.h"
#import "CheckMoneyApi.h"

@interface ExchangeMainViewController () <ResponseDelegate>

@property (strong, nonatomic) ExchangeViewController *exchangeVC;
@property (strong, nonatomic) ExchangeStatusViewController *statusVC;
@property (strong, nonatomic) CheckMoneyApi *checkApi;

@end

@implementation ExchangeMainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_checkApi call];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.statusVC = [[ExchangeStatusViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self addChildViewController:self.statusVC];
    [self.view addSubview:self.statusVC.view];
    
    self.exchangeVC = [ExchangeViewController new];
    [self addChildViewController:self.exchangeVC];
    [self.view addSubview:self.exchangeVC.view];
    
    _checkApi = [CheckMoneyApi new];
    _checkApi.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkAction) name:@"check" object:nil];
}

- (void)checkAction
{
    [_checkApi call];
}

- (void)request:(NetworkRequest *)request success:(id)response
{
    if ([request.url containsString:getCheckMoneyUrl]) {
        
        StatusModel *model = [StatusModel mj_objectWithKeyValues:response];
        if ([model.type isEqualToString:@"-1"]) {
            [self transitionFromViewController:self.statusVC toViewController:self.exchangeVC duration:0 options:(UIViewAnimationOptionTransitionNone) animations:nil completion:nil];
        } else {
            self.statusVC.model = model;
            [self transitionFromViewController:self.exchangeVC toViewController:self.statusVC duration:0 options:(UIViewAnimationOptionTransitionNone) animations:nil completion:nil];
        }
    }
    
}

- (void)request:(NetworkRequest *)request failure:(NSError *)error
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
