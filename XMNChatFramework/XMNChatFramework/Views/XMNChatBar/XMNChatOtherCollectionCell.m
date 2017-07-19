//
//  XMNChatOtherCollectionCell.m
//  XMNChatFramework
//
//  Created by XMFraker on 16/7/18.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNChatOtherCollectionCell.h"
#import "XMNChatOtherView.h"
#import "XMNChatOtherItem.h"
#import "XMNChatConfiguration.h"


@interface XMNChatOtherItemView : UICollectionViewCell

@property (weak, nonatomic) IBOutlet  UIImageView *imageView;
@property (weak, nonatomic)  IBOutlet UILabel   *titleLabel;

@end

@implementation XMNChatOtherItemView

- (void)setHighlighted:(BOOL)highlighted {
    
    self.imageView.highlighted = highlighted;
}

@end


@interface XMNChatOtherCollectionCell () <UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *_items;
}

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation XMNChatOtherCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark - Methods

- (void)setup {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    [flowLayout setItemSize:CGSizeMake((SCREEN_WIDTH - 48)/4, (self.bounds.size.height - 16)/2)];

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.scrollEnabled = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.contentInset = UIEdgeInsetsMake(8, 24, 0, 24);
    [self addSubview:self.collectionView = collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XMNChatOtherItemView" bundle:kXMNChatBundle] forCellWithReuseIdentifier:@"XMNChatOtherItemView"];
    
    self.collectionView.backgroundColor = XMNVIEW_BACKGROUND_COLOR;
    
}

-(void)setItems:(NSArray *)items maxCount:(NSInteger)maxCount{
    if (items) {
        _items = [[NSArray alloc] initWithArray:items];
    }
    
    NSInteger column = maxCount/2;
    UICollectionViewFlowLayout *layout = self.collectionView.collectionViewLayout;
    [layout setItemSize:CGSizeMake((SCREEN_WIDTH-48)/column, (self.bounds.size.height - 16)/2)];
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XMNChatOtherItemView *itemView = [collectionView dequeueReusableCellWithReuseIdentifier:@"XMNChatOtherItemView" forIndexPath:indexPath];
    
    XMNChatOtherItem *item = [_items objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[XMNChatOtherItem class]]) {
        itemView.imageView.image = [UIImage imageNamed:item.icon];
        [itemView.titleLabel setText:item.title];
    }
    
//    itemView.imageView.image = XMNCHAT_LOAD_IMAGE(@"aio_icons_pic");
    
    return itemView;
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *tmpCell = [collectionView cellForItemAtIndexPath:indexPath];
    tmpCell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *tmpCell = [collectionView cellForItemAtIndexPath:indexPath];
    tmpCell.backgroundColor = [UIColor clearColor];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    XMNChatOtherItem *item = [_items objectAtIndex:indexPath.row];
    NSString *itemTitle = [NSString stringWithFormat:@"%@",item.title];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kXMNChatOtherItemNotification object:@{kXMNChatOtherItemNotificationDataKey:itemTitle}];

}

@end
