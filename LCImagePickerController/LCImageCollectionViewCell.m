//
//  LCImageCollectionViewCell.m
//  LCPickerControllerDemo
//
//  Created by bawn on 11/4/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "LCImageCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "LCImageCollectionSelectedView.h"

@interface LCImageCollectionViewCell ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet LCImageCollectionSelectedView *selectedView;


@end

@implementation LCImageCollectionViewCell


- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.selectedView.hidden = !selected;
}

- (void)setSelectionIndex:(NSUInteger)selectionIndex{
    _selectionIndex = selectionIndex;
    self.selectedView.selectionIndex = selectionIndex;
}

- (void)setShowsSelectionIndex:(BOOL)showsSelectionIndex{
    _showsSelectionIndex = showsSelectionIndex;
    self.selectedView.showsSelectionIndex = showsSelectionIndex;
}

- (void)configWithItem:(ALAsset *)item{
    self.imageView.image = [UIImage imageWithCGImage:item.thumbnail];
}


@end
