//
//  DetailJopDesCell.m
//  MakeMoney
//
//  Created by yedexiong on 16/10/30.
//  Copyright © 2016年 yoke121. All rights reserved.
//

#import "DetailJopDesCell.h"
#import "HotModel.h"

@interface DetailJopDesCell ()
@property (weak, nonatomic) IBOutlet UILabel *workDesLabel;

@end

@implementation DetailJopDesCell

+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"DetailJopDesCell";
    
    DetailJopDesCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailJopDesCell" owner:nil options:nil] lastObject];
        
    }
    
    
    return cell;
    
}

-(void)setModel:(HotModel *)model
{
    _model = model;
    self.workDesLabel.text = model.job_description;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
