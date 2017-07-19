//
//  NewFriendTableViewCell.m
//  XmppProject
//
//  Created by IntelcentMac on 17/7/18.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "NewFriendTableViewCell.h"
#import "CoreDataManager.h"
#import "UIImageView+WebCache.h"
#import "NewFriendObject+CoreDataClass.h"

@interface NewFriendTableViewCell ()
{
    IBOutlet NSLayoutConstraint *stateBtnWidthConstraint;
    void(^agreeCompliteBlock)(BOOL result);   //同意请求成功回调
}

@property (nonatomic, retain) UIView *botomLine;

@end


@implementation NewFriendTableViewCell


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
    
    [ToolMethods layerViewCorner:self.imageView withRadiu:3.0 color:nil];
}

-(void)setAgreeActionBlock:(void (^)(BOOL))agreeBlock{
    if (agreeBlock) {
        agreeCompliteBlock = agreeBlock;
    }
}

-(void)setObjItem:(NewFriendObject *)objItem{
    _objItem = objItem;
    
    if ([objItem isKindOfClass:[NewFriendObject class]]) {
        NewFriendObject *object = (NewFriendObject *)objItem;
        
        NSURL *imgURL = [NSURL URLWithString:object.imageUrl];
        [self.headerImage sd_setImageWithURL:imgURL placeholderImage:IMAGECache(@"default_head")];
        
        [self.nameLabel setText:object.name];
        [self.descLabel setText:object.phone];
        self.state = object.state;
    }
}

-(void)setState:(TLNewFriendApplyState)state{
    _state = state;
    switch (state) {
        case TLNewFriendApplyStateNew:
            //同意
        {
            [self.applyState setTitle:@"同意" forState:(UIControlStateNormal)];
            [self.applyState setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            
            UIColor *bgColor = RGBColor(61, 193, 119);            
            [self.applyState setBackgroundImage:[UIImage imageWithColor:bgColor cornerRadius:3.0] forState:(UIControlStateNormal)];
            [self.applyState setBackgroundImage:[UIImage imageWithColor:[bgColor colorWithAlphaComponent:0.5] cornerRadius:3.0] forState:(UIControlStateHighlighted)];
            
            self.applyState.enabled = YES;
        }
            break;
        case TLNewFriendApplyStateAgreed:
            //已添加
        {
            [self.applyState setTitle:@"已添加" forState:(UIControlStateNormal)];
            [self.applyState setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
            [self.applyState setBackgroundImage:nil forState:(UIControlStateNormal)];
            [self.applyState setBackgroundColor:[UIColor clearColor]];
            
            self.applyState.enabled = NO;
        }
            break;
        case TLNewFriendApplyStateWaiting:
            //等待验证
        {
            [self.applyState setTitle:@"等待验证" forState:(UIControlStateNormal)];
            [self.applyState setTitleColor:[UIColor darkGrayColor] forState:(UIControlStateNormal)];
            [self.applyState setBackgroundImage:nil forState:(UIControlStateNormal)];
            [self.applyState setBackgroundColor:[UIColor clearColor]];
            self.applyState.enabled = NO;
            stateBtnWidthConstraint.constant = 60.0;  //宽度不够显示文字
        }
            break;
            
        default:
            break;
    }
}

    //同意
-(IBAction)ClickAction:(id)sender{
    if (self.state == TLNewFriendApplyStateNew) {
        
        if (_objItem.phone.length == 0) {
            NSLog(@"号码错误");
            return;
        }
        
        [[XMPPTool shareXMPPTool] xmppAgreeWithFriendRequest:_objItem.phone];
        
        if (agreeCompliteBlock) {
            agreeCompliteBlock(YES);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (_botomLine) {
        [self.botomLine setFrame:CGRectMake(10, self.height-1, self.width-20, 1)];
    }
}

@end



//@interface NewFriendObject ()
//
////@property (nonatomic, retain) NSManagedObjectContext *context;
//
//@end
//
//static NSManagedObjectContext *_context;
//
//@implementation NewFriendObject
//
//
////查询所有
//+(NSArray <NewFriendObject *> *)featchAllRequest{
//    
//    NSFetchRequest *fetchRequset = [[NSFetchRequest alloc] init];
//    
//    NSString *classname = NSStringFromClass([NewFriendObject class]);
//    fetchRequset.entity = [NSEntityDescription entityForName:classname inManagedObjectContext:[self context]];
//    
//    //排序
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timeInterval" ascending:YES];
//    fetchRequset.sortDescriptors = @[sort];
//    
//    //筛选过滤
//    NSString *userphone = UDGetString(username_preference);
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userphone = %@",userphone];
//    fetchRequset.predicate = predicate;
//    
//    NSError *error = nil;
//    NSArray *results = [[self context] executeFetchRequest:fetchRequset error:&error];
//    if (error) {
//        [NSException raise:@"查询失败" format:@"%@",error.description];
//    }
//    
//    if (results.count >0) {
//        NSMutableArray *arr = [NSMutableArray array];
//        for (NSManagedObject *tmpObj in results) {
//            NewFriendObject *friObj = [[NewFriendObject alloc] init];
//            
//            [friObj UpdateSelfFromManagedObject:tmpObj];
//            [arr addObject:friObj];
//        }
//        
//        return arr;
//    }
//    return nil;
//}
//
////更新数据
//-(BOOL)updateFriendObject{
//    //找到该记录
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    
//    NSString *classname = NSStringFromClass([self class]);
//    fetchRequest.entity = [NSEntityDescription entityForName:classname inManagedObjectContext:[NewFriendObject context]];
//    
//    //筛选过滤
//    NSString *userphone = UDGetString(username_preference);
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userphone = %@ , phone = %@",userphone,self.phone];
//    fetchRequest.predicate = predicate;
//    
//    NSError *error = nil;
//    NSArray *objs = [[NewFriendObject context] executeFetchRequest:fetchRequest error:&error];
//    if (error) {
//        [NSException raise:@"查询失败" format:@"%@",error.description];
//    }
//    if (objs.count >0){
//        NSManagedObject *obj = [objs firstObject];
//        //修改
//        [self CopySelfToManagedObject:obj];
//        
//        //保存
//        if ([self saveContext]) {
//            return YES;
//        }
//    }
//    
//    return NO;
//}
//
//
//-(NSManagedObject *)insertManagedObject{
//    // 创建实体对象，出入上下文
//    NSString *className = NSStringFromClass([self class]);
//    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:className
//                                                            inManagedObjectContext:[NewFriendObject context]];
//    
//    [self CopySelfToManagedObject:object];
//    
//    //同步到上下文，持久保存数据库
//    if (![self saveContext]) {
//        [NSException raise:@"访问数据库错误" format:@""];
//        return nil;
//    }
//    return object;
//}
//
//+(NSManagedObjectContext *)context{
//    if (!_context) {
//        //加载模型文件
//        NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
//        //传入模型对象
//        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
//        //构建SQLite数据库文件
//        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//        NSURL *URL = [NSURL fileURLWithPath:[docPath stringByAppendingPathComponent:@"NewFriend.data"]];
//        //添加持久存储库
//        NSError *error = nil;
//        NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:URL options:nil error:&error];
//        if (store == nil) {
//            [NSException raise:@"添加数据库失败" format:@"%@",error.description];
//        }
//        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
//        context.persistentStoreCoordinator = coordinator;
//        _context = context;
//        
//    }
//    return _context;
//}
//
//    //将self属性同步到 managedObject，然后持久化保存
//-(void)CopySelfToManagedObject:(NSManagedObject *)object{
//    
//    NSString *username = UDGetString(username_preference);
//    [object setValue:NotNullString(username) forKey:@"userphone"];   //当前登录用户
//    
//    [object setValue:NotNullString(_uid) forKey:@"uid"];
//    [object setValue:NotNullString(_name) forKey:@"name"];  //昵称
//    [object setValue:NotNullString(_phone) forKey:@"phone"];
//    [object setValue:NotNullString(_imageUrl) forKey:@"imageUrl"];
//    [object setValue:NotNullString(_signString) forKey:@"sign"];  //签名
//    [object setValue:[NSNumber numberWithInt:_applyState] forKey:@"state"];
//    
//    [object setValue:[NSNumber numberWithDouble:[NSDate timeInterval]] forKey:@"timeInterval"];  //时间戳、排序
//}
//
//    //将 managedObject属性 赋值到 self
//-(void)UpdateSelfFromManagedObject:(NSManagedObject *)object{
//    
//    self.uid    = [object valueForKey:@"uid"];
//    self.name   = [object valueForKey:@"name"];
//    self.phone  = [object valueForKey:@"phone"];
//    self.imageUrl = [object valueForKey:@"imageUrl"];
//    
//    self.signString = [object valueForKey:@"sign"];
//    self.applyState = [[object valueForKey:@"state"] intValue];
//    
//}
//
////上下文
////+(NSManagedObjectContext *)context{
////    return [CoreDataManager instance].managedObjectContext;
////}
//
////保存
//-(BOOL)saveContext{
////    return [[CoreDataManager instance] saveContext];
//    
//    NSError *error = nil;
//    NSManagedObjectContext *managedObjectContext = [NewFriendObject context];
//    if (managedObjectContext != nil) {
//        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
//            
//            //持久化失败
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            return NO;
//        }
//    }else{
//        NSLog(@"Managed Object Context is nil");
//        return NO;
//    }
//    NSLog(@"Context Saved");
//    return YES;
//}
//
//@end
