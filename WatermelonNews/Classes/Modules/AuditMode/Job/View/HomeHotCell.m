//
//  HomeHotCell.m
//  MakeMoney
//
//  Created by yedexiong on 16/10/29.
//  Copyright © 2016年 yoke121. All rights reserved.
//

#import "HomeHotCell.h"
#import "HotModel.h"
#import "DateRequest.h"

@interface HomeHotCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *loactionLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLale;
@property (weak, nonatomic) IBOutlet UILabel *browseLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation HomeHotCell


+(instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *ID = @"HomeHotCell";
    
    HomeHotCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HomeHotCell" owner:nil options:nil] lastObject];
        
    }
    
    
    return cell;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
   self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(HotModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.title;
    self.loactionLabel.text = model.location;
    self.timeLale.text = [DateRequest getTime:model.date];
    self.browseLabel.text = model.browser;
    if (model.price) {
        self.priceLabel.attributedText = model.price;
    }else{
        self.priceLabel.text = model.reward;
    }
    
    self.icon.image = [UIImage imageNamed:model.iconImageName];
   
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
