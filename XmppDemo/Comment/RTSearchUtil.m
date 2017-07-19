//
//  RTSearchUtil.m
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/5/12.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "RTSearchUtil.h"

static RTSearchUtil *defaultUitl = nil;

@interface RTSearchUtil()


@property (nonatomic, weak) id source;
@property (nonatomic) SEL selector;
@property (nonatomic,copy) RealTimeSearchResultBlock resultBlock;
/** 当前搜索线程 */
@property (strong, nonatomic) NSThread *searchThread;
/** 搜索线程队列 */
@property (strong, nonatomic) dispatch_queue_t searchQueue;


@end


@implementation RTSearchUtil

@synthesize source = _source;
@synthesize selector = _selector;

-(instancetype)init{
    if (self = [super init]) {
        _searchQueue = dispatch_queue_create("rt_search_gcdQueue", NULL);
        
    }
    return self;
}

+(instancetype)currentUtil{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultUitl = [[RTSearchUtil alloc] init];
    });
    return defaultUitl;
}

#pragma mark private
-(void)realtimeSearch:(NSString *)string{
    [self.searchThread cancel];
    
    //开启线程
    self.searchThread = [[NSThread alloc] initWithTarget:self selector:@selector(searchBegin:) object:string];
    [self.searchThread start];
}

-(void)searchBegin:(NSString *)string{
    __weak typeof (self) weakSelf = self;
    dispatch_async(self.searchQueue, ^{
        if (string.length == 0) {
            weakSelf.resultBlock(weakSelf.source);
        }
        else{
            NSMutableArray *results = [NSMutableArray array];
            NSString *subStr = [string lowercaseString];  //小写
            for (id object in weakSelf.source) {
                NSString *tmpStr = @"";
                if (weakSelf.selector) {
                    if ([object respondsToSelector:weakSelf.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                        tmpStr = [[object performSelector:weakSelf.selector] lowercaseString];
#pragma clang diagnostic pop
                    }
                }
                else if([object isKindOfClass:[NSString class]]){
                    tmpStr = [object lowercaseString];
                }
                else{
                    continue;
                }
                
                if ([tmpStr rangeOfString:subStr].location != NSNotFound) {
                    [results addObject:object];
                }
            }
            
            weakSelf.resultBlock(results);
        }
        
    });
}

#pragma mark - public
//开始搜索，只需要调用一次，与[realtimeSearchStop]配套使用
-(void)searchWithSource:(id)source searchText:(NSString *)searchText collationStringSelector:(SEL)selector resultBlock:(RealTimeSearchResultBlock)resultBlock
{
    if (!source || [searchText length] == 0 || !resultBlock) {
        if (resultBlock) {
            resultBlock(nil);
        }
        return;
    }
    
    _source = source;
    _selector = selector;
    _resultBlock = resultBlock;
    [self realtimeSearch:searchText];
}

//从fromString中搜索是否包含searchStri
-(BOOL)searchStringContain:(NSString *)searchString fromString:(NSString *)fromString;
{
    if (!searchString || !fromString || (fromString.length == 0 && searchString.length != 0)) {
        return NO;
    }
    if (searchString.length == 0) {
        return YES;
    }
    
    NSUInteger location = [[fromString lowercaseString] rangeOfString:[searchString lowercaseString]].location;
    return (location == NSNotFound ? NO : YES);
}

/**
 * 结束搜索，只需要调用一次，在[realtimeSearchBeginWithSource:]之后使用，主要用于释放资源
 */
- (void)realtimeSearchStop
{
    [self.searchThread cancel];
}


@end
