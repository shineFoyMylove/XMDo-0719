//
//  NumberKeyboard.m
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/4.
//  Copyright © 2016年 GeryHui. All rights reserved.
//

#import "NumberKeyboard.h"
#import "KeyboardCell.h"

@interface NumberKeyboard()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSArray *numberArr;   //数字
    NSArray *letterArr;   //字母
    
    CGRect ViewFrame;
    UIView *cellSelectedView;
    BOOL isLongPress;   //触发长按
}

@property (strong ,nonatomic) UICollectionView *numberCollection;
@property (strong ,nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) NSIndexPath *tapIndexPath;  //当前点击index
@end

@implementation NumberKeyboard

-(id)init{
    if (self = [super init]) {
        [self viewInit];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self viewInit];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self viewInit];
    }
    return self;
}

-(void)viewInit{
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.minimumLineSpacing = 0;   //上下间距
    _flowLayout.minimumInteritemSpacing = 0;  //item之间的间距
    
    self.numberCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
    self.numberCollection.delegate = self;
    self.numberCollection.dataSource = self;
    self.numberCollection.scrollEnabled = NO;
    [self.numberCollection registerNib:[UINib nibWithNibName:@"KeyboardCell" bundle:nil] forCellWithReuseIdentifier:@"numberCellID"];
    
    self.numberCollection.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.numberCollection];
    
    
}


#pragma mark UICollectionViewDelegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return numberArr.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    KeyboardCell *cell = (KeyboardCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"numberCellID" forIndexPath:indexPath];
    
    NSString *tmpText = numberArr[indexPath.row];
    NSInteger cellTag = indexPath.row+1;  //0-7 (1-8)
    
        //reset
    [cell.textLabel setText:@""];
    [cell.letterLabel setText:@""];
    [cell.iconImg setImage:nil];
    cell.textLabel.font = LightFontItem(25.0);
    cell.textLabel.textColor = RGBColor(60, 60, 60);
    
    if (indexPath.row >0 && indexPath.row < 9) {
        NSString *tmpLetter = letterArr[indexPath.row-1];
        cell.textType = NumberKeyboardTextStyleNumber;
        
        [cell.textLabel setText:tmpText];
        [cell.letterLabel setText:tmpLetter];
    }else if (indexPath.row == 10 || indexPath.row == 0){
        // 0
        [cell.textLabel setText:tmpText];
        [cell.letterLabel setText:nil];
    }else{
        
        if ([tmpText isEqualToString:@"paste"]) {
            [cell.textLabel setText:@"粘贴"];
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
            cell.textLabel.textColor = AppMainColor;
            cell.textType = NumberKeyboardTextStylePaste;
        }else if ([tmpText isEqualToString:@"add"]){
            cell.textType = NumberKeyboardTextStyleAdd;
            [cell.iconImg setImage:IMAGECache(@"dialer_add.png")];
            [cell.iconImg setHidden:NO];
        }else if ([tmpText isEqualToString:@"delete"]){
            cell.textType = NumberKeyboardTextStyleDelete;
            [cell.iconImg setImage:IMAGECache(@"dialer_delete.png")];
            [cell.iconImg setHidden:NO];

        }else if ([tmpText isEqualToString:@"set"]){
            cell.textType = NumberKeyboardTextStyleSetting;
            [cell.iconImg setImage:IMAGECache(@"dialer_set.png")];
            [cell.iconImg setHidden:NO];
        }
    }
    
    cell.index = cellTag;   //1-12
    
    UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    tmpView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.9];
//    tmpView.backgroundColor = UIColorFromRGB(0xB7E6D2);
    cell.selectedBackgroundView = tmpView;
    
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _tapIndexPath = indexPath;
    
    KeyboardCell *tempCell = (KeyboardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([tempCell isKindOfClass:[KeyboardCell class]]) {
        if (self.numberLongDeleteBlock && tempCell.textType == NumberKeyboardTextStyleDelete) {
            //长按删除
            WkSelf(weakSelf);
            [self setTPLongTapBlock:^{
                weakSelf.numberLongDeleteBlock();
            }];
        }else{
            [self removeGestureRecognizer:self.TPLongPressGes];
            self.TPLongTapBlock = nil;
        }
    }
    
    return YES;
}

//选中
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
    KeyboardCell *tempCell = (KeyboardCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([tempCell isKindOfClass:[KeyboardCell class]]) {
        
        if (self.KeyboardDidTapBlock){
            self.KeyboardDidTapBlock(tempCell.index,tempCell.textType);
        }
    }
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    numberArr = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"paste",@"0",@"add", nil];  //12个
    letterArr = [[NSArray alloc] initWithObjects:@"ABC",@"DEF",@"GHI",@"JKL",@"MNO",@"PQRS",@"TUV",@"WXYZ", nil];  //8个
    
    
    ViewFrame = self.bounds;
    CGFloat itemWidth = ViewFrame.size.width/3;   //3列
    CGFloat itemHeight = ViewFrame.size.height/4;  //4行
    [_flowLayout setItemSize:CGSizeMake(itemWidth, itemHeight)];
    [_flowLayout setScrollDirection:(UICollectionViewScrollDirectionVertical)];
    
    [self.numberCollection setFrame:ViewFrame];
    [self.numberCollection reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
