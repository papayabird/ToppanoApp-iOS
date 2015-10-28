//
//  TATestSphere.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/27.
//  Copyright © 2015年 papayabird. All rights reserved.
//

#import "TATestSphere.h"

@interface TATestSphere()

{
    GLfloat *vertices;
    GLfloat **vertexArray;
    GLfloat *texCoords;
}

@end

@implementation TATestSphere

- (TATestSphere *)init:(float)radius widthSegments:(float)widthSegments heightSegments:(float)heightSegments phiStart:(float)phiStart phiLength:(float)phiLength thetaStart:(float)thetaStart thetaLength:(float)thetaLength
{
    self = [super init];
    if (self) {
        
        /*
        float segmentsX = widthSegments;
        float segmentsY = heightSegments;
        
        vertices = malloc(sizeof(GLfloat)*(widthSegments * heightSegments));
        texCoords = malloc(sizeof(GLfloat)*(12));
        
        float thetaEnd = thetaStart + thetaLength;

        NSMutableArray *indices = [NSMutableArray array];
        NSMutableArray *uvs = [NSMutableArray array];
        NSMutableArray *verticesAr = [NSMutableArray array];
        
        int index = 0;
        for ( int y = 0; y <= segmentsY; y ++ ) {
            
            NSMutableArray *indicesRow = [NSMutableArray array];
            NSMutableArray *uvsRow = [NSMutableArray array];

            for ( int x = 0; x <= segmentsX; x ++ ) {
                
                float u = ( float )x / segmentsX;
                float v = ( float )y / segmentsY;
                
                GLKVector3 vector;
                vector.x = - radius * cos( phiStart + u * phiLength ) * sin( thetaStart + v * thetaLength );
                vector.y = radius * cos( thetaStart + v * thetaLength );
                vector.z = radius * sin( phiStart + u * phiLength ) * sin( thetaStart + v * thetaLength );
                
                [verticesAr addObject:NSStringFromGLKVector3(vector)];
                
                [indicesRow addObject:[NSString stringWithFormat:@"%i",index]];
                [uvsRow addObject:NSStringFromCGPoint(CGPointMake(u, 1- v))];
                index++;
            }
            
            [indices addObject:indicesRow];
            [uvs addObject:uvsRow];
        }
        
        for ( int y = 0; y < heightSegments; y ++ ) {
            
            for ( int x = 0; x < widthSegments; x ++ ) {
                
                int index1 = [indices[ y ][ x + 1 ] intValue];
                int index2 = [indices[ y ][ x ] intValue];
                int index3 = [indices[ y + 1 ][ x ] intValue];
                int index4 = [indices[ y + 1 ][ x + 1 ] intValue] ;

                GLKVector3 v1 = *(__bridge GLKVector3 *)verticesAr[index1];
                GLKVector3 v2 = *(__bridge GLKVector3 *)verticesAr[index2];
                GLKVector3 v3 = *(__bridge GLKVector3 *)verticesAr[index3];
                GLKVector3 v4 = *(__bridge GLKVector3 *)verticesAr[index4];
                
                id uv1 = uvs[ y ][ x + 1 ] ;
                id uv2 = uvs[ y ][ x ];
                id uv3 = uvs[ y + 1 ][ x ];
                id uv4 = uvs[ y + 1 ][ x + 1 ];

                CGPoint uv1 = [uv1 CGPointValue];
                CGPoint uv2 = [uv2 CGPointValue];
                CGPoint uv3 = [uv3 CGPointValue];
                CGPoint uv4 = [uv4 CGPointValue];
                
                if ( y != 0 || thetaStart > 0 )
                {
                    vertices[0] = v1.x;
                    vertices[1] = v1.y;
                    vertices[2] = v1.z;
                    vertices[3] = v2.x;
                    vertices[4] = v2.y;
                    vertices[5] = v2.z;
                    vertices[6] = v4.x;
                    vertices[7] = v4.y;
                    vertices[8] = v4.z;
                    
                    texCoords[0] = uv1.x;
                    texCoords[1] = uv1.y;
                    texCoords[2] = uv2.x;
                    texCoords[3] = uv2.y;
                    texCoords[4] = uv4.x;
                    texCoords[5] = uv4.y;
                }
                if ( y != heightSegments - 1 || thetaEnd < M_PI )
                {
                    vertices[0] = v2.x;
                    vertices[1] = v2.y;
                    vertices[2] = v2.z;
                    vertices[3] = v3.x;
                    vertices[4] = v3.y;
                    vertices[5] = v3.z;
                    vertices[6] = v4.x;
                    vertices[7] = v4.y;
                    vertices[8] = v4.z;
                    
                    texCoords[0] = uv2.x;
                    texCoords[1] = uv2.y;
                    texCoords[2] = uv3.x;
                    texCoords[3] = uv3.y;
                    texCoords[4] = v4.x;
                    texCoords[5] = v4.y;
                }
            }
        }
    */

        
        
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
