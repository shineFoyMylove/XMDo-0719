//
//  FirendCircleCell.m
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/5/31.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "FriendCircleCell.h"
#import "SDWeiXinPhotoContainerView.h"
#import "SDTimeLineCellCommentView.h"
#import "SDTimeLineCellOperationMenu.h"

#import <UIView+SDAutoLayout.h>
#import <SDAutoLayout.h>

const CGFloat contentLabelFontSize = 15;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定

NSString *const kSDTimeLineCellOperationButtonClickedNotification = @"SDTimeLineCellOperationButtonClickedNotification";

#define TimeLineCellHighlightedColor [UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]

@interface FriendCircleCell ()
{
    UIImageView *_iconImage;    //头像
    UILabel     *_nameLabel;    //用户名
    UILabel     *_contentLabel; //内容
    UILabel     *_timeLabel;    //发布时间
    UIButton     *_moreButton;   //更多按钮
    UIButton    *_operationButton; //触发 赞、评论 按钮

    //图片展示
    SDWeiXinPhotoContainerView  *_picContainerView;
    //评论区域
    SDTimeLineCellCommentView   *_commentView;
    //赞、评论 menu
    SDTimeLineCellOperationMenu *_operationMenu;
    
}

@end

@implementation FriendCircleCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self initSubViews];  //初始子view
        [self setupLayoutConstraintOfSubViews];  //添加约束
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    //UI刷新则隐藏 menu
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

#pragma mark 数据源
-(void)setModel:(FriendCircleModel *)model{
    _model = model;
    //attacth
    [_contentLabel setFont:[UIFont systemFontOfSize:_contentFontSize>0?_contentFontSize:contentLabelFontSize]];
    if (maxContentLabelHeight == 0) {
        maxContentLabelHeight = _contentLabel.font.lineHeight * 3;
    }
    
    [_nameLabel setFont:[UIFont systemFontOfSize:_nameFontSize>0?_nameFontSize:14]];  //默认 14
    
    
    [_commentView setupWithLikeItemsArray:model.likeItemArr commentItemsArray:model.commentItemArr];
    
    _iconImage.image = [UIImage imageNamed:model.iconName];
    _nameLabel.text = model.name;
    _contentLabel.text = model.msgContent;
    _picContainerView.picPathStringsArray = model.picNameArr;
    
    if (model.shouldShowMoreButton) { // 如果文字高度超过60
        _moreButton.sd_layout.heightIs(20);
        _moreButton.hidden = NO;
        if (model.isOpening) { // 如果需要展开
            _contentLabel.sd_layout.maxHeightIs(MAXFLOAT);
            [_moreButton setTitle:@"收起" forState:UIControlStateNormal];
        } else {
            _contentLabel.sd_layout.maxHeightIs(maxContentLabelHeight);
            [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
        }
    } else {
        _moreButton.sd_layout.heightIs(0);
        _moreButton.hidden = YES;
    }
    
    CGFloat picContainerTopMargin = 0;
    if (model.picNameArr.count) {
        picContainerTopMargin = 10;
    }
    _picContainerView.sd_layout.topSpaceToView(_moreButton, picContainerTopMargin);
    
    UIView *bottomView;
    
    if (!model.commentItemArr.count && !model.likeItemArr.count) {
        bottomView = _timeLabel;
    } else {
        bottomView = _commentView;
    }
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:15];
    
    _timeLabel.text = @"1分钟前";
}

#pragma mark Action事件
//全文更多
-(void)moreButtonClicked{
    if (self.moreButtoClickBlock) {
        self.moreButtoClickBlock(self.indexPath);
    }
}

    //touch 事件监听
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    //关闭操作 menu
    if (_operationMenu.isShowing) {
        _operationMenu.show = NO;
    }
}

//展开操作 menu
-(void)operationButtonClicked{
    _operationMenu.show = !_operationMenu.show;
    
}
    //接收到 operation 操作点击通知
//-(void)receiveOperationButtonClickNotification:(NSNotification *)notify{
//    UIButton *btn = [notify object];
//    if (btn != _operationButton && _operationMenu.isShowing) {
//        //menu展开且不是 本身按钮, 点击赞、评论，隐藏 menu
//        _operationMenu.show = NO;
//    }
//}
//发送 menu 点击通知
//-(void)postOperationButtonClickNotification{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kSDTimeLineCellOperationButtonClickedNotification object:_operationButton];
//}


#pragma mark View init
//初始子view
-(void)initSubViews{
    //头像
    _iconImage = [UIImageView new];
    
    //名称
    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = [UIColor colorWithRed:(54 / 255.0) green:(71 / 255.0) blue:(121 / 255.0) alpha:0.9];
    
    //内容
    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines = 0;
    
    //全文更多
    _moreButton = [UIButton new];
    [_moreButton setTitle:@"全文" forState:UIControlStateNormal];
    [_moreButton setTitleColor:TimeLineCellHighlightedColor forState:UIControlStateNormal];
    [_moreButton addTarget:self action:@selector(moreButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
        //操作按钮
    _operationButton = [UIButton new];
    [_operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    [_operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //图片 容器
    _picContainerView = [SDWeiXinPhotoContainerView new];
    //评论View
    _commentView = [SDTimeLineCellCommentView new];
    
    //发布时间
    _timeLabel = [UILabel new];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    
    //操作 menu
    _operationMenu = [SDTimeLineCellOperationMenu new];
    __weak typeof(self) weakSelf = self;
    [_operationMenu setLikeButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(friendCircleCellDidClickLikeButton:)]) {
            [weakSelf.delegate friendCircleCellDidClickLikeButton:weakSelf];
        }
    }];
    [_operationMenu setCommentButtonClickedOperation:^{
        if ([weakSelf.delegate respondsToSelector:@selector(friendCircleCellDidClickCommentButton:)]) {
            [weakSelf.delegate friendCircleCellDidClickCommentButton:weakSelf];
        }
    }];
    
    NSArray *views = @[_iconImage, _nameLabel, _contentLabel, _moreButton, _picContainerView, _timeLabel, _operationButton, _operationMenu, _commentView];
    
    
    [self.contentView sd_addSubviews:views];
}

//添加约束
-(void)setupLayoutConstraintOfSubViews{
    UIView *contentView = self.contentView;
    CGFloat margin = 10;    //边距
    //      left、right、top、bottom、width、height
    
    //头像   10,*,20,*,40,40
    _iconImage.sd_layout
    .leftSpaceToView(contentView,margin)
    .topSpaceToView(contentView,margin+5)
    .widthIs(40)
    .heightEqualToWidth();
    
    //昵称
    _nameLabel.sd_layout
    .leftSpaceToView(_iconImage,margin)
    .topEqualToView(_iconImage)
    .heightIs(18);
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    //内容
    _contentLabel.sd_layout
    .leftEqualToView(_nameLabel)
    .topSpaceToView(_nameLabel,margin)
    .rightSpaceToView(contentView,margin)
    .autoHeightRatio(0);
    
    //全文更多按钮
    _moreButton.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_contentLabel,5)
    .widthIs(30);
    
    //图片容器
    _picContainerView.sd_layout
    .leftEqualToView(_contentLabel);
    
    //发布时间
    _timeLabel.sd_layout
    .leftEqualToView(_contentLabel)
    .topSpaceToView(_picContainerView,margin)
    .heightIs(15);
    [_timeLabel setSingleLineAutoResizeWithMaxWidth:200];  //最大宽度200
    
    //操作按钮
    _operationButton.sd_layout
    .rightSpaceToView(contentView,margin)
    .centerYEqualToView(_timeLabel)
    .heightIs(25)
    .widthIs(25);
    
    //评论view
    _commentView.sd_layout
    .leftEqualToView(_contentLabel)
    .rightSpaceToView(contentView,margin)
    .topSpaceToView(_timeLabel,margin);
    
    //操作 menu
    _operationMenu.sd_layout
    .rightSpaceToView(_operationButton,0)
    .centerYEqualToView(_operationButton)
    .heightIs(36)
    .widthIs(0);
    
}


#pragma mark property set 方法
//内容 size
-(void)setContentFontSize:(CGFloat)contentFontSize{
    if (contentFontSize >0) {
        [_contentLabel setFont:[UIFont systemFontOfSize:contentFontSize]];
        [self updateLayoutWithCellContentView:self.contentView];
        
    }
}
//名字 size
-(void)setNameFontSize:(CGFloat)nameFontSize{
    if (nameFontSize >0) {
        [_nameLabel setFont:[UIFont systemFontOfSize:nameFontSize]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)awakeFromNib {
    [super awakeFromNib];
}

@end
