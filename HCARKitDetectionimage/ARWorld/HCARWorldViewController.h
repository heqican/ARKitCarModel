//
//  HCARWorldViewController.h
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/4/16.
//  Copyright © 2019 松小宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>
#import "Const.h"

NS_ASSUME_NONNULL_BEGIN



@interface HCARWorldViewController : UIViewController
@property (nonatomic, assign) ARWorldTrackingConfigurationType arType;//AR追踪类型
@end

NS_ASSUME_NONNULL_END
