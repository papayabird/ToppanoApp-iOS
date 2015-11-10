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
    GLfloat **vertexAr;
    GLfloat *texCoords;
    GLfloat **texCoordsAr;
    
    int width;
    int height;
}

@end

@implementation TASphereFragmentObject

- (TASphereFragmentObject *)init:(float)radius widthSegments:(float)widthSegments heightSegments:(float)heightSegments phiStart:(float)phiStart phiLength:(float)phiLength thetaStart:(float)thetaStart thetaLength:(float)thetaLength;
{
    self = [super init];
    if (self) {
        
        width = widthSegments;
        height = heightSegments;
        
        vertexAr = malloc(sizeof(GLfloat*)*(heightSegments * 2));
        texCoordsAr = malloc(sizeof(GLfloat*)*(heightSegments) * 2);
        
        for ( int y = 0; y < heightSegments; y ++ ) {
            
            float v = y / heightSegments;
            float v2 = (y + 1) / heightSegments;
            
            vertices = malloc(sizeof(GLfloat)*((widthSegments * 18 + 18)));
            texCoords = malloc(sizeof(GLfloat)*(widthSegments * 12 + 12));
            
            for ( int x = 0; x < widthSegments; x ++ ) {
                
                float u = x / widthSegments;
                float u2 = (x + 1) / widthSegments;
                
                //原本
                float px0 = radius * cos( phiStart + u * phiLength ) * sin( thetaStart + v * thetaLength );
                float py1 = radius * cos( thetaStart + v * thetaLength );
                float pz2 = radius * sin( phiStart + u * phiLength ) * sin( thetaStart + v * thetaLength );
                
                float px3 = radius * cos( phiStart + u2 * phiLength ) * sin( thetaStart + v * thetaLength );
                float py4 = radius * cos( thetaStart + v * thetaLength );
                float pz5 = radius * sin( phiStart + u2 * phiLength ) * sin( thetaStart + v * thetaLength );
                
                float px6 = radius * cos( phiStart + u * phiLength ) * sin( thetaStart + v2 * thetaLength );
                float py7 = radius * cos( thetaStart + v2 * thetaLength );
                float pz8 = radius * sin( phiStart + u * phiLength ) * sin( thetaStart + v2 * thetaLength );
                
                float px9 = radius * cos( phiStart + u2 * phiLength ) * sin( thetaStart + v2 * thetaLength );
                float py10 = radius * cos( thetaStart + v2 * thetaLength );
                float pz11 = radius * sin( phiStart + u2 * phiLength ) * sin( thetaStart + v2 * thetaLength );
                
                //原本
                
                vertices[x * 18 + 0] = px0;
                vertices[x * 18 + 1] = py1;
                vertices[x * 18 + 2] = pz2;
                
                vertices[x * 18 + 3] = px3;
                vertices[x * 18 + 4] = py4;
                vertices[x * 18 + 5] = pz5;
                
                vertices[x * 18 + 6] = px6;
                vertices[x * 18 + 7] = py7;
                vertices[x * 18 + 8] = pz8;
                
                vertices[x * 18 + 9] = px6;
                vertices[x * 18 + 10] = py7;
                vertices[x * 18 + 11] = pz8;
                
                vertices[x * 18 + 12] = px3;
                vertices[x * 18 + 13] = py4;
                vertices[x * 18 + 14] = pz5;
                
                vertices[x * 18 + 15] = px9;
                vertices[x * 18 + 16] = py10;
                vertices[x * 18 + 17] = pz11;
                
                //原本 __
                //    |\|這樣畫
                texCoords[x * 12 + 0] = u;
                texCoords[x * 12 + 1] = v;
                
                texCoords[x * 12 + 2] = u2;
                texCoords[x * 12 + 3] = v;
                
                texCoords[x * 12 + 4] = u;
                texCoords[x * 12 + 5] = v2;
                
                texCoords[x * 12 + 6] = u;
                texCoords[x * 12 + 7] = v2;
                
                texCoords[x * 12 + 8] = u2;
                texCoords[x * 12 + 9] = v;
                
                texCoords[x * 12 + 10] = u2;
                texCoords[x * 12 + 11] = v2;
                
                /*
                 //逆時鐘
                 texCoords[x * 12 + 0] = u;
                 texCoords[x * 12 + 1] = v;
                 
                 texCoords[x * 12 + 2] = u;
                 texCoords[x * 12 + 3] = v2;
                 
                 texCoords[x * 12 + 4] = u2;
                 texCoords[x * 12 + 5] = v;
                 
                 texCoords[x * 12 + 6] = u2;
                 texCoords[x * 12 + 7] = v;
                 
                 texCoords[x * 12 + 8] = u;
                 texCoords[x * 12 + 9] = v2;
                 
                 texCoords[x * 12 + 10] = u2;
                 texCoords[x * 12 + 11] = v2;
                 */
                /*
                 //  |/|這樣畫
                 texCoords[x * 12 + 0] = u;
                 texCoords[x * 12 + 1] = v2;
                 
                 texCoords[x * 12 + 2] = u;
                 texCoords[x * 12 + 3] = v;
                 
                 texCoords[x * 12 + 4] = u2;
                 texCoords[x * 12 + 5] = v2;
                 
                 texCoords[x * 12 + 6] = u;
                 texCoords[x * 12 + 7] = v2;
                 
                 texCoords[x * 12 + 8] = u2;
                 texCoords[x * 12 + 9] = v2;
                 
                 texCoords[x * 12 + 10] = u2;
                 texCoords[x * 12 + 11] = v;
                 */
            }
            
            vertexAr[y] = vertices;
            texCoordsAr[y] = texCoords;
        }
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
    
    GLfloat *vertice;
    GLfloat *texCoord;
    
    for (int i = 0; i < height; i++) {
        vertice = vertexAr[i];
        texCoord = texCoordsAr[i];
        
        //把頂點座標餵給aPosition
        glVertexAttribPointer(posLocation, 3, GL_FLOAT, false, 0, vertice);
        //把貼圖座標餵給aUV
        glVertexAttribPointer(uvLocation, 2, GL_FLOAT, false, 0, texCoord);
        
        glDrawArrays(GL_TRIANGLES, 0, width * 6);
    }
}

@end
