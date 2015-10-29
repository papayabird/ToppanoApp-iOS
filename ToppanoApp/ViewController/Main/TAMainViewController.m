//
//  TAMainViewController.m
//  ToppanoApp
//
//  Created by papayabird on 2015/10/15.
//  Copyright (c) 2015年 papayabird. All rights reserved.
//

#import "TAMainViewController.h"
#import "TASceneViewController.h"
#import "TAMainCollectionViewCell.h"
@interface TAMainViewController ()

{
    NSString *userIdString;
    NSMutableArray *MapAllDataArray;
}

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;

@end

@implementation TAMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *aNibNotification = [UINib nibWithNibName:@"TAMainCollectionViewCell" bundle:nil];
    [self.mainCollectionView registerNib:aNibNotification forCellWithReuseIdentifier:@"TAMainCollectionViewCell"];
    // Do any additional setup after loading the view from its nib.
    [self setTitleText:@"SPACE LIST"];
    
    [self getMainData:[AppDelegate sharedAppDelegate].userId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)getMainData:(NSString *)userId
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
        
        [[TANetworkAPI sharedManager] getMapWithUserId:userId complete:^(BOOL isSuccess, NSError *err, id responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                
                [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                
                if (isSuccess) {
                    NSLog(@"%@",responseObject);
                    //寫入
                    if ([responseObject count] > 0) {
                        
                        NSString *path = [TAFileManager returnSpaceFolderPath:[responseObject[0][@"id"] description]];
                        
                        NSMutableDictionary *userMapDict = [NSMutableDictionary dictionaryWithDictionary:responseObject[0]];
                        
                        [userMapDict writeToFile:[NSString stringWithFormat:@"%@/%@map.plist",path,[responseObject[0][@"id"] description]] atomically:YES];
                        
                        [self getDataFromFile];
                    }
                }
                else {
                    
                    NSString *titleString = NSLocalizedString(@"撈取Map失敗", @"String");
                    NSString *cancelString = NSLocalizedString(@"確認", @"String");
                    
                    [RMUniversalAlert showAlertInViewController:self withTitle:titleString message:@"" cancelButtonTitle:cancelString destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert *alert, NSInteger buttonIndex){
                        
                        
                    }];
                    NSLog(@"Error %@",err);
                }
                
            });
        }];
    });

}

#pragma mark - Button Action
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)reloadAction:(id)sender
{
    [self getMainData:userIdString];
}

- (void)getDataFromFile
{
    MapAllDataArray = [NSMutableArray arrayWithArray:[TAFileManager getAllMapPlistFromMapFile]];
    
    [self.mainCollectionView reloadData];
}

#pragma mark - UICollectionVIew Delegate % Datasource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(310, 320);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [MapAllDataArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     TAMainCollectionViewCell *cell = (TAMainCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TAMainCollectionViewCell" forIndexPath:indexPath];
    
    int imageIndex = indexPath.row % 5;
    cell.spaceImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%i.JPG",imageIndex]];
    
    cell.titleLabel.text = [MapAllDataArray[indexPath.row][@"id"] description];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TASceneViewController *sceneVC = [[TASceneViewController alloc] initWithDataDict:MapAllDataArray[indexPath.row]];
    
    [self.navigationController pushViewController:sceneVC animated:YES];
}

@end
