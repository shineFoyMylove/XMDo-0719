//
//  SHWelcomView.m
//  iCallYiQiTong
//
//  Created by IntelcentMacMini on 16/9/10.
//  Copyright © 2016年 英之杰讯邦网络科技. All rights reserved.
//

#import "SHWelcomView.h"

@interface SHWelcomView()<UIScrollViewDelegate>{
    CGRect viewFrame;
    NSArray *imagesArr;
    void(^viewOverBlock)();
    
    BOOL(^upConditioBlock)();
    
    BOOL show;
    
}


@property (nonatomic, retain) UIScrollView *MainScrollView;
@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) UIButton *jumpOverBtn;
@property (nonatomic, retain) UIButton *clickBegin;   //点击开始

@end



@implementation SHWelcomView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.havePageControl = YES;   //默认是有pageNum
    }
    return self;
}

-(UIScrollView *)MainScrollView{
    if (_MainScrollView == nil) {
        _MainScrollView = [[UIScrollView alloc] init];
        _MainScrollView.bounces = NO;
        _MainScrollView.showsVerticalScrollIndicator = NO;
        _MainScrollView.showsHorizontalScrollIndicator = NO;
        _MainScrollView.pagingEnabled = YES;
        _MainScrollView.delegate = self;
    }
    return _MainScrollView;
}

-(UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.enabled = NO;   //不需要
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];  //未显示位置点颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:45/255.0 green:163/255.0 blue:254/255.0 alpha:1.0];  //45.163.245
    }
    return _pageControl;
}

-(UIButton *)jumpOverBtn{
    if (_jumpOverBtn == nil) {
        _jumpOverBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
        [_jumpOverBtn setTitle:@"跳过" forState:(UIControlStateNormal)];
        _jumpOverBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        [_jumpOverBtn addTarget:self action:@selector(viewHidden) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _jumpOverBtn;
}

-(UIButton *)clickBegin{
    if (_clickBegin == nil) {
        CGFloat btnPre = 0.7;
        CGFloat btnWidth = viewFrame.size.width *btnPre;
        CGFloat btnHeight = 40;
        _clickBegin = [[UIButton alloc] initWithFrame:CGRectMake(viewFrame.size.width*(1-btnPre)/2, viewFrame.size.height-btnHeight-90, btnWidth, btnHeight)];
        
        [_clickBegin setTitle:@"开始体验" forState:(UIControlStateNormal)];
        [_clickBegin setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    }
    return _clickBegin;
}

    //允许跳过
-(void)setEnableJumpOverClick:(BOOL)enableJumpOverClick{
    _enableJumpOverClick = enableJumpOverClick;
    
}
    //退出view
-(void)setViewOverBlock:(void(^)())overBlock{
    if (overBlock) {
        viewOverBlock = overBlock;
    }
}

    //跟进判断条件判断是否启用
-(void)setViewOverBlock:(void (^)())overBlock withSwithOnCondition:(BOOL (^)())condition{
    if (overBlock) {
        viewOverBlock = overBlock;
    }
    if (condition) {
        upConditioBlock = condition;
    }
    show = upConditioBlock();
}

    //欢迎页图片
-(void)setWelcomeImages:(NSArray *)images{
    if ([images isKindOfClass:[NSArray class]]) {
        imagesArr = [[NSArray alloc] initWithArray:images];
        
        [self.pageControl setNumberOfPages:imagesArr.count];
    }
}

    //显示
-(void)viewShow{
    show = YES;
    [self layoutSubviews];
}
    //隐藏
-(void)viewHidden{
    show = NO;
    
    __weak SHWelcomView *weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf setAlpha:0.0];
    } completion:^(BOOL finished) {
        [weakSelf.MainScrollView setFrame:CGRectZero];
        [weakSelf setFrame:CGRectZero];
        [weakSelf.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
    
    if (viewOverBlock) {
        viewOverBlock();
    }
}


-(void)createWelcomScrollView{
    
    [self.MainScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i< imagesArr.count; i++) {
        UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*viewFrame.size.width, 0, viewFrame.size.width, viewFrame.size.height)];
        tmpImgView.contentMode = UIViewContentModeScaleAspectFill;
        tmpImgView.userInteractionEnabled = YES;  //button生效
        
        NSString *imgStr = [imagesArr objectAtIndex:i];
        if ([imgStr isKindOfClass:[NSString class]]) {
            [tmpImgView setImage:[UIImage imageNamed:imgStr]];
        }
        
        if (i == imagesArr.count-1) {
            [tmpImgView addSubview:self.clickBegin];
            
            _clickBegin.layer.masksToBounds = YES;
            _clickBegin.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
            _clickBegin.layer.cornerRadius = 5.0;
            _clickBegin.layer.borderWidth = 1.0;
            [_clickBegin addTarget:self action:@selector(viewHidden) forControlEvents:(UIControlEventTouchUpInside)];
        }
        
        [self.MainScrollView addSubview:tmpImgView];
    }
    
    [self.MainScrollView setContentSize:CGSizeMake(viewFrame.size.width*imagesArr.count, viewFrame.size.height)];
    
    if (self.havePageControl) {
        [self.pageControl setFrame:CGRectMake(0, viewFrame.size.height-30, viewFrame.size.width, 30)];
        [self addSubview:self.pageControl];
    }
    
    if (self.enableJumpOverClick) {
        [self.jumpOverBtn setFrame:CGRectMake(viewFrame.size.width-60, 20, 50, 30)];
        [self addSubview:_jumpOverBtn];
        
        self.jumpOverBtn.layer.masksToBounds = YES;
        self.jumpOverBtn.layer.cornerRadius = 5.0;
        self.jumpOverBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        self.jumpOverBtn.layer.borderWidth = 1.0;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    viewFrame = self.bounds;
    
    if (show) {
        [self.MainScrollView setFrame:viewFrame];
        [self addSubview:self.MainScrollView];
        
        [self createWelcomScrollView];
        
    }else{
        
        [self.MainScrollView setFrame:CGRectZero];
        [self setFrame:CGRectZero];
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
}

#pragma mark UIScrollViewDelegate
    //结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger picNum = (scrollView.contentOffset.x + viewFrame.size.width/2)/viewFrame.size.width;
    
    [_pageControl setCurrentPage:picNum];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
