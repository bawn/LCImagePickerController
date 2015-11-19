//
//  LCImageCollectionSelectedView.m
//  LCPickerControllerDemo
//
//  Created by bawn on 11/5/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "LCImageCollectionSelectedView.h"
#import "LCImagePickerDefines.h"
#import "Masonry.h"

@interface LCImageCollectionSelectedView ()

@property (nonatomic, strong) UILabel *selectionIndexLabel;

@end

@implementation LCImageCollectionSelectedView


- (instancetype)init{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}


- (void)awakeFromNib{
    [self initUI];
}


- (void)setSelectedBackgroundColor:(UIColor *)backgroundColor{
    UIColor *color = backgroundColor ? backgroundColor : LCImageCollectionSelectedBackgroundColor;
    self.backgroundColor = color;
}


- (void)setBadgeTextColor:(UIColor *)badgeTextColor{
    UIColor *color = badgeTextColor ? : LCImageCollectionSelectedTextColor;
    self.selectionIndexLabel.textColor = color;
}

- (void)setBadgeTextFont:(UIFont *)badgeTextFont{
    UIFont *font = badgeTextFont ? : LCImageCollectionSelectedViewFont;
    self.selectionIndexLabel.font = font;
}

- (void)setBadgeColor:(UIColor *)badgeColor{
    UIColor *color = badgeColor ? : self.tintColor;
    self.selectionIndexLabel.backgroundColor = color;
}

- (void)setBadgeSize:(CGSize)badgeSize{
    
    CGSize size = CGSizeEqualToSize(badgeSize, CGSizeZero) ? LCImageCollectionSelectedBadgeSize : badgeSize;
    [self.selectionIndexLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
}

- (void)setShowsSelectionIndex:(BOOL)showsSelectionIndex{
    _showsSelectionIndex = showsSelectionIndex;
    
    if (showsSelectionIndex){
        self.selectionIndexLabel.hidden = NO;
    }
    else{
        self.selectionIndexLabel.hidden = YES;
    }
}


- (void)initUI{
    // 蒙层颜色
    self.backgroundColor = LCImageCollectionSelectedBackgroundColor;
    
    // 角标
    self.selectionIndexLabel = [[UILabel alloc] init];
    self.selectionIndexLabel.textAlignment = NSTextAlignmentCenter;
    self.selectionIndexLabel.backgroundColor = self.tintColor;
    self.selectionIndexLabel.font = LCImageCollectionSelectedViewFont;
    self.selectionIndexLabel.textColor = LCImageCollectionSelectedTextColor;
    self.selectionIndexLabel.layer.masksToBounds = YES;
    [self addSubview:_selectionIndexLabel];
    
    [self.selectionIndexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-LCImageCollectionIndexLabelSpace);
        make.top.mas_equalTo(LCImageCollectionIndexLabelSpace);
        make.size.mas_equalTo(LCImageCollectionSelectedBadgeSize);
    }];
}

- (void)setSelectionIndex:(NSUInteger)selectionIndex;
{
    _selectionIndex = selectionIndex;
    self.selectionIndexLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)(selectionIndex + 1)];
    [self layoutIfNeeded];
    [self.selectionIndexLabel layoutIfNeeded];
    self.selectionIndexLabel.layer.masksToBounds = YES;
    self.selectionIndexLabel.layer.cornerRadius = _selectionIndexLabel.frame.size.height * 0.5f;
}

@end
