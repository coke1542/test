//
//  YPSegmentStyle.m
//  YPPageView
//
//  Created by 王艳苹 on 2019/7/18.
//  Copyright © 2019 王艳苹. All rights reserved.
//

#import "YPSegmentStyle.h"

@implementation YPSegmentStyle

- (instancetype)init{
    self = [super init];
    if (self) {
        _itemWidth = 80;
        _itemSpace = 5;
        _lineWidth = _itemWidth - _itemSpace * 2;
        _lineHeight = 1.5;
        _titleTextHeight  = 16;
        _menuHeight = 44.0;
        _itemWidthType = YPItemWidthFixation;//固定宽度
        _underlineWidthType = YPUnderLineWidthByFont;//固定宽度
        _selectedItemType = YPSelectedItemUnderLine;//默认选中有下滑线
        _normalTitleColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _selectedTitleColor = [UIColor colorWithRed:255/255.0 green:18/255.0 blue:104/255.0 alpha:1];
        _titleTextFont = [UIFont systemFontOfSize:16.0f];
        _selectedTitleTextFont = [UIFont systemFontOfSize:21.0f];
    }
    return self;
}

@end
