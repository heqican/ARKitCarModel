//
//  HCARWorldViewController.m
//  HCARKitDetectionimage
//
//  Created by 何其灿 on 2019/4/16.
//  Copyright © 2019 松小宝. All rights reserved.
//

#import "HCARWorldViewController.h"



@interface HCARWorldViewController ()<ARSCNViewDelegate>
@property (nonatomic, strong) ARSCNView *sceneView;
@property (nonatomic, strong) ARWorldTrackingConfiguration *configuration;//AR世界追踪
@property (nonatomic, strong) ARConfiguration *faceConfiguration;//人脸识别追踪
@property (nonatomic, strong) SCNScene *scene;

/**
 *  播放器对象
 */
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) SCNNode *playerParanNode;//视频播放器载体节点

//人脸贴图节点
@property (nonatomic, strong) SCNNode *faceTextureMaskNode;
//眼镜贴图
@property (nonatomic, strong) SCNNode *glassTextureNode;

@end

@implementation HCARWorldViewController

- (void)dealloc{
    _sceneView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AR World";
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initARSceneView];
    [self startARWorldTrackingConfiguration];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.sceneView.session pause];
}

//初始化AR场景
- (void)initARSceneView{
    self.sceneView.scene = self.scene;
    [self.view addSubview:self.sceneView];
}


//开启AR世界追踪
- (void)startARWorldTrackingConfiguration{
    switch (self.arType) {
        case ARWorldTrackingConfigurationType_detectionImage:{//图片识别
            if (@available(iOS 11.3, *)) {
                //设置ARWorldTrackingConfiguration的detectionImage指向的目录（标示图文件夹）
                //注意：文件夹中的标示图必须设置其size大小，否则不能使用
                self.configuration.detectionImages = [ARReferenceImage referenceImagesInGroupNamed:@"ARDetectionImageResource" bundle:nil];
                //启动AR追踪
                [self.sceneView.session runWithConfiguration:self.configuration options:ARSessionRunOptionResetTracking | ARSessionRunOptionRemoveExistingAnchors];
            }
            break;
        }
        case ARWorldTrackingConfigurationType_planeDetection:{//平面识别
            if (@available(iOS 11.3, *)) {
                self.configuration.planeDetection = ARPlaneDetectionHorizontal; // | ARPlaneDetectionVertical;
                //启动AR追踪
                [self.sceneView.session runWithConfiguration:self.configuration options:ARSessionRunOptionResetTracking | ARSessionRunOptionRemoveExistingAnchors];
            }
            break;
        }
        case ARWorldTrackingConfigurationType_faceTracking:{//人脸检测
            if (@available(iOS 11.3, *)) {
                [self.sceneView.session runWithConfiguration:self.faceConfiguration];
            }
            break;
        }
        case ARWorldTrackingConfigurationType_faceTrackingBlendShapes:{//人脸检测 - 表情检测
            if (@available(iOS 11.3, *)) {
                [self.sceneView.session runWithConfiguration:self.faceConfiguration];
            }
            break;
        }
            
        default:{
            
            break;
        }
    }
    
}

#pragma mark - ARSCNViewDelegate
// 是不是需要持续定位之前的识别锚点
- (BOOL)sessionShouldAttemptRelocalization:(ARSession *)session{
    return YES;
}
//AR世界追踪回调
- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    if (self.arType == ARWorldTrackingConfigurationType_planeDetection) {//平面捕捉
        if ([anchor isMemberOfClass:[ARPlaneAnchor class]]) {//识别到了平面
            //添加一个3D模型，ARKit只有捕捉能力，锚点只是一个空间位置
            //获取捕捉到的平面锚点
            ARPlaneAnchor *planeAnchor = (ARPlaneAnchor *)anchor;
//            //创建一个box，3D模型（系统捕捉到的平底是不规则的，这里将其缩放）
//            SCNBox *planBox = [SCNBox boxWithWidth:planeAnchor.extent.x * 0.5 height:0 length:planeAnchor.extent.x * 0.5 chamferRadius:0];
//            //使用Material渲染3D模型
//            planBox.firstMaterial.diffuse.contents = [UIColor redColor];
//            //创建3D模型节点
//            SCNNode *planeNode = [SCNNode nodeWithGeometry:planBox];
//            //设置节点的中心为捕捉到的中心点
//            planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z);
//
//            //将3D模型添加到捕捉到的节点上（此时如果将模型设置有颜色，就可以看到3D长方体模型）
//            [node addChildNode:planeNode];
            
            
//            /**
//             *  1、加载.scn模型
//             */
//            //创建3D模型场景(将自定义模型展现出来)
//            SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/vase/vase.scn"];
//            //获取模型节点
//            //一个场景有多个节点，所有场景有且只有一个根节点
//            SCNNode *modelNode = scene.rootNode.childNodes.firstObject;
//            //设置模型节点的位置为捕捉到平底的位置（默认为相机位置）
//            modelNode.position = SCNVector3Make(planeAnchor.center.x, -10, planeAnchor.center.z);
//            modelNode.scale = SCNVector3Make(0.01, 0.01, 0.01);
//            //将自定义模型节点添加到捕捉到的节点上
//            [node addChildNode:modelNode];
            
            
            /**
             *  2、加载.dae模型
             */
//            SCNScene *scene = [SCNScene sceneWithURL:[[NSBundle mainBundle] URLForResource:@"skinning" withExtension:@".dae"] options:nil error:nil];
//            SCNScene *scene = [SCNScene sceneWithURL:[[NSBundle mainBundle] URLForResource:@"carBMW" withExtension:@".dae"] options:nil error:nil];
            SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/che/che.DAE"];
//            SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/skinning/skinning.dae"];
            
            for (SCNNode *childNode in scene.rootNode.childNodes) {
                NSLog(@"node name:%@",childNode.name);
            }
            
            //获取模型节点
            //一个场景有多个节点，所有场景有且只有一个根节点
            SCNNode *modelNode = scene.rootNode;
            //设置模型节点的位置为捕捉到平底的位置（默认为相机位置）
            modelNode.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y-5, planeAnchor.center.z-5);
            modelNode.scale = SCNVector3Make(0.1, 0.1, 0.1);
            modelNode.eulerAngles = SCNVector3Make(0, 0, 0);
//            modelNode.transform = SCNMatrix4MakeScale(0.001, 0.001, 0.001);
            
            modelNode.name = @"modelRootNode";//很重要，根据这个那么做对比，是否点击了模型
            
            //将自定义模型节点添加到捕捉到的节点上
            [node addChildNode:modelNode];
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}


//AR世界追踪回调 - 不断更新
- (void)renderer:(id <SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    if (self.arType == ARWorldTrackingConfigurationType_detectionImage) {//图片识别
        ARImageAnchor *imageAnchor = (ARImageAnchor *)anchor;
        //获取参考标示图对象
        ARReferenceImage  *referenceImage = imageAnchor.referenceImage;
        if ([referenceImage.name isEqual:@"imageHC01"] || [referenceImage.name isEqualToString:@"0003"]) {//识别到指定标示图
            
            //暂停并移除原先添加的节点
            [self.player pause];
            [self.playerParanNode removeFromParentNode];
            
            //加载新的视频资源
            [self setPlayerVideoItemWithDetectionImageName:referenceImage.name];
            
            //在标示图上创建节点
            self.playerParanNode = [SCNNode new];
            SCNBox *box = [SCNBox boxWithWidth:referenceImage.physicalSize.width height:referenceImage.physicalSize.height length:0.001 chamferRadius:0];
            self.playerParanNode.geometry = box;//创建一个箱子放在节点上
            //将创建的子节点旋转到与图片贴合(右手坐标)
            self.playerParanNode.eulerAngles = SCNVector3Make(-M_PI/2, 0, 0);
            
            //将box的materials设置成player对象
            SCNMaterial *material = [[SCNMaterial alloc] init];
            material.diffuse.contents = self.player;
            self.playerParanNode.geometry.materials = @[material];
            
            //直接播放
            [self.player play];
            
            [node addChildNode:self.playerParanNode];
            
        }
    }
}

- (void)renderer:(id<SCNSceneRenderer>)renderer willUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor{
    if (self.arType == ARWorldTrackingConfigurationType_faceTracking) {
        if (anchor && [anchor isKindOfClass:[ARFaceAnchor class]]) {//识别到人脸
            ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
            
            if (!_faceTextureMaskNode) {
                [node addChildNode:self.faceTextureMaskNode];
            }
            
            //实时更新贴图
            ARSCNFaceGeometry *faceGeometry = (ARSCNFaceGeometry *)self.faceTextureMaskNode.geometry;
            if (faceGeometry && [faceGeometry isKindOfClass:[ARSCNFaceGeometry class]]) {
                [faceGeometry updateFromFaceGeometry:faceAnchor.geometry];
            }
        }
        
    }else if (self.arType == ARWorldTrackingConfigurationType_faceTrackingBlendShapes){//表情检测
        if (anchor && [anchor isKindOfClass:[ARFaceAnchor class]]) {//识别到人脸锚点
            ARFaceAnchor *faceAnchor = (ARFaceAnchor *)anchor;
            NSDictionary *blendShapes = faceAnchor.blendShapes;
            NSNumber *browInnerUp = blendShapes[ARBlendShapeLocationBrowInnerUp];//皱眉程度
            if ([browInnerUp floatValue] > 0.5) {
                NSLog(@"皱眉啦............");
                if (!_glassTextureNode) {
                    [node addChildNode:self.glassTextureNode];
                }
                ARSCNFaceGeometry *faceGeometry = (ARSCNFaceGeometry *)self.glassTextureNode.geometry;
                if (faceGeometry && [faceGeometry isKindOfClass:[ARSCNFaceGeometry class]]) {
                    [faceGeometry updateFromFaceGeometry:faceAnchor.geometry];
                }
            }
            
        }
    }
}

- (void)renderer:(id <SCNSceneRenderer>)renderer didRemoveNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor {
    // Nodes will be removed if planes multiple individual planes that are detected to all be
    // part of a larger plane are merged.
    
}

- (void)sessionInterruptionEnded:(ARSession *)session {
    
}



//设置player预播放的视频资源
- (void)setPlayerVideoItemWithDetectionImageName:(NSString *)imageName{
    NSURL *videoUrl = [self getPlayVideoUrl:imageName];
    self.player = [AVPlayer playerWithURL:videoUrl];
}


#pragma mark - lazy load
- (SCNView *)sceneView{
    if (!_sceneView) {
        _sceneView = [[ARSCNView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _sceneView.delegate = self;
        _sceneView.allowsCameraControl = YES;//对模型随意的进行操作
    }
    return _sceneView;
}

- (ARWorldTrackingConfiguration *)configuration{
    if (!_configuration) {
        _configuration = [[ARWorldTrackingConfiguration alloc] init];
    }
    return _configuration;
}

- (ARConfiguration *)faceConfiguration{
    if (!_faceConfiguration) {
        _faceConfiguration = [[ARFaceTrackingConfiguration alloc] init];
        _faceConfiguration.lightEstimationEnabled = YES;
    }
    return _faceConfiguration;
}

- (SCNScene *)scene{
    if (!_scene) {
        _scene = [[SCNScene alloc] init];
    }
    return _scene;
}

//视频载体节点（视频添加在该节点上）
- (SCNNode *)playerParanNode{
    if (!_playerParanNode) {
        _playerParanNode = [SCNNode new];
    }
    return _playerParanNode;
}


/**
 播放器对象

 @return AVPlayer
 */
-(AVPlayer *)player{
    if (!_player) {
//        AVPlayerItem *playerItem=[self getPlayItem:0];
        _player=[[AVPlayer alloc] init];
    }
    return _player;
}


-(AVPlayerItem *)getPlayItem:(int)videoIndex{
    NSString * urlStr = [[NSBundle mainBundle]pathForResource:@"0004.mp4" ofType:nil];
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
    return playerItem;
}

//获取与识别图对应的视频路径
- (NSURL *)getPlayVideoUrl:(NSString *)videoName{
    NSString * urlStr = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@.mp4",videoName] ofType:nil];
    NSURL *url=[NSURL fileURLWithPath:urlStr];
//    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
    return url;
}


/**
 人脸贴图节点

 @return SCNNode
 */
- (SCNNode *)faceTextureMaskNode {
    if (!_faceTextureMaskNode) {
        id<MTLDevice> device = self.sceneView.device;
        ARSCNFaceGeometry *geometry = [ARSCNFaceGeometry faceGeometryWithDevice:device fillMesh:NO];
        SCNMaterial *material = geometry.firstMaterial;
        material.fillMode = SCNFillModeFill;
        material.diffuse.contents = [UIImage imageNamed:@"faceTexture.jpg"];
        _faceTextureMaskNode = [SCNNode nodeWithGeometry:geometry];
    }
    _faceTextureMaskNode.name = @"textureMask";
    return _faceTextureMaskNode;
}


/**
 眼镜贴图

 @return <#return value description#>
 */
- (SCNNode *)glassTextureNode{
    if (!_glassTextureNode) {
        id<MTLDevice> device = self.sceneView.device;
        ARSCNFaceGeometry *geometry = [ARSCNFaceGeometry faceGeometryWithDevice:device fillMesh:NO];
        SCNMaterial *material = geometry.firstMaterial;
        material.fillMode = SCNFillModeFill;
        material.diffuse.contents = [UIImage imageNamed:@"glass.png"];
        _glassTextureNode = [SCNNode nodeWithGeometry:geometry];
    }
    _glassTextureNode.name = @"glassNode";
    return _glassTextureNode;
}

@end
