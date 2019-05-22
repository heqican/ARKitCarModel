//
//  HCRouterManager.m
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/4/16.
//  Copyright © 2019 松小宝. All rights reserved.
//

#import "HCRouterManager.h"
#import "HCHomeViewController.h"
#import "HCARWorldViewController.h"
#import "HCARCarViewController.h"
#import "HCARAnimationActionViewController.h"

@interface HCRouterManager ()

@end

@implementation HCRouterManager
static HCRouterManager *_shareInstance = nil;
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareInstance = [[HCRouterManager alloc] init];
    });
    return _shareInstance;
}

//进入AR世界 - 图片识别
- (void)onARWorldWithType:(ARWorldTrackingConfigurationType)type ParamVC:(UIViewController *)paranVC animated:(BOOL)animated{
    HCARWorldViewController *arVC = [[HCARWorldViewController alloc] init];
    if ([arVC isKindOfClass:[UIViewController class]]) {
        arVC.arType = type;//AR世界追踪为模式
        [paranVC.navigationController pushViewController:arVC animated:animated];
    }
}

//进入AR世界 - 汽车Demo
- (void)onARWorldCarWithType:(ARWorldTrackingConfigurationType)type ParamVC:(UIViewController *)paranVC animated:(BOOL)animated{
    HCARCarViewController *arVC = [[HCARCarViewController alloc] init];
    if ([arVC isKindOfClass:[UIViewController class]]) {
        arVC.arType = type;//AR世界追踪为模式
//        [paranVC.navigationController pushViewController:arVC animated:animated];
        [paranVC presentViewController:arVC animated:YES completion:nil];
    }
}

//进入AR世界 - SCNAction动画
- (void)onARWorldAnimationActionWithType:(ARWorldTrackingConfigurationType)type paranVC:(UIViewController *)paranVC animated:(BOOL)animated{
    HCARAnimationActionViewController *arVC = [[HCARAnimationActionViewController alloc] init];
    if ([arVC isKindOfClass:[UIViewController class]]) {
        arVC.arType = type;//AR世界追踪为模式
        [paranVC presentViewController:arVC animated:YES completion:nil];
    }
}

#pragma mark - lazy load
- (HCHomeViewController *)homeViewController{
    if (!_homeViewController) {
        _homeViewController = [[HCHomeViewController alloc] init];
    }
    return _homeViewController;
}

@end
