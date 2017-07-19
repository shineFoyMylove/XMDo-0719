@interface NSDate (TimeAgo)
- (NSString *) timeAgoSimple;
- (NSString *) timeAgo;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormat:(NSDateFormatterStyle)dFormatter andTimeFormat:(NSDateFormatterStyle)tFormatter;
- (NSString *) timeAgoWithLimit:(NSTimeInterval)limit dateFormatter:(NSDateFormatter *)formatter;


// this method only returns "{value} {unit} ago" strings and no "yesterday"/"last month" strings
- (NSString *)dateTimeAgo;

// this method gives when possible the date compared to the current calendar date: "this morning"/"yesterday"/"last week"/..
// when more precision is needed (= less than 6 hours ago) it returns the same output as dateTimeAgo
- (NSString *)dateTimeUntilNow;

- (NSString *)dateTimeShow;   /**<1分钟内-(刚刚)，1小时内-(n分钟前) ，一天内(月-日 时:分) , 大于1天-(年-月-日) */

@end

