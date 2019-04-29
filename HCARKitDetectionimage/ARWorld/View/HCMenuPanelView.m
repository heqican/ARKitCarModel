//
//  HCMenuPanelView.m
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/4/26.
//  Copyright © 2019 松小宝. All rights reserved.
//

#import "HCMenuPanelView.h"
#import <Masonry.h>
#import "HCMenuPanelTableViewCell.h"



@interface HCMenuPanelView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation HCMenuPanelView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image_menu_panel_bgView"]];
        [self tableViewDataList];
        [self createSubviews];
        [self createAutoLayout];
    }
    return self;
}

- (void)tableViewDataList{
    self.dataArray = [NSMutableArray arrayWithObjects:@"拆卸轮胎",@"转动轮胎",@"汽车旋转",@"后视镜",@"升降车窗", nil];
}

- (void)createSubviews{
    [self addSubview:self.closeButton];
    [self addSubview:self.tableView];
}

- (void)createAutoLayout{
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(44);
        make.height.mas_equalTo(44);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.closeButton.mas_bottom).offset(5);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)show{
    [UIView animateWithDuration:0.5 animations:^{
        self.center = CGPointMake(iphone_width - MenuPanel_Size_Width/2, iphone_height/2);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hidden{
    [UIView animateWithDuration:0.5 animations:^{
        self.center = CGPointMake(iphone_width + MenuPanel_Size_Width/2, iphone_height/2);
    } completion:^(BOOL finished) {
        
    }];
}

//更新轮胎拆卸控件状态
- (void)updateTireSparedStatus:(BOOL)tireSpared{
    self.tireSpared = tireSpared;
    [self.tableView reloadData];
}

#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView_cell_height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCMenuPanelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menu_cell_str"];
    if (cell == nil) {
        cell = [[HCMenuPanelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menu_cell_str"];
    }
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MenuPanel_Size_Width, tableView_cell_height)];
    selectView.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = selectView;
    cell.backgroundColor = [UIColor clearColor];
    
    NSString *title = [self.dataArray objectAtIndex:indexPath.row];
    
    //init cell
    switch (indexPath.row) {
        case 0:{//拆卸轮胎
            [cell initCellWithTitle:title active:self.tireSpared indexPath:indexPath];
            break;
        }
        case 1:{//轮胎转动
            [cell initCellWithTitle:title active:self.tireTurned indexPath:indexPath];
            break;
        }
        case 2:{//汽车旋转（自转）
            [cell initCellWithTitle:title active:self.carTurned indexPath:indexPath];
            break;
        }
        case 3:{//后视镜
            [cell initCellWithTitle:title active:self.rearviewMirrorClosed indexPath:indexPath];
            break;
        }
        case 4:{//升降车窗
            [cell initCellWithTitle:title active:self.windowsDown indexPath:indexPath];
            break;
        }
            
        default:{
            [cell initCellWithTitle:title active:NO indexPath:indexPath];
            break;
        }
    }
    
    //按钮切换回调
    cell.switchBlock = ^(NSInteger index, BOOL active) {
        switch (index) {
            case 0:{//拆卸轮胎回调
                if (self.tireSparedBlock) {
                    self.tireSparedBlock(active);
                }
                break;
            }
            case 1:{//轮胎转动回调
                if (self.tireTurnBlock) {
                    self.tireTurned = active;
                    self.tireTurnBlock(active);
                }
                break;
            }
            case 2:{//汽车旋转（自转）
                if (self.carTurnBlock) {
                    self.carTurned = active;
                    self.carTurnBlock(active);
                }
                break;
            }
            case 3:{//合上后视镜
                if (self.rearviewMirrorBlock) {
                    self.rearviewMirrorClosed = active;
                    self.rearviewMirrorBlock(active);
                }
                break;
            }
            case 4:{//升降车窗
                if (self.windowsBlock) {
                    self.windowsDown = active;
                    self.windowsBlock(active);
                }
                break;
            }
                
            default:
                break;
        }
    };
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 点击
//关闭菜单
- (void)closePanelView:(id)sender{
    [self hidden];
}


#pragma mark - lazy load
- (UIButton *)closeButton{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"image_close_icon"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closePanelView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

@end
