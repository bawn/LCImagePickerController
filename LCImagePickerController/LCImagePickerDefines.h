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


#define LCImageCollectionSelectedBackgroundColor  [[UIColor blackColor] colorWithAlphaComponent:0.7]
#define LCImageCollectionSelectedViewFont         [UIFont preferredFontForTextStyle:UIFontTextStyleBody]
#define LCImageCollectionSelectedTextColor        [UIColor blackColor]
#define LCImageCollectionBackgroundColor          [UIColor blackColor]
#define LCImageCollectionSelectedBadgeSize        CGSizeMake(LCImageCollectionIndexLabelSize, LCImageCollectionIndexLabelSize)

#endif /* LCImagePickerDefines_h */
