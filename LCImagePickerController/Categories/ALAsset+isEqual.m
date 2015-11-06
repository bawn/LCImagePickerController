//
//  ALAsset+isEqual.m
//  LCImagePickerControllerDemo
//
//  Created by bawn on 11/5/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "ALAsset+isEqual.h"



@implementation ALAsset (isEqual)

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:ALAsset.class])
        return NO;
    
    return ([[self valueForProperty:ALAssetPropertyAssetURL] isEqual:[object valueForProperty:ALAssetPropertyAssetURL]]);
}

@end