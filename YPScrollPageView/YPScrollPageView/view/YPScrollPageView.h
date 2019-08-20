//
//  YPScrollPageView.h
//  YPPageView
//
//  Created by 王艳苹 on 2019/7/18.
//  Copyright © 2019 王艳苹. All rights reserved.
//  整体视图

#import <UIKit/UIKit.h>

#import "YPSegmentView.h"
#import "YPContentView.h"
#import "YPSegmentStyle.h"
#import "UIView+YPExtention.h"
#import "YPScrollPageViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPScrollPageView : UIView

typedef void(^ClickSegmentViewBlock)(NSInteger index);

@property (copy, nonatomic) ClickSegmentViewBlock segmentViewBlock;
@property (weak, nonatomic, readonly) YPContentView *contentView;
@property (weak, nonatomic, readonly) YPSegmentView *segmentView;

/** 必须设置代理并且实现相应的方法*/
@property(weak, nonatomic)id<YPScrollPageViewDelegate> delegate;


- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(YPSegmentStyle *)segmentStyle titles:(NSArray<NSString *> *)titles parentViewController:(UIViewController *)parentViewController delegate:(id<YPScrollPageViewDelegate>) delegate ;

/** 给外界设置选中的下标的方法 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

/** 给外界重新设置的标题的方法(同时会重新加载页面的内容) */
- (void)reloadWithNewTitles:(NSArray<NSString *> *)newTitles;


@end

NS_ASSUME_NONNULL_END
