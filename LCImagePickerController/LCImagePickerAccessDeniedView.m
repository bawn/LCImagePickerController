//
//  LCImagePickerAccessDeniedView.m
//  LCImagePickerControllerDemo
//
//  Created by bawn on 11/26/15.
//  Copyright © 2015 bawn. All rights reserved.
//

#import "LCImagePickerAccessDeniedView.h"
#import "LCImagePickerDefines.h"
#import "Masonry.h"

@interface LCImagePickerAccessDeniedView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subLabel;

@end

@implementation LCImagePickerAccessDeniedView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization{
    self.titleLabel = [[UILabel alloc] init];
    self.subLabel = [[UILabel alloc] init];
    
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.subLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    
    self.titleLabel.textColor = LCImagePickerAccessDeniedTitleColor;
    self.subLabel.textColor = LCImagePickerAccessDeniedTitleColor;
    
    self.titleLabel.text = LCImagePickerAccessDeniedTitleString;
    self.subLabel.text = LCImagePickerAccessDeniedSubString;
    
    self.titleLabel.numberOfLines = 0.0f;
    self.subLabel.numberOfLines = 0.0f;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.subLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_titleLabel];
    [self addSubview:_subLabel];

    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0.0f);
        make.leading.mas_equalTo(LCImagePickerAccessDeniedLabelMargin);
        make.trailing.mas_equalTo(-LCImagePickerAccessDeniedLabelMargin);
    }];
    
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0.0f);
        make.leading.mas_equalTo(LCImagePickerAccessDeniedLabelMargin);
        make.trailing.mas_equalTo(-LCImagePickerAccessDeniedLabelMargin);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(LCImagePickerAccessDeniedLabelSpace);
    }];
}



@end
