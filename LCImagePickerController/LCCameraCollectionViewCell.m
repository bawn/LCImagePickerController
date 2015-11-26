//
//  LCCameraCollectionViewCell.m
//  LCImagePickerControllerDemo
//
//  Created by bawn on 11/26/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "LCCameraCollectionViewCell.h"
#import "LCImageCollectionSelectedView.h"

@interface LCCameraCollectionViewCell ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end

@implementation LCCameraCollectionViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.imageView.image = [LCImageCollectionSelectedView appearance].camearImage;
    self.imageView.backgroundColor = [LCImageCollectionSelectedView appearance].camearBackgroundColor;
}

@end
