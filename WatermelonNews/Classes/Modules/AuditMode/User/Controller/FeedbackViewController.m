//
//  FeedbackViewController.m
//  WatermelonNews
//
//  Created by 刘永杰 on 2017/10/24.
//  Copyright © 2017年 刘永杰. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackView.h"
#import "FeedbackApi.h"

@interface FeedbackViewController ()<ResponseDelegate>

@property (strong, nonatomic) FeedbackView *feedbackView;
@property (strong, nonatomic) FeedbackApi *feedbackApi;

@end

@implementation FeedbackViewController

- (void)loadView
{
    [super loadView];
    self.feedbackView = [[FeedbackView alloc] initWithFrame:self.view.frame];
    self.view = self.feedbackView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    self.automaticallyAdjustsScrollViewInsets = NO;
    @kWeakObj(self)
    self.feedbackView.backResult = ^(NSInteger index) {
        
        selfWeak.feedbackApi.contact = selfWeak.feedbackView.contactTextField.text;
        selfWeak.feedbackApi.content = selfWeak.feedbackView.feedbackTextView.text;
        [selfWeak.feedbackApi call];
    };
    
    _feedbackApi = [FeedbackApi new];
    _feedbackApi.delegate = self;
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - ResponseDelegate

- (void)request:(NetworkRequest *)request success:(id)response
{
    [MBProgressHUD showSuccess:@"反馈成功"];
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)request:(NetworkRequest *)request failure:(NSError *)error
{
    [MBProgressHUD showSuccess:@"反馈失败"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
