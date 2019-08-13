//
//  YPContentView.h
//  YPPageView
//
//  Created by 王艳苹 on 2019/7/18.
//  Copyright © 2019 王艳苹. All rights reserved.
//  滚动视图

#import <UIKit/UIKit.h>
#import "YPScrollPageViewDelegate.h"
@class YPSegmentView;
NS_ASSUME_NONNULL_BEGIN

@interface YPContentView : UIView

/**初始化方法:和YPsegmentView连用*/
- (instancetype)initWithFrame:(CGRect)frame segmentView:(YPSegmentView *)segmentView parentViewController:(UIViewController *)parentViewController delegate:(id<YPScrollPageViewDelegate>) delegate;

/**初始化方法:单独使用*/
- (instancetype)initWithFrame:(CGRect)frame selectedIndex:(NSInteger)index parentViewController:(UIViewController *)parentViewController delegate:(id<YPScrollPageViewDelegate>) delegate;

- (void)scrollControllerAtIndex:(NSInteger)index;

- (void)reload;

@end

NS_ASSUME_NONNULL_END
