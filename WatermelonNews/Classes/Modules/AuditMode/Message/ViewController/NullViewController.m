//
//  NullViewController.m
//  WaterMelonHeadline
//
//  Created by 王海玉 on 2017/10/13.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "NullViewController.h"
#import "masonry.h"

@interface NullViewController ()

@end

@implementation NullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *nulLable = [[UILabel alloc]init];
    nulLable.text = @"暂无更多消息";
    [self.view addSubview:nulLable];
    
    [nulLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
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
