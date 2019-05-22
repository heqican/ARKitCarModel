//
//  HCMessagePanelView.h
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/5/22.
//  Copyright © 2019 松小宝. All rights reserved.
//  汽车详情面板

#import <UIKit/UIKit.h>
#import "Const.h"

#define Message_Panel_Size_Width (iphone_width - 100) //菜单面板宽
#define Message_Panel_Size_Height (iphone_height - 10)

NS_ASSUME_NONNULL_BEGIN

@interface HCMessagePanelView : UIView

- (void)show;
- (void)hidden;

@end

NS_ASSUME_NONNULL_END
