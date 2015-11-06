//
//  LCImageGroupTableViewCell.m
//  LCPickerControllerDemo
//
//  Created by bawn on 11/4/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "LCImageGroupTableViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface LCImageGroupTableViewCell ()

@property (nonatomic, strong) IBOutlet UIImageView *infoImageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;

@end

@implementation LCImageGroupTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configWithItem:(ALAssetsGroup *)item{
    self.infoImageView.image = [UIImage imageWithCGImage:item.posterImage scale:1.0f orientation:UIImageOrientationUp];
    self.titleLabel.text = [item valueForProperty:ALAssetsGroupPropertyName];
    self.countLabel.text = [@([item numberOfAssets]) stringValue];
    
}

@end
