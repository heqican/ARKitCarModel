//
//  HCColorPanelView.h
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/4/26.
//  Copyright © 2019 松小宝. All rights reserved.
//  颜色选择面板

#import <UIKit/UIKit.h>
#import "Const.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^ClickColorItemBlock)(UIColor *color);//选择颜色回调

@interface HCColorPanelView : UIView
@property (nonatomic, copy) ClickColorItemBlock selectColorBlock;//选择颜色回调

@end

NS_ASSUME_NONNULL_END
