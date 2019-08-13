//
//  YPContentView.m
//  YPPageView
//
//  Created by 王艳苹 on 2019/7/18.
//  Copyright © 2019 王艳苹. All rights reserved.
//

#import "YPContentView.h"
#import "YPSegmentView.h"
#import "UIView+YPExtention.h"

@interface YPContentView()<UIScrollViewDelegate>

/**父控制器 使用weak避免循环引用*/
@property (nonatomic,weak) UIViewController *parentViewController;
/*存放子控制器**/
@property (nonatomic,strong) NSMutableDictionary<NSString*,UIViewController *> *childControllersDic;
/*当前控制器**/
@property (nonatomic,strong) UIViewController *currentChildController;
/*当前控制器index**/
@property (nonatomic,assign) NSInteger currentIndex;
/*oldIndex**/
@property (nonatomic,assign) NSInteger oldIndex;
/*oldOffSetX**/
@property (nonatomic,assign) CGFloat oldOffSetX;
/*总数目**/
@property (nonatomic,assign) NSInteger itemsCount;
/*滚动视图**/
@property (nonatomic,strong) UIScrollView *scrollView;
/*菜单视图**/
@property (nonatomic,strong) YPSegmentView *segmentView;
/**代理方法*/
@property (nonatomic,weak) id<YPScrollPageViewDelegate>delegate;

@end

@implementation YPContentView
/**初始化方法*/
- (instancetype)initWithFrame:(CGRect)frame segmentView:(YPSegmentView *)segmentView parentViewController:(UIViewController *)parentViewController delegate:(id<YPScrollPageViewDelegate>) delegate{
    if (self = [super initWithFrame:frame]) {
        self.segmentView = segmentView;
        self.delegate = delegate;
        self.parentViewController = parentViewController;
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.currentIndex = segmentView.selectIndex;
        [self commonInit];
    }
    return self;
}

- (void)reload{
    //刷新方法
}

/**初始化方法:单独使用*/
- (instancetype)initWithFrame:(CGRect)frame selectedIndex:(NSInteger)index parentViewController:(UIViewController *)parentViewController delegate:(id<YPScrollPageViewDelegate>) delegate{
    if (self = [super initWithFrame:frame]) {
        self.delegate = delegate;
        self.parentViewController = parentViewController;
        self.scrollView.backgroundColor = [UIColor whiteColor];
        self.currentIndex = index;
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    if ([self.delegate respondsToSelector:@selector(numberOfChildViewControllers)]) {
        self.itemsCount = [self.delegate numberOfChildViewControllers];
    }else {
        NSAssert(NO, @"必须实现的代理方法");
    }
    self.scrollView.contentSize = CGSizeMake(self.itemsCount * self.frame.size.width, 0);
    [self scrollControllerAtIndex:self.currentIndex];
}

- (void)scrollControllerAtIndex:(NSInteger)index{
    self.currentIndex = index;
    CGFloat offsetX = index * self.frame.size.width;
    CGPoint offset = CGPointMake(offsetX, 0);
    if (fabs(self.scrollView.contentOffset.x - offset.x) > self.frame.size.width || self.scrollView.contentOffset.x == offset.x) {
        [self.scrollView setContentOffset:offset animated:NO];
        // 获得索引
        int index = (int)self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
        [self addChildViewAtIndex:[NSString stringWithFormat:@"%d",index]];
    }else {
        [self.scrollView setContentOffset:offset animated:YES];
    }
}

- (void)addChildViewAtIndex:(NSString *)index{
    if (self.currentIndex != [index integerValue]) {
        return; // 跳过中间的多页
    }
    self.currentChildController = self.childControllersDic[index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(childViewController:forIndex:)]) {
        if (self.currentChildController == nil) {
            self.currentChildController = [self.delegate childViewController:nil forIndex:[index integerValue]];
            // 设置当前下标
            [self.childControllersDic setValue:self.currentChildController forKey:index];
        } else {
            [_delegate childViewController:self.currentChildController forIndex:[index integerValue]];
        }
    } else {
        NSAssert(NO, @"必须设置代理和实现代理方法");
    }
    // 这里建立子控制器和父控制器的关系
    if ([self.currentChildController isKindOfClass:[UINavigationController class]]) {
        NSAssert(NO, @"不要添加UINavigationController包装后的子控制器");
    }
    [self.parentViewController addChildViewController:self.currentChildController];
    self.currentChildController.view.frame = CGRectMake(self.width * [index integerValue],0, self.width, self.height);
    [self.scrollView addSubview:self.currentChildController.view];
    [self.currentChildController didMoveToParentViewController:self.parentViewController];
    if (self.segmentView) {
        [self.segmentView refreshContentOffsetItemByIndex:[index integerValue]];
        [self.segmentView adjustTitleOffSetToCurrent];
    }
}

#pragma mark ----- UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _oldOffSetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ( scrollView.contentOffset.x <= 0 || // first or last
        scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.size.width) {
        return;
    }
    CGFloat tempProgress = scrollView.contentOffset.x / self.bounds.size.width;
    NSInteger tempIndex = tempProgress;

    CGFloat progress = tempProgress - floor(tempProgress);
    CGFloat deltaX = scrollView.contentOffset.x - _oldOffSetX;
    if (deltaX > 0) {// 向左
        if (progress == 0.0) {
            return;
        }
        self.currentIndex = tempIndex + 1;
        self.oldIndex = tempIndex;
    }else if (deltaX < 0) {
        progress = 1.0 - progress;
        self.oldIndex = tempIndex + 1;
        self.currentIndex = tempIndex;
    }else {
        return;
    }
    [self contentViewDidMoveFromIndex:_oldIndex toIndex:_currentIndex progress:progress];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView*)scrollView {
    NSLog(@"结束滚动");
    if (self.childControllersDic) {
        int index = (int)self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
        [self addChildViewAtIndex:[NSString stringWithFormat:@"%d",index]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


#pragma mark ----- private method
- (void)contentViewDidMoveFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    if(self.segmentView) {
        [self.segmentView adjustUIWithProgress:progress oldIndex:fromIndex currentIndex:toIndex];
    }
}

- (void)adjustSegmentTitleOffsetToCurrentIndex:(NSInteger)index {
    if(self.segmentView) {
        [self.segmentView adjustTitleOffSetToCurrent];
    }
}

+ (void)removeChildController:(UIViewController *)child {
    [child willMoveToParentViewController:nil];
    [child.view removeFromSuperview];
    [child removeFromParentViewController];
}

#pragma mark ---- setter
- (void)setCurrentIndex:(NSInteger)currentIndex{
    if (_currentIndex != currentIndex) {
        _currentIndex = currentIndex;
    }
}
#pragma mark ---- getter
- (NSMutableDictionary<NSString *,UIViewController *> *)childControllersDic{
    if (!_childControllersDic) {
        _childControllersDic = [NSMutableDictionary dictionary];
    }
    return _childControllersDic;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

@end
