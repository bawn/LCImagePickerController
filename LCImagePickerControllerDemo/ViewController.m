//
//  ViewController.m
//  LCPickerControllerDemo
//
//  Created by bawn on 11/4/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "ViewController.h"
#import "LCImagePicker.h"

@interface ViewController ()<LCImagePickerViewControllerDelagate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)pickButtonAction:(id)sender{
    
    LCImageCollectionSelectedView *selectedView = [LCImageCollectionSelectedView appearance];
    selectedView.selectedBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.65];
    selectedView.textFont = [UIFont systemFontOfSize:13.0f];
    selectedView.textColor = [UIColor blackColor];
    selectedView.badgeColor = [UIColor colorWithRed:255.0f/255.0f green:226.0f/255.0 blue:0.0f alpha:1.0f];
    
    
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:[LCImagePickerViewController class], nil];
    navBar.barStyle = UIBarStyleDefault;
    navBar.translucent = NO;
    navBar.barTintColor = [UIColor whiteColor];
    navBar.tintColor = [UIColor whiteColor];
    
    LCImagePickerViewController *vc = [[LCImagePickerViewController alloc] init];
    vc.delegate = self;
    vc.defaultGroupType = ALAssetsGroupSavedPhotos;
    [self presentViewController:vc animated:YES completion:NULL];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LCImagePickerViewControllerDelagate Method

- (UIButton *)doneButtonForImagePicker:(LCImagePickerViewController *)picker{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 52, 25);
    button.layer.cornerRadius = 4.0f;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor yellowColor];
    return button;
}


- (UIButton *)backButtonForImagePicker:(LCImagePickerViewController *)picker{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage = [UIImage imageNamed:@"btn_back"];
    [button setImage:backImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    return button;
}


- (void)imagePickerController:(LCImagePickerViewController *)picker didFinishPickingAssets:(NSArray *)assets{
    [picker dismissViewControllerAnimated:NO completion:NULL];
    
    //    UIViewController *vc = [[UIViewController alloc] init];
    //    vc.view.backgroundColor = [UIColor whiteColor];
    //    [picker.navigationController pushViewController:vc animated:YES];
    //    NSLog(@"%@", assets);
}

// 限制选择数量

- (BOOL)imagePickerController:(LCImagePickerViewController *)picker shouldSelectAsset:(ALAsset *)asset{
    if (picker.selectedAssets.count >= 9) {
        return NO;
    }
    return YES;
}



@end
