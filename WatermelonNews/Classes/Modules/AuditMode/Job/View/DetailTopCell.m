//
//  DetailTopCell.m
//  MakeMoney
//
//  Created by yedexiong on 2017/2/8.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "DetailTopCell.h"
#import "HotModel.h"
#import "DateRequest.h"

@interface DetailTopCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *browse;
@end

@implementation DetailTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(HotModel *)model
{
    _model = model;
    self.title.text = model.title;
    self.location.text = model.location;
    self.date.text = [DateRequest getTime:model.date];
    self.price.text = model.reward;
    self.browse.text = model.browser;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
