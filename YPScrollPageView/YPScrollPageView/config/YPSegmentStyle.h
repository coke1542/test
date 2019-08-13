//
//  YPSegmentStyle.h
//  YPPageView
//
//  Created by 王艳苹 on 2019/7/18.
//  Copyright © 2019 王艳苹. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    YPItemWidthAdaptionByFont,   //根据标题字体自适应
    YPItemWidthFixation          //固定宽度
} YPItemWidthType;

typedef enum {
    YPSelectedItemUnderLine,   //下划线
    YPSelectedItemFontBigger,    //字体变大
    YPSelectedItemUnderAndFontBigger    //有下划线且字体变大
} YPSelectedItemType;

typedef enum {
    YPUnderLineWidthByFont,  //根据字体自适应
    YPUnderLineWidthBySelectedFont, //根据选中字体自适应
    YPUnderLineWidthFixation   //固定长度
} YPUnderLineWidthType;

NS_ASSUME_NONNULL_BEGIN

@interface YPSegmentStyle : NSObject

/**item宽度类型*/
@property (nonatomic,assign) YPItemWidthType itemWidthType;
/**下划线宽度类型*/
@property (nonatomic,assign) YPUnderLineWidthType underlineWidthType;
/**选中样式*/
@property (nonatomic,assign) YPSelectedItemType selectedItemType;
/** 背景颜色 */
@property (nonatomic,strong) UIColor *menuBackgroundColor;

/** 标题未选中时的颜色 */
@property (nonatomic,strong) UIColor *normalTitleColor;
/** 标题文字字体 */
@property (nonatomic,strong) UIFont  *titleTextFont;
/** 标题文字高度 */
@property (nonatomic,assign) CGFloat titleTextHeight;
/** 标题选中时的颜色 */
@property (nonatomic,strong) UIColor *selectedTitleColor;
/** 标题选中时字体 */
@property (nonatomic,strong) UIFont *selectedTitleTextFont;

/** 下划线颜色 */
@property (nonatomic,strong) UIColor *lineColor;
/** 下划线长度 */
@property (nonatomic,assign) CGFloat lineWidth;
/** 下划线长度 */
@property (nonatomic,assign) CGFloat lineHeight;
/** 是否在拖拽 */
@property (nonatomic,assign) BOOL isDrag;
/** item的宽度 */
@property (nonatomic,assign) CGFloat itemWidth;
/**item之间的间距*/
@property (nonatomic,assign) CGFloat itemSpace;
/**item之间的间距*/
@property (nonatomic,assign) CGFloat menuHeight;

/**下划线是否随滚动j过度 默认是NO*/
@property (nonatomic,assign) BOOL isUnderlineGraduallyVaried;
/**标题颜色是否随滚动j过度 默认是NO*/
@property (nonatomic,assign) BOOL isColorGraduallyVaried;

@end

NS_ASSUME_NONNULL_END
