//
//  YPScrollPageView.m
//  YPPageView
//
//  Created by 王艳苹 on 2019/7/18.
//  Copyright © 2019 王艳苹. All rights reserved.
//

#import "YPScrollPageView.h"
#import "YPHeader.h"

@interface YPScrollPageView ()

@property (nonatomic,strong) YPSegmentStyle *segmentStyle;
@property (nonatomic,weak) YPSegmentView *segmentView;
@property (nonatomic,weak) YPContentView *contentView;

@property (weak, nonatomic) UIViewController *parentViewController;
@property (strong, nonatomic) NSArray *childVcs;
@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation YPScrollPageView

- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(YPSegmentStyle *)segmentStyle titles:(NSArray<NSString *> *)titles parentViewController:(UIViewController *)parentViewController delegate:(id<YPScrollPageViewDelegate>) delegate {
    if (self = [super initWithFrame:frame]) {
        self.segmentStyle = segmentStyle;
        self.delegate = delegate;
        self.parentViewController = parentViewController;
        self.titlesArray = titles.copy;
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    // 触发懒加载
    self.segmentView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - public helper
/** 给外界设置选中的下标的方法 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated{
    [self.segmentView setSelectIndex:selectedIndex];
}

/**  给外界重新设置视图内容的标题的方法 */
- (void)reloadWithNewTitles:(NSArray<NSString *> *)newTitles {
    self.titlesArray = nil;
    self.titlesArray = newTitles.copy;
    self.segmentView.titles = newTitles;
    [self.segmentView reloadData];
    [self.contentView reload];
}


#pragma mark - getter ---- setter
- (void)setSegmentStyle:(YPSegmentStyle *)segmentStyle{
    _segmentStyle = segmentStyle;
    self.segmentView.segmentStyle = segmentStyle;
}

- (YPContentView *)contentView {
    if (!_contentView) {
        YPContentView *content = [[YPContentView alloc]initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.segmentView.frame), self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(self.segmentView.frame)) segmentView:self.segmentView parentViewController:self.parentViewController delegate:self.delegate];
        [self addSubview:content];
        _contentView = content;
    }
    
    return  _contentView;
}

- (YPSegmentView *)segmentView {
    if (!_segmentView) {
        __weak typeof(self) weakSelf = self;
        YPSegmentView *segment = [YPSegmentView segmentViewWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.segmentStyle.menuHeight) titles:self.titlesArray];
        segment.clickIndexBlock = ^(NSInteger clickIndex) {
            [weakSelf.contentView scrollControllerAtIndex:clickIndex];
        };
        [self addSubview:segment];
        _segmentView = segment;
    }
    return _segmentView;
}

- (NSArray *)childVcs {
    if (!_childVcs) {
        _childVcs = [NSArray array];
    }
    return _childVcs;
}

- (NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = [NSArray array];
    }
    return _titlesArray;
}

- (void)setsegmentViewBlock:(ClickSegmentViewBlock)segmentViewBlock{
    _segmentViewBlock = segmentViewBlock;
    self.segmentView.clickIndexBlock = segmentViewBlock;
}

- (void)dealloc {
    NSLog(@"ZJScrollPageView--销毁");
}

@end
