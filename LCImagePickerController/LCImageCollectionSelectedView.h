//
//  LCImageCollectionSelectedView.h
//  LCPickerControllerDemo
//
//  Created by bawn on 11/5/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCImageCollectionSelectedView : UIView

@property (nonatomic, assign) BOOL showsSelectionIndex;
@property (nonatomic, assign) NSUInteger selectionIndex;

@property (nonatomic, strong) UIColor *__nonnull selectedBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *__nonnull badgeTextFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *__nonnull badgeTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *__nonnull badgeColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGSize badgeSize UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *__nonnull camearImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *__nonnull camearBackgroundColor UI_APPEARANCE_SELECTOR;

@end
