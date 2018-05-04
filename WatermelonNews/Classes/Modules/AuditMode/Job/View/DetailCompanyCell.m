//
//  DetailCompanyCell.m
//  MakeMoney
//
//  Created by yedexiong on 16/10/30.
//  Copyright © 2016年 yoke121. All rights reserved.
//

#import "DetailCompanyCell.h"
#import "HotModel.h"

@interface DetailCompanyCell ()
@property (weak, nonatomic) IBOutlet UILabel *companyScale;
@property (weak, nonatomic) IBOutlet UILabel *companyType;
@property (weak, nonatomic) IBOutlet UILabel *companyIndustry;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *companyInfo;
@property (weak, nonatomic) IBOutlet UIButton *feedbackBtn;

@end

@implementation DetailCompanyCell

+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"DetailCompanyCell";
    
    DetailCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DetailCompanyCell" owner:nil options:nil] lastObject];
        
    }
    
    
    return cell;
    
}

-(void)setModel:(HotModel *)model
{
    _model = model;
    
    self.companyType.text = model.company_type;
    self.companyIndustry.text = model.industry;
    self.location.text = model.company_address;
    self.companyScale.text = model.corporate_size;
    self.companyInfo.text = model.company_intro;
    [self.companyInfo sizeToFit];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.feedbackBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.feedbackBtn.layer.borderWidth = 1;
    
}
- (IBAction)feedbackBtnClick:(id)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
