//
//  YPPartController.m
//  YPPageView
//
//  Created by 王艳苹 on 2019/8/7.
//  Copyright © 2019 王艳苹. All rights reserved.
//

#import "YPPartController.h"
#import "YPSubPartController.h"

#import "YPFrameConfig.h"
#import "YPSystemConfig.h"
#import "YPSegmentStyle.h"
#import "YPSegmentView.h"
#import "YPContentView.h"
#import "YPScrollPageViewDelegate.h"

@interface YPPartController ()<YPScrollPageViewDelegate>

@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) YPSegmentView *segmentView;
@property (nonatomic,strong) YPContentView *content;

@end

@implementation YPPartController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configureContentView];
}

- (void)setIsDeleteUnderlineStyle:(BOOL)isDeleteUnderlineStyle{
    _isDeleteUnderlineStyle = isDeleteUnderlineStyle;
    [self.segmentView deleteUnderLineStyleByIndex:self.segmentView.selectIndex isDelete:isDeleteUnderlineStyle];
}

- (void)configureContentView{
    YPSegmentStyle *style = [[YPSegmentStyle alloc]init];
    style.selectedItemType = YPSelectedItemUnderLine;
    style.itemWidthType = YPItemWidthAdaptionByFont;
    style.isUnderlineGraduallyVaried = YES;
    style.isColorGraduallyVaried = YES;
    self.segmentView.segmentStyle = style;
    self.segmentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentView];
    [self.segmentView reloadData];
    
    YPContentView *content = [[YPContentView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.segmentView.frame),self.view.frame.size.width,self.view.frame.size.height - CGRectGetMaxY(self.segmentView.frame)) segmentView:self.segmentView parentViewController:self delegate:self];
    content.backgroundColor = [UIColor whiteColor];
    self.content = content;
    [self.view addSubview:content];
}

- (NSInteger)numberOfChildViewControllers{
    return self.titleArray.count;
}

- (UIViewController *)childViewController:(UIViewController *)reuseViewController forIndex:(NSInteger)index{
    YPSubPartController *vc = [[YPSubPartController alloc]init];
    return vc;
}

- (YPSegmentView *)segmentView{
    if (!_segmentView) {
        _segmentView = [YPSegmentView segmentViewWithFrame:CGRectMake(0, __kStatusBarHeight__, __kScreenWidth__,44.0f) titles:self.titleArray];
        __kWeakSelf__
        _segmentView.clickIndexBlock = ^(NSInteger clickIndex) {
            [weakSelf.content scrollControllerAtIndex:clickIndex];
        };
    }
    return _segmentView;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"正在抢购",@"待抢购",@"待抢购",@"待抢购",@"待抢购",@"待抢购"].mutableCopy;
    }
    return _titleArray;
}


@end
