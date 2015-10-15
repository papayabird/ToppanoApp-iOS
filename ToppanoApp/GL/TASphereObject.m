//
//  TASphereObject.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "TASphereObject.h"

@interface TASphereObject (){
    
    GLfloat **vertexArray;
    GLfloat **texCoordsArray;
    int mDivide;
}

@end

@implementation TASphereObject

-(id) init:(GLfloat)radius divide:(int)divide {
    
    int i;
    int j;
    double altitude;
    double altitudeDelta;
    double azimuth;
    
    if((self = [super init])){
        
        mDivide = divide;
        
        vertexArray = malloc(sizeof(GLfloat *)*mDivide);
        texCoordsArray = malloc(sizeof(GLfloat *)*mDivide);
        
        for(i = 0; i < (mDivide/2); i++){
            
            //這邊原本是 M_PI/2.0- 改成+的從圖的坐左邊開始貼
            altitude      = M_PI/2.0 + ( i ) * (M_PI*2/mDivide);
            altitudeDelta = M_PI/2.0 + (i+1) * (M_PI*2/mDivide);
            
            GLfloat *vertices = malloc(sizeof(GLfloat)*(mDivide*6+6));
            GLfloat *texCoords = malloc(sizeof(GLfloat)*(mDivide*4+4));
            
            for(j = 0; j <= mDivide ; j++){
                
                azimuth = M_PI - ((float)j) * (2*M_PI/(float)(mDivide));
                
                // 1st point
                vertices[j*6+3] = radius * cos(altitudeDelta) * cos(azimuth);
                
                vertices[j*6+4] = radius * sin(altitudeDelta);
                vertices[j*6+5] = radius * cos(altitudeDelta) * sin(azimuth);
                
                texCoords[j*4+2] =  1.0 - (j / (float)(mDivide));
                texCoords[j*4+3] =  2*(i + 1) / (float)(mDivide);
                
                // 2nd point
                vertices[j*6+0] = radius * cos(altitude) * cos(azimuth);
                vertices[j*6+1] = radius * sin(altitude);
                vertices[j*6+2] = radius * cos(altitude) * sin(azimuth);
                
                texCoords[j*4+0] =  1.0 - (j / (float)(mDivide));
                texCoords[j*4+1] =  2*(i + 0) / (float)(mDivide);
                /*
                 //頂點
                 NSLog(@"cos(altitudeDelta) * cos(azimuth) = %f",radius * cos(altitudeDelta) * cos(azimuth));
                 NSLog(@"sin(altitudeDelta) = %f",radius * sin(altitudeDelta));
                 NSLog(@"cos(altitudeDelta) * sin(azimuth) = %f",radius * cos(altitudeDelta) * sin(azimuth));
                 
                 NSLog(@"cos(altitude) * cos(azimuth) = %f",radius * cos(altitude) * cos(azimuth));
                 NSLog(@"sin(altitude) = %f",radius * sin(altitude));
                 NSLog(@"cos(altitude) * sin(azimuth) = %f",radius * cos(altitude) * sin(azimuth));
                 */
                /*
                 NSLog(@"texCoords[%i] = %f",j*4+0,1.0 - (j / (float)(mDivide)));
                 NSLog(@"texCoords[%i] = %f",j*4+1,2*(i + 0) / (float)(mDivide));
                 NSLog(@"texCoords[%i] = %f",j*4+2,1.0 - (j / (float)(mDivide)));
                 NSLog(@"texCoords[%i] = %f",j*4+3,2*(i + 1) / (float)(mDivide));
                 */
            }
            
            //計算球體頂點座標
            vertexArray[i] = vertices;
            //計算球體貼圖座標
            texCoordsArray[i] = texCoords;
            //            NSLog(@"%i",i);
        }
    }
    return self;
}


/**
 * Method for drawing spheres
 * Variables connected to the shader are used for drawing.
 * It is assumed that shader variables are activated.
 *
 * @param posLocation Attribute compatibility variable for shader connected to the position
 * @param uvLocation Attribute compatibility variable for shader connected to the UV space
 */
-(void) draw:(GLint) posLocation uv:(GLint) uvLocation textureModeSlot:(GLint)_textureModeSlot tex:(GLint )uTex{
    
    glUniform1i(_textureModeSlot,self.textureMode);
    glUniform1i(uTex, 1);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, self.textureInfo.name);
    
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    GLfloat *vertices;
    GLfloat *texCoords;
    
#warning 這邊應該要再修改成load 32 張貼圖
    
    for (int i = 0; i < (mDivide/2); i++) {
        vertices = vertexArray[i];
        texCoords = texCoordsArray[i];
        
        //把頂點座標餵給aPosition
        glVertexAttribPointer(posLocation, 3, GL_FLOAT, false, 0, vertices);
        //把貼圖座標餵給aUV
        glVertexAttribPointer(uvLocation, 2, GL_FLOAT, false, 0, texCoords);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, mDivide*2+2);
        
    }
    
    return;
}

@end
