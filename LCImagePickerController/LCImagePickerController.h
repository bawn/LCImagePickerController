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

@class LCImagePickerController;
@protocol LCImagePickerControllerDelagate <NSObject>

@required
- (void)imagePickerController:(LCImagePickerController *)picker didFinishPickingAssets:(NSArray *)assets;

@optional


- (void)imagePickerControllerDidCancel:(LCImagePickerController *)picker;

- (BOOL)imagePickerController:(LCImagePickerController *)picker shouldShowAssetsGroup:(ALAssetsGroup *)group;

- (BOOL)imagePickerController:(LCImagePickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group;

- (BOOL)imagePickerController:(LCImagePickerController *)picker shouldShowAsset:(ALAsset *)asset;

- (BOOL)imagePickerController:(LCImagePickerController *)picker shouldEnableAsset:(ALAsset *)asset;

- (BOOL)imagePickerController:(LCImagePickerController *)picker shouldSelectAsset:(ALAsset *)asset;

- (void)imagePickerController:(LCImagePickerController *)picker didSelectAsset:(ALAsset *)asset;

- (BOOL)imagePickerController:(LCImagePickerController *)picker shouldDeselectAsset:(ALAsset *)asset;

- (void)imagePickerController:(LCImagePickerController *)picker didDeselectAsset:(ALAsset *)asset;

- (BOOL)imagePickerController:(LCImagePickerController *)picker shouldHighlightAsset:(ALAsset *)asset;

- (void)imagePickerController:(LCImagePickerController *)picker didHighlightAsset:(ALAsset *)asset;

- (void)imagePickerController:(LCImagePickerController *)picker didUnhighlightAsset:(ALAsset *)asset;

- (BOOL)imagePickerController:(LCImagePickerController *)picker shouldScrollToBottomForAssetCollection:(UICollectionView *)collectionView;

- (UIButton *)doneButtonForImagePicker:(LCImagePickerController *)picker;
- (UIButton *)backButtonForImagePicker:(LCImagePickerController *)picker;
- (UIButton *)cancleButtonForImagePicker:(LCImagePickerController *)picker;

- (UIButton *)hqDoneButtonForImagePicker:(LCImagePickerController *)picker;
- (UIViewController *)hqPushViewControllerForImagePicker:(LCImagePickerController *)picker selectAsset:(ALAsset *)asset;


@end
@interface LCImagePickerController : UIViewController

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, assign) ALAssetsGroupType defaultGroupType;
@property (nonatomic, assign) BOOL showsCancelButton;
@property (nonatomic, assign) BOOL showsNumberOfSelectedImages;// 是否显示选择数量
@property (nonatomic, weak) id <LCImagePickerControllerDelagate> delegate;

- (void)selectAsset:(ALAsset *)asset;
- (void)deselectAsset:(ALAsset *)asset;


@end
