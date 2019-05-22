//
//  HCARAnimationActionViewController.h
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/5/7.
//  Copyright © 2019 松小宝. All rights reserved.
//  AR动画

#import <UIKit/UIKit.h>
#import "Const.h"
#import "HCToast.h"
#import <ARKit/ARKit.h>
#import <SceneKit/SceneKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCARAnimationActionViewController : UIViewController
@property (nonatomic, assign) ARWorldTrackingConfigurationType arType;//AR追踪类型

@end

NS_ASSUME_NONNULL_END
