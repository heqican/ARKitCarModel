//
//  HCARCarViewController.m
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/4/25.
//  Copyright © 2019 松小宝. All rights reserved.
//

#import "HCARCarViewController.h"
#import "Const.h"
#import "HCColorPanelView.h"
#import "HCMenuPanelView.h"

static const CGFloat Car_Model_Scale = 0.01;//汽车模型缩放比例


@interface HCARCarViewController ()<ARSCNViewDelegate,ARSessionDelegate>
@property (nonatomic, strong) ARSCNView *sceneView;//AR视图（AR场景填在在其上）
@property (nonatomic, strong) ARWorldTrackingConfiguration *configuration;//AR世界追踪
@property (nonatomic, strong) SCNScene *scene;//AR场景

@property (nonatomic, strong) ARPlaneAnchor *planAnchor;//平面锚点
@property (nonatomic, strong) SCNNode *planParanNode;//地面节点(模型放上面)
@property (nonatomic, assign) BOOL modelShowing;//是否已经显示模型（已经显示模型后不继续重新布置平面）
@property (nonatomic, assign) BOOL isSeachPlan;//是否已经找到平面

@property (nonatomic, strong) SCNNode *carModelNode;//汽车模型节点

@property (nonatomic, assign) BOOL tireSpared;//是否已经拆下轮胎

//颜色面板
@property (nonatomic, strong) HCColorPanelView *colorPanelView;
//菜单面板
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) HCMenuPanelView *menuPanelView;
@property (nonatomic, strong) UIImageView *topNameImageView;
@property (nonatomic, strong) UIButton *lightButton;//开车灯按钮


@end

@implementation HCARCarViewController

- (BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

- (void)dealloc{
    _sceneView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"汽车世界";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.arType = ARWorldTrackingConfigurationType_planeDetection_CarDemo;
    
    self.modelShowing = NO;
    self.isSeachPlan = NO;
    self.colorPanelView.hidden = YES;
    self.menuButton.hidden = YES;
    self.topNameImageView.hidden = YES;
    self.lightButton.hidden = YES;

    self.tireSpared = NO;
    self.menuPanelView.tireSpared = NO;
    
    [self initARSceneView];
    [self initPageUI];
    [self startARWorldTrackingConfiguration];
    
    [self addRecognizerToSceneView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.sceneView.session pause];
}

- (void)initPageUI{
    [self.sceneView addSubview:self.colorPanelView];
    [self.sceneView addSubview:self.menuButton];
    [self.sceneView addSubview:self.topNameImageView];
    [self.sceneView addSubview:self.lightButton];
    [self.sceneView addSubview:self.menuPanelView];
}

//初始化AR场景
- (void)initARSceneView{
    self.sceneView.scene = self.scene;
    [self.view addSubview:self.sceneView];
}

//开启AR世界追踪
- (void)startARWorldTrackingConfiguration{
    switch (self.arType) {
        case ARWorldTrackingConfigurationType_planeDetection_CarDemo:{//平面识别
            if (@available(iOS 11.3, *)) {
                self.configuration.planeDetection = ARPlaneDetectionHorizontal;
                //启动AR追踪
                [self.sceneView.session runWithConfiguration:self.configuration options:ARSessionRunOptionResetTracking | ARSessionRunOptionRemoveExistingAnchors];
            }
            break;
        }
        default:{
            break;
        }
    }
}

#pragma mark - ARKit Delegate
//AR世界追踪回调
- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    if (self.arType == ARWorldTrackingConfigurationType_planeDetection_CarDemo) {
        if ([anchor isMemberOfClass:[ARPlaneAnchor class]] && !self.modelShowing) {
            [self.planParanNode removeFromParentNode];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.isSeachPlan = YES;
                
                //获取捕捉到的平面锚点
                ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
                self.planAnchor = planeAnchor;
                
                 //方案一
                //创建一个box，3D模型（系统捕捉到的平底是不规则的，这里将其缩放）
                SCNBox *planBox = [SCNBox boxWithWidth:planeAnchor.extent.x  height:0 length:planeAnchor.extent.x  chamferRadius:0];
                //使用Material渲染3D模型
                planBox.firstMaterial.diffuse.contents = [UIColor greenColor];
                //创建3D模型节点
                self.planParanNode = [SCNNode nodeWithGeometry:planBox];
                
//                //方案二
//                SCNPlane *planeGeometry = [SCNPlane planeWithWidth:planeAnchor.extent.x height:planeAnchor.extent.z];
//                //平面展示网格
//                SCNMaterial *material = [SCNMaterial new];
//                UIImage *img = [UIImage imageNamed:@"tron_grid"];
//                material.diffuse.contents = img;
//                planeGeometry.materials = @[material];
//                //创建3D模型节点
//                self.planParanNode = [SCNNode nodeWithGeometry:planeGeometry];
//                self.planParanNode.transform = SCNMatrix4MakeRotation(-M_PI/2.0, 1.0, 0.0, 0.0);//平面在SceneKit中默认是vertical的，所以要旋转90度
                
                
                //设置节点的中心为捕捉到的中心点
                self.planParanNode.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z);
                
                self.planParanNode.name = @"planNodeName";//用于检测点击事件
                
                //将3D模型添加到捕捉到的节点上（此时如果将模型设置有颜色，就可以看到3D长方体模型）
                [node addChildNode:self.planParanNode];
            });
            
            
        }
    }
}

//相机移动
- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame{
    
}

#pragma mark - 拆卸汽车零件

//拆下|安装轮胎
- (void)tireParts:(id)sender{
    if (self.tireSpared) {
        [self recoveryPartsCar:@"Group002" spareDistance:10 beFlip:YES];//Group002:左前轮
        self.tireSpared = NO;
        self.menuPanelView.tireSpared = NO;
    }else{
        [self removePartsCar:@"Group002" spareDistance:10 beFlip:YES];
        self.tireSpared = YES;
        self.menuPanelView.tireSpared = YES;
    }
    
    //更新菜单面板上 拆卸按钮状态
    [self.menuPanelView updateTireSparedStatus:self.tireSpared];
    
}

/**
 拆汽车零件 [self removePartsCar:@"Group002"];
 
 @param sparePartsName 汽车零件模型名称
 @param spareDistance 拆卸偏离距离 （为0时，使用默认距离）
 @param beFlip 是否翻转模型
 */
- (void)removePartsCar:(NSString *)sparePartsName spareDistance:(CGFloat)spareDistance beFlip:(BOOL)beFlip{
    for (SCNNode *partsNode in self.carModelNode.childNodes) {
        if ([partsNode.name isEqualToString:sparePartsName]) {
            //找到对应的零件模型
            [UIView animateWithDuration:1.0 animations:^{
                //零件往外移动
                partsNode.position = SCNVector3Make(partsNode.position.x + spareDistance ,partsNode.position.y,partsNode.position.z);
            } completion:^(BOOL finished) {
                if (beFlip) {
                    //零件翻转
                    partsNode.eulerAngles = SCNVector3Make(0, 0, M_PI/2);
                }
            }];
            
        }
    }
}

/**
 安装拆下的零件
 
 @param sparePartsName 汽车零件模型名称
 @param spareDistance 拆卸偏离距离 （为0时，使用默认距离）
 @param beFlip 是否翻转模型
 */
- (void)recoveryPartsCar:(NSString *)sparePartsName spareDistance:(CGFloat)spareDistance beFlip:(BOOL)beFlip{
    for (SCNNode *partsNode in self.carModelNode.childNodes) {
        if ([partsNode.name isEqualToString:sparePartsName]) {
            //找到对应的零件模型 Group002:左前轮
            [UIView animateWithDuration:1.0 animations:^{
                if (beFlip) {
                    //零件翻转
                    partsNode.eulerAngles = SCNVector3Make(0, 0, 0);
                }
            } completion:^(BOOL finished) {
                //零件回到原来位置
                partsNode.position = SCNVector3Make(partsNode.position.x - spareDistance ,partsNode.position.y,partsNode.position.z);
            }];
            
        }
    }
}

#pragma mark - 轮胎转动

/**
 轮胎转动|停止转动

 @param active 转动状态
 */
- (void)tireTurnWithActive:(BOOL)active{
    if (active) {
        [self startTireTurnningModel:@"Group002" duration:0.1];
        [self startTireTurnningModel:@"Group003" duration:0.1];
        [self startTireTurnningModel:@"Group004" duration:0.1];
        [self startTireTurnningModel:@"Group005" duration:0.1];
    }else{
        [self stopTireTurnningModel:@"Group002"];
        [self stopTireTurnningModel:@"Group003"];
        [self stopTireTurnningModel:@"Group004"];
        [self stopTireTurnningModel:@"Group005"];
    }
}

//开始轮胎转动
- (void)startTireTurnningModel:(NSString *)modelName duration:(NSTimeInterval)duration{
    for (SCNNode *partsNode in self.carModelNode.childNodes) {
        if ([partsNode.name isEqualToString:modelName]) {
            //创建自转动画
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
            animation.duration = duration;
            animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0,1,0, M_PI *2)];
            animation.repeatCount = FLT_MAX;
            [partsNode addAnimation:animation forKey:@"tire rotation"];
            [partsNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:2 y:0 z:0 duration:duration]]];//轮胎自转 绕X轴自转
        }
    }
}

//停止轮胎转动
- (void)stopTireTurnningModel:(NSString *)modelName{
    for (SCNNode *partsNode in self.carModelNode.childNodes) {
        if ([partsNode.name isEqualToString:modelName]) {
            //需要同时remove Animation和Actions，只移除其中一个无效
            [partsNode removeAnimationForKey:@"tire rotation"];
            [partsNode removeAllActions];
        }
    }
}


#pragma mark - 汽车旋转（自转）

/**
 汽车自转

 @param active <#active description#>
 */
- (void)carTurnWithActive:(BOOL)active{
    if (active) {
        [self startCarTurnningDuration:5.0];
    }else{
        [self stopCarTurnning];
    }
}

//开始轮胎转动
- (void)startCarTurnningDuration:(NSTimeInterval)duration{
    //创建自转动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"carRotation"];
    animation.duration = duration;
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0,1,0, M_PI *2)];
    animation.repeatCount = FLT_MAX;
    [self.carModelNode addAnimation:animation forKey:@"car rotation"];
    [self.carModelNode runAction:[SCNAction repeatActionForever:[SCNAction rotateByX:0 y:2 z:0 duration:duration]]];//轮胎自转 绕Y轴自转
}

//停止轮胎转动
- (void)stopCarTurnning{
    //需要同时remove Animation和Actions，只移除其中一个无效
    [self.carModelNode removeAnimationForKey:@"car rotation"];
    [self.carModelNode removeAllActions];
}


#pragma mark - 后视镜开|合

/**
 打开|合上后视镜

 @param active 是否要合上后视镜
 */
- (void)rearviewMirrorClose:(BOOL)active{
    if (active) {//合上后视镜
        [self closeRearviewMirrorModel:@"GroupMirror_left" angle:M_PI*2/5 Duration:1.0];
        [self closeRearviewMirrorModel:@"GroupMirror_right" angle:-M_PI*2/5 Duration:1.0];
    }else{//打开后视镜
        [self openRearviewMirrorModel:@"GroupMirror_left" angle:-M_PI*2/5 Duration:1.0];
        [self openRearviewMirrorModel:@"GroupMirror_right" angle:M_PI*2/5 Duration:1.0];
    }
}

//合上后视镜
- (void)closeRearviewMirrorModel:(NSString *)modelName angle:(CGFloat)angle Duration:(NSTimeInterval)duration{
    for (SCNNode *partsNode in self.carModelNode.childNodes) {
        if ([partsNode.name isEqualToString:modelName]) {
            
            //创建自转动画
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"rotation"];//执行的是旋转
            animation.duration = duration;
//            animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0,0,0, 0)];//旋转角度
            animation.repeatCount = 1;
            [partsNode addAnimation:animation forKey:@"rearviewMirror rotation"];
            [partsNode runAction:[SCNAction repeatAction:[SCNAction rotateByX:0 y:angle z:0 duration:duration] count:1]];//后视镜绕Y轴旋转 angle角度
        }
    }
}

//打开后视镜
- (void)openRearviewMirrorModel:(NSString *)modelName angle:(CGFloat)angle Duration:(NSTimeInterval)duration{
    for (SCNNode *partsNode in self.carModelNode.childNodes) {
        if ([partsNode.name isEqualToString:modelName]) {
            //创建自转动画
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
            animation.duration = duration;
//            animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0,1,0, 0)];
            animation.repeatCount = 1;
            [partsNode addAnimation:animation forKey:@"rearviewMirror2 rotation"];
            [partsNode runAction:[SCNAction repeatAction:[SCNAction rotateByX:0 y:angle z:0 duration:duration] count:1]];//后视镜绕Y轴旋转
        }
    }
}


#pragma mark - 升降车窗

/**
 升降车窗 Object009 Object010 Object011

 @param active 是否要降下车窗
 */
- (void)windowsUpDown:(BOOL)active{
    if (active) {
        [self downWindowsWithModelName:@"Object009" offsetY:5 duration:2.0];
        [self downWindowsWithModelName:@"Object010" offsetY:5 duration:2.0];
        [self downWindowsWithModelName:@"Object011" offsetY:5 duration:2.0];
    }else{
        [self upWindowsWithModelName:@"Object009" offsetY:5 duration:2.0];
        [self upWindowsWithModelName:@"Object010" offsetY:5 duration:2.0];
        [self upWindowsWithModelName:@"Object011" offsetY:5 duration:2.0];
        
    }
}


/**
 降下车窗

 @param modelName 模型对象名称
 @param duration 执行周期
 */
- (void)downWindowsWithModelName:(NSString *)modelName offsetY:(CGFloat)offsetY duration:(NSTimeInterval)duration{
    for (SCNNode *windowNode in self.carModelNode.childNodes) {
        if ([windowNode.name isEqualToString:modelName]) {
            //创建自转动画
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];//执行平移动画
            animation.duration = duration;
            animation.toValue = [NSValue valueWithSCNVector3:SCNVector3Make(windowNode.position.x, windowNode.position.y-offsetY, windowNode.position.z)];
            animation.removedOnCompletion = NO;
            animation.fillMode = @"forwards";
            [windowNode addAnimation:animation forKey:@"window position"];
        }
    }
}

//升起车窗
- (void)upWindowsWithModelName:(NSString *)modelName offsetY:(CGFloat)offsetY duration:(NSTimeInterval)duration{
    for (SCNNode *windowNode in self.carModelNode.childNodes) {
        if ([windowNode.name isEqualToString:modelName]) {
            //创建自转动画
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];//执行平移动画
            animation.duration = duration;
            animation.fromValue = [NSValue valueWithSCNVector3:SCNVector3Make(windowNode.position.x, windowNode.position.y-offsetY, windowNode.position.z)];
            animation.toValue = [NSValue valueWithSCNVector3:SCNVector3Make(windowNode.position.x, windowNode.position.y, windowNode.position.z)];
            animation.removedOnCompletion = NO;
            animation.fillMode = @"forwards";
            [windowNode addAnimation:animation forKey:@"window position"];
        }
    }
}


#pragma mark - 点击

- (void)doBak:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//显示菜单面板
- (void)showMenuPanelView:(id)sender{
    [self.menuPanelView show];
}

//点击车灯按钮
- (void)clickLightButton:(UIButton *)sender{
    sender.selected = !sender.selected;
    
}

#pragma mark - 显示汽车模型
//放置汽车模型  放在self.planParanNode上
- (void)showCarModel:(id)sender{
    if (!self.isSeachPlan) {
        [[HCToast shareInstance] showToast:@"请先寻找平面区域"];
        return;
    }
    if (self.modelShowing) {
        [[HCToast shareInstance] showToast:@"已放置汽车"];
        return;
    }
    
    //将汽车模型放在平面节点上
    dispatch_async(dispatch_get_main_queue(), ^{
        SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/che/che.scn"];
        self.carModelNode = scene.rootNode;
        //设置模型节点的位置为捕捉到平底的位置（默认为相机位置）
        self.carModelNode.position = SCNVector3Make(self.planParanNode.position.x, self.planParanNode.position.y, self.planParanNode.position.z);
        self.carModelNode.scale = SCNVector3Make(Car_Model_Scale, Car_Model_Scale, Car_Model_Scale);
//        self.carModelNode.transform = SCNMatrix4MakeRotation(M_PI/2.0, 1.0, 0.0, 0.0);//平面在SceneKit中默认是vertical的，所以要旋转90度
        self.carModelNode.name = @"modelCarNode";//很重要，根据这个那么做对比，是否点击了模型
        [self.planParanNode addChildNode:self.carModelNode];
        
        //隐藏捕捉平面的颜色（颜色设置为不可见）
        self.planParanNode.geometry.firstMaterial.diffuse.contents = [UIColor clearColor];
    });
    self.modelShowing = YES;
    self.colorPanelView.hidden = NO;
    self.menuButton.hidden = NO;
    self.topNameImageView.hidden = NO;
    self.lightButton.hidden = NO;
}

//点击检测（碰撞检测）
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.arType == ARWorldTrackingConfigurationType_planeDetection_CarDemo && self.modelShowing) {
        //已经放置了汽车模型，检测点击汽车事件
        UITouch *touch = [touches anyObject];
        CGPoint tapPoint  = [touch locationInView:self.sceneView];//该点就是手指的点击位置
        NSDictionary *hitTestOptions = [NSDictionary dictionaryWithObjectsAndKeys:@(true),SCNHitTestBoundingBoxOnlyKey, nil];
        NSArray<SCNHitTestResult *> * results= [self.sceneView hitTest:tapPoint options:hitTestOptions];
        for (SCNHitTestResult *res in results) {//遍历所有的返回结果中的node
            if ([self isNodeCarModelObject:res.node]) {
//                [[HCToast shareInstance] showToast:@"点击了汽车"];
                NSLog(@"点击了汽车...............");
                break;
            }
        }
    }else if (self.arType == ARWorldTrackingConfigurationType_planeDetection_CarDemo && self.isSeachPlan){
        //已经捕捉到平面，检测点击平面事件
        UITouch *touch = [touches anyObject];
        CGPoint tapPoint  = [touch locationInView:self.sceneView];//该点就是手指的点击位置
        NSDictionary *hitTestOptions = [NSDictionary dictionaryWithObjectsAndKeys:@(true),SCNHitTestBoundingBoxOnlyKey, nil];
        NSArray<SCNHitTestResult *> * results= [self.sceneView hitTest:tapPoint options:hitTestOptions];
        for (SCNHitTestResult *res in results) {//遍历所有的返回结果中的node
            if ([self isNodePlanNodeObject:res.node]) {
//                [[HCToast shareInstance] showToast:@"点击了平面"];
                [self showCarModel:nil];
                break;
            }
        }
    }
}
//上溯找寻指定的node（是否点击了汽车）
-(BOOL) isNodeCarModelObject:(SCNNode*)node {
    if ([@"modelCarNode" isEqualToString:node.name]) {
        return true;
    }
    if (node.parentNode != nil) {
        return [self isNodeCarModelObject:node.parentNode];
    }
    return false;
}
//上溯找寻指定的node（是否点击了平面）
-(BOOL) isNodePlanNodeObject:(SCNNode*)node {
    if ([@"planNodeName" isEqualToString:node.name]) {
        return true;
    }
    if (node.parentNode != nil) {
        return [self isNodePlanNodeObject:node.parentNode];
    }
    return false;
}

#pragma mark - 模型的拖拽、旋转、缩放

//给场景视图添加手势
- (void)addRecognizerToSceneView{
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.sceneView addGestureRecognizer:panGes];
    UIRotationGestureRecognizer *rotateGes = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateView:)];
    [self.sceneView addGestureRecognizer:rotateGes];
    UIPinchGestureRecognizer *pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.sceneView addGestureRecognizer:pinchGes];
}

// 处理拖拉手势 - 移动 旋转
- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer{
    if (self.modelShowing) {
        NSLog(@"拖拽.....................");
        UIView *view = panGestureRecognizer.view;
        CGPoint location = [panGestureRecognizer translationInView:self.sceneView];
        CGPoint velocityPoint = [panGestureRecognizer velocityInView:self.sceneView];
        switch (panGestureRecognizer.state) {
            case UIGestureRecognizerStateChanged:{
//                self.carModelNode.position = SCNVector3Make(self.planParanNode.position.x + location.y/10*Car_Model_Scale, self.planParanNode.position.y, self.planParanNode.position.z + location.x/10*Car_Model_Scale);

//                if let touchedObj = virtualObject(at: location, inSceV: sceneView) {//位移
//                    objM.translate(touchedObj, in: sceneView, basedOn: location, instantly: true)//位移方法
//                    objM.lastUsedObject = touchedObj//自定义模型管理类
//                }
                
                //旋转模型
                float xx = velocityPoint.x/5000;
                float yy = velocityPoint.y/5000;
                self.carModelNode.eulerAngles = SCNVector3Make(0, self.carModelNode.eulerAngles.y + (fabs(xx) > fabs(yy) ? xx : -yy), 0);
                
                break;
            }
            case UIGestureRecognizerStateEnded:{
                return;
            }
                
            default:{
                break;
            }
        }
    }
    
}

// 处理旋转手势
- (void)rotateView:(UIRotationGestureRecognizer *)rotationGestureRecognizer{
    if (self.modelShowing){
        NSLog(@"旋转.....................");
        
    }
}

// 处理缩放手势
CGFloat oldGesScale = Car_Model_Scale;
CGFloat oldModelScale = Car_Model_Scale;
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer{
    if (self.modelShowing){
//        NSLog(@"缩放.....................");
        if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan) {//手势开始
            oldGesScale = pinchGestureRecognizer.scale;//手势开始时，获取模型的比例
            oldModelScale = self.carModelNode.scale.x;//手势开始时，获取模型的scale
        }
        
        if (pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            //计算, 当前手势scale除以手势开始时的scale, 以开始时模型的scale为基准相乘, 实现圆润的放大缩小效果
            CGFloat currentGesScale = pinchGestureRecognizer.scale;
            CGFloat scale = oldModelScale *  (float)(currentGesScale / oldGesScale);
            scale = scale < 0.005 ? 0.005 : scale;
            scale = scale > 0.05 ? 0.05 : scale ;
            self.carModelNode.scale = SCNVector3Make(scale, scale, scale);
        }
        
    }
}


#pragma mark - lazy load

- (ARSCNView *)sceneView{
    if (!_sceneView) {
        _sceneView = [[ARSCNView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _sceneView.delegate = self;
        _sceneView.session.delegate = self;
//        _sceneView.allowsCameraControl = YES;//对模型随意的进行操作
    }
    return _sceneView;
}

- (ARWorldTrackingConfiguration *)configuration{
    if (!_configuration) {
        _configuration = [[ARWorldTrackingConfiguration alloc] init];
    }
    return _configuration;
}

- (SCNScene *)scene{
    if (!_scene) {
        _scene = [[SCNScene alloc] init];
    }
    return _scene;
}

- (SCNNode *)planParanNode{
    if (!_planParanNode) {
        _planParanNode = [SCNNode new];
    }
    return _planParanNode;
}


- (HCColorPanelView *)colorPanelView{
    if (!_colorPanelView) {
        _colorPanelView = [[HCColorPanelView alloc] initWithFrame:CGRectMake(0, iphone_height - color_item_size_width - color_item_distance_width*2, color_items_count*color_item_size_width + (color_items_count+1)*color_item_distance_width, color_item_size_width + color_item_distance_width*2)];
        _colorPanelView.center = CGPointMake(iphone_width/2, _colorPanelView.center.y);
        __weak typeof(self)weakSelf = self;
        _colorPanelView.selectColorBlock = ^(UIColor * _Nonnull color) {
            //修改汽车颜色
            SCNNode *bodyNode = [weakSelf.carModelNode childNodeWithName:@"body_01" recursively:YES];
            bodyNode.childNodes[0].geometry.firstMaterial.diffuse.contents = color;
            
            [weakSelf.menuPanelView hidden];
        };
    }
    return _colorPanelView;
}

- (UIButton *)menuButton{
    if (!_menuButton) {
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.frame = CGRectMake(iphone_width - 60, 15, 44, 44);
        [_menuButton setImage:[UIImage imageNamed:@"image_menu_icon"] forState:UIControlStateNormal];
        [_menuButton addTarget:self action:@selector(showMenuPanelView:) forControlEvents:UIControlEventTouchUpInside];
        _menuButton.hidden = YES;
    }
    return _menuButton;
}

- (UIImageView *)topNameImageView{
    if (!_topNameImageView) {
        _topNameImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 131, 40)];
        [_topNameImageView setImage:[UIImage imageNamed:@"car_topName_image"]];
        _topNameImageView.center = CGPointMake(iphone_width/2, _topNameImageView.center.y);
        _topNameImageView.hidden = YES;
    }
    return _topNameImageView;
}

- (UIButton *)lightButton{
    if (!_lightButton) {
        _lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _lightButton.frame = CGRectMake(16, 15, 44, 44);
        [_lightButton setImage:[UIImage imageNamed:@"car_light_button_image_normal"] forState:UIControlStateNormal];
        [_lightButton setImage:[UIImage imageNamed:@"car_light_button_image_selected"] forState:UIControlStateSelected];
        [_lightButton addTarget:self action:@selector(clickLightButton:) forControlEvents:UIControlEventTouchUpInside];
        _lightButton.hidden = YES;
    }
    return _lightButton;
}

- (HCMenuPanelView *)menuPanelView{
    if (!_menuPanelView) {
        _menuPanelView = [[HCMenuPanelView alloc] initWithFrame:CGRectMake(iphone_width, 0, MenuPanel_Size_Width, iphone_height)];
        __weak typeof(self)weakSelf = self;
        //点击拆卸按钮
        _menuPanelView.tireSparedBlock = ^(BOOL active) {
            [weakSelf tireParts:nil];
        };
        //点击转动轮胎按钮
        _menuPanelView.tireTurnBlock = ^(BOOL active) {
            [weakSelf tireTurnWithActive:active];
        };
        //汽车旋转（自转）
        _menuPanelView.carTurnBlock = ^(BOOL active) {
            [weakSelf carTurnWithActive:active];
        };
        //后视镜开|合
        _menuPanelView.rearviewMirrorBlock = ^(BOOL active) {
            [weakSelf rearviewMirrorClose:active];
        };
        //升降车窗
        _menuPanelView.windowsBlock = ^(BOOL active) {
            [weakSelf windowsUpDown:active];
        };
    }
    return _menuPanelView;
}

@end
