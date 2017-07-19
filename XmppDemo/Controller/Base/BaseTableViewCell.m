//
//  BaseTableViewCell.m
//  WHIMDemo1
//
//  Created by Gery晖 on 17/4/10.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()

@property (nonatomic, retain) UIView *botomLine;

@end

@implementation BaseTableViewCell

-(UIView *)botomLine{
    if (_botomLine == nil) {
        _botomLine = [[UIView alloc] init];
        _botomLine.backgroundColor = RGBColor(248, 248, 248);
    }
    return _botomLine;
}

-(void)setHaveBottomLine:(BOOL)haveBottomLine{
    if (haveBottomLine) {
        [self.contentView addSubview:self.botomLine];
    }else{
        [self.botomLine removeFromSuperview];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (_botomLine) {
        [self.botomLine setFrame:CGRectMake(10, self.height-1, self.width-20, 1)];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
