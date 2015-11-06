//
//  ALAsset+assetType.m
//  LCImagePickerControllerDemo
//
//  Created by bawn on 11/5/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "ALAsset+assetType.h"



@implementation ALAsset (assetType)

- (BOOL)isPhoto
{
    return [[self valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypePhoto];
}

- (BOOL)isVideo
{
    return [[self valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo];
}

@end
