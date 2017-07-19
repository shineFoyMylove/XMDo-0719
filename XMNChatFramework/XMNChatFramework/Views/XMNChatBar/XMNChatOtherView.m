//
//  XMNChatOtherView.m
//  XMNChatFrameworkDemo
//
//  Created by XMFraker on 16/4/25.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNChatOtherView.h"
#import "XMNChatOtherCollectionCell.h"
#import "XMNChatConfiguration.h"

@interface XMNChatOtherView () <UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *_items;
    NSInteger apageCount;    //每页显示的items
    NSInteger pageNum;      //页数
}

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation XMNChatOtherView

#pragma mark - Life Cycle

- (instancetype)init {
    
    NSArray *views = [kXMNChatBundle loadNibNamed:@"XMNChatOtherView" owner:nil options:nil];
    return [views firstObject];
}

    //设置数据源
-(void)setItems:(NSArray *)items{
    _items = [[NSArray alloc] initWithArray:items];
    
    //分页
    apageCount = apageCount!=0?apageCount:8;
    NSInteger count = _items.count;
    NSInteger p = count/apageCount;
    if (count > p* apageCount) {
        p = p+1;
    }
    pageNum = p;
    
    [self.collectionView reloadData];
}

#pragma mark - Override Methods

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setupUI];
}

#pragma mark - Methods

- (void)setupUI {
    
    //默认值
    apageCount = 8;  //一页8个
    
    self.collectionView.backgroundColor = XMNVIEW_BACKGROUND_COLOR;
    
    self.pageControl.pageIndicatorTintColor = RGB(177, 177, 177);
    self.pageControl.currentPageIndicatorTintColor = RGB(113, 113, 113);
    
    [self.collectionView registerClass:[XMNChatOtherCollectionCell class] forCellWithReuseIdentifier:@"XMNChatOtherCollectionCell"];
    [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setMinimumInteritemSpacing:.0f];
    [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setMinimumLineSpacing:.0f];
    [(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout setItemSize:CGSizeMake(SCREEN_WIDTH, self.bounds.size.height - 35)];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return pageNum;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XMNChatOtherCollectionCell *itemView = [collectionView dequeueReusableCellWithReuseIdentifier:@"XMNChatOtherCollectionCell" forIndexPath:indexPath];
    
    
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_items];
    NSArray *resutlArr = [NSArray arrayWithArray:_items];
    NSInteger count = _items.count;
    
    if (pageNum >1) {
        if (indexPath.row == pageNum-1) {
            //最后一页
            resutlArr = [tempArr subarrayWithRange:NSMakeRange(indexPath.row*apageCount-1, count-((pageNum-1)*apageCount))];
        }else{
            resutlArr =  [tempArr subarrayWithRange:NSMakeRange(indexPath.row*apageCount, apageCount)];
        }
    }
    
    [itemView setItems:resutlArr maxCount:apageCount];
    
    return itemView;
}


#pragma mark - UIScrollViewDelegate

- (void)collectionView:(UICollectionView *)collectionView
       willDisplayCell:(UICollectionViewCell *)cell
    forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.pageControl.numberOfPages = [self.collectionView numberOfItemsInSection:indexPath.section];
    self.pageControl.currentPage = indexPath.row;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSIndexPath *indexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    self.pageControl.numberOfPages = [self.collectionView numberOfItemsInSection:indexPath.section];
    self.pageControl.currentPage = indexPath.row;
}

@end



