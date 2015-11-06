//
//  LCImagePickerViewController+Internal.h
//  LCPickerControllerDemo
//
//  Created by bawn on 11/5/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "LCImagePickerController.h"

@interface LCImagePickerController (Internal)

- (void)dismiss:(id)sender;
- (void)finishPickingAssets:(id)sender;

- (CGSize)assetCollectionThumbnailSize;

@end
