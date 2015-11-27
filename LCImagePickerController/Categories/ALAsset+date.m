//
//  ALAsset+date.m
//  LCImagePickerControllerDemo
//
//  Created by bawn on 11/27/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "ALAsset+date.h"

@implementation ALAsset (date)

- (NSDate *) date{
    return [self valueForProperty:ALAssetPropertyDate];
}
@end
