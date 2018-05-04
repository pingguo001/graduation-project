//
//  DetailsecondCell.m
//  MakeMoney
//
//  Created by yedexiong on 16/10/29.
//  Copyright © 2016年 yoke121. All rights reserved.
//

#import "DetailsecondCell.h"
#import "HotModel.h"

@interface DetailsecondCell ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *contact;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UILabel *workTime;

@end

@implementation DetailsecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"DetailsecondCell";
    
    DetailsecondCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailsecondCell" owner:nil options:nil] lastObject];
        
    }
    
    
    return cell;
    
}

-(void)setModel:(HotModel *)model
{
    _model =model;
    
    self.contact.text = [self randomPhoneNumber];
    self.price.text = model.reward;
  
    self.workTime.text = model.working_time;
    self.company.text = model.working_time;
    self.count.text = model.hire_count;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex > 0) {
        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.model.hr_tel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    }
}

- (NSString *)randomPhoneNumber {
    NSString *number = @"1";
    NSString *a = [_model.reward substringToIndex:1];
    if ([a isEqualToString:@"0"]) {
        number = [number stringByAppendingString:@"3"];
    } else if ([a isEqualToString:@"8"]) {
        number = [number stringByAppendingString:@"5"];
    } else{
        number = [number stringByAppendingString:@"8"];
    }
    NSString *b = [_model.date substringWithRange:NSMakeRange(9,1)];
    NSString *c = [_model.date substringWithRange:NSMakeRange(6,1)];
    NSString *d = [_model.date substringWithRange:NSMakeRange(8,1)];
    NSString *e = [_model.working_time substringWithRange:NSMakeRange(0,2)];
    NSString *f = [_model.working_time substringWithRange:NSMakeRange(6,2)];
    NSString *g = [_model.reward substringWithRange:NSMakeRange(0,2)];
    number = [number stringByAppendingString:b];
    number = [number stringByAppendingString:c];
    number = [number stringByAppendingString:d];
    number = [number stringByAppendingString:e];
    number = [number stringByAppendingString:f];
    number = [number stringByAppendingString:g];
    return number;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
