//
//  SpecialDetailListCell.m
//  MakeMoney
//
//  Created by yedexiong on 2017/2/10.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "SpecialDetailListCell.h"
#import "EpisodeModel.h"

@interface SpecialDetailListCell ()
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end

@implementation SpecialDetailListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(EpisodeModel *)model
{
    _model = model;
    self.title.text = model.title;
    self.playCount.text = [model.play_count stringValue];
    self.date.text = model.date;
    
    if (model.isPlay) {
        self.playBtn.selected = YES;
    }else{
        self.playBtn.selected = NO;
    }
}

- (IBAction)playBtnClick:(UIButton *)sender {
    
  
    if (self.playBtnClick) {
        self.playBtnClick(self.model);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
