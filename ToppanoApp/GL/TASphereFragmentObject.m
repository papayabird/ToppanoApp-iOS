//
//  TASphereFragmentObject.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/21.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "TASphereFragmentObject.h"

@interface TASphereFragmentObject()

{
    GLfloat *vertices;
    GLfloat *texCoords;
}

@end

@implementation TASphereFragmentObject

- (TASphereFragmentObject *)init:(float)radius widthSegments:(float)widthSegments heightSegments:(float)heightSegments phiStart:(float)phiStart phiLength:(float)phiLength thetaStart:(float)thetaStart thetaLength:(float)thetaLength;
{
    self = [super init];
    if (self) {
        
        double altitude;
        double altitudeDelta;
        double azimuth;
        double azimuthDelta;
        vertices = malloc(sizeof(GLfloat)*(18));
        texCoords = malloc(sizeof(GLfloat)*(12));
        
        altitude = (M_PI/2) - thetaStart;
        altitudeDelta = (M_PI/2) - (thetaStart + thetaLength);

        azimuth = (M_PI/2) - phiStart;
        azimuthDelta = (M_PI/2) - (phiStart + phiLength);
    
        // 1nd point
        vertices[0] = radius * cos(altitude) * cos(azimuth);
        vertices[1] = radius * sin(altitude);
        vertices[2] = radius * cos(altitude) * sin(azimuth);
        
        // 2st point
        vertices[3] = radius * cos(altitudeDelta) * cos(azimuth);
        vertices[4] = radius * sin(altitudeDelta);
        vertices[5] = radius * cos(altitudeDelta) * sin(azimuth);
    
        // 3nd point
        vertices[6] = radius * cos(altitude) * cos(azimuthDelta);
        vertices[7] = radius * sin(altitude);
        vertices[8] = radius * cos(altitude) * sin(azimuthDelta);
        
        // 4nd point
        vertices[9] = radius * cos(altitude) * cos(azimuthDelta);
        vertices[10] = radius * sin(altitude);
        vertices[11] = radius * cos(altitude) * sin(azimuthDelta);
        
        // 5st point
        vertices[12] = radius * cos(altitudeDelta) * cos(azimuth);
        vertices[13] = radius * sin(altitudeDelta);
        vertices[14] = radius * cos(altitudeDelta) * sin(azimuth);
        
        // 2nd point
        vertices[15] = radius * cos(altitudeDelta) * cos(azimuthDelta);
        vertices[16] = radius * sin(altitudeDelta);
        vertices[17] = radius * cos(altitudeDelta) * sin(azimuthDelta);
        
        //texture
        texCoords[0] =  0;
        texCoords[1] =  0;
        
        texCoords[2] =  1;
        texCoords[3] =  0;
        
        texCoords[4] =  0;
        texCoords[5] =  1;

        texCoords[6] =  0;
        texCoords[7] =  1;
        
        texCoords[8] =  1;
        texCoords[9] =  0;
        
        texCoords[10] =  1;
        texCoords[11] =  1;
    }
    return self;
}


-(void) draw:(GLint) posLocation uv:(GLint) uvLocation textureModeSlot:(GLint)_textureModeSlot tex:(GLint )uTex;
{
    glUniform1i(_textureModeSlot,self.textureMode);
    glUniform1i(uTex, 1);
    
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, self.textureInfo.name);
    
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    //把頂點座標餵給aPosition
    glVertexAttribPointer(posLocation, 3, GL_FLOAT, false, 0, vertices);
    //把貼圖座標餵給aUV
    glVertexAttribPointer(uvLocation, 2, GL_FLOAT, false, 0, texCoords);
    
    glDrawArrays(GL_TRIANGLES, 0, 18);
}

@end
