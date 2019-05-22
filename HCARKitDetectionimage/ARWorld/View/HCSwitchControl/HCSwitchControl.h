//
//  HCSwitchControl.h
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/5/22.
//  Copyright © 2019 松小宝. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HCSwitchControl : UIButton

- (void)setSwitchControlStatus:(BOOL)isOn;

- (BOOL)getSwitchControlStatus;

@end

NS_ASSUME_NONNULL_END
