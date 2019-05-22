//
//  HCARAnimationActionViewController.m
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/5/7.
//  Copyright © 2019 松小宝. All rights reserved.
//

#import "HCARAnimationActionViewController.h"

@interface HCARAnimationActionViewController ()<ARSCNViewDelegate,ARSessionDelegate>
@property (nonatomic, strong) UIButton *backButton;//返回按钮
@property (nonatomic, strong) ARSCNView *sceneView;//AR视图（AR场景填在在其上）
@property (nonatomic, strong) ARWorldTrackingConfiguration *configuration;//AR世界追踪
@property (nonatomic, strong) SCNScene *scene;//AR场景

@property (nonatomic, strong) ARPlaneAnchor *planAnchor;//平面锚点
@property (nonatomic, strong) SCNNode *planParanNode;//地面节点(模型放上面)
@property (nonatomic, assign) BOOL modelShowing;//是否已经显示模型（已经显示模型后不继续重新布置平面）
@property (nonatomic, assign) BOOL isSeachPlan;//是否已经找到平面

//node
@property(strong,nonatomic)SCNNode *sunNode,*earthNode,*moonNode,*earthGroupNode,*sunHaloNode;

@end

@implementation HCARAnimationActionViewController

- (void)dealloc{
    _sceneView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AR动画";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.isSeachPlan = NO;
    self.modelShowing = NO;
    
    [self initARSceneView];
    [self initPageUI];
    [self startARWorldTrackingConfiguration];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.sceneView.session pause];
}

///初始化AR场景
- (void)initARSceneView{
    self.sceneView.scene = self.scene;
    [self.view addSubview:self.sceneView];
}

- (void)initPageUI{
    [self.sceneView addSubview:self.backButton];
}

//开启AR世界追踪
- (void)startARWorldTrackingConfiguration{
    switch (self.arType) {
        case ARWorldTrackingConfigurationType_Animation_Action:{//平面识别
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
            
            
            //设置节点的中心为捕捉到的中心点
            self.planParanNode.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z);
            
            self.planParanNode.name = @"planNodeName";//用于检测点击事件
            
            //将3D模型添加到捕捉到的节点上（此时如果将模型设置有颜色，就可以看到3D长方体模型）
            [node addChildNode:self.planParanNode];
        });
        
    }
}

//点击检测（碰撞检测）
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.arType == ARWorldTrackingConfigurationType_Animation_Action && self.isSeachPlan){
        //已经捕捉到平面，检测点击平面事件
        UITouch *touch = [touches anyObject];
        CGPoint tapPoint  = [touch locationInView:self.sceneView];//该点就是手指的点击位置
        NSDictionary *hitTestOptions = [NSDictionary dictionaryWithObjectsAndKeys:@(true),SCNHitTestBoundingBoxOnlyKey, nil];
        NSArray<SCNHitTestResult *> * results= [self.sceneView hitTest:tapPoint options:hitTestOptions];
        for (SCNHitTestResult *res in results) {//遍历所有的返回结果中的node
            if ([self isNodePlanNodeObject:res.node]) {
//                [[HCToast shareInstance] showToast:@"点击了平面"];
                [self showSCNNodeInARWorld];
                break;
            }
        }
    }
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

#pragma mark - 点击
- (void)doBak:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//显示节点内容
- (void)showSCNNodeInARWorld{
    if (!self.isSeachPlan) {
        [[HCToast shareInstance] showToast:@"请先寻找平面区域"];
        return;
    }
    if (self.modelShowing) {
        [[HCToast shareInstance] showToast:@"已显示场景内容"];
        return;
    }
    
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        //创建节点
//        [self initNode];
//    });

    //创建节点
    [self initNode];

    //隐藏捕捉平面的颜色（颜色设置为不可见）
    self.planParanNode.geometry.firstMaterial.diffuse.contents = [UIColor clearColor];
}


//创建节点
- (void)initNode{
    self.modelShowing = YES;
//    _sunNode = [[SCNNode alloc] init];//太阳节点
//    _sunNode.position = SCNVector3Make(self.planParanNode.position.x, self.planParanNode.position.y, self.planParanNode.position.z);
////    _sunNode.position = SCNVector3Make(0,0,0);
//    _sunNode.geometry = [SCNSphere sphereWithRadius:2.5];
//    _sunNode.geometry.firstMaterial.diffuse.contents = @"art.scnassets/earth/sun.jpg";
////    _sunNode.geometry.firstMaterial.multiply.contents = @"art.scnassets/earth/sun.jpg";
//    _sunNode.geometry.firstMaterial.multiply.intensity = 0.5;
//    _sunNode.geometry.firstMaterial.lightingModelName = SCNLightingModelConstant;
//    _sunNode.geometry.firstMaterial.multiply.wrapS =
//    _sunNode.geometry.firstMaterial.diffuse.wrapS  =
//    _sunNode.geometry.firstMaterial.multiply.wrapT =
//    _sunNode.geometry.firstMaterial.diffuse.wrapT  = SCNWrapModeRepeat;
//    _sunNode.geometry.firstMaterial.locksAmbientWithDiffuse   = YES;
//    [self.planParanNode addChildNode:_sunNode];

    
    SCNBox *planBox = [SCNBox boxWithWidth:10  height:10 length:10  chamferRadius:0];
    //使用Material渲染3D模型
    planBox.firstMaterial.diffuse.contents = [UIColor redColor];
    //创建3D模型节点
    SCNNode *node = [SCNNode nodeWithGeometry:planBox];
    node.position = SCNVector3Make(self.planParanNode.position.x, self.planParanNode.position.y, self.planParanNode.position.z);
    [self.planParanNode addChildNode:node];
}

//节点旋转
- (void)rotationNode{
    
}

-(void)addAnimationToSun{
    // Achieve a lava effect by animating textures
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"contentsTransform"];
    animation.duration = 10.0;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(3, 3, 3))];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(3, 3, 3))];
    animation.repeatCount = FLT_MAX;
    [_sunNode.geometry.firstMaterial.diffuse addAnimation:animation forKey:@"sun-texture"];
    
    animation = [CABasicAnimation animationWithKeyPath:@"contentsTransform"];
    animation.duration = 30.0;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(0, 0, 0), CATransform3DMakeScale(5, 5, 5))];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeTranslation(1, 0, 0), CATransform3DMakeScale(5, 5, 5))];
    animation.repeatCount = FLT_MAX;
    [_sunNode.geometry.firstMaterial.multiply addAnimation:animation forKey:@"sun-texture2"];
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

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(10, 20, 44, 44);
        [_backButton setImage:[UIImage imageNamed:@"image_back"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(doBak:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

@end
