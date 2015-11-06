//
//  LCImageCollectionViewCell.h
//  LCPickerControllerDemo
//
//  Created by bawn on 11/4/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCImageCollectionViewCell : UICollectionViewCell

- (void)configWithItem:(id)item;

@property (nonatomic, assign) NSUInteger selectionIndex;

@end
