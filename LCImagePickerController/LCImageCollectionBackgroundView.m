//
//  LCImageCollectionBackgroundView.m
//  LCImagePickerControllerDemo
//
//  Created by bawn on 11/9/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "LCImageCollectionBackgroundView.h"
#import "LCImagePickerDefines.h"

@implementation LCImageCollectionBackgroundView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = LCImageCollectionBackgroundColor;
    }
    return self;
}

#pragma mark - Apperance

- (UIColor *)collectionBackgroundColor{
    return self.backgroundColor;
}

- (void)setCollectionBackgroundColor:(UIColor *)collectionBackgroundColor{
    UIColor *color = (collectionBackgroundColor) ? (collectionBackgroundColor) : LCImageCollectionBackgroundColor;
    self.backgroundColor = color;
}



@end
