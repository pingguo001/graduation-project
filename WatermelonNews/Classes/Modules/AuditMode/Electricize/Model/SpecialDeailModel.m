//
//  SpecialDeailModel.m
//  MakeMoney
//
//  Created by yedexiong on 2017/2/10.
//  Copyright © 2017年 yoke121. All rights reserved.
//

#import "SpecialDeailModel.h"
#import "SDWebImageManager.h"

@implementation SpecialDeailModel

//计算UILabel的高度(带有行间距的情况)
-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 10;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

-(CGFloat)desCellHeight
{
    if (!_desCellHeight) {
        _desCellHeight = [self getSpaceLabelHeight:self.intro withFont:[UIFont systemFontOfSize:15] withWidth:kScreenWidth-30];
        
    }
    return _desCellHeight +15 +30;
}
-(void)setIcon_url:(NSString *)icon_url
{
    _icon_url = icon_url;
    
    [self iconImage];
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"episodes":@"EpisodeModel"};
}

-(UIImage *)iconImage
{
    if (_iconImage == nil) {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.icon_url] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (image) {
                _iconImage = image;
            }
        }];
    }
    return _iconImage;
}

@end
