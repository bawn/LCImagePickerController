//
//  LCImagePickerViewController.h
//  LCPickerControllerDemo
//
//  Created by bawn on 11/4/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

extern NSString * const LCImagePickerSelectedAssetsDidChangeNotification;

extern NSString * const LCImagePickerDidSelectAssetNotification;

extern NSString * const LCImagePickerDidDeselectAssetNotification;

@class LCImagePickerViewController;
@protocol LCImagePickerViewControllerDelagate <NSObject>

@required
- (void)imagePickerController:(LCImagePickerViewController *)picker didFinishPickingAssets:(NSArray *)assets;

@optional


- (void)imagePickerControllerDidCancel:(LCImagePickerViewController *)picker;

- (BOOL)imagePickerController:(LCImagePickerViewController *)picker shouldShowAssetsGroup:(ALAssetsGroup *)group;

- (BOOL)imagePickerController:(LCImagePickerViewController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group;

- (BOOL)imagePickerController:(LCImagePickerViewController *)picker shouldShowAsset:(ALAsset *)asset;

- (BOOL)imagePickerController:(LCImagePickerViewController *)picker shouldEnableAsset:(ALAsset *)asset;

- (BOOL)imagePickerController:(LCImagePickerViewController *)picker shouldSelectAsset:(ALAsset *)asset;

- (void)imagePickerController:(LCImagePickerViewController *)picker didSelectAsset:(ALAsset *)asset;

- (BOOL)imagePickerController:(LCImagePickerViewController *)picker shouldDeselectAsset:(ALAsset *)asset;

- (void)imagePickerController:(LCImagePickerViewController *)picker didDeselectAsset:(ALAsset *)asset;

- (BOOL)imagePickerController:(LCImagePickerViewController *)picker shouldHighlightAsset:(ALAsset *)asset;

- (void)imagePickerController:(LCImagePickerViewController *)picker didHighlightAsset:(ALAsset *)asset;

- (void)imagePickerController:(LCImagePickerViewController *)picker didUnhighlightAsset:(ALAsset *)asset;

- (UIButton *)doneButtonForImagePicker:(LCImagePickerViewController *)picker;
- (UIButton *)backButtonForImagePicker:(LCImagePickerViewController *)picker;
- (UIButton *)cancleButtonForImagePicker:(LCImagePickerViewController *)picker;


@end
@interface LCImagePickerViewController : UIViewController

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) ALAssetsFilter *assetsFilter;
@property (nonatomic, assign) ALAssetsGroupType defaultGroupType;
@property (nonatomic, assign) BOOL showsCancelButton;
@property (nonatomic, weak) id <LCImagePickerViewControllerDelagate> delegate;

- (void)selectAsset:(ALAsset *)asset;
- (void)deselectAsset:(ALAsset *)asset;


@end
