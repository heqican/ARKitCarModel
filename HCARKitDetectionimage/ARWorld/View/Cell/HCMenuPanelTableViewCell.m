//
//  HCMenuPanelTableViewCell.m
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/4/26.
//  Copyright © 2019 松小宝. All rights reserved.
//

#import "HCMenuPanelTableViewCell.h"
#import "HCToast.h"
#import <Masonry.h>
#import "HCSwitchControl.h"

@interface HCMenuPanelTableViewCell ()
@property (nonatomic, strong) UILabel *titleNameLabel;
//@property (nonatomic, strong) UISwitch *switchControl;
@property (nonatomic, strong) HCSwitchControl *switchControl;
@end

@implementation HCMenuPanelTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
        [self createAutoLayoutSubviews];
    }
    return self;
}

- (void)initCellWithTitle:(NSString *)title active:(BOOL)active indexPath:(NSIndexPath *)indexPath{
    self.titleNameLabel.text = title;
    self.switchControl.tag = indexPath.row;
//    self.switchControl.on = active;
    [self.switchControl setSwitchControlStatus:active];
}

- (void)createSubViews{
    [self.contentView addSubview:self.titleNameLabel];
    [self.contentView addSubview:self.switchControl];
}

- (void)createAutoLayoutSubviews{
    [self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(100);
    }];
    [self.switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleNameLabel.mas_bottom);
        make.left.mas_equalTo(self.titleNameLabel.mas_left);
        make.width.mas_equalTo(159);
        make.height.mas_equalTo(25);
    }];
}

- (void)switchStatus:(HCSwitchControl *)sender{
    [self.switchControl setSwitchControlStatus:!self.switchControl.selected];
    if (self.switchBlock) {
        self.switchBlock(sender.tag, sender.selected);
    }
}

#pragma mark - lazy load
- (UILabel *)titleNameLabel{
    if (!_titleNameLabel) {
        _titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
        _titleNameLabel.textColor = [UIColor whiteColor];
        _titleNameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleNameLabel;
}

- (HCSwitchControl *)switchControl{
    if (!_switchControl) {
        _switchControl = [[HCSwitchControl alloc] init];
        [_switchControl addTarget:self action:@selector(switchStatus:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchControl;
}

@end
