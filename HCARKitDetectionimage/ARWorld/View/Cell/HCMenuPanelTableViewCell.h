//
//  HCMenuPanelTableViewCell.h
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/4/26.
//  Copyright © 2019 松小宝. All rights reserved.
//  菜单面板cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define tableView_cell_height 70.f

typedef void(^ClickSwitchControlBlock)(NSInteger index, BOOL active);

@interface HCMenuPanelTableViewCell : UITableViewCell
@property (nonatomic, copy) ClickSwitchControlBlock switchBlock;//切换按钮点击回调

/**
 加载cell

 @param title cell标题
 @param active 该项是否活跃状态
 */
- (void)initCellWithTitle:(NSString *)title active:(BOOL)active indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
