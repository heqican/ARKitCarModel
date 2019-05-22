//
//  HCToast.m
//  HCToast
//
//  Created by 何其灿 on 2018/9/12.
//  Copyright © 2018年 松小宝. All rights reserved.
//

#import "HCToast.h"

#define UI_SCREEN_WIDTH         ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT        ([[UIScreen mainScreen] bounds].size.height)
#define HCToast_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? ([[UIScreen mainScreen] currentMode].size.height == 2436) : NO)
#define HCToast_NAVIGATION_STATUS_BAR_HEIGHT (HCToast_iPhoneX?88.0f:64.0f)

#define Toast_Duration_Normal 2.0f //默认逗留时长



/**
 Toast类型

 - HCToastType_Toast: 普通Toast
 - HCToastType_SuccessIconToast: 带成功图标的Toast
 - HCToastType_ErrorIconToast: 带失败图标的Toast
 - HCToastType_TopToast: 顶部显示Toast
 */
typedef NS_ENUM(NSInteger , HCToastType) {
    HCToastType_Toast = 0,
    HCToastType_SuccessIconToast = 1,
    HCToastType_ErrorIconToast = 2,
    HCToastType_TopToast = 3,
};

static const CGFloat Interval_Size_5 = 5.0f;
static const CGFloat Interval_Size_20 = 20.0f;
static const CGFloat Interval_Size_25 = 25.0f;
static const CGFloat Interval_Size_30 = 30.0f;
static const CGFloat Normal_Size_Width = 260.0f;

#pragma mark - HCToastView

@interface HCToastView()
@property (strong,nonatomic) UILabel *textLabel;
@property (strong,nonatomic) UIImageView *tipsImageView;
@end

@implementation HCToastView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}


/**
 显示Toast

 @param message 提示文本
 */
-(void)setTextMessage:(NSString *)message{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    self.textLabel.text = message;
    CGRect rect =[self.textLabel.text  boundingRectWithSize:CGSizeMake(Normal_Size_Width, MAXFLOAT)
                                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:@{NSFontAttributeName:self.textLabel.font} context:nil];
    self.textLabel.textAlignment = (rect.size.width>180.0f) ? NSTextAlignmentCenter : NSTextAlignmentLeft;
    self.textLabel.frame = CGRectMake(Interval_Size_25/2, Interval_Size_20/2, rect.size.width, rect.size.height);
    [self addSubview:self.textLabel];
    
    CGFloat width = rect.size.width+Interval_Size_25;
    CGFloat height = rect.size.height+Interval_Size_20;
    CGFloat x = (UI_SCREEN_WIDTH - width)/2;
    CGFloat y = (UI_SCREEN_HEIGHT -height)/2;
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    self.frame = CGRectMake(x, y, width, height);
}


/**
 显示带有Icon的Toast提示

 @param message 提示文本
 */
-(void)setIconText:(NSString *)message type:(HCToastType)type{
    self.textLabel.text = message;
    
    UIImage *tipsIcon = nil;
    if (type == HCToastType_SuccessIconToast) {
        tipsIcon = [UIImage imageNamed:@"HCToast_toast_success"];
    }else if (type == HCToastType_ErrorIconToast){
        tipsIcon = [UIImage imageNamed:@"HCToast_toast_error"];
    }
    
    
    CGRect rect = [self.textLabel.text boundingRectWithSize:CGSizeMake(Normal_Size_Width, MAXFLOAT)
                                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:@{NSFontAttributeName:self.textLabel.font}
                                                    context:nil];
    CGFloat width = rect.size.width + Interval_Size_30*2;
    CGFloat height = rect.size.height + Interval_Size_20 + tipsIcon.size.height + Interval_Size_5*2;
    CGFloat x = (UI_SCREEN_WIDTH - width) / 2;
    CGFloat y = (UI_SCREEN_HEIGHT - height) / 2;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2;
    self.frame = CGRectMake(x, y, width, height);
    
    CGFloat iconX = (self.frame.size.width - tipsIcon.size.width)/2;
    self.tipsImageView.frame = CGRectMake(iconX, Interval_Size_20/2, tipsIcon.size.width, tipsIcon.size.height);
    self.tipsImageView.image = tipsIcon;
    [self addSubview:self.tipsImageView];
    
    self.textLabel.frame = CGRectMake(Interval_Size_30, self.tipsImageView.frame.origin.y + self.tipsImageView.frame.size.height + Interval_Size_5, rect.size.width, rect.size.height);
    [self addSubview:self.textLabel];
    
}

-(void)setTopText:(NSString *)message offsetY:(CGFloat)offsetY{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    self.textLabel.text = message;
    CGFloat normalWidth = UI_SCREEN_WIDTH - 2*Interval_Size_25;
    CGRect rect =[self.textLabel.text  boundingRectWithSize:CGSizeMake(normalWidth, MAXFLOAT)
                                                    options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:@{NSFontAttributeName:self.textLabel.font} context:nil];
    self.textLabel.textAlignment = (rect.size.width>normalWidth) ? NSTextAlignmentCenter : NSTextAlignmentLeft;
    self.textLabel.frame = CGRectMake(Interval_Size_25/2, Interval_Size_20/2, rect.size.width, rect.size.height);
    [self addSubview:self.textLabel];
    CGFloat height = rect.size.height+Interval_Size_20;
    self.layer.cornerRadius = 0;
    self.layer.masksToBounds = YES;
    self.frame = CGRectMake(0.0f, offsetY > 0 ? offsetY : HCToast_NAVIGATION_STATUS_BAR_HEIGHT, UI_SCREEN_WIDTH, height);
}

#pragma mark - Lazy load
@synthesize textLabel = _textLabel;
-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.numberOfLines = 0;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

@synthesize tipsImageView = _tipsImageView;
-(UIImageView *)tipsImageView{
    if (!_tipsImageView) {
        _tipsImageView = [[UIImageView alloc] init];
        _tipsImageView.backgroundColor = [UIColor clearColor];
    }
    return _tipsImageView;
}

@end


#pragma mark - HCToast

@interface HCToast()
@property (strong,nonatomic) HCToastView *toastView;
@property (assign,nonatomic) NSTimeInterval duration;
@property (assign,nonatomic) BOOL active;//是否活跃
@property (assign,nonatomic) CGFloat top_offsetY;//顶部显示Toast偏移量
@end

@implementation HCToast

+(instancetype)shareInstance{
    static HCToast *hcToast = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hcToast = [[HCToast alloc] init];
    });
    return hcToast;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.toastView = [[HCToastView alloc] init];
        self.active = NO;
        self.top_offsetY = 0;
    }
    return self;
}

-(void)showToast:(NSString *)message{
    if (!_active) {
        [[HCToast shareInstance] showToastViewWithMessage:message duration:Toast_Duration_Normal type:HCToastType_Toast];
    }
}

-(void)showSuccessIconToast:(NSString *)message{
    if (!_active) {
        [[HCToast shareInstance] showToastViewWithMessage:message duration:Toast_Duration_Normal type:HCToastType_SuccessIconToast];
    }
}

-(void)showErrorIconToast:(NSString *)message{
    if (!_active) {
        [[HCToast shareInstance] showToastViewWithMessage:message duration:Toast_Duration_Normal type:HCToastType_ErrorIconToast];
    }
}

-(void)showTopToast:(NSString *)message{
    if (!_active) {
        [[HCToast shareInstance] showToastViewWithMessage:message duration:Toast_Duration_Normal type:HCToastType_TopToast];
    }
}

-(void)showTopToast:(NSString *)message offsetY:(CGFloat)offsetY{
    if (!_active) {
        self.top_offsetY = offsetY;
        [[HCToast shareInstance] showToastViewWithMessage:message duration:Toast_Duration_Normal type:HCToastType_TopToast];
    }
}

-(void)clearToast{
    if (_active) {
        [self animationForViewRemove];
    }
}

-(void)showToastViewWithMessage:(NSString *)message duration:(NSTimeInterval)duration type:(HCToastType)type{
    if ([self isEmptyObj:message]) {
        return;
    }
    self.active = YES;
    self.duration = duration;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.toastView];
    
    //显示
    switch (type) {
        case HCToastType_Toast:{
            [self.toastView setTextMessage:message];
            break;
        }
        case HCToastType_SuccessIconToast:{
            [self.toastView setIconText:message type:type];
            break;
        }
        case HCToastType_ErrorIconToast:{
            [self.toastView setIconText:message type:type];
            break;
        }
        case HCToastType_TopToast:{
            [self.toastView setTopText:message offsetY:self.top_offsetY];
            break;
        }
            
        default:
            break;
    }
    
    if (type != HCToastType_TopToast) {
        self.toastView.center = [UIApplication sharedApplication].keyWindow.center;
    }
    
    
    //动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationWithDismiss)];
    self.toastView.alpha = 0.8;
    [UIView commitAnimations];
    
}

-(void)animationWithDismiss{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:self.duration?self.duration:Toast_Duration_Normal];//逗留时长
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationForViewRemove)];
    self.toastView.alpha = 0;
    [UIView commitAnimations];
}

- (void)animationForViewRemove{
    [self.toastView removeFromSuperview];
    self.active = NO;
    self.top_offsetY = 0;
}

#pragma mark - Utils
- (BOOL)isEmptyObj:(id)o
{
    if (o==nil) {
        return YES;
    }
    if (o==NULL) {
        return YES;
    }
    if ([o isKindOfClass:[NSNull class]]) {
        return YES;
    }

    if ([o isKindOfClass:[NSData class]]) {
        return [((NSData *)o) length]<=0;
    }
    if ([o isKindOfClass:[NSDictionary class]]) {
        return [((NSDictionary *)o) count]<=0;
    }
    if ([o isKindOfClass:[NSArray class]]) {
        return [((NSArray *)o) count]<=0;
    }
    if ([o isKindOfClass:[NSSet class]]) {
        return [((NSSet *)o) count]<=0;
    }
    return NO;
}

@end
