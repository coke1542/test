//
//  YPSegmentView.h
//  YouBuy
//
//  Created by 王艳苹 on 2019/3/12.
//  Copyright © 2019 王艳苹. All rights reserved.
//  菜单视图

#import <UIKit/UIKit.h>

@class YPSegmentStyle;
@class YPSegmentItem;

@interface YPSegmentView : UIView

/** 设置选中的下标 */
@property (nonatomic,assign) NSInteger selectIndex;
/** 标题数组 */
@property (nonatomic,copy)   NSArray<NSString *> *titles;
/** 背景视图 */
@property (nonatomic,strong) UIView *backgroundView;
/** 菜单视图样式设置 */
@property (nonatomic,strong) YPSegmentStyle *segmentStyle;
/** block方式监听点击 */
@property (nonatomic,copy) void (^clickIndexBlock)(NSInteger clickIndex);

- (void)deleteUnderLineStyleByIndex:(NSInteger)index isDelete:(BOOL)isDelete;

/**初始分段选择控件*/
+ (instancetype)segmentViewWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles;
/**刷新数据*/
- (void)reloadData;
/**拖动Controller滑动选择控件*/
- (void)refreshContentOffsetItemByIndex:(NSInteger)index;
- (void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex;
- (void)adjustTitleOffSetToCurrent;
@end
