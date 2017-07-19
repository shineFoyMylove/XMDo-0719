//
//  QRScanViewController.h
//  WHIMDemo1
//
//  Created by IntelcentMac on 17/6/21.
//  Copyright © 2017年 wh_shine. All rights reserved.
//

#import "BaseViewController.h"

@interface QRScanViewController : BaseViewController

-(void)setScanCompliteBlock:(void(^)(id obj))scanCompliteBlock;


@end
