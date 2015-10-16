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
    TAGLKViewController *glViewController;
    NSMutableArray *dataArray;
    __weak IBOutlet UIView *contentView;
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UIButton *editButton;
    IBOutlet UIView *toolView;
    
    int selectIndex;
}

@end

@implementation TASceneViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        dataArray = [NSMutableArray arrayWithArray:[AppDelegate sharedAppDelegate].dataArray];
        
        self.spaceIndex = @"00000001";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self setTitleText:@"SCENE"];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /*
    [self callAPIGetData:self.spaceIndex complete:^(BOOL isSuccess, NSError *err, id responseObject) {
        
        
        
    }];
    */
    
    
    [self showImage:dataArray[0] rotationAngleXZ:0 rotationAngleY:0];
    
    if ([AppDelegate isPad]) {
        [tableView reloadData];
    }
}

- (void)showImage:(NSMutableDictionary *)dataDict rotationAngleXZ:(double)rotationAngleXZ rotationAngleY:(double)rotationAngleY
{
    NSString *tempImagePath = [dataDict[@"photoName"] description];
    
    __block UIImage *tempImage = [UIImage imageNamed:tempImagePath];
    
    __weak TASceneViewController *weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:contentView animated:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideAllHUDsForView:contentView animated:NO];
            
            NSMutableData *imageData = [NSMutableData dataWithData:UIImageJPEGRepresentation(tempImage, 2)];
            
            [glViewController releaseRenderView];
            glViewController = nil;
            [glViewController.view removeFromSuperview];
            
            glViewController = [[TAGLKViewController sharedManager] init:contentView.bounds image:imageData width:contentView.frame.size.width height:contentView.frame.size.height dataDict:dataDict rotationAngleXZ:rotationAngleXZ rotationAngleY:rotationAngleY];
            glViewController.tapDelegate = weakSelf;
            
            glViewController.view.frame = contentView.bounds;
            [contentView addSubview:glViewController.view];
            
            [self bringSubviewToFront];
            
        });
    });
}

- (void)bringSubviewToFront
{
    toolView.frame = CGRectMake(0, 0, toolView.frame.size.width, toolView.frame.size.height);
    [contentView addSubview:toolView];
}

#pragma mark - mark UITableView Datasource & Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TATableViewCell *cell = [TATableViewCell cell];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    cell.displayImage.image = [UIImage imageNamed:dataArray[indexPath.row][@"sphotoName"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editButton.selected) {
        
        //編輯中點擊
    }
    else {
        
        //非編輯中
        
        
        if (selectIndex != indexPath.row) {
            selectIndex = (int)indexPath.row;
            [self showImage:dataArray[indexPath.row] rotationAngleXZ:0 rotationAngleY:0];
        }
    }
}

#pragma mark - OTGLViewProtocol

-(void)transfromView:(int)pageIndex rotationAngleXZ:(double)rotationAngleXZ rotationAngleY:(double)rotationAngleY
{
    
#warning 這邊還要做轉場動畫
    
    [self showImage:dataArray[pageIndex] rotationAngleXZ:rotationAngleXZ rotationAngleY:rotationAngleY];
    selectIndex = pageIndex;
}

#pragma mark - Button Action

- (IBAction)editAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        glViewController.view.alpha = 0.5f;
        glViewController.editType = YES;
    }
    else {
        glViewController.view.alpha = 1.0f;
        glViewController.editType = NO;
    }
    
}

- (IBAction)popAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - NetworkAPI
- (void)callAPIGetData:(NSString *)pageIndex complete:(OTRequestFinishBlock)completeBlock
{
    [[TANetworkAPI sharedManager] getPhotoMetadataAndImageWithIndex:pageIndex complete:^(BOOL isSuccess, NSError *err, id responseObject) {
        
        if (isSuccess) {
            
            completeBlock(YES,nil,nil);
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


@end
