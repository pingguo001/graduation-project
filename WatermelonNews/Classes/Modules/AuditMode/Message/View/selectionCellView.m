//
//  selectionCellView.m
//  WaterMelonHeadline
//
//  Created by 王海玉 on 2017/9/30.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "selectionCellView.h"
#import "HotModel.h"

@interface selectionCellView()
@property (weak, nonatomic) IBOutlet UILabel *mianTitleLable;
@property (weak, nonatomic) IBOutlet UILabel *salaryLable;
@property (weak, nonatomic) IBOutlet UILabel *detailLable;

@end

@implementation selectionCellView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(HotModel *)model {
    _model = model;
    
    _mianTitleLable.text = _model.title;
    _salaryLable.text    = _model.reward;
    _detailLable.text    = _model.job_description;
}

@end
