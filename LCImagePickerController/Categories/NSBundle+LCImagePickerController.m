//
//  NSBundle+LCImagePickerController.m
//  LCPickerControllerDemo
//
//  Created by bawn on 11/5/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "NSBundle+LCImagePickerController.h"
#import "LCImagePickerController.h"

@implementation NSBundle (LCImagePickerController)


+ (NSString *)lcAssetsPickerControllerBundle{
    
    return [[NSBundle bundleForClass:[LCImagePickerController class]] pathForResource:NSStringFromClass([LCImagePickerController class]) ofType:@"bundle"];
}

@end
