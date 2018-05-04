//
//  FMListCell.m
//  MakeMoney
//
//  Created by yedexiong on 2017/2/9.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "FMListCell.h"
#import "FMListModel.h"

@interface FMListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *des;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@property (weak, nonatomic) IBOutlet UILabel *fmCount;

@end

@implementation FMListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(FMListModel *)model
{
    _model = model;
    
    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.icon_url] placeholderImage:nil];
    self.title.text = model.title;
    self.des.text = model.brief;
    self.playCount.text = model.play_count;
    self.fmCount.text = model.episode_count;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
