//
//  YPSegmentItem.m
//  YouBuy
//
//  Created by 王艳苹 on 2019/3/12.
//  Copyright © 2019 王艳苹. All rights reserved.
//

#import "YPSegmentItem.h"

@interface YPSegmentItem ()

/** 标题label */
@property (nonatomic,weak) UILabel *titleLabel;
/**下划线*/
@property (nonatomic,weak) UIView *lineView;

@end

@implementation YPSegmentItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureContentView];
    }
    return self;
}

- (void)configureContentView {
    _underLineWidth = self.frame.size.width - 10;
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel = titleLabel;
    UIView *lineView = [[UIView alloc] init];
    _lineView = lineView;
    [self addSubview:_titleLabel];
    [self addSubview:_lineView];
}

#pragma mark ---- layout
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    _titleLabel.frame  = CGRectMake(0,0,bounds.size.width,bounds.size.height);
    _lineView.frame = CGRectMake((self.frame.size.width - _underLineWidth) * 0.5,bounds.size.height - 1,_underLineWidth,1);
    [self bringSubviewToFront:_lineView];
}

#pragma mark ---- setter

- (void)setTitleText:(NSString *)titleText{
    _titleText = [titleText copy];
    self.titleLabel.text = titleText;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
    self.lineView.backgroundColor = titleColor;
}

- (void)setTitleTextFont:(UIFont *)titleTextFont {
    _titleTextFont = titleTextFont;
    self.titleLabel.font = titleTextFont;
}

- (void)setIsShowUnderLine:(BOOL)isShowUnderLine{
    _isShowUnderLine = isShowUnderLine;
    _lineView.hidden = !isShowUnderLine;
}

@end
