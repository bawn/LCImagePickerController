//
//  NSBundle+LCImagePickerController.m
//  LCImagePickerControllerDemo
//
//  Created by bawn on 11/5/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "NSBundle+LCImagePickerController.h"
#import "LCImagePickerController.h"

@implementation NSBundle (LCImagePickerController)

+ (NSBundle *)lcAssetsPickerControllerBundle{
    return [NSBundle bundleWithPath:[NSBundle clAssetsPickerControllerBundlePath]];
}

+ (NSString *)clAssetsPickerControllerBundlePath{
    
    return [[NSBundle bundleForClass:[LCImagePickerController class]] pathForResource:NSStringFromClass([LCImagePickerController class]) ofType:@"bundle"];
}

@end
