//
//  InformResultViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/17.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "InformResultViewController.h"
#import "InformResultView.h"
#import "NewsDetailViewController.h"
#import "TimelineDetailViewController.h"
#import "PersonalViewController.h"

@interface InformResultViewController ()

@property (strong, nonatomic) InformResultView *resultView;


@end

@implementation InformResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.resultView = [InformResultView new];
    [self.view addSubview:self.resultView];
    
    @kWeakObj(self)
    self.resultView.backResult = ^(NSInteger index) {
        
        for (UIViewController *indexVC in selfWeak.navigationController.viewControllers) {
            
            if ([indexVC isKindOfClass:[NewsDetailViewController class]] || [indexVC isKindOfClass:[TimelineDetailViewController class]] || [indexVC isKindOfClass:[PersonalViewController class]]) {
                
                [selfWeak.navigationController popToViewController:indexVC animated:YES];
            }
        }
        
    };
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
