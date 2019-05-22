//
//  HCRouterManager.h
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/4/16.
//  Copyright © 2019 松小宝. All rights reserved.
//  跳转路由 - 控制页面跳转

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HCARWorldViewController.h"


@class HCHomeViewController;

NS_ASSUME_NONNULL_BEGIN

@interface HCRouterManager : NSObject
@property (nonatomic, strong) HCHomeViewController *homeViewController;

+ (instancetype)shareInstance;



/**
 进入AR世界 - 图片识别

 @param type AR世界模式
 @param paranVC 父视图
 @param animated animated
 */
- (void)onARWorldWithType:(ARWorldTrackingConfigurationType)type ParamVC:(UIViewController *)paranVC animated:(BOOL)animated;


/**
 进入AR世界 - 汽车Demo

 @param type <#type description#>
 @param paranVC <#paranVC description#>
 @param animated <#animated description#>
 */
- (void)onARWorldCarWithType:(ARWorldTrackingConfigurationType)type ParamVC:(UIViewController *)paranVC animated:(BOOL)animated;


/**
 进入AR世界 - SCNAction动画

 @param type <#type description#>
 @param paranVC <#paranVC description#>
 @param animated <#animated description#>
 */
- (void)onARWorldAnimationActionWithType:(ARWorldTrackingConfigurationType)type paranVC:(UIViewController *)paranVC animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
