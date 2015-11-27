//
//  ALAsset+url.m
//  LCImagePickerControllerDemo
//
//  Created by bawn on 11/27/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "ALAsset+url.h"

@implementation ALAsset (url)

- (NSString *)url{
    return [self valueForProperty:ALAssetPropertyAssetURL];
}


@end
