//
//  TASquareObject.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "TASquareObject.h"

//物件座標
typedef struct {
    GLKVector4  positionCoords;
}
calculVertex;

calculVertex objectVertices[] =
{
    {{ 1.0f,  1.0f,  1.0f, 1}},
    {{ 1.0f,  1.0f,  1.0f, 1}},
    {{ 1.0f,  1.0f,  1.0f, 1}},
    {{ 1.0f,  1.0f,  1.0f, 1}},
    {{ 1.0f,  1.0f,  1.0f, 1}},
    {{ 1.0f,  1.0f,  1.0f, 1}}
};


//貼圖座標 - 左下(0.0) 右上(1.1)
typedef struct {
    GLKVector2  positionCoords;
}
MapVertex;

MapVertex mapVertices[] =
{
    {{ 0.0f,  0.0f}},
    {{ 1.0f,  0.0f}},
    {{ 0.0f,  1.0f}},
    {{ 0.0f,  1.0f}},
    {{ 1.0f,  0.0f}},
    {{ 1.0f,  1.0f}},
};

@interface TASquareObject()

{
    GLKMatrix4 mViewMatrix;
    NSMutableArray *vectorArray;
    calculVertex vector;
}

@end

@implementation TASquareObject

- (instancetype)initSize:(float)size radius:(float)radius transformPage:(NSString *)transformPage transfromTheta:(float)transfromTheta transfromPhi:(float)transfromPhi rotationX:(float)rotationX rotationY:(float)rotationY rotationZ:(float)rotationZ
{
    self = [super init];
    if (self) {
        
        self.transformPageIndex = transformPage;
        vectorArray = [NSMutableArray array];
        
        //先產生在 x = radius,y = 0, z = 0的按鈕
        //theta,phi是弧度,以度數表示的角度，把數字乘以π/180便轉換成弧度；以弧度表示的角度，乘以180/π便轉換成度數
        float theta = 0;
        float phi = 0;
        
        //中心點
        float directionX = (float) (cos(theta)*cos(phi));
        float directionY = (float) sin(phi);
        float directionZ = (float) (sin(theta)*cos(phi));
        
        //建立一個面對X軸的四方形
        calculVertex array[] = {
            GLKVector4Make(directionZ + (size/2), directionY + (size/2), directionX,1.0f),
            GLKVector4Make(-(directionZ + (size/2)), directionY + (size/2), directionX,1.0f),
            GLKVector4Make(directionZ + (size/2), -(directionY + (size/2)), directionX,1.0f),
            GLKVector4Make(directionZ + (size/2), -(directionY + (size/2)), directionX,1.0f),
            GLKVector4Make(-(directionZ + (size/2)), directionY + (size/2), directionX,1.0f),
            GLKVector4Make(-(directionZ + (size/2)), -(directionY + (size/2)), directionX,1.0f),
        };
        
        //旋轉
        for (int i = 0; i < 6; i++) {
            GLKVector4 ver = GLKMatrix4MultiplyVector4(GLKMatrix4MakeXRotation(rotationX*M_PI/180),array[i].positionCoords);
            array[i].positionCoords = ver;
        }
        for (int i = 0; i < 6; i++) {
            GLKVector4 ver = GLKMatrix4MultiplyVector4(GLKMatrix4MakeYRotation(rotationY*M_PI/180),array[i].positionCoords);
            array[i].positionCoords = ver;
        }
        for (int i = 0; i < 6; i++) {
            GLKVector4 ver = GLKMatrix4MultiplyVector4(GLKMatrix4MakeZRotation(rotationZ*M_PI/180),array[i].positionCoords);
            array[i].positionCoords = ver;
        }
        
        //轉成正值度數
        transfromTheta = fmodf((transfromTheta + 360.0f), 360.0f);
        //轉成水平90度(跟ike一樣)
        transfromPhi = 90 - transfromPhi;
        transfromPhi = (transfromPhi + 180.0f);
        transfromPhi = fmodf(transfromPhi, 180.0f);
        
        //轉成弧度
        transfromTheta *= (M_PI/180);
        transfromPhi *= (M_PI/180);
        
        //中心點位移到 translationX translationY translationZ
        float translationX = (float) radius * (cos(transfromTheta)*sin(transfromPhi));
        float translationY = (float) radius * cos(transfromPhi);
        float translationZ = (float) radius * (sin(transfromTheta)*sin(transfromPhi));
        
        //減原本位置得到位移量
        translationX -= directionX;
        translationY -= directionY;
        translationZ -= directionZ;
        
        //乘位移1
        for (int i = 0; i < 6; i++) {
            GLKVector3 arrayVer = GLKVector3Make(array[i].positionCoords.x, array[i].positionCoords.y, array[i].positionCoords.z);
            GLKVector3 ver = GLKMatrix4MultiplyVector3WithTranslation(GLKMatrix4MakeTranslation(translationX,translationY,translationZ), arrayVer);
            array[i].positionCoords = GLKVector4Make(ver.x, ver.y, ver.z, 1);
        }
        
        //包object的向量到array裡面
        for (int i = 0; i < 6; i++) {
            calculVertex cal;
            cal.positionCoords = array[i].positionCoords;
            
            // To add your struct value to a NSMutableArray
            NSValue *pushValue = [NSValue valueWithBytes:&cal objCType:@encode(calculVertex)];
            [vectorArray addObject:pushValue];
        }
    }
    return self;
}

-(void) draw:(GLint) posLocation uv:(GLint) uvLocation textureModeSlot:(GLint)_textureModeSlot tex:(GLint )uTex2;
{
    glUniform1i(_textureModeSlot,self.textureMode);
    glUniform1i(uTex2, 1);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, self.textureInfo.name);
    
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    calculVertex array[] = {
        GLKVector4Make(1.0f,1.0f,1.0f,1.0f),
        GLKVector4Make(1.0f,1.0f,1.0f,1.0f),
        GLKVector4Make(1.0f,1.0f,1.0f,1.0f),
        GLKVector4Make(1.0f,1.0f,1.0f,1.0f),
        GLKVector4Make(1.0f,1.0f,1.0f,1.0f),
        GLKVector4Make(1.0f,1.0f,1.0f,1.0f)
    };
    
    for (int i = 0; i < 6; i++) {
        calculVertex structValue;
        NSValue *pullValue = [vectorArray objectAtIndex:i];
        [pullValue getValue:&structValue];
        array[i].positionCoords = structValue.positionCoords;
    }
    
    //把頂點座標餵給aPosition
    glVertexAttribPointer(posLocation, 4, GL_FLOAT, false, 0, array);
    //把貼圖座標餵給aUV
    glVertexAttribPointer(uvLocation, 2, GL_FLOAT, false, 0, mapVertices);
    //畫
    glDrawArrays(GL_TRIANGLES, 0,6);
}

- (NSMutableArray *)getObjectvectorArray
{
    return vectorArray;
}

#pragma mark - 可能會用到

/*
 //乘位移2
 for (int i = 0; i < 6; i++) {
 GLKVector4 ver = GLKMatrix4MultiplyVector4(GLKMatrix4MakeTranslation(translationX,translationY,translationZ), array[i].positionCoords);
 array[i].positionCoords = ver;
 }
 */

@end
