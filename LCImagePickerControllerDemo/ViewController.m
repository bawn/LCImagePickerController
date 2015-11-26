//
//  ViewController.m
//  LCPickerControllerDemo
//
//  Created by bawn on 11/4/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "ViewController.h"
#import "LCImagePicker.h"
#import "RSKImageCropViewController.h"
#import "MBProgressHUD.h"

@interface ViewController ()<LCImagePickerControllerDelagate, UITableViewDataSource, UITableViewDelegate, RSKImageCropViewControllerDelegate, RSKImageCropViewControllerDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *assetArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.assetArray = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)pickButtonAction:(id)sender{
    
    [self showPickerController];
}

- (void)showPickerController{
    

//    LCImageCollectionSelectedView *selectedView = [LCImageCollectionSelectedView appearance];
//    selectedView.camearBackgroundColor = [UIColor blackColor];
//    selectedView.camearImage = [UIImage imageNamed:@"cameraIconTakepicDefault"]; 
//    
//    selectedView.selectedBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
//    selectedView.badgeTextFont = [UIFont systemFontOfSize:13.0f];
//    selectedView.badgeTextColor = [UIColor blackColor];
//    selectedView.badgeColor = [UIColor colorWithRed:255.0f/255.0f green:226.0f/255.0 blue:0.0f alpha:1.0f];
//    selectedView.badgeSize = CGSizeMake(26, 26);
//    
//    LCImageCollectionBackgroundView *backgroundView = [LCImageCollectionBackgroundView appearance];
//    backgroundView.collectionBackgroundColor = [UIColor blackColor];
//    
//    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:[LCImagePickerController class], nil];
//    navBar.translucent = NO;
//    navBar.barStyle = UIBarStyleBlack;
//    navBar.barTintColor = [UIColor blackColor];
//    navBar.tintColor = [UIColor blackColor];
    
    
    LCImagePickerController *vc = [[LCImagePickerController alloc] init];
    vc.delegate = self;
    vc.selectedAssets = [NSMutableArray arrayWithArray:_assetArray];
    vc.defaultGroupType = ALAssetsGroupSavedPhotos;
    vc.allowsMultipleSelection = YES;
    vc.showCameraCell = YES;
    [self presentViewController:vc animated:YES completion:NULL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LCImagePickerViewControllerDelagate Method



- (BOOL)collectionPickerController:(LCImgaeCollectionViewController *)collectionViewController didSelectItemAtIndexPath:(NSIndexPath *)indexPath asset:(ALAsset *)asset{
//    UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage scale:1.0f orientation:UIImageOrientationUp];
//    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
//    imageCropVC.cropMode = RSKImageCropModeCustom;
//    imageCropVC.avoidEmptySpaceAroundImage = YES;
//    imageCropVC.maskLayerStrokeColor = [UIColor whiteColor];
//    imageCropVC.delegate = self;
//    imageCropVC.dataSource = self;
//    [collectionViewController.navigationController pushViewController:imageCropVC animated:YES];
    
    if (indexPath.row == 0) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor whiteColor];
        [collectionViewController presentViewController:vc animated:YES completion:NULL];
        return YES;
    }
    return NO;
}


- (UIButton *)backButtonForImagePicker:(LCImagePickerController *)picker{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [UIImage imageNamed:@"btn_back"];
    [button setImage:backImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    return button;
}

- (UIButton *)cancleButtonForImagePicker:(LCImagePickerController *)picker{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [UIImage imageNamed:@"navIconDissmisDefault"];
    [button setImage:backImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    return button;
}

- (void)imagePickerController:(LCImagePickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.assetArray removeAllObjects];
    [self.assetArray addObjectsFromArray:assets];
    [self.tableView reloadData];
}

// 限制选择数量

- (BOOL)imagePickerController:(LCImagePickerController *)picker shouldSelectAsset:(ALAsset *)asset{
    if (picker.selectedAssets.count >= 9) {
        return NO;
    }
    return YES;
}

- (void)imagePickerWillShow:(LCImagePickerController *)picker{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:picker.view];
    [picker.view addSubview:HUD];
    [HUD show:NO];
}

- (void)imagePickerDidShow:(LCImagePickerController *)picker{
    [MBProgressHUD hideHUDForView:picker.view animated:NO];
}

#pragma mark - UITableView Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _assetArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"imageCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageWithCGImage:[self.assetArray[indexPath.row] thumbnail]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showPickerController];
    
}


#pragma mark - RSKImageCropViewControllerDelegate Method

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller{
    
    [controller.navigationController popViewControllerAnimated:YES];
}


- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller{
    CGFloat originY = (controller.view.frame.size.height - controller.view.frame.size.width) *0.5f;
    CGRect maskRect = (CGRect){0, originY, controller.view.frame.size.width, controller.view.frame.size.width};
    
    return maskRect;
}


- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller{
    return [UIBezierPath bezierPathWithRect:controller.maskRect];
}


@end
