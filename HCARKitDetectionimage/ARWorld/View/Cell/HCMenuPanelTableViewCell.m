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

@interface HCMenuPanelTableViewCell ()
@property (nonatomic, strong) UILabel *titleNameLabel;
@property (nonatomic, strong) UISwitch *switchControl;
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
    self.switchControl.on = active;
}

- (void)createSubViews{
    [self.contentView addSubview:self.titleNameLabel];
    [self.contentView addSubview:self.switchControl];
}

- (void)createAutoLayoutSubviews{
    [self.titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(100);
    }];
    [self.switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-20);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(44);
    }];
}

- (void)switchStatus:(UISwitch *)sender{
    if (self.switchBlock) {
        self.switchBlock(sender.tag, sender.isOn);
    }
}

#pragma mark - lazy load
- (UILabel *)titleNameLabel{
    if (!_titleNameLabel) {
        _titleNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
        _titleNameLabel.textColor = [UIColor whiteColor];
        _titleNameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleNameLabel;
}

- (UISwitch *)switchControl{
    if (!_switchControl) {
        _switchControl = [[UISwitch alloc] init];
        [_switchControl addTarget:self action:@selector(switchStatus:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchControl;
}

@end
