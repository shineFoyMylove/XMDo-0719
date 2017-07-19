//
//  QRCodeViewController.m
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/6/21.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "QRCodeViewController.h"
#import "SGQRCodeTool.h"

@interface QRCodeViewController ()
{
    CGSize QRSize;
}

@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    QRSize = CGSizeMake(Main_Screen_Width*0.85, Main_Screen_Width*0.85);
    self.QRUrl = @"https://github.com/HHQBOOK/qrCode";
    
    //生成二维码(Default)
//    [self setupGenerateQRCode];
    
    // 生成二维码(中间带有图标)
    [self setupGenerate_Icon_QRCode];
}
    //普通二维码
-(void)setupGenerateQRCode{
    
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat imgOriginX = (self.view.frame.size.width-QRSize.width)/2;
    CGFloat imgOriginY = (self.view.frame.size.height-QRSize.height)/2;
    [imageView setFrame:CGRectMake(imgOriginX, imgOriginY, QRSize.width, QRSize.height)];
    [self.view addSubview:imageView];
    
    // 将二维码显示在UIImageView上
    imageView.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:self.QRUrl
                                                      imageViewWidth:QRSize.width];
}


// 生成二维码(中间带有图标)
-(void)setupGenerate_Icon_QRCode{
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat imgOriginX = (Main_Screen_Width-QRSize.width)/2;
    CGFloat imgOriginY = (Main_Screen_Height-QRSize.height-100)/2;
    [imageView setFrame:CGRectMake(imgOriginX, imgOriginY, QRSize.width, QRSize.height)];
    [self.view addSubview:imageView];
    
    // 将二维码显示在UIImageView上
    CGFloat scale = 0.25;
    imageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:self.QRUrl
                                                    logoImageName:@"icon_logo"
                                             logoScaleToSuperView:scale];
    
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
