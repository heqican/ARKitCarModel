//
//  HCARCarViewController.h
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/4/25.
//  Copyright © 2019 松小宝. All rights reserved.
//  汽车模型

#import <UIKit/UIKit.h>
#import "Const.h"
#import "HCToast.h"
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCARCarViewController : UIViewController
@property (nonatomic, assign) ARWorldTrackingConfigurationType arType;//AR追踪类型

@end

NS_ASSUME_NONNULL_END
