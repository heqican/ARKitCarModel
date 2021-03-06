//
//  Const.h
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/4/25.
//  Copyright © 2019 松小宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCToast.h"
#import <Masonry.h>

#ifndef Const_h
#define Const_h


//AR世界追踪场景
typedef enum : NSUInteger {
    ARWorldTrackingConfigurationType_detectionImage,//图片识别
    ARWorldTrackingConfigurationType_planeDetection,//平面捕捉
    ARWorldTrackingConfigurationType_faceTracking,//人脸识别
    ARWorldTrackingConfigurationType_faceTrackingBlendShapes,//表情检测
    ARWorldTrackingConfigurationType_planeDetection_CarDemo,//平面捕捉 - 汽车Demo
    ARWorldTrackingConfigurationType_Animation_Action,//SCNAction动画
} ARWorldTrackingConfigurationType;

#define color_items_count  4//颜色数
#define color_item_size_width 60//颜色按钮宽
#define color_item_distance_width 10//颜色按钮间距

#define iphone_width [UIScreen mainScreen].bounds.size.width
#define iphone_height [UIScreen mainScreen].bounds.size.height

//RGB color macro
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//RGB color macro with alpha
#define UIAlphaColorFromRGB(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:a]



#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height == 1136) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height == 1334) : NO)

#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height == 2208) : NO)

#define iPhoneX_Screen ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height == 2436) : NO)

#define iPhoneXR_Screen ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height == 1792) : NO)

#define iPhoneXS_Screen ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height == 2436) : NO)

#define iPhoneXSMAX_Screen ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height == 2688) : NO)

//iphone X+ 系列
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (([[UIScreen mainScreen] currentMode].size.height == 2436) ||  ([[UIScreen mainScreen] currentMode].size.height == 1624)) ||  ([[UIScreen mainScreen] currentMode].size.height == 2688) || ([[UIScreen mainScreen] currentMode].size.height == 1792)  : NO)



#endif /* Const_h */
