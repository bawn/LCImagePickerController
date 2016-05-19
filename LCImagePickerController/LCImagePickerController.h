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
@class LCImgaeCollectionViewController;
@protocol LCImagePickerControllerDelagate <NSObject>

@required

/**
 *  点击完成按钮后的操作
 *
 *  @param picker 相册
 *  @param assets 已选择的照片
 */

- (void)imagePickerController:(LCImagePickerController *)picker didFinishPickingAssets:(NSArray *)assets;

@optional

/**
 *  取消相册操作
 *
 *  @param picker 相册
 */
- (void)imagePickerControllerDidCancel:(LCImagePickerController *)picker;


/**
 *  将要选择照片时的操作
 *
 *  @param picker 相册
 *  @param asset  已选择的照片
 *
 *  @return 是否可以再选择照片
 */
- (BOOL)imagePickerController:(LCImagePickerController *)picker shouldSelectAsset:(ALAsset *)asset;
/**
 *  当进入照片选择页面的时候是否滚动到底部
 *
 *  @param picker 相册
 *
 *  @return 返回是否滚动到底部，默认是 YES
 */
- (BOOL)imagePickerControllerShouldScrollToBottom:(LCImagePickerController *)picker;
/**
 *  照片选择页面将要出现，这时候可以添加HUD
 *
 *  @param picker 相册
 */
- (void)imagePickerWillShow:(LCImagePickerController *)picker;
/**
 *  照片选择页面已经出现，这时候可以移除HUD
 *
 *  @param picker 相册
 */

- (void)imagePickerDidShow:(LCImagePickerController *)picker;
/**
 *  照片选择页面右上角的完成按钮
 *
 *  @param picker 相册
 *
 *  @return 自定义的完成按钮
 */
- (UIButton *)doneButtonForImagePicker:(LCImagePickerController *)picker;
/**
 *  照片选择页面的返回按钮
 *
 *  @param picker 相册
 *
 *  @return 自定义的返回按钮
 */

- (UIButton *)backButtonForImagePicker:(LCImagePickerController *)picker;
/**
 *  相册组页面的取消按钮
 *
 *  @param picker 相册
 *
 *  @return 自定义的取消按钮
 */

- (UIButton *)cancleButtonForImagePicker:(LCImagePickerController *)picker;

/**
 *  照片选择页面当选择cell的时候是否需要跳转到另一个页面
 *
 *  @param picker     相册
 *  @param controller 当前的照片选择页面
 *  @param indexPath  当前indexPath
 *  @param asset      当前asset
 *
 *  @return 是否需要跳转到一个界面
 */
- (BOOL)imagePicker:(LCImagePickerController *)picker pickerController:(LCImgaeCollectionViewController *)controller didSelectItemAtIndexPath:(NSIndexPath *)indexPath asset:(ALAsset *)asset;


@end
@interface LCImagePickerController : UIViewController

/**
 *  是否显示取消按钮，默认 YES
 */
@property (nonatomic, assign) BOOL showsCancelButton;
/**
 *  是否允许多选，默认 NO
 */
@property (nonatomic, assign) BOOL allowsMultipleSelection;
/**
 *  是否显示拍照按钮，默认 NO
 */
@property (nonatomic, assign) BOOL showCameraCell;
/**
 *  是否显示空专辑，默认 NO
 */
@property (nonatomic, assign) BOOL showsEmptyAlbums;

/**
 *  是否倒序排列照片，默认 NO
 */
@property (nonatomic, assign) BOOL descendingOrder;

@property (nonatomic, assign) ALAssetsGroupType defaultGroupType;
@property (nonatomic, strong, readonly) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, weak) id <LCImagePickerControllerDelagate> delegate;

- (void)selectAsset:(ALAsset *)asset;
- (void)deselectAsset:(ALAsset *)asset;

@end
