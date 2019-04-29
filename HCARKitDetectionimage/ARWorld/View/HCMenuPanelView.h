//
//  HCMenuPanelView.h
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/4/26.
//  Copyright © 2019 松小宝. All rights reserved.
//  菜单面板

#import <UIKit/UIKit.h>
#import "Const.h"

NS_ASSUME_NONNULL_BEGIN

#define MenuPanel_Size_Width 200 //菜单面板宽

typedef void(^ClickTireSparedBlock)(BOOL active);
typedef void(^ClickTireTurnBlock)(BOOL active);
typedef void(^ClickCarTurnBlock)(BOOL active);
typedef void(^ClickRearviewMirrorBlock)(BOOL active);
typedef void(^ClickWindowsBlock)(BOOL active);

@interface HCMenuPanelView : UIView
@property (nonatomic, assign) BOOL tireSpared;//是否已经拆下轮胎
@property (nonatomic, copy) ClickTireSparedBlock tireSparedBlock;//拆卸轮胎回调

@property (nonatomic, assign) BOOL tireTurned;//轮胎是否正在转动
@property (nonatomic, copy) ClickTireTurnBlock tireTurnBlock;//轮胎转动点击回调

@property (nonatomic, assign) BOOL carTurned;//汽车是否正在转动
@property (nonatomic, copy) ClickCarTurnBlock carTurnBlock;//轮胎转动点击回调

@property (nonatomic, assign) BOOL rearviewMirrorClosed;//后视镜是否合上
@property (nonatomic, copy) ClickRearviewMirrorBlock rearviewMirrorBlock;//后视镜开关点击回调

@property (nonatomic, assign) BOOL windowsDown;//车窗是否降下
@property (nonatomic, copy) ClickWindowsBlock windowsBlock;//车窗开关点击回调

- (void)show;
- (void)hidden;


/**
 更新轮胎拆卸控件状态

 @param tireSpared 是否已经拆下轮胎
 */
- (void)updateTireSparedStatus:(BOOL)tireSpared;


@end

NS_ASSUME_NONNULL_END
