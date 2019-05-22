//
//  HCSwitchControl.m
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/5/22.
//  Copyright © 2019 松小宝. All rights reserved.
//

#import "HCSwitchControl.h"

@implementation HCSwitchControl

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setImage:[UIImage imageNamed:@"switch_control_normal"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"switch_control_selected"] forState:UIControlStateSelected];
    }
    return self;
}

- (void)setSwitchControlStatus:(BOOL)isOn{
    self.selected = isOn;
}

- (BOOL)getSwitchControlStatus{
    return self.selected;
}

@end
