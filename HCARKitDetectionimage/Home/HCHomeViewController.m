//
//  HCHomeViewController.m
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/4/16.
//  Copyright © 2019 松小宝. All rights reserved.
//

#import "HCHomeViewController.h"
#import "HCRouterManager.h"
#import "HCARWorldViewController.h"

@interface HCHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIButton *detectionImageButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation HCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Welcom HCARKit";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self initListItem];
    [self.view addSubview:self.tableView];
}

- (void)initListItem{
    [self.dataArray addObject:@"ARWorld - DetectionImage (图片识别)"];
    [self.dataArray addObject:@"ARWorld - planeDetection (平面捕捉)"];
    [self.dataArray addObject:@"ARWorld - faceTracking (人脸贴图)"];
    [self.dataArray addObject:@"ARWorld - faceTracking (表情检测)"];
    [self.dataArray addObject:@"ARWorld - 汽车Demo"];
    [self.dataArray addObject:@"ARWorld - SCNAction动画"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"table_cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"table_cell"];
    }
    NSString *title = [self.dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            [self clickARWorldCellWithARMode:ARWorldTrackingConfigurationType_detectionImage sender:nil];
            break;
        }
        case 1:{
            [self clickARWorldCellWithARMode:ARWorldTrackingConfigurationType_planeDetection sender:nil];
            break;
        }
        case 2:{
            [self clickARWorldCellWithARMode:ARWorldTrackingConfigurationType_faceTracking sender:nil];
            break;
        }
        case 3:{
            [self clickARWorldCellWithARMode:ARWorldTrackingConfigurationType_faceTrackingBlendShapes sender:nil];
            break;
        }
        case 4:{
            [self clickARWorldCarCellWithARMode:ARWorldTrackingConfigurationType_planeDetection_CarDemo sender:nil];
            break;
        }
        case 5:{
            [self clickARWorldAnimationActionARModel:ARWorldTrackingConfigurationType_Animation_Action sender:nil];
        }
            
        default:
            break;
    }
}

/**
 进图AR世界，图片识别

 @param sender <#sender description#>
 */
- (void)clickARWorldCellWithARMode:(ARWorldTrackingConfigurationType)type sender:(id)sender{
    [[HCRouterManager shareInstance] onARWorldWithType:type ParamVC:self animated:YES];
}
- (void)clickARWorldCarCellWithARMode:(ARWorldTrackingConfigurationType)type sender:(id)sender{
    [[HCRouterManager shareInstance] onARWorldCarWithType:type ParamVC:self animated:YES];
}
- (void)clickARWorldAnimationActionARModel:(ARWorldTrackingConfigurationType)type sender:(id)sender{
    [[HCRouterManager shareInstance] onARWorldAnimationActionWithType:type paranVC:self animated:YES];
}

#pragma mark  - lazy load

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}

@end
