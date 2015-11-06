//
//  ALAsset+assetType.h
//  LCImagePickerControllerDemo
//
//  Created by bawn on 11/5/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>



@interface ALAsset (assetType)

- (BOOL)isPhoto;
- (BOOL)isVideo;

@end
