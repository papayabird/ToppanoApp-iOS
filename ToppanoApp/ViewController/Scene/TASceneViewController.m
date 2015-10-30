//
//  TASceneViewController.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "TASceneViewController.h"

@implementation UIImage (resize)
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end

@interface TASceneViewController ()

{
    MBProgressHUD *hud;
    TAGLKViewController *glViewController;
    TAGLKViewController *glViewControllerOld;
    NSMutableArray *dataArray;
    NSMutableDictionary *daraDict;
    __weak IBOutlet UIView *contentView;
    __weak IBOutlet UITableView *sceneTableView;
    __weak IBOutlet UIButton *editButton;
    IBOutlet UIView *toolView;
    
    NSString *selectIndex;
}

@end

@implementation TASceneViewController

- (instancetype)initWithDataDict:(NSMutableDictionary *)dict
{
    self = [super init];
    if (self) {
        
        daraDict = dict;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setTitleText:@"SCENE"];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    
    if ([self checkoutImageisExist:[daraDict[kEntryPanoId] description]]) {
        
        NSString *path = [[TAFileManager returnPhotoFilePathWithFileName:[daraDict[kMapId] description] photoFileName:[daraDict[kEntryPanoId] description]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",[daraDict[kEntryPanoId] description]]];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        [self showImage:dict rotationAngleXZ:0 rotationAngleY:0];
    }
    else {
        hud.labelText = @"下載圖片中";
        [hud show:YES];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            [self callAPIGetData:[daraDict[kEntryPanoId] description] mapName:[daraDict[kMapId] description] complete:^(BOOL isSuccess, NSError *err, id responseObject) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [hud hide:YES];
                    
                    [self showImage:responseObject rotationAngleXZ:0 rotationAngleY:0];
                    
                    if ([AppDelegate isPad]) {
                        [sceneTableView reloadData];
                    }
                });
            }];
        });

    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    toolView.frame = CGRectMake(self.view.frame.size.width, 70, toolView.frame.size.width, toolView.frame.size.height);
}

- (BOOL)checkoutImageisExist:(NSString *)sceneId
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [[TAFileManager returnPhotoFilePathWithFileName:[daraDict[kMapId] description] photoFileName:[sceneId description]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",sceneId]];
    BOOL isDir;
    BOOL isExist =  [fileManager fileExistsAtPath:path isDirectory:&isDir];

    return isExist;
}

- (void)showImage:(NSMutableDictionary *)dataDict rotationAngleXZ:(double)rotationAngleXZ rotationAngleY:(double)rotationAngleY
{
    NSString *tempImagePath = [[TAFileManager returnPhotoFilePathWithFileName:[dataDict[kMapId] description] photoFileName:[dataDict[kPanoId] description]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[dataDict[kPanoId] description]]];
    
    __block UIImage *tempImage = [UIImage imageWithContentsOfFile:tempImagePath];
    
    __weak TASceneViewController *weakSelf = self;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableData *imageData = [NSMutableData dataWithData:UIImageJPEGRepresentation(tempImage, 2)];
    
        [glViewController releaseRenderView];
        [glViewController.view removeFromSuperview];
        [glViewController removeFromParentViewController];
        glViewController = nil;
        
        glViewController = [[TAGLKViewController sharedManager] init:contentView.bounds image:imageData width:contentView.frame.size.width height:contentView.frame.size.height dataDict:dataDict rotationAngleXZ:rotationAngleXZ rotationAngleY:rotationAngleY];
        glViewController.tapDelegate = weakSelf;
        
        glViewController.view.frame = contentView.bounds;
        [contentView addSubview:glViewController.view];

#warning 這邊要做轉場動畫
        /*
        if (glViewControllerOld) {
            
            glViewController = [[TAGLKViewController alloc] init:contentView.bounds image:imageData width:contentView.frame.size.width height:contentView.frame.size.height dataDict:dataDict rotationAngleXZ:rotationAngleXZ rotationAngleY:rotationAngleY];
            glViewController.tapDelegate = weakSelf;
            
            glViewController.view.frame = contentView.bounds;
            [contentView addSubview:glViewController.view];
            glViewController.view.alpha = 0.0f;
            
            [UIView  animateWithDuration:0.5f animations:^{
                
                glViewController.view.alpha = 1.0f;
                glViewControllerOld.view.alpha = 0.0f;
            } completion:^(BOOL finished) {
                
                [glViewControllerOld releaseRenderView];
                [glViewControllerOld.view removeFromSuperview];
                [glViewControllerOld removeFromParentViewController];
                glViewControllerOld = nil;
            }];
        }
        else {
            glViewControllerOld = [[TAGLKViewController alloc] init:contentView.bounds image:imageData width:contentView.frame.size.width height:contentView.frame.size.height dataDict:dataDict rotationAngleXZ:rotationAngleXZ rotationAngleY:rotationAngleY];
            glViewControllerOld.tapDelegate = weakSelf;
            
            glViewControllerOld.view.frame = contentView.bounds;
            [contentView addSubview:glViewControllerOld.view];
            glViewControllerOld.view.alpha = 0.0f;

            [UIView  animateWithDuration:0.5f animations:^{
                
                glViewControllerOld.view.alpha = 1.0f;
                glViewController.view.alpha = 0.0f;
            } completion:^(BOOL finished) {
                
                [glViewController releaseRenderView];
                [glViewController.view removeFromSuperview];
                [glViewController removeFromParentViewController];
                glViewController = nil;
            }];
        }
       */
    });
}

- (void)displayToolButton:(BOOL)isDisplay
{
    [self.view addSubview:toolView];

    if (isDisplay) {
        [UIView animateWithDuration:0.3 animations:^{
            
            toolView.frame = CGRectMake(self.view.frame.size.width - toolView.frame.size.width, 70, toolView.frame.size.width, toolView.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            
            toolView.frame = CGRectMake(self.view.frame.size.width, 70, toolView.frame.size.width, toolView.frame.size.height);
            
        } completion:^(BOOL finished) {
            
            
        }];
    }
}

#pragma mark - mark UITableView Datasource & Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TATableViewCell *cell = [TATableViewCell cell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    cell.displayImage.image = [UIImage imageNamed:dataArray[indexPath.row][@"sphotoName"]];
    
    if (indexPath.row == selectIndex) {
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editButton.selected) {
        
        //編輯中點擊
    }
    else {
        
        //非編輯中
        /*
        if (selectIndex != indexPath.row) {
            selectIndex = (int)indexPath.row;
            [self showImage:dataArray[indexPath.row] rotationAngleXZ:0 rotationAngleY:0];
        }
         */
        [sceneTableView reloadData];
    }
}

#pragma mark - OTGLViewProtocol

-(void)transfromView:(NSString *)pageIndex rotationAngleXZ:(double)rotationAngleXZ rotationAngleY:(double)rotationAngleY
{
    
    if ([self checkoutImageisExist:[NSString stringWithFormat:@"%@",pageIndex]]) {
        
        NSString *path = [[TAFileManager returnPhotoFilePathWithFileName:[daraDict[kMapId] description] photoFileName:[pageIndex description]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",pageIndex]];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        
        [self showImage:dict rotationAngleXZ:rotationAngleXZ rotationAngleY:rotationAngleY];
        selectIndex = pageIndex;
        
        if ([AppDelegate isPad]) {
            [sceneTableView reloadData];
        }
    }
    else {
        hud.labelText = @"下載圖片中";
        [hud show:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            [self callAPIGetData:[NSString stringWithFormat:@"%@",pageIndex] mapName:[daraDict[kMapId] description] complete:^(BOOL isSuccess, NSError *err, id responseObject) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [hud hide:YES];
                    
                    [self showImage:responseObject rotationAngleXZ:rotationAngleXZ rotationAngleY:rotationAngleY];
                    selectIndex = pageIndex;
                    
                    if ([AppDelegate isPad]) {
                        [sceneTableView reloadData];
                    }
                });
            }];
        });
    }
}

#pragma mark - Button Action

- (IBAction)editAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [self displayToolButton:YES];
        glViewController.view.alpha = 0.5f;
        glViewController.editType = YES;
    }
    else {
        [self displayToolButton:NO];
        glViewController.view.alpha = 1.0f;
        glViewController.editType = NO;
    }
    
}

- (IBAction)popAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - NetworkAPI
- (void)callAPIGetData:(NSString *)pageIndex mapName:(NSString *)mapName complete:(TARequestFinishBlock)completeBlock
{
    [[TANetworkAPI sharedManager] getPhotoMetadataAndImageWithIndex:pageIndex mapName:mapName complete:^(BOOL isSuccess, NSError *err, id responseObject) {
        
        if (isSuccess) {
            
            completeBlock(YES,nil,responseObject);
        }
        else {
            DxLog(@"%@",err.description);
            completeBlock(NO,err,nil);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 沒用到
/*
 CGFloat width = tempImage.size.width;
 CGFloat height = tempImage.size.height;
 
 while (width > 2048) {
 @autoreleasepool {
 //                NSLog(@"width = %f, height = %f",width,height);
 width /= 1.2;
 height /= 1.2;
 tempImage = [UIImage imageWithImage:tempImage scaledToSize:CGSizeMake(tempImage.size.width / 1.2, tempImage.size.height / 1.2)];
 }
 }
 */

@end
