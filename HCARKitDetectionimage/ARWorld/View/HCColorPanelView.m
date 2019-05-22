//
//  HCColorPanelView.m
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/4/26.
//  Copyright © 2019 松小宝. All rights reserved.
//

#import "HCColorPanelView.h"
#import "Const.h"

@interface HCColorPanelView ()
@property (nonatomic, strong) NSMutableArray *colorArray;
@end

@implementation HCColorPanelView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image_color_panel_bgView"]];
        self.layer.cornerRadius = 5;
        [self createSubviews];
        [self createAutoLayout];
    }
    return self;
}

- (void)createSubviews{
    for (int i = 0; i < self.colorArray.count; i++) {
        UIColor *color = [self.colorArray objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = color;
        button.layer.cornerRadius = color_item_size_width/2;
        button.tag = i;
        [button addTarget:self action:@selector(selectColorWithIndex:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(color_item_size_width*i + (i+1)*color_item_distance_width, color_item_distance_width, color_item_size_width, color_item_size_width);
        [self addSubview:button];
    }
    
}

- (void)createAutoLayout{
    
}

- (void)selectColorWithIndex:(UIButton *)button{
    UIColor *color = [self.colorArray objectAtIndex:button.tag];
    if (self.selectColorBlock) {
        self.selectColorBlock(color);
    }
}

/*
 868B95FF
 2F2F2FFF
 FFFFFFFF
 2756EBFF
 */
- (NSMutableArray *)colorArray{
    if (!_colorArray) {
        _colorArray = [NSMutableArray arrayWithObjects:
                       UIColorFromRGB(0x868B95),
                       UIColorFromRGB(0x2F2F2F),
                       UIColorFromRGB(0xFFFFFF),
                       UIColorFromRGB(0x2756EB),
                       nil];
    }
    return _colorArray;
}

@end
