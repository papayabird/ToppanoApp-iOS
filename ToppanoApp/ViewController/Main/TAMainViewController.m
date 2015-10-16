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

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@end

@implementation TAMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *aNibNotification = [UINib nibWithNibName:@"TAMainCollectionViewCell" bundle:nil];
    [self.mainCollectionView registerNib:aNibNotification forCellWithReuseIdentifier:@"TAMainCollectionViewCell"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Button Action

- (IBAction)logoutAction:(id)sender
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logOut];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UICollectionVIew Delegate % Datasource

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(320, 320);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     TAMainCollectionViewCell *cell = (TAMainCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"TAMainCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TASceneViewController *sceneVC = [[TASceneViewController alloc] init];
    
    [self.navigationController pushViewController:sceneVC animated:YES];
}

@end
