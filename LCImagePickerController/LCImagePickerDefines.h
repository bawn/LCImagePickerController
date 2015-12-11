//
//  LCImagePickerDefines.h
//  LCPickerControllerDemo
//
//  Created by bawn on 11/5/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#ifndef LCImagePickerDefines_h
#define LCImagePickerDefines_h


static CGFloat const LCImageCollectionIndexLabelSpace = 4.0f;
static CGFloat const LCImageCollectionIndexLabelSize = 26.0f;
static CGFloat const LCImageGroupCellHeight = 96.0f;

static NSString *const LCImagePickerAccessDeniedTitleString = @"此应用程序对您的照片或视频没有访问权。";
static NSString *const LCImagePickerAccessDeniedSubString = @"您可以在隐私设置中启用访问权。";
static CGFloat const LCImagePickerAccessDeniedLabelSpace = 5.0f;
static CGFloat const LCImagePickerAccessDeniedLabelMargin = 16.0f;

#define LCImageCollectionSelectedBackgroundColor  [[UIColor blackColor] colorWithAlphaComponent:0.7]
#define LCImageCollectionSelectedViewFont         [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
#define LCImageCollectionSelectedTextColor        [UIColor blackColor]
#define LCImageCollectionBackgroundColor          [UIColor blackColor]
#define LCImageCollectionSelectedBadgeSize        CGSizeMake(LCImageCollectionIndexLabelSize, LCImageCollectionIndexLabelSize)

#define LCImagePickerAccessDeniedTitleColor       [UIColor colorWithRed:130.0f/255.0f green:135.0f/255.0f blue:148.0f/255.0f alpha:1.0f]
#define LCImagePickerAccessDeniedSubColor         [UIColor colorWithRed:129.0f/255.0f green:136.0f/255.0f blue:148.0f/255.0f alpha:1.0f]

#endif /* LCImagePickerDefines_h */
