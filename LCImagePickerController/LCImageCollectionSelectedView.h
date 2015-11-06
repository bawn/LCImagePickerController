//
//  LCImageCollectionSelectedView.h
//  LCPickerControllerDemo
//
//  Created by bawn on 11/5/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCImageCollectionSelectedView : UIView

@property (nonatomic, assign) NSUInteger selectionIndex;

@property (nonatomic, weak) UIColor *selectedBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, weak) UIFont *textFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, weak) UIColor *textColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, weak) UIColor *badgeColor UI_APPEARANCE_SELECTOR;

@end
