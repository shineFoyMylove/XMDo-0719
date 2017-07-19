//
//  MyFirendCircleTable.m
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/5/31.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "MyFriendCircleTable.h"
#import "SDTimeLineRefreshHeader.h"
#import "SDTimeLineRefreshFooter.h"
#import "SDTimeLineTableHeaderView.h"

#import <SDAutoLayout.h>

#import "FriendCircleModel.h"
#import "FriendCircleCell.h"

static CGFloat inputViewH = 45;

@interface MyFriendCircleTable ()<FriendCircelCellDelegate,UITextFieldDelegate>

@property (nonatomic, retain) NSMutableArray *dataArray;

@end

@implementation MyFriendCircleTable
{
    SDTimeLineRefreshHeader *_refreshHeader;
    SDTimeLineRefreshFooter *_refreshFooter;
    
    CGFloat _totalKeybordHeight;
    NSIndexPath *_currentEditingIndexPath;  //当前编辑的cell
    UITextField *_textField;
    
}

#pragma mark Static Property

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

#pragma mark View Life 生命周期

-(void)dealloc{
    [_refreshHeader removeFromSuperview];
    _refreshHeader = nil;
    
    [_refreshFooter removeFromSuperview];
    _refreshFooter = nil;
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
        //初始化测试数据
    [self.dataArray addObjectsFromArray:[self creatModelsWithCount:10]];
    
        //加载footer
    [self setupRefreshFooter];
    
        //Table HeaderView
    SDTimeLineTableHeaderView *tableHeaderView = [SDTimeLineTableHeaderView new];
    tableHeaderView.frame = CGRectMake(0, 0, 0, 260);
    self.tableView.tableHeaderView = tableHeaderView;
    
    [self.tableView registerClass:[FriendCircleCell class] forCellReuseIdentifier:@"friendCircleCellId"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.dataArray.count == 0) {
            [_refreshFooter removeFromSuperview];
        }
    });
    
    [self setupInputView];  //输入view
    
    //添加键盘监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardNotification:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //刷新header
    [self setupRefreshHeader];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

#pragma mark 设置上拉加载更多 下拉刷新
-(void)setupRefreshHeader{
    if (!_refreshHeader.superview) {
        
        _refreshHeader = [SDTimeLineRefreshHeader refreshHeaderWithCenter:CGPointMake(40,45)];
        _refreshHeader.scrollView = self.tableView;
        __weak typeof(_refreshHeader) weakHeader = _refreshHeader;
        __weak typeof(self) weakSelf = self;
        [_refreshHeader setRefreshingBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.dataArray = [[weakSelf creatModelsWithCount:10] mutableCopy];
                [weakHeader endRefreshing];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
                
            });
        }];
        [self.tableView.superview addSubview:_refreshHeader];
        
    }else{
        [self.tableView.superview bringSubviewToFront:_refreshHeader];
    }
}

-(void)setupRefreshFooter{
    _refreshFooter = [SDTimeLineRefreshFooter refreshFooterWithRefreshingText:@"正在加载数据..."];
    __weak typeof(_refreshFooter) weakFooter = _refreshFooter;
    __weak typeof(self) weakSelf = self;
    [_refreshFooter addToScrollView:self.tableView refreshOpration:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.dataArray addObjectsFromArray:[weakSelf creatModelsWithCount:10]];
            
            [weakSelf.tableView reloadDataWithExistedHeightCache];
            [weakFooter endRefreshing];
        });
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id model = self.dataArray[indexPath.row];
    
    CGFloat cellHeight = [self.tableView cellHeightForIndexPath:indexPath model:model keyPath:@"model" cellClass:[FriendCircleCell class] contentViewWidth:[self cellContentViewWith]];
    
    return cellHeight;
    
//    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"friendCircleCellId";
    FriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[FriendCircleCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    
    cell.indexPath = indexPath;
    __weak typeof(self) weakSelf = self;
    if (!cell.moreButtoClickBlock) {
        [cell setMoreButtoClickBlock:^(NSIndexPath *indexPath) {
            FriendCircleModel *model = weakSelf.dataArray[indexPath.row];
            model.isOpening = !model.isOpening;  //展开或者关闭
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        cell.delegate = self;
    }
    
   // cell frame 缓存
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    //数据
    cell.contentFontSize = 13.0;
    cell.model = self.dataArray[indexPath.row];
    
    
    return cell;
}
    //手动拖动
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
}

#pragma mark FriendCircleCellDelegate
//点赞
-(void)friendCircleCellDidClickLikeButton:(UITableViewCell *)cell{
    NSIndexPath *index = [self.tableView indexPathForCell:cell];
    FriendCircleModel *model = self.dataArray[index.row];
    NSMutableArray *likeArr = [NSMutableArray arrayWithArray:model.likeItemArr];
    
    if (!model.isLiked) {
        FriCircleLikeItemModel *likeModel = [FriCircleLikeItemModel new];
        likeModel.userName = @"wh_shine";
        likeModel.userId = @"2017_1314";
        [likeArr addObject:likeModel];
        model.like = YES;
    }else{
        FriCircleLikeItemModel *tmpModel = nil;
        for (FriCircleLikeItemModel *likeModel in model.likeItemArr) {
            if ([likeModel.userId isEqualToString:@"2017_1314"]) {
                tmpModel = likeModel;
                break;
            }
        }
        [likeArr removeObject:tmpModel];
        model.like = NO;
    }
    model.likeItemArr = [likeArr copy];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    });
}
//评论
-(void)friendCircleCellDidClickCommentButton:(UITableViewCell *)cell{
    _currentEditingIndexPath = [self.tableView indexPathForCell:cell];
    [_textField becomeFirstResponder];
    [self adjustTableViewToFitKeyboard];
}

    // tableview 偏移适应键盘
-(void)adjustTableViewToFitKeyboard{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentEditingIndexPath];
    //坐标转义
    CGRect cellCovWindow = [cell.superview convertRect:cell.frame toView:window];
    //Cell当前的 pointY 离适应的位置的距离
    CGFloat moveSpace = CGRectGetMaxY(cellCovWindow) - (window.height-_totalKeybordHeight);
    
    CGPoint offset = self.tableView.contentOffset;
    offset.y += moveSpace;      //上移 +
    if (offset.y <0) {
        offset.y = 0;
    }
    [self.tableView setContentOffset:offset animated:YES];
}

    // keyboard Notification 键盘通知监听
-(void)keyboardNotification:(NSNotification *)notify{
    NSDictionary *dict = notify.userInfo;
    CGRect rect = [dict[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    CGRect textFieldRect = CGRectMake(0, rect.origin.y-inputViewH, rect.size.width, inputViewH);
    if (rect.origin.y == Main_Screen_Height) {
#pragma mark 什么鬼
        textFieldRect = rect;
    }
    [UIView animateWithDuration:0.25 animations:^{
        _inputView.frame = textFieldRect;
    }];
    
    CGFloat h = rect.size.height + inputViewH;
    if (_totalKeybordHeight != h) {
        _totalKeybordHeight = h;
        [self adjustTableViewToFitKeyboard];
    }
}


#pragma mark 评论 inputView
-(void)setupInputView{
    self.inputView = [UIView new];
    _inputView.backgroundColor = RGBColor(245, 245, 245);
    
    _textField = [UITextField new];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.delegate = self;
    [ToolMethods layerViewCorner:_textField withRadiu:3.0 color:RGBColor(200, 200, 200)];
    [self.inputView addSubview:_textField];
    
    _textField.sd_layout
    .topSpaceToView(_inputView,5)
    .leftSpaceToView(_inputView,10)
    .rightSpaceToView(_inputView,10)
    .bottomSpaceToView(_inputView,5);
    
    [self.inputView setFrame:CGRectMake(0, Main_Screen_Height, self.view.width, inputViewH)];
    [[UIApplication sharedApplication].keyWindow addSubview:_inputView];
    
    //获取键盘高度
    [_textField becomeFirstResponder];
    [_textField resignFirstResponder];
}

#pragma mark UITextFieldDelegate
//键盘 done 发送评论
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length) {
        [_textField resignFirstResponder];
        
        FriendCircleModel *editModel = self.dataArray[_currentEditingIndexPath.row];
        if ([editModel isKindOfClass:[FriendCircleModel class]]) {
            NSMutableArray *commentsArr = [NSMutableArray arrayWithArray:editModel.commentItemArr];
            
            FriCircleCommentItemModel *comModel = [FriCircleCommentItemModel new];
            comModel.userName = @"wh_shine";
            comModel.userId = @"2017_1314";
            comModel.commentString = _textField.text;
            [commentsArr addObject:comModel];
            
            editModel.commentItemArr = [commentsArr copy];
            [self.tableView reloadRowsAtIndexPaths:@[_currentEditingIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            _textField.text = @"";
        }
    }else{
        [textField resignFirstResponder];
    }
    
    return YES;
}

#pragma  mark Data Model 测试数据模型

-(NSArray *)creatModelsWithCount:(NSInteger)count{
    NSArray *iconImageNamesArray = @[@"icon0.jpg",
                                     @"icon1.jpg",
                                     @"icon2.jpg",
                                     @"icon3.jpg",
                                     @"icon4.jpg",
                                     ];
    
    NSArray *namesArray = @[@"GSD_iOS",
                            @"风口上的猪",
                            @"当今世界网名都不好起了",
                            @"我叫郭德纲",
                            @"Hello Kitty"];
    
    NSArray *textArray = @[@"当你的 app 没有提供 3x 的 LaunchImage 时，系统默认进入兼容模式，https://github.com/gsdios/SDAutoLayout大屏幕一切按照 320 宽度渲染，屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。",
                           @"然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，https://github.com/gsdios/SDAutoLayout等于把小屏完全拉伸。",
                           @"当你的 app 没有提供 3x 的 LaunchImage 时屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。屏幕宽度返回 320；然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。",
                           @"但是建议不要长期处于这种模式下，否则在大屏上会显得字大，内容少，容易遭到用户投诉。",
                           @"屏幕宽度返回 320；https://github.com/gsdios/SDAutoLayout然后等比例拉伸到大屏。这种情况下对界面不会产生任何影响，等于把小屏完全拉伸。但是建议不要长期处于这种模式下。"
                           ];
    
    NSArray *commentsArray = @[@"社会主义好！👌👌👌👌",
                               @"正宗好凉茶，正宗好声音。。。",
                               @"你好，我好，大家好才是真的好",
                               @"有意思",
                               @"你瞅啥？",
                               @"瞅你咋地？？？！！！",
                               @"hello，看我",
                               @"曾经在幽幽暗暗反反复复中追问，才知道平平淡淡从从容容才是真",
                               @"人艰不拆",
                               @"咯咯哒",
                               @"呵呵~~~~~~~~",
                               @"我勒个去，啥世道啊",
                               @"真有意思啊你💢💢💢"];
    
    NSArray *picImageNamesArray = @[ @"pic0.jpg",
                                     @"pic1.jpg",
                                     @"pic2.jpg",
                                     @"pic3.jpg",
                                     @"pic4.jpg",
                                     @"pic5.jpg",
                                     @"pic6.jpg",
                                     @"pic7.jpg",
                                     @"pic8.jpg"
                                     ];
    NSMutableArray *resArr = [NSMutableArray new];
    
    for (int i = 0; i < count; i++) {
        int iconRandomIndex = arc4random_uniform(5);
        int nameRandomIndex = arc4random_uniform(5);
        int contentRandomIndex = arc4random_uniform(5);
        
        FriendCircleModel *model = [FriendCircleModel new];
        model.iconName = iconImageNamesArray[iconRandomIndex];
        model.name = namesArray[nameRandomIndex];
        model.msgContent = textArray[contentRandomIndex];
        
        
        // 模拟“随机图片”
        int random = arc4random_uniform(6);
        
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < random; i++) {
            int randomIndex = arc4random_uniform(9);
            [temp addObject:picImageNamesArray[randomIndex]];
        }
        if (temp.count) {
            model.picNameArr = [temp copy];
        }
        
        // 模拟随机评论数据
        int commentRandom = arc4random_uniform(3);
        NSMutableArray *tempComments = [NSMutableArray new];
        for (int i = 0; i < commentRandom; i++) {
            FriCircleCommentItemModel *commentItemModel = [FriCircleCommentItemModel new];
            int index = arc4random_uniform((int)namesArray.count);
            commentItemModel.userName = namesArray[index];
            commentItemModel.userId = @"666";
            if (arc4random_uniform(10) < 5) {
                commentItemModel.replyUserName = namesArray[arc4random_uniform((int)namesArray.count)];
                commentItemModel.replyUserId = @"888";
            }
            commentItemModel.commentString = commentsArray[arc4random_uniform((int)commentsArray.count)];
            [tempComments addObject:commentItemModel];
        }
        model.commentItemArr = [tempComments copy];
        
        // 模拟随机点赞数据
        int likeRandom = arc4random_uniform(3);
        NSMutableArray *tempLikes = [NSMutableArray new];
        for (int i = 0; i < likeRandom; i++) {
            FriCircleLikeItemModel *model = [FriCircleLikeItemModel new];
            int index = arc4random_uniform((int)namesArray.count);
            model.userName = namesArray[index];
            model.userId = namesArray[index];
            [tempLikes addObject:model];
        }
        
        model.likeItemArr = [tempLikes copy];
        
        
        [resArr addObject:model];
    }
    return [resArr copy];
}

#pragma mark 横竖屏
//横竖屏宽度计算
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

@end
