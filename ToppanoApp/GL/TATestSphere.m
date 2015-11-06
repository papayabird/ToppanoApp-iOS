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
    GLfloat **vertexAr;
    GLfloat *texCoords;
    GLfloat **texCoordsAr;
    
    int width;
    int height;
}

@end

@implementation TATestSphere

- (TATestSphere *)init:(float)radius widthSegments:(float)widthSegments heightSegments:(float)heightSegments phiStart:(float)phiStart phiLength:(float)phiLength thetaStart:(float)thetaStart thetaLength:(float)thetaLength
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
                float px0 = - radius * cos( phiStart + u * phiLength ) * sin( thetaStart + v * thetaLength );
                float py1 = radius * cos( thetaStart + v * thetaLength );
                float pz2 = radius * sin( phiStart + u * phiLength ) * sin( thetaStart + v * thetaLength );
                
                float px3 = - radius * cos( phiStart + u2 * phiLength ) * sin( thetaStart + v * thetaLength );
                float py4 = radius * cos( thetaStart + v * thetaLength );
                float pz5 = radius * sin( phiStart + u2 * phiLength ) * sin( thetaStart + v * thetaLength );
                
                float px6 = - radius * cos( phiStart + u * phiLength ) * sin( thetaStart + v2 * thetaLength );
                float py7 = radius * cos( thetaStart + v2 * thetaLength );
                float pz8 = radius * sin( phiStart + u * phiLength ) * sin( thetaStart + v2 * thetaLength );
                
                float px9 = - radius * cos( phiStart + u2 * phiLength ) * sin( thetaStart + v2 * thetaLength );
                float py10 = radius * cos( thetaStart + v2 * thetaLength );
                float pz11 = radius * sin( phiStart + u2 * phiLength ) * sin( thetaStart + v2 * thetaLength );
                
//                NSLog(@"px0 = %f",px0);
//                NSLog(@"px0 = %f",py1);
//                NSLog(@"px0 = %f",pz2);
//                NSLog(@"px0 = %f",px3);
//                NSLog(@"px0 = %f",py4);
//                NSLog(@"px0 = %f",pz5);
//                NSLog(@"px0 = %f",px6);
//                NSLog(@"px0 = %f",py7);
//                NSLog(@"px0 = %f",pz8);
//                NSLog(@"px0 = %f",px9);
//                NSLog(@"px0 = %f",py10);
//                NSLog(@"px0 = %f",pz11);
                
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
                
                //原本
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

/*
 //js
float thetaEnd = thetaStart + thetaLength;
int index = 0;
NSMutableArray *verticesArray = [NSMutableArray array];
NSMutableArray *uvs = [NSMutableArray array];
NSMutableArray *verticesAr = [NSMutableArray array];

for ( int y = 0; y <= heightSegments; y ++ ) {
    
    NSMutableArray *verticesRow = [NSMutableArray array];
    
    int v = y / heightSegments;
    
    for ( int x = 0; x <= widthSegments; x ++ ) {
        
        float u = x / widthSegments;
        
        float px = - radius * cos( phiStart + u * phiLength ) * sin( thetaStart + v * thetaLength );
        float py = radius * cos( thetaStart + v * thetaLength );
        float pz = radius * sin( phiStart + u * phiLength ) * sin( thetaStart + v * thetaLength );
        
        [verticesAr addObject:NSStringFromGLKVector3(GLKVector3Make(px, py, pz)) ];
        
        [uvs addObject:NSStringFromCGPoint(CGPointMake(u, 1 - v))];
        
        [verticesRow addObject:@(index)];
 
        index ++;
        
    }
    
    [verticesArray addObject:verticesRow];
    
}

//上面會拿到45個GLKVector & 45個(u,v)

 NSMutableArray *indices = [NSMutableArray array];
 
 for ( int y = 0; y < heightSegments; y ++ ) {
 
 for ( int x = 0; x < widthSegments; x ++ ) {
 
 NSNumber *v1 = verticesArray[ y ][ x + 1 ];
 NSNumber *v2 = verticesArray[ y ][ x ];
 NSNumber *v3 = verticesArray[ y + 1 ][ x ];
 NSNumber *v4 = verticesArray[ y + 1 ][ x + 1 ];
 
 if ( y != 0 || thetaStart > 0 ){
 
 [indices addObject:v1];
 [indices addObject:v2];
 [indices addObject:v4];
 
 }
 if ( y != heightSegments - 1 || thetaEnd < M_PI ){
 
 [indices addObject:v2];
 [indices addObject:v3];
 [indices addObject:v4];
 }
 }
 }
 */

/*
 //cpp
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


@end
