//
//  TAGLKView.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "TAGLKView.h"

/** Camera FOV initial value */
#define CAMERA_FOV_DEGREE_INIT          (80.0f)
/** Camera FOV minimum value */
#define CAMERA_FOV_DEGREE_MIN           (40.0f)
/** Camera FOV maximum value */
#define CAMERA_FOV_DEGREE_MAX           (100.0f)

/** Parameter for maximum width control */
#define SCALE_RATIO_TICK_EXPANSION      (1.02f)
/** Parameter for minimum width control */
#define SCALE_RATIO_TICK_REDUCTION      (0.98f)

/** Z/NEAR for OpenGL perspective display */
#define Z_NEAR                          (0.1f)
/** Z/FA for OpenGL perspective display */
#define Z_FAR                           (100.0f)

/** Spherical radius for photo attachment */
#define SHELL_RADIUS                    (100.0f)
/** Number of spherical polygon partitions for photo attachment */
#define SHELL_DIVIDE                    (48)

/** Parameter for amount of rotation control (X axis) */
#define DIVIDE_ROTATE_X                 (400)
/** Parameter for amount of rotation control (Y axis) */
#define DIVIDE_ROTATE_Y                 (400)

/** Timer s */
#define KNUM_INTERVAL_INERTIA           (0.01)
/** Amount of movement parameter for inertia (weak) */
#define WEAK_INERTIA_RATIO              (1.0)
/** Amount of movement parameter for inertia (mediun) */
#define MEDIUM_INERTIA_RATIO            (5.0)
/** Amount of movement parameter for inertia (strong) */
#define STRONG_INERTIA_RATIO            (10.0)

//uProjection:從camera到螢幕的轉換 - 螢幕顯示的座標
//uView * uModel * aPosition:從世界座標系到camera的轉換 - camera的座標
//uModel * aPosition:從物件座標系到世界座標系的轉換 - 世界座標
//aPosition:物件座標

typedef enum : int {
    NoneInertia = 0,
    ShortInertia,
    MediumInertia,
    LongInertia
} enumInertia;

@interface TAGLKView() {
    
    TASphereObject *shell;
    
    GLKTextureInfo *mTextureInfo;
    GLKTextureInfo *mTextureInfo2;
    GLKTextureInfo *mTextureInfo3;
    
    GLKTextureLoader *textureLoader;
    
    GLuint shaderProgram;
    
    NSTimer *_timer;
    uint _timerCount;
    int _kindInertia;
    
    BOOL inPanMode;
    CGPoint panPrev;
    int panLastDiffX;
    int panLastDiffY;
    double inertiaRatio;
    
    float viewAspectRatio;
    
    GLint aPosition;
    GLint aUV;
    GLint aUV2;
    
    GLint uProjection;
    GLint uView;
    GLint uModel;
    GLint uTex;
    GLint uTex2;
    
    float _yaw;
    float _roll;
    float _pitch;
    
    UIPanGestureRecognizer *panGestureRecognizer;
    UIPinchGestureRecognizer *pinchGestureRecognizer;
    UITapGestureRecognizer *tapGestureRecognizer;
    UILongPressGestureRecognizer *longPressGestureRecognizer;
    
    GLKMatrix4 projectionMatrix;
    GLKMatrix4 lookAtMatrix;
    GLKMatrix4 modelMatrix;
    
    float cameraPosX;
    float cameraPosY;
    float cameraPosZ;
    float cameraDirectionX;
    float cameraDirectionY;
    float cameraDirectionZ;
    float cameraUpX;
    float cameraUpY;
    float cameraUpZ;
    
    float cameraFovDegree;
    
    double mRotationAngleXZ;
    double mRotationAngleY;
    
    GLuint vertexBufferID;
    
    GLint _textureModeSlot;
    GLint _textureMode;
    
    NSMutableDictionary *dataDictionary;
    NSMutableArray *buttonObjectArray;
    NSMutableArray *sceneObjectArray;
    NSMutableArray *calculateSquareArray;
}

@end


@implementation TAGLKView

#pragma mark - Init

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        buttonObjectArray = [NSMutableArray array];
        sceneObjectArray = [NSMutableArray array];
        calculateSquareArray = [NSMutableArray array];
        textureLoader = [[GLKTextureLoader alloc] init];

        //滑動延遲
        _kindInertia = NoneInertia;
        
        projectionMatrix = GLKMatrix4Identity;
        lookAtMatrix = GLKMatrix4Identity;
        modelMatrix = GLKMatrix4Identity;
        
        EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext:context];
        self.context = context;
        
        if (self) {
            [self settingCamera];
            [self registerGestures];
            [self initOpenGLSettings];
            [self killTimer];
            
            // Enable fragment blending with Frame Buffer contents
            glEnable(GL_BLEND);
            glBlendFunc( GL_SRC_ALPHA , GL_ONE_MINUS_SRC_ALPHA );
            
            glEnable(GL_DEPTH_TEST);
            glDepthFunc(GL_LESS);
            
            shell = [[TASphereObject alloc] init:SHELL_RADIUS divide:SHELL_DIVIDE];
        }
        
        DxLog(@"initwithframe frame: x: %f y: %f width %f height %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    }
    
    return self;
}

-(void) setTexture:(NSMutableData*)data width:(int)width height:(int)height dataDict:(NSMutableDictionary *)dataDict rotationAngleXZ:(double)rotationAngleXZ rotationAngleY:(double)rotationAngleY
{
    mRotationAngleXZ = rotationAngleXZ;
    mRotationAngleY = rotationAngleY;
    
    GLuint name = mTextureInfo.name;
    glDeleteTextures(1,&name);
    GLuint name2 = mTextureInfo2.name;
    glDeleteTextures(1,&name2);
    GLuint name3 = mTextureInfo3.name;
    glDeleteTextures(1,&name3);
    
    dataDictionary = dataDict;
    
    NSError *error;
    
    mTextureInfo =[GLKTextureLoader textureWithContentsOfData:data options:nil error:&error];
    
    //============
    
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageNamed:@"arrow1.png"])];
    
    mTextureInfo2 = [GLKTextureLoader textureWithContentsOfData:imageData options:nil error:&error];
    
    //============
    
    NSData *imageData2 = [NSData dataWithData:UIImagePNGRepresentation([UIImage imageNamed:@"arrow.png"])];
    
    mTextureInfo3 = [GLKTextureLoader textureWithContentsOfData:imageData2 options:nil error:&error];

    [self settingSphereObject];
    [self settingSquareObject];
}

- (void)settingCamera
{
    mRotationAngleXZ = 0.0f;
    mRotationAngleY = 0.0f;
    
    // set initial camera pos and direction
    cameraPosX = 0.0f;
    cameraPosY = 0.0f;
    cameraPosZ = 0.0f;
    cameraDirectionX = 0.0f;
    cameraDirectionY = 0.0f;
    cameraDirectionZ = 0.0f;
    cameraUpX = 0.0f;
    cameraUpY = 1.0f;
    cameraUpZ = 0.0f;
    
    cameraFovDegree = CAMERA_FOV_DEGREE_INIT;
}

- (UIImage *)flipImage:(UIImage *)image
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, image.size.width, 0);
    transform = CGAffineTransformScale(transform, -1, 1);
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
- (void)settingSphereObject
{
    
    for (int i = 0 ; i < 4 ; i++) {
        for (int j = 0 ; j < 8 ; j++) {
            TATestSphere *tt = [[TATestSphere alloc] init:90 widthSegments:10 heightSegments:10 phiStart:M_PI / 4 * j phiLength:M_PI / 4 thetaStart:M_PI / 4 * i thetaLength:M_PI / 4];
            
            NSString *name = [NSString stringWithFormat:@"%i-%i.jpeg",i,j];
            UIImage *image = [UIImage imageNamed:name];
            UIImage *flipImage = [self flipImage:image];

//            NSData *imageData = UIImageJPEGRepresentation(flipImage, 2);
            
            NSError *error;
            GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:([image CGImage]) options:nil error:&error];
//            GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfData:imageData options:nil error:&error];
            tt.textureMode = _textureMode;
            tt.textureInfo = textureInfo;
            
            [sceneObjectArray addObject:tt];
        }
    }
    

    /*
    for (int i = 0 ; i < 4 ; i++) {
        for (int j = 0 ; j < 8 ; j++) {
            
            TASphereFragmentObject *spfragmentObj = [[TASphereFragmentObject alloc] init:90
                                                                           widthSegments:4
                                                                          heightSegments:8
                                                                                phiStart:M_PI / 4 * j
                                                                               phiLength:M_PI / 4
                                                                              thetaStart:M_PI / 4 * i
                                                                             thetaLength:M_PI / 4];
            
//            NSString *name = [NSString stringWithFormat:@"%i-%i.jpeg",i,j];
//            GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:([[UIImage imageNamed:name] CGImage]) options:nil error:nil];
            
            spfragmentObj.textureMode = _textureMode;
            spfragmentObj.textureInfo = mTextureInfo;
            
            [sceneObjectArray addObject:spfragmentObj];
        }
    }
*/
}

- (void)settingSquareObject
{
    
    for (NSDictionary *dict in dataDictionary[@"transition"]) {
        
        TASquareObject *square = [[TASquareObject alloc] initSize:[dict[@"size"] floatValue]
                                                           radius:90
                                                    transformPage:[dict[@"nextID"] description]
                                                   transfromTheta:[dict[@"lng"] floatValue]
                                                     transfromPhi:[dict[@"lat"] floatValue]
                                                        rotationX:[dict[@"rotateX"] floatValue]
                                                        rotationY:[dict[@"rotateY"] floatValue]
                                                        rotationZ:[dict[@"rotateZ"] floatValue]];
        
        square.textureInfo = mTextureInfo2;
        square.textureMode = 1;
        [buttonObjectArray addObject:square];
    }
}

#pragma mark - returnMotionDataDelegate

//-(void)returnMotionCMGyroDataData:(CMGyroData *)data
//{
//    
//}

#pragma mark - Draw

/**
 * Redraw method
 */
-(void) draw{
    
    //  gl_Position = uProjection * uView * uModel * aPosition;
    
    //camera -> 螢幕
    projectionMatrix = GLKMatrix4Identity;
    //camera
    lookAtMatrix = GLKMatrix4Identity;
    //物件 -> 世界
    modelMatrix = GLKMatrix4Identity;
    
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //決定相機觀看位置
    cameraDirectionX = (float) (cos(mRotationAngleXZ)*cos(mRotationAngleY));
    cameraDirectionY = (float) sin(mRotationAngleY);
    cameraDirectionZ = (float) (sin(mRotationAngleXZ)*cos(mRotationAngleY));
    
    //    NSLog(@"camera direction: %f %f %f", cameraDirectionX, cameraDirectionY, cameraDirectionZ);
    
    //決定projectionMatrix(Z_NEAR,Z_FAR,cameraFovDegree,viewAspectRatio)
    projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(cameraFovDegree), viewAspectRatio, Z_NEAR, Z_FAR);
    
    //model不動可以不用設定 = 1
    GLKMatrix4 elevetionAngleMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(_pitch), 0, 0, 1);
    modelMatrix = GLKMatrix4Multiply(modelMatrix, elevetionAngleMatrix);
    GLKMatrix4 horizontalAngleMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(_roll), 1, 0, 0);
    modelMatrix = GLKMatrix4Multiply(modelMatrix, horizontalAngleMatrix);
    
    //相機(注視點,位置點,Direction)
    lookAtMatrix = GLKMatrix4MakeLookAt(cameraPosX, cameraPosY, cameraPosZ,
                                        cameraDirectionX, cameraDirectionY, cameraDirectionZ,
                                        cameraUpX, cameraUpY, cameraUpZ);
    //一系列給值
    //uModel = modelMatrix
    glUniformMatrix4fv(uModel, 1, GL_FALSE, modelMatrix.m);
    [self glCheckError:@"glUniform4fv model"];
    //uView = lookAtMatrix
    glUniformMatrix4fv(uView, 1, GL_FALSE, lookAtMatrix.m);
    [self glCheckError:@"glUniform4fv viewmatrix"];
    //uProjection = projectionMatrix
    glUniformMatrix4fv(uProjection, 1, GL_FALSE, projectionMatrix.m);
    [self glCheckError:@"glUniform4fv projectionmatrix"];
    
    //===共用的shader參數===//
    //把aPosition這個參數的id通知shader
    glEnableVertexAttribArray(aPosition);
    
    //畫球體
    //把aUV這個參數的id通知shader
//    glEnableVertexAttribArray(aUV);
//    [self drawSphere];
    
    //畫球體fragment
    glEnableVertexAttribArray(aUV);
    [self drawSphereFragment];
    
    //畫箭頭
    //把aUV2這個參數的id通知shader
    glEnableVertexAttribArray(aUV2);
    [self drawSquare];
    
    //解除
    glDisableVertexAttribArray(aPosition);
    glDisableVertexAttribArray(aUV);
    glDisableVertexAttribArray(aUV2);
    
    return;
}


-(void)drawRect:(CGRect)rect
{
    [self draw];
}

- (void)drawSphere
{
    //畫球體
    //uTex = 所用素材
    shell.textureMode = 0;
    shell.textureInfo = mTextureInfo;
    [shell draw:aPosition uv:aUV textureModeSlot:_textureModeSlot tex:uTex];
}

- (void)drawSphereFragment
{
    
    for (TATestSphere *sphereFrag in sceneObjectArray) {
        [sphereFrag draw:aPosition uv:aUV textureModeSlot:_textureModeSlot tex:uTex];
    }
    
    /*
    for (TASphereFragmentObject *sphereFrag in sceneObjectArray) {
        
        [sphereFrag draw:aPosition uv:aUV textureModeSlot:_textureModeSlot tex:uTex];
    }
     */
}

- (void)drawSquare
{
    for (TASquareObject *square in buttonObjectArray) {
        
        [square draw:aPosition uv:aUV2 textureModeSlot:_textureModeSlot tex:uTex2];
    }
}

#pragma mark - Calculate

typedef struct {
    GLKVector4  positionCoords;
}
calculVertex;

calculVertex TriangleVertice2[] =
{
    {{ 1.0f,  1.0f,  1.0f,  1.0}},
    {{ 1.0f,  1.0f,  1.0f,  1.0}},
    {{ 1.0f,  1.0f,  1.0f,  1.0}},
    {{ 1.0f,  1.0f,  1.0f,  1.0}},
    {{ 1.0f,  1.0f,  1.0f,  1.0}},
    {{ 1.0f,  1.0f,  1.0f,  1.0}},
};

- (void)calculate3DTo2D:(CGPoint)tapPoint
{
    for (TASquareObject *square in buttonObjectArray) {
        
        for (int i = 0; i < 6; i++) {
            TriangleVertice2[i].positionCoords = GLKVector4Make(1, 1, 1, 1);
        }
        
        for (int i = 0; i < 6; i++) {
            calculVertex structValue;
            NSValue *pullValue = [[square getObjectvectorArray] objectAtIndex:i];
            [pullValue getValue:&structValue];
            TriangleVertice2[i].positionCoords = structValue.positionCoords;
        }
        //撈出來的四方形位置向量已經是有乘過model矩陣的了,所以直接乘camera的就好
        
        // 乘lookAtMatrix
        for (int i = 0 ; i < 6; i++) {
            GLKVector4 ver = GLKMatrix4MultiplyVector4(lookAtMatrix, TriangleVertice2[i].positionCoords);
            TriangleVertice2[i].positionCoords = ver;
        }
        // 乘projectionMatrix
        for (int i = 0 ; i < 6; i++) {
            GLKVector4 ver = GLKMatrix4MultiplyVector4(projectionMatrix, TriangleVertice2[i].positionCoords);
            TriangleVertice2[i].positionCoords = ver;
        }
        //除以W = X/W Y/W (1~-1)
        for (int i = 0 ; i < 6; i++) {
            GLKVector4 ver = TriangleVertice2[i].positionCoords;
            ver.x = ver.x / ver.w;
            ver.y = ver.y / ver.w;
            ver.z = ver.z / ver.w;
            TriangleVertice2[i].positionCoords = ver;
        }
        //1-YW/2*h = Y point, 1+XW/2*W = X point
        for (int i = 0 ; i < 6; i++) {
            GLKVector4 ver = TriangleVertice2[i].positionCoords;
            ver.x = ((1 + ver.x) / 2) * (self.frame.size.width * 2);
            ver.y = ((1 - ver.y) / 2) * (self.frame.size.height * 2);
            TriangleVertice2[i].positionCoords = ver;
        }
        NSArray *titleArray = [NSArray arrayWithObjects:@"左下",@"右下",@"左上,",@"左上,",@"右下",@"右上", nil];
        for (int i = 0 ; i < 6; i++) {
            GLKVector4 ver = TriangleVertice2[i].positionCoords;
//            NSLog(@"轉換後位置:%@(%f, %f) z = %f",titleArray[i],ver.x,ver.y,ver.z);
            /*
             if (ver.x < 0 || ver.y < 0) {
             DxLog(@"計算座標錯誤！x = %f, y = %f",ver.x,ver.y);
             return;
             }
             */
        }
        
        if ([self calculateTouch:tapPoint]) {
            
            [calculateSquareArray addObject:square];
        }
    }
    
    //判斷如果有同x,y的square要看哪個z比較近
    if ([calculateSquareArray count] == 0) {
        //沒點到按鈕
        return;
    }
    else if ([calculateSquareArray count] == 1) {
        
        TASquareObject *square = calculateSquareArray[0];
        //只有一個的話那就直接跳轉
        square.textureInfo = mTextureInfo3;
        
        double delayInSeconds = 0.02f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            square.textureInfo = mTextureInfo2;
            DxLog(@"square.transformPageIndex = %@",square.transformPageIndex);
            
            //換場景
            TAGLKViewController *glVC = (TAGLKViewController *)self.myViewController;
            [glVC.tapDelegate transfromView:square.transformPageIndex rotationAngleXZ:mRotationAngleXZ rotationAngleY:mRotationAngleY];
            
            [calculateSquareArray removeAllObjects];
        });
    }
    else if ([calculateSquareArray count] > 1) {
        
#warning 這邊計算有問題,但是現在按鈕轉到地板上所以不會有同軸的情況
        [calculateSquareArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            TASquareObject *sq1 = obj1;
            TASquareObject *sq2 = obj2;
            
            calculVertex structValue;
            NSValue *pullValue = [[sq1 getObjectvectorArray] objectAtIndex:0];
            [pullValue getValue:&structValue];
            float z = structValue.positionCoords.z;
            
            calculVertex structValue2;
            NSValue *pullValue2 = [[sq2 getObjectvectorArray] objectAtIndex:0];
            [pullValue2 getValue:&structValue2];
            float z2 = structValue2.positionCoords.z;
            
            z = fabs(z);
            z2 = fabs(z2);
            DxLog(@"z = %f, z2 = %f",z,z2);
            
            if (z > z2)
            {
                NSLog(@"降冪");
                return (NSComparisonResult)NSOrderedDescending;
            }else if (z < z2)
            {
                NSLog(@"升冪");
                return (NSComparisonResult)NSOrderedAscending;
            }
            else{
                NSLog(@"忽略大小寫相同的字串");
                return (NSComparisonResult)NSOrderedSame;
            }
            
        }];
        
        TASquareObject *square = calculateSquareArray[0];
        square.textureInfo = mTextureInfo3;
        
        double delayInSeconds = 0.03f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            square.textureInfo = mTextureInfo2;
            DxLog(@"square.transformPageIndex = %i",square.transformPageIndex);
            
            //換場景
            TAGLKViewController *glVC = (TAGLKViewController *)self.myViewController;
            [glVC.tapDelegate transfromView:square.transformPageIndex rotationAngleXZ:mRotationAngleXZ rotationAngleY:mRotationAngleY];
            
            [calculateSquareArray removeAllObjects];
            
        });
    }
}

- (BOOL)calculateTouch:(CGPoint)tapPoint
{
    //計算範圍內點擊
    
    double x,x1,x2,x3,y,y1,y2,y3,ans1,ans2,ans3;
    
    x = tapPoint.x;
    y = tapPoint.y;
    
    for (int i = 0; i < 2; i++) {
        
        if (i == 0) {
            
            x1 = TriangleVertice2[0].positionCoords.x;
            x2 = TriangleVertice2[1].positionCoords.x;
            x3 = TriangleVertice2[2].positionCoords.x;
            
            y1 = TriangleVertice2[0].positionCoords.y;
            y2 = TriangleVertice2[1].positionCoords.y;
            y3 = TriangleVertice2[2].positionCoords.y;
        }
        else {
            x1 = TriangleVertice2[3].positionCoords.x;
            x2 = TriangleVertice2[4].positionCoords.x;
            x3 = TriangleVertice2[5].positionCoords.x;
            
            y1 = TriangleVertice2[3].positionCoords.y;
            y2 = TriangleVertice2[4].positionCoords.y;
            y3 = TriangleVertice2[5].positionCoords.y;
        }
        
        ans1 = (((y2 - y3) * (x - x3)) + ((x3 - x2) * (y - y3))) / (((y2 - y3) * (x1 - x3)) + ((x3 - x2) * (y1 - y3)));
        ans2 = (((y3 - y1) * (x - x3)) + ((x1 - x3) * (y - y3))) / (((y2 - y3) * (x1 - x3)) + ((x3 - x2) * (y1 - y3)));
        ans3 = 1 - ans1 - ans2;
        
        if (i == 0) {
            if (ans3 >= 0 && ans3 <= 1 && ans2 >= 0 && ans2 <= 1 && ans1 >= 0 && ans1 <= 1) {
//                NSLog(@"ans1 = %f,ans2 = %f,ans3 = %f",ans1,ans2,ans3);
                return YES;
            }
        }
        else {
            if (ans3 >= 0 && ans3 <= 1 && ans2 >= 0 && ans2 <= 1 && ans1 >= 0 && ans1 <= 1) {
//                NSLog(@"ans1 = %f,ans2 = %f,ans3 = %f",ans1,ans2,ans3);
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark Gestures
/**
 * Gesture registration method
 */

-(void) registerGestures{
    
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
    [panGestureRecognizer setMaximumNumberOfTouches:1];
    [self addGestureRecognizer:panGestureRecognizer];
    
    pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureHandler:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
    
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    
    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapGestureHandler:)];
    [self addGestureRecognizer:longPressGestureRecognizer];
}

- (void)killTimer
{
    [_timer invalidate];
    _timer = nil;
    _timerCount = 0;
}

/**
 * Handler when touch start is detected
 * @param touches Touch information
 * @param event Event
 */
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self killTimer];
    
    inPanMode = false;
    return;
}

/**
 * Handler when touch is detected
 * @param touches Touch information
 * @param event Event
 */
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //CGPoint movePos = [[touches anyObject] locationInView:self];
    //NSLog(@"touchesMoved x = %f, y = %f", movePos.x, movePos.y);
    return;
}

/**
 * Handler when touch exit is detected
 * @param touches Touch information
 * @param event Event
 */
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touchesEnded");
    return;
}

/**
 * Multiple gesture detection compatibility setting method
 */
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return NO;
}
/*
 tapGestureHandler
 */
-(void) tapGestureHandler:(UITapGestureRecognizer*)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint tapLoc = [recognizer locationInView:self];
        tapLoc.x *= [UIScreen mainScreen].scale;
        tapLoc.y *= [UIScreen mainScreen].scale;
        
        NSLog(@"tapLoc = %@",NSStringFromCGPoint(CGPointMake(tapLoc.x, tapLoc.y)));
        
        TAGLKViewController *glVC = (TAGLKViewController *)self.myViewController;
        if (glVC.editType) {
            //編輯中
            
            
        }
        else {
            
            [self calculate3DTo2D:tapLoc];
        }
    }
}

/*
 longTapGestureHandler
 */
-(void) longTapGestureHandler:(UILongPressGestureRecognizer*)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint tapLoc = [recognizer locationInView:self];
        tapLoc.x *= [UIScreen mainScreen].scale;
        tapLoc.y *= [UIScreen mainScreen].scale;
        
        NSLog(@"longTap = %@",NSStringFromCGPoint(CGPointMake(tapLoc.x, tapLoc.y)));
        
        TAGLKViewController *glVC = (TAGLKViewController *)self.myViewController;
        if (glVC.editType) {
            //編輯中
            [self calculate3DTo2D:tapLoc];
        }
        else {
            
            
        }
    }
}

/**
 * Pinch operation compatibility handler
 * @param recognizer Recognizer object for gesture operations
 */
-(void) pinchGestureHandler:(UIPinchGestureRecognizer*)recognizer {
    
    [self scale:[recognizer scale]];
    //NSLog(@"pinchHandler state = %d, zoom = %f, scale = %f", [sender state], zoom, [sender scale]);
    
    return;
}

/**
 * Zoom in/Zoom out method
 * @param ratio Zoom in/zoom out ratio
 */
-(void) scale:(float) ratio {
    
    if (ratio < 1.0) {
        cameraFovDegree = cameraFovDegree * (SCALE_RATIO_TICK_EXPANSION);
        if (cameraFovDegree > CAMERA_FOV_DEGREE_MAX) {
            cameraFovDegree = CAMERA_FOV_DEGREE_MAX;
        }
    }
    else {
        cameraFovDegree = cameraFovDegree * (SCALE_RATIO_TICK_REDUCTION);
        if (cameraFovDegree < CAMERA_FOV_DEGREE_MIN) {
            cameraFovDegree = CAMERA_FOV_DEGREE_MIN;
        }
    }
    
    //    NSLog(@"cameraFovDegree: %f", cameraFovDegree);
    
    return;
}

/**
 * Pan operation compatibility handler
 * @param recognizer Recognizer object for gesture operations
 */
-(void) panGestureHandler:(UIPanGestureRecognizer*)recognizer {
    
    CGPoint cur = [recognizer translationInView:self];
    
    switch ([recognizer state]) {
        case UIGestureRecognizerStateEnded:
            //NSLog(@"pan gesture ended");
            [_timer invalidate];
            _timerCount = 0;
            if(_kindInertia != NoneInertia) {
                _timer = [NSTimer scheduledTimerWithTimeInterval:KNUM_INTERVAL_INERTIA
                                                          target:self
                                                        selector:@selector(timerInfo:)
                                                        userInfo:nil
                                                         repeats:YES];
            }
            break;
        default:
            if (inPanMode) {
                panLastDiffX = cur.x - panPrev.x;
                panLastDiffY = cur.y - panPrev.y;
                
                panPrev = cur;
                [self rotate:-panLastDiffX diffy:panLastDiffY];
            }
            else {
                inPanMode = true;
                panPrev = cur;
            }
            break;
    }
    
    //    NSLog(@"pan handler state %ld pos %f %f", (long)[recognizer state], cur.x, cur.y);
    return;
}

/**
 * Timer setting method
 * @param timer Setting target timer
 */
-(void) timerInfo:(NSTimer *)timer
{
    int diffX = 0;
    int diffY = 0;
    
    if (_timerCount == 0) {
        inertiaRatio = 1.0;
        switch (_kindInertia) {
            case ShortInertia:
                inertiaRatio = WEAK_INERTIA_RATIO;
                break;
            case MediumInertia:
                inertiaRatio = MEDIUM_INERTIA_RATIO;
                break;
            case LongInertia:
                inertiaRatio = STRONG_INERTIA_RATIO;
                break;
        }
    } else if(_timerCount > 150) {
        [_timer invalidate];
        _timer = nil;
        _timerCount = 0;
        return;
    } else {
        diffX = panLastDiffX*(1.0/_timerCount)*inertiaRatio;
        diffY = panLastDiffY*(1.0/_timerCount)*inertiaRatio;
        
        [self rotate:-diffX diffy:diffY];
    }
    
    //NSLog(@"********** timerInfo : %d lastx %d lasty %d x %d y %d ratio %f **********",
    //      _timerCount, panLastDiffX, panLastDiffX, diffX, diffY, inertiaRatio);
    _timerCount++;
    
    return;
}

/**
 * Rotation method
 * @param diffx Rotation amount (y axis)
 * @param diffy Rotation amount (xy plane)
 */
-(void) rotate:(int) diffx diffy:(int) diffy {
    
    float xz;
    float y;
    
    xz = (float)diffx / DIVIDE_ROTATE_X;
    y = (float)diffy / DIVIDE_ROTATE_Y;
    mRotationAngleXZ += xz;
    mRotationAngleY += y;
    if (mRotationAngleY > (M_PI/2)) {
        mRotationAngleY = (M_PI/2);
    }
    if (mRotationAngleY < -(M_PI/2)) {
        mRotationAngleY = -(M_PI/2);
    }
    
    //    NSLog(@"rotation angle: %f %f", mRotationAngleXZ, mRotationAngleY);
    return;
}

#pragma mark GLSettings
/**
 * OpenGL Initial value setting method
 * @param context OpenGL Context
 */
-(void) initOpenGLSettings {
    
    float viewWidth = self.frame.size.width;
    float viewHeight = self.frame.size.height;
    
    NSString *vertShaderPathname, *fragShaderPathname;
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"VertexShader" ofType:@"vsh"];
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"FragmentShader" ofType:@"fsh"];
    
    shaderProgram = [self loadProgram:vertShaderPathname fShaderSrc:fragShaderPathname];
    
    [self useAndAttachLocation: shaderProgram];
    
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    
    viewAspectRatio = viewWidth/viewHeight;
    glViewport(0, 0, viewWidth, viewHeight);
    
    return;
}

/**
 * Program creation function for OpenGL
 * @param vShaderSrc Vertex shader source
 * @param fShaderSrc Fragment shader source
 */
-(GLuint) loadProgram:(NSString*)vShaderSrc fShaderSrc:(NSString*)fShaderSrc {
    
    GLuint vertexShader;
    GLuint fragmentShader;
    GLuint program;
    GLint linked;
    
    // load the vertex shader
    vertexShader = [self loadShader:GL_VERTEX_SHADER shaderSrc:vShaderSrc];
    if (vertexShader == 0) {
        return 0;
    }
    // load fragment shader
    fragmentShader = [self loadShader:GL_FRAGMENT_SHADER shaderSrc:fShaderSrc];
    if (fragmentShader == 0) {
        glDeleteShader(vertexShader);
        return 0;
    }
    
    // create the program object
    program = glCreateProgram();
    if (program == 0) {
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        return 0;
    }
    
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    
    // link the program
    glLinkProgram(program);
    
    // check the link status
    glGetProgramiv(program, GL_LINK_STATUS, &linked);
    if (!linked) {
        
        GLint infoLen = 0;
        
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLen);
        
        if (infoLen > 1) {
            char *infoLog = malloc (sizeof(char) * infoLen);
            
            glGetProgramInfoLog(program, infoLen, NULL, infoLog);
            NSLog(@"Error linking program:\n%s\n", infoLog);
            
            free(infoLog);
        }
        
        glDeleteProgram(program);
        return 0;
    }
    
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    
    return program;
}

/**
 * Method for creating OpenGL shader
 *
 * @param @shaderType Shader type
 * @param @shaderSrc Shader source
 */
-(GLuint) loadShader:(GLenum)shaderType shaderSrc:(NSString *)shaderSrc {
    
    GLuint shader;
    GLint compiled;
    
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderSrc
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
    const char* shaderRealSrc = [shaderString cStringUsingEncoding:NSUTF8StringEncoding];
    
    shader = glCreateShader(shaderType);
    if (0 == shader) {
        return 0;
    }
    
    glShaderSource(shader, 1, &shaderRealSrc, NULL);
    glCompileShader(shader);
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    
    if (!compiled) {
        
        GLint infoLen = 0;
        
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
        
        if (infoLen > 1) {
            char *infoLog = malloc(sizeof(char) * infoLen);
            
            glGetShaderInfoLog(shader, infoLen, NULL, infoLog);
            NSLog(@"Error compiling shader:\n%s\n", infoLog);
            
            free(infoLog);
        }
        
        glDeleteShader(shader);
        return 0;
    }
    
    return shader;
}

/**
 * Program validation and various shader variable validation methods for OpenGL
 * @param program OpenGL Program variable
 */
-(void) useAndAttachLocation:(GLuint) program {
    
    glUseProgram(program);
    [self glCheckError:@"glUseProgram"];
    
    //把在shader裡面的參數id拿出來放到.m的變數裡面,之後要綁這些參數就是用他們的id
    
    aPosition = glGetAttribLocation(program, "aPosition");
    [self glCheckError:@"glGetAttribLocation position"];
    
    aUV = glGetAttribLocation(program, "aUV");
    [self glCheckError:@"glGetAttribLocation uv"];
    
    aUV2 = glGetAttribLocation(program, "aUV2");
    [self glCheckError:@"glGetAttribLocation uv2"];
    
    uProjection = glGetUniformLocation(program, "uProjection");
    [self glCheckError:@"glGetUniformLocation projection"];
    
    uView = glGetUniformLocation(program, "uView");
    [self glCheckError:@"glGetUniformLocation view"];
    
    uModel = glGetUniformLocation(program, "uModel");
    [self glCheckError:@"glGetUniformLocation model"];
    
    uTex = glGetUniformLocation(program, "uTex");
    [self glCheckError:@"glGetUniformLocation texture"];
    
    uTex2 = glGetUniformLocation(program, "uTex2");
    [self glCheckError:@"glGetUniformLocation texture2"];
    
    _textureModeSlot = glGetUniformLocation(program, "textureMode");
    [self glCheckError:@"glGetUniformLocation textureMode"];
    
    // Get the attribute color slot from program
}

/**
 * OpenGL Method for OpenGL error detection
 * @param Output character string at detection
 */
-(void) glCheckError:(NSString *) msg {
    GLenum error;
    
    while (GL_NO_ERROR != (error = glGetError())) {
        NSLog(@"GLERR: %d %@¥n", error, msg);
    }
    
    return;
}

#pragma mark - 報廢 methods

/*
 //取得正方行上的顏色
 int pix = 705*748*3;
 int32_t* pixelBuffer = malloc(pix);
 glReadPixels(0, 0, 705, 748, GL_RGB, GL_FLOAT, pixelBuffer);
 
 for (int i = 0; i < 396288; i++) {
 if (pixelBuffer[i] != 0 && pixelBuffer[i] > 0 && pixelBuffer[i] != 1) {
 NSLog(@"%d",pixelBuffer[i]);
 }
 }
 free(pixelBuffer);
 //
 */

@end
