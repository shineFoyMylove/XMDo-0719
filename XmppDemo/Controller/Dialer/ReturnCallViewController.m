//
//  ReturnCallViewController.m
//  CallLiaoBei
//
//  Created by IntelcentMacMini on 16/11/21.
//  Copyright © 2016年 GeryHui. All rights reserved.
//  回拨页面

#import "ReturnCallViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ReturnCallViewController (){
    IBOutlet UIImageView *bgImageView;
    IBOutlet UIImageView *contactHeaderImage;
    
    NSString *dialerPhone;
    NSString *dialerName;
    
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *phoneLabel;
@property (nonatomic, retain) IBOutlet UILabel *callStatusLab;
@property (nonatomic, retain) IBOutlet UIButton *hangUpButton;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation ReturnCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.nameLabel setText:dialerName];
    [self.phoneLabel setText:dialerPhone];
    
    [self requetForDialerCall];
    
        //15秒后页面自动退出
    WkSelf(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(12.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf ClickExit:nil];
    });
    
//    if (self.userInfo.soundPath.length >0) {
//        
//        NSURL *tmpURL = [NSURL fileURLWithPath:self.userInfo.soundPath];
//        if (tmpURL) {
//            
//            if ([[NSFileManager defaultManager] fileExistsAtPath:self.userInfo.soundPath] == NO) {
//                [self.userInfo downloadSoundSource];   //文件不存在，重新下载
//                
//                NSString *tmpFile = [[NSBundle mainBundle] pathForResource:@"hold" ofType:@"wav"];
//                tmpURL = [NSURL fileURLWithPath:tmpFile];
//            }
//            
//            NSError *error = nil;
//            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:tmpURL error:&error];
//            if (error) {
//                NSLog(@"音频初始化失败:%@",error.description);
//            }
//            [self.audioPlayer prepareToPlay];
//            [self.audioPlayer play];
//        }
//    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewDidDisappear:animated];
    
    [_audioPlayer stop];   //
}

-(void)returnDialerCall:(NSString *)phone name:(NSString *)name{
    dialerName = name;
    dialerPhone = phone;
}

-(void)requetForDialerCall{
    
    WkSelf(weakSelf);
//    [HTTPRequest requestForAppDialerCall:dialerPhone complite:^(BOOL result, NSString *errmsg, NSDictionary *jsonDic) {
//        if (result && jsonDic) {
//            NSString *resultStr = [jsonDic getStringValueForKey:@"result" defaultValue:@"-15"];
//            if ([resultStr isEqualToString:@"0"]) {
//                [weakSelf.callStatusLab setText:@"呼叫成功"];
//            }else{
//                errmsg = [RequestError errorForDialerCallWithCode:resultStr];
//                [weakSelf.callStatusLab setText:[NSString stringWithFormat:@"呼叫失败\n%@",errmsg]];
//            }
//        }else{
//            NSLog(@"%@",errmsg);
//            [weakSelf.callStatusLab setText:@"呼叫错误,请检查网络"];
//        }
//    }];
}

#pragma mark 铃声播放


-(IBAction)ClickExit:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
