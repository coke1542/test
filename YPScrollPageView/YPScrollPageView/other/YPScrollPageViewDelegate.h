//
//  YPScrollPageViewDelegate.h
//  YPPageView
//
//  Created by 王艳苹 on 2019/7/18.
//  Copyright © 2019 王艳苹. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YPScrollPageViewDelegate <NSObject>

/** 将要显示的子页面的总数 */
- (NSInteger)numberOfChildViewControllers;

/** 获取到将要显示的页面的控制器
 * reuseViewController:这个是返回给你的controller,你应该首先判断这个是否为nil,如果为nil 创建对应的控制器并返回, 如果不为nil直接使用并返回
 * index : 对应的下标
 */
- (UIViewController *)childViewController:(UIViewController *)reuseViewController forIndex:(NSInteger)index;

@end
