//
//  TANetworkAPI.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "TANetworkAPI.h"

@implementation TANetworkAPI

+(instancetype)sharedManager
{
    static TANetworkAPI *sharedStorage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStorage = [[TANetworkAPI alloc] init];
    });
    return sharedStorage;
}

- (void)loginWith:(NSString *)account password:(NSString *)password complete:(TARequestFinishBlock)completeBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSString *url = [NSString stringWithFormat:@"%@&%@",account,password];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        completeBlock(YES,nil,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(NO,error,nil);
    }];

}

- (void)getPhotoMetadataAndImageWithIndex:(NSString *)index complete:(TARequestFinishBlock)completeBlock
{
    [[TANetworkAPI sharedManager] getPhotoMetadataWithIndex:index complete:^(BOOL isSuccess, NSError *err, id responseObject) {
        
        if (isSuccess) {
            
            NSMutableDictionary *metadataArray;
            metadataArray = [NSMutableDictionary dictionaryWithContentsOfFile:[[AppDelegate sharedAppDelegate] returnMetadataPlistPath]];
            if (!metadataArray) {
                metadataArray = [NSMutableDictionary dictionary];
            }
            
            [metadataArray setObject:index forKey:responseObject];
            
            [metadataArray writeToFile:[[AppDelegate sharedAppDelegate] returnMetadataPlistPath] atomically:YES];
            
            [[TANetworkAPI sharedManager]getImageWithIndex:index complete:^(BOOL isSuccess, NSError *err, id responseObject) {
                
                if (isSuccess) {
                    //下載完
#warning 這邊先合成一張,之後找到32貼圖方法在改掉
                    [self imageByCombiningImage:index];
                    
                    completeBlock(YES,nil,nil);
                }
                else {
                    
                    completeBlock(NO,nil,nil);
                }
            }];
        }
        else {
            
            DxLog(@"%@",err.description);
            completeBlock(NO,err,nil);
        }
    }];
}

- (void)getPhotoMetadataWithIndex:(NSString *)photoIndex complete:(TARequestFinishBlock)completeBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSString *url = [NSString stringWithFormat:@"http://helios-api-0.cloudapp.net:6687/maps/photometa?panoid=%@",photoIndex];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        completeBlock(YES,nil,responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completeBlock(NO,error,nil);
    }];
    
}

-(void)getImageWithIndex:(NSString *)photoIndex complete:(TARequestFinishBlock)completeBlock
{
    // Create a dispatch group
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0; i < 4; i++) {
        // Enter the group for each request we create
        
        for (int j = 0; j < 8; j++) {
            
            dispatch_group_enter(group);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                
                NSString *xString = [NSString stringWithFormat:@"%i",i];
                NSString *yString = [NSString stringWithFormat:@"%i",j];
                
                NSString *url = [NSString stringWithFormat:@"http://helios-api-0.cloudapp.net:6688/photo?panoid=%@&output=tile&x=%@&y=%@",photoIndex,xString,yString];
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSString *saveFileName = [[[AppDelegate sharedAppDelegate] returnPhotoFilePath] stringByAppendingPathComponent:photoIndex];
                    
                    [UIImageJPEGRepresentation([UIImage imageWithData:imageData], 2.0f) writeToFile:[NSString stringWithFormat:@"%@/%i.jpg",saveFileName,(i*8 + j)] atomically:YES];
                    
                });
            });
        }
    }
    
    // Here we wait for all the requests to finish
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // Do whatever you need to do when all requests are finished
        
        NSLog(@"download images finished");
        completeBlock(YES,nil,nil);
    });
    
}

- (void)imageByCombiningImage:(NSString *)index{
    
    NSString *path = [[[AppDelegate sharedAppDelegate] returnPhotoFilePath]stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@",index]];
    
    UIImage *image = nil;
    
    UIImage *originalImage = nil;
    
    int imageNumber = 0;
    
    for (int i = 0; i < 4; i++) {
        
        for (int j = 0; j < 8; j++) {
            
            UIImage *firstImage = [UIImage imageWithContentsOfFile:[path stringByAppendingPathComponent:[NSString stringWithFormat:@"/%i.jpg",imageNumber]]];
            
            CGSize newImageSize = CGSizeMake(3584, 1792);
            
            UIGraphicsBeginImageContext(newImageSize);
            
            [firstImage drawAtPoint:CGPointMake(j * 448,i * 448)];
            
            [originalImage drawAtPoint:CGPointMake(0,0)];
            
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            originalImage = image;
            
            imageNumber++;
        }
    }
    
    [UIImageJPEGRepresentation(image, 2.0f) writeToFile:[NSString stringWithFormat:@"%@/%@.jpg",path,index] atomically:YES];
}


@end
