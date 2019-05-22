//
//  HCToast.h
//  HCToast
//
//  Created by 何其灿 on 2018/9/12.
//  Copyright © 2018年 松小宝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HCToastView : UIView

@end


@interface HCToast : NSObject

+(instancetype)shareInstance;


/**
 显示Toast

 @param message 提示文本内容
 */
-(void)showToast:(NSString *)message;


/**
 显示带成功icon的Toast

 @param message 成功提示文本内容
 */
-(void)showSuccessIconToast:(NSString *)message;


/**
 显示带错误icon的Toast

 @param message 错误提示文本内容
 */
-(void)showErrorIconToast:(NSString *)message;


/**
 显示顶部Toast (默认位置为导航条下方)

 @param message 提示文本内容
 */
-(void)showTopToast:(NSString *)message;


/**
 显示顶部Toast

 @param message 提示文本内容
 @param offsetY 顶部Y方向偏移位置 offsetY >= 0
 */
-(void)showTopToast:(NSString *)message offsetY:(CGFloat)offsetY;


/**
 清除Toast
 */
-(void)clearToast;

@end
