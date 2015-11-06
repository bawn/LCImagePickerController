//
//  LCImagePickerViewController+Internal.h
//  LCPickerControllerDemo
//
//  Created by bawn on 11/5/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "LCImagePickerViewController.h"

@interface LCImagePickerViewController (Internal)

- (void)dismiss:(id)sender;
- (void)finishPickingAssets:(id)sender;

- (CGSize)assetCollectionThumbnailSize;

@end
