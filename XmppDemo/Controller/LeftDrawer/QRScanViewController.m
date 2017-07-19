//
//  QRScanViewController.m
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/6/21.
//  Copyright © 2017年 wh_shine. All rights reserved.
//  

#import "QRScanViewController.h"
#import "ICWebViewController.h"

#import "SGQRCodeScanningView.h"
#import "SGQRCodeConst.h"
#import "UIImage+SGHelper.h"

@interface QRScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    void(^QRScanCompliteBlock)(id obj);
    
}
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;

// 会话对象
@property (nonatomic, strong) AVCaptureSession *session;
// 图层类
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;


@end

@implementation QRScanViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.scanningView addTimer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_session && _session.running == NO) {
        __weak __typeof(&*self)weakSelf = self;
        dispatch_async(GCDQueueDEFAULT, ^{
            [weakSelf.session startRunning];
            [weakSelf.view.layer insertSublayer:weakSelf.previewLayer atIndex:0];
        });
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.scanningView removeTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫一扫";
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.scanningView];
    
    [self setupSGQRCodeScanning];
    
}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [SGQRCodeScanningView scanningViewWithFrame:self.view.bounds layer:self.view.layer];
    }
    return _scanningView;
}

-(void)setScanCompliteBlock:(void (^)(id))scanCompliteBlock{
    if (scanCompliteBlock) {
        QRScanCompliteBlock = scanCompliteBlock;
    }
}

#pragma mark - - - 从相册中识别二维码, 并进行界面跳转
- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image {
    // 对选取照片的处理，如果选取的图片尺寸过大，则压缩选取图片，否则不作处理
    image = [UIImage imageSizeWithScreenImage:image];
    
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    for (int index = 0; index < [features count]; index ++) {
        CIQRCodeFeature *feature = [features objectAtIndex:index];
        NSString *scannedResult = feature.messageString;
        //SGQRCodeLog(@"scannedResult - - %@", scannedResult);
        // 在此发通知，告诉子类二维码数据
        [SGQRCodeNotificationCenter postNotificationName:SGQRCodeInformationFromeAibum object:scannedResult];
    }
}


- (void)setupSGQRCodeScanning {
    // 1、获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2、创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    //3、创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    //4、设置代理  在主线程刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置扫描范围(每一个取值0～1，以屏幕右上角为坐标原点)
    // 注：微信二维码的扫描范围是整个屏幕，这里并没有做处理（可不用设置）
    output.rectOfInterest = CGRectMake(0.05, 0.2, 0.7, 0.7);
    
    //5、初始化 链接对象(会话对象)
    self.session = [[AVCaptureSession alloc] init];
    // 高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    //5.1、添加会话输入
    [_session addInput:input];
    
    //5.2、添加会话输出
    [_session addOutput:output];
    
    // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code];
    
    //7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
//    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
//    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//    _previewLayer.frame = self.view.layer.bounds;
    //8、图层插入当前视图
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    
    [_session startRunning];
}

-(AVCaptureVideoPreviewLayer *)previewLayer{
    if (_previewLayer == nil) {
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        _previewLayer.frame = self.view.layer.bounds;
    }
    return _previewLayer;
}

#pragma mark - - - AVCaptureMetadataOutputObjectsDelegate

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    //扫描成功提示音
    [self SG_playSoundEffect:@"SGQRCode.bundle/sound.caf"];
    
    //扫描完成停止会话
    [self.session stopRunning];
    
    //删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
    //显示扫描结果
    if (metadataObjects.count >0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        if (QRScanCompliteBlock) {
            QRScanCompliteBlock(obj);
        }
        
        NSString *resultUrl = [NSString stringWithFormat:@"%@",obj.stringValue];
        
        ICWebViewController *webVc = [[ICWebViewController alloc] init];
        webVc.popRootVc = YES;
        if ([resultUrl hasPrefix:@"http"]) {
            webVc.Url = resultUrl;
        }else{
            webVc.Url = resultUrl;
            webVc.WebTitle = resultUrl;
        }
        [self pushViewController:webVc];
    }
}

/** 播放音效文件 */
-(void)SG_playSoundEffect:(NSString *)name{
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(fileUrl), &soundID);
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, AudioSoundCompleteCallback, NULL);
    
    AudioServicesPlaySystemSound(soundID);  //播放
}

/** 播放完成回调函数 */
void AudioSoundCompleteCallback(SystemSoundID soundID, void *clientData){
    SGQRCodeLog(@"播放完成");
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
