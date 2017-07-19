//
//  MsgCenterTableViewCell.m
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/6/9.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "MsgCenterTableViewCell.h"
#import "ICWebViewController.h"

@implementation MsgCenterTableViewCell
{
//    UIView  *contentView;
    UIButton *contentBtn;
    
    UILabel *timeLabel;
    UILabel *titleLabel;
    UILabel *contentLabel;
    
    UILabel *detailLab;
    UIView *separatorLine2;
    
    NSString *detailUrl;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor  = [UIColor clearColor];
        
        [self setupSubView];
        [self setupLayoutConstraint];
    }
    return self;
}


-(void)setModel:(id)model{
    if ([model isKindOfClass:[MsgCenterModel class]]) {
        MsgCenterModel *dataModel = (MsgCenterModel *)model;
        
        [timeLabel setText:dataModel.time];
        [titleLabel setText:dataModel.title];
        [contentLabel setText:dataModel.content];

//        if (dataModel.detailUrl.length >0) {
//            [self haveDetailMsg];
//        }
        
//        [contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(titleLabel.mas_bottom).offset(8);
//            make.left.offset(12);
//            make.right.offset(12);
//            make.bottom.equalTo(contentLabel.mas_bottom).offset(12);
//        }];
        
//        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.edges.offset(0);
//            make.bottom.equalTo(contentView.mas_bottom).offset(10);
//        }];
        
//        [self updateConstraints];
//        [self layoutIfNeeded];
        
//        [self.contentView updateLayoutWithCellContentView:contentView];
        
        
        CGSize timeSize = [dataModel.time boundingRectWithSize:CGSizeMake(Main_Screen_Width *0.8, 20)
                                                       options:(NSStringDrawingUsesFontLeading
                                                                |NSStringDrawingUsesLineFragmentOrigin)
                                                    attributes:@{NSFontAttributeName:timeLabel.font}
                                                       context:NULL].size;
        timeLabel.sd_layout.widthIs(timeSize.width+8);
        
        if (dataModel.detailUrl.length >0) {
            detailUrl = dataModel.detailUrl;
            
            contentBtn.enabled = YES;
            separatorLine2.sd_layout.heightIs(0.5);
            detailLab.sd_layout.heightIs(18);
            
            [contentBtn setupAutoHeightWithBottomView:contentLabel bottomMargin:18];
            [self setupAutoHeightWithBottomView:contentBtn bottomMargin:12];
        }else{
            contentBtn.enabled = NO;
            separatorLine2.sd_layout.heightIs(0);
            detailLab.sd_layout.heightIs(0);
            
            [contentBtn setupAutoHeightWithBottomView:contentLabel bottomMargin:(-18)];
            [self setupAutoHeightWithBottomView:contentBtn bottomMargin:12];
        }
    
    }
}

//添加subView
-(void)setupSubView{
    
    //时间
    timeLabel = [UILabel new];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.backgroundColor = [UIColor colorWithWhite:0.75 alpha:0.9];
    timeLabel.font = [UIFont systemFontOfSize:12.0];
    timeLabel.textColor = [UIColor colorWithWhite:1 alpha:0.95];
    [ToolMethods layerViewCorner:timeLabel withRadiu:2.0 color:nil];
    
    [self.contentView addSubview:timeLabel];
    
    //内容view
//    contentView = [UIView new];
//    contentView.backgroundColor = [UIColor clearColor];
//    [ToolMethods layerViewCorner:contentView withRadiu:3.0 color:RGBColor(220, 220, 220)];
//    [self.contentView addSubview:contentView];
    
    contentBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    contentBtn.backgroundColor = [UIColor whiteColor];
    [ToolMethods layerViewCorner:contentBtn withRadiu:3.0 color:RGBColor(220, 220, 220)];
    [self.contentView addSubview:contentBtn];
    [contentBtn setBackgroundImage:[UIImage imageWithColor:RGBColor(235, 235, 235) cornerRadius:3.0]
                          forState:(UIControlStateHighlighted)];
    [contentBtn addTarget:self
                   action:@selector(cellBtnClickAction:)
         forControlEvents:(UIControlEventTouchUpInside)];
    
    //标题
    titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    
    //内容
    contentLabel = [UILabel new];
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:15.0];
    contentLabel.textColor = [UIColor darkGrayColor];
    
    detailLab = [UILabel new];
    detailLab.text = @"详情";
    detailLab.textColor = [UIColor blueColor];
    detailLab.font = [UIFont systemFontOfSize:15.0];
    
    separatorLine2 = [UIView new];
    separatorLine2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:contentLabel];

    [self.contentView addSubview:detailLab];
    [self.contentView addSubview:separatorLine2];
    
}

-(void)haveDetailMsg{
//    if (detailLab.superview == nil) {
//        [contentView addSubview:detailLab];
//    }
//    if (separatorLine2.superview == nil) {
//        [contentView addSubview:separatorLine2];
//    }
//    
//    [separatorLine2 mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(contentLabel).offset(8);
//        make.left.equalTo(contentLabel);
//        make.right.equalTo(contentLabel);
//        make.height.mas_equalTo(0.5);
//    }];
//    
//    [detailLab mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(separatorLine2).offset(10);
//        make.left.equalTo(contentLabel);
//    }];

}

//设置约束
-(void)setupLayoutConstraint{
    UIView *cellContent = self.contentView;
    CGFloat topMargin = 8;
    CGFloat margin = 12;
//    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(topMargin);
//        make.centerX.equalTo(cellContent);
//        make.height.mas_equalTo(22);
//    }];
//    
//    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(titleLabel.mas_bottom).offset(topMargin);
//        make.left.offset(margin);
//        make.right.offset(margin);
//        make.height.mas_equalTo(100);
//    }];
//
//
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(margin);
//        make.left.offset(margin);
//    }];
//    
//    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(titleLabel).offset(margin);
//        make.left.offset(margin);
//        make.right.offset(margin);
//    }];
//    
//    
//    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.offset(0);
//        make.bottom.equalTo(contentView.mas_bottom).offset(12);
//    }];
    
    timeLabel.sd_layout
    .topSpaceToView(cellContent,topMargin)
    .centerXEqualToView(cellContent)
    .heightIs(22);
    
    titleLabel.sd_layout
    .topSpaceToView(timeLabel,margin+topMargin)
    .leftSpaceToView(cellContent,margin*2)
    .rightSpaceToView(cellContent,margin*2)
    .heightIs(20);
    
    
    contentLabel.sd_layout
    .topSpaceToView(titleLabel,margin)
    .leftSpaceToView(cellContent,margin*2)
    .rightSpaceToView(cellContent,margin*2)
    .autoHeightRatio(0);
    
//    contentView.sd_layout
//    .topSpaceToView(timeLabel,topMargin)
//    .leftSpaceToView(cellContent,margin)
//    .rightSpaceToView(cellContent,margin)
//    .autoHeightRatio(0);
    
    contentBtn.sd_layout
    .topSpaceToView(timeLabel,topMargin)
    .leftSpaceToView(cellContent,margin)
    .rightSpaceToView(cellContent,margin)
    .autoHeightRatio(0);
    
    separatorLine2.sd_layout
    .topSpaceToView(contentLabel,margin)
    .leftEqualToView(contentLabel)
    .rightEqualToView(contentLabel)
    .heightIs(0);
    
    detailLab.sd_layout
    .topSpaceToView(separatorLine2,margin)
    .leftEqualToView(contentLabel)
    .heightIs(0);
    [detailLab setSingleLineAutoResizeWithMaxWidth:200];
    
}

-(UIViewController *)viewController{
    NSInteger num = 0;
    for (UIView *next = [self superview]; next; next = next.superview) {
        num++;
        if (num >5) {
            break;
        }
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

#pragma mark Click Action
-(void)cellBtnClickAction:(UIButton *)sender{
    UIViewController *vc = [self viewController];
    if (vc) {
        ICWebViewController *webVc = [[ICWebViewController alloc] init];
        webVc.Url = detailUrl;
        webVc.WebTitle = titleLabel.text;
        [vc.navigationController pushViewController:webVc animated:YES];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation MsgCenterModel



@end
