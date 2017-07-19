//
//  MyCollectionCell.m
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/5/22.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "MyCollectionCell.h"
#import "MyCollectionModel.h"

@implementation MyCollectionCell
{
    UIImageView *userHeader;   /**<用户头像 */
    UILabel *usernameLable;     /**<用户昵称、备注名 */
    UILabel *timeLable;         /**<收藏日期 */
    
    //媒体 (音频、位置)
    UIView  *media_contentView;   /**<媒体 内容View */
    UIImageView  *media_logo;          /**<媒体 logo */
    UILabel *media_name;          /**<媒体类型名 */
    UILabel *media_detail;        /**<媒体详情描述 */
    
    //文字
    UILabel *text_content;
    //链接
    UIImageView *link_image;       /**<链接 - 图标 */
    UILabel     *link_title;       /**<链接 - 标题 */
    //图片
    UIImageView *pic_image;         /**< 图片类型 */
    //视频
    UIImageView *video_screenImage;  /**<视频截图 */
    UIImageView *video_playIcon;     /**<播放小图标 */
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupSubViews];
        [self setupLayoutConstraint];
    }
    return self;
}

#pragma mark 赋值数据源
-(void)setCollectionModel:(id)model{
    if ([model isKindOfClass:[MyCollectionModel class]]) {
        MyCollectionModel *dataModel = (MyCollectionModel *)model;
        
        [userHeader setImage:IMAGECache(dataModel.userHeader)];
        [usernameLable setText:dataModel.username];
        [timeLable setText:dataModel.timeString];
        
        [self contentViewReset];
        switch (dataModel.contentType) {
            case sh_messageTypeTxt:
                //文字内容
            {
                [self.contentView addSubview:text_content];
                [text_content setText:dataModel.text_content];
                
                [self updateTextContentLayout];
            }
                break;
            case sh_messageTypeVoice:
                //语音
            {
                [self.contentView addSubview:media_contentView];
                [media_logo setImage:[UIImage imageNamed:@"clet_voice_icon"]];
            }
                break;
            case sh_messageTypeLocation:
                //位置
            {
                [self.contentView addSubview:media_contentView];
                [media_logo setImage:[UIImage imageNamed:@"clet_location_icon"]];
            }
                break;
            case sh_messageTypePicture:
                //图片
            {
                [self.contentView addSubview:pic_image];
                dispatch_async(GCDQueueDEFAULT, ^{
                    [pic_image setImage:[UIImage imageNamed:dataModel.pic_image]];
                });
                
                [self updatePicContentLayout];
            }
                break;
            case sh_messageTypeShareLink:
                //分享链接、内容
            {
                [self.contentView addSubview:link_image];
                [self.contentView addSubview:link_title];
            }
                break;
            case sh_messageTypeVedio:
            {
                [self.contentView addSubview:video_screenImage];
                [self.contentView addSubview:media_contentView];
            }
                break;
            default:
                break;
        }
        
        [self.contentView layoutIfNeeded];
    }
}

    //清楚内容view，防止重用
-(void)contentViewReset{
    
    [text_content removeFromSuperview];
    [link_image removeFromSuperview];
    [link_title removeFromSuperview];
    [pic_image removeFromSuperview];
    [video_screenImage removeFromSuperview];
    [video_playIcon removeFromSuperview];
}

#pragma mark 初始化
//初始化 subviews
-(void)setupSubViews{
    //头像
    userHeader = [UIImageView new];
    //名称
    usernameLable = [UILabel new];
    usernameLable.font = [UIFont systemFontOfSize:14.0];
    
    //时间
    timeLable = [UILabel new];
    timeLable.font = [UIFont systemFontOfSize:13.0];
    timeLable.textColor = [UIColor lightGrayColor];
    
    //媒体(音频、位置)
    media_contentView = [UIView new];
    media_contentView.backgroundColor = [UIColor clearColor];
    
    media_logo = [UIImageView new];
    
    media_name = [UILabel new];
    media_name.font = [UIFont systemFontOfSize:16.0];
    
    media_detail = [UILabel new];
    media_detail.font = [UIFont systemFontOfSize:12.0];
    media_detail.textColor = [UIColor lightGrayColor];
    
    [media_contentView sd_addSubviews:@[media_logo,media_name,media_detail]];
    
    //文字
    text_content = [UILabel new];
    text_content.font = [UIFont systemFontOfSize:15.0];
    text_content.numberOfLines = 0;
    
    //链接
    link_image = [UIImageView new];
    link_title = [UILabel new];
    link_title.font = [UIFont systemFontOfSize:15.0];
    
    //图片
    pic_image = [UIImageView new];
    pic_image.contentMode = UIViewContentModeLeft;
    pic_image.clipsToBounds = YES;
    
    //视频
    video_screenImage = [UIImageView new];
    video_playIcon    = [UIImageView new];
    
    [self.contentView sd_addSubviews:@[userHeader,usernameLable,timeLable,media_contentView,text_content,link_image,link_title,pic_image,video_screenImage,video_playIcon]];
    
}

//添加约束
-(void)setupLayoutConstraint{
    //头像
    UIView *contentView = self.contentView;
    CGFloat margin = 12;
    [userHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(margin);
        make.top.offset(margin);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    //名字
    [usernameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userHeader.mas_right).offset(5);
        make.centerY.equalTo(userHeader.mas_centerY);
        
    }];

    //时间
    [timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-margin);
        make.top.offset(margin);
    }];

}

-(void)updateTextContentLayout{
    
    CGFloat margin = 12;
    CGFloat lineRow = text_content.font.lineHeight * 4;  //最大高度
    [text_content mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userHeader.mas_bottom).offset(margin);
        make.height.mas_lessThanOrEqualTo(lineRow);
        make.left.offset(margin);
        make.right.offset(-margin);
        
    }];
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        make.bottom.equalTo(text_content.mas_bottom).offset(margin);
    }];
}

-(void)updatePicContentLayout{
    WkSelf(weakSelf);
    
    CGFloat margin = 12;
    
    [pic_image mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(margin);
        make.top.equalTo(userHeader.mas_bottom).offset(margin);
        make.width.mas_equalTo(weakSelf.width*0.6);
        make.height.mas_equalTo(120);
        
    }];
    
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
        make.bottom.mas_equalTo(pic_image.mas_bottom).offset(12);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
