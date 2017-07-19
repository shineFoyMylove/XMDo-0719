//
//  IMNetwrokObject.h
//  XmppProject
//
//  Created by IntelcentMac on 17/7/12.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, IMUploadResult) {
    IMUploadResultSuccess,
    IMUploadResultFaild,    //有json返回，上传失败
    IMUploadResultError     //无json返回，请求错误
};

//结果block
typedef void (^TSYComplite)(BOOL result,NSString *errmsg, NSDictionary *jsonObj);

//上传过程block
typedef void(^TSYUploadProgress)(int64_t bytesProgress,
                                  int64_t totalBytesProgress);
//下载过程block
typedef void(^TSYDownloadProgress)(int64_t bytesProgress,
                                    int64_t totalBytesProgress);


@interface IMNetwrokObject : NSObject


@property (nonatomic, assign,getter=uploding) BOOL uploadStatu;  //上传状态
@property (nonatomic, assign) IMUploadResult *uploadResult;  /**< 上传结果 */

#pragma mark - 上传文件

/**
 上传图片
 
 @param image 图片obj
 @param complite 结果回调(w,h,url)
 */
-(void)uploadImage:(UIImage *)image complite:(void(^)(CGFloat imgWidth, CGFloat height, NSString *imgUrl))complite;


/**
 上传音频
 
 @param audioObj 音频Obj
 @param complite 结果回调 (url)
 */
-(void)uploadAudio:(id)audioObj complite:(void(^)(NSString *audoUrl))complite;



/**
 上传视频
 
 @param videoObj 视频Obj
 @param complite 结果回调 (url,视频截图url)
 */
-(void)uploadVideo:(id)videoObj complite:(void(^)(NSString *videoUrl, NSString *viewImageUrl))complite;



/**
 上传文件
 
 @param fileObj 文件Obj
 @param type 文件类型(后缀)
 @param complite 结果回调(url)
 */
-(void)uploadFile:(id)fileObj fileType:(NSString *)type complite:(void(^)(NSString *fileUrl))complite;


#pragma mark - 下载文件


/**
 下载文件

 @param fileUrl 文件下载地址
 @param saveToPath 文件保存路径
 @param progressBlock 下载进度
 @param complite 完成回调
 @param showHUD 是否显示HUD
 @return 返回请求任务对象，便于操作
 */
-(NSURLSessionTask *)downloadFile:(NSString *)fileUrl
         saveToPath:(NSString *)saveToPath
           progress:(TSYDownloadProgress)progressBlock
           complite:(TSYComplite)complite
            showHUD:(BOOL)showHUD;




@end
