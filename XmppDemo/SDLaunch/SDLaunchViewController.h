//
//  SDLaunchViewController.h
//  SDLaunchDemo
//
//  Created by songjc on 16/11/23.
//  Copyright © 2016年 Don9. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    ADLaunchViewController,//广告类型
    GreenhandLaunchViewController,//轮播图新手导引类型
    GifBackgroundLaunchViewController,//gif图背景类型
    RollImageLaunchViewController//滚动图片类型
} LaunchViewControllerType;

@interface SDLaunchViewController : UIViewController


/**
 初始化,并且指定一个根视图控制器mainVC

 @param mainVC App的根视图控制器
 @param viewControllerType 页面类型
 @return 初始化完成
 */
-(instancetype)initWithMainVC:(UIViewController *)mainVC viewControllerType:(LaunchViewControllerType )viewControllerType;


/**
 跳转到App的根视图控制器
 */
-(void)skipAppRootMainViewController;


/**
 结束导引按钮,只要页面类型不是ADLaunchViewController,其他类型都有这个按钮,所以要拿出来.
 */
@property(nonatomic,strong)UIButton *endButton;




/********************广告类型控制器相关参数************************/
/**
 广告图片的连接URL
 */
@property(nonatomic,strong)NSString *imageURL;


/**
 广告页的持续时间,默认为5秒钟
 */
@property(nonatomic,assign)NSInteger adTime;


/**
 广告的连接地址
 */
@property(nonatomic,strong)NSString *adURL;


/**
 广告页面标题
 */
@property(nonatomic,strong)NSString *titleString;

/**
 广告页面是否允许跳过,默认可以点击跳过
 */
@property(nonatomic,assign)BOOL isSkip;



@property(nonatomic,strong)NSTimer *timer;//广告计时器







/********************新手导引控制器相关参数************************/

//❗️❗️❗️❗️注意:如果同时加载本地图片数组和服务器图片数组,本地图片将不会生效.建议使用本地图片~因为服务器图片可能会造成卡顿,使用户体验效果下降.

/**
 加载本地图片数组来完成新手导引图片的加载,图片名称要命名规范.
 */
@property(nonatomic,strong)NSArray *imageNameArray;


/**
 加载图片URL数组来完成新手导引图片的加载,图片地址要命名规范
 */
@property(nonatomic,strong)NSArray *imageURLArray;




/**
 新手导引的页面标记
 */
@property(nonatomic,strong)UIPageControl *pageControl;






/********************GIF背景控制器相关参数************************/


//❗️❗️❗️❗️注意:如果同时加载本地图片和服务器图片,本地图片将不会生效.

/**
 本地GIF动态图背景的名称.
 */
@property(nonatomic,strong)NSString *gifImageName;


/**
 服务器GIF动态图背景的URL字符串.
 */
@property(nonatomic,strong)NSString *gifImageURL;


/**
 以动态图片为背景的frontView.
 */
@property(nonatomic,strong)UIView *frontGifView;


/**
 去除跳转按钮,默认是NO
 */
@property(nonatomic,assign)BOOL hideEndButton;





/********************滚动图片背景控制器相关参数**********************/

//❗️❗️❗️❗️注意:如果同时加载本地图片数组和服务器图片数组,本地图片将不会生效.建议使用本地图片~因为服务器图片可能会造成卡顿,使用户体验效果下降.

/**
 本地滚动图片的名称
 */
@property(nonatomic,strong)NSString *rollImageName;


/**
 服务器滚动图片的URL
 */
@property(nonatomic,strong)NSString *rollImageURL;


/**
 以滚动视图为背景的view
 */
@property(nonatomic,strong)UIView *frontRollView;


@property(nonatomic,strong)NSTimer *rollTimer;//滚动视图计时器

@end














