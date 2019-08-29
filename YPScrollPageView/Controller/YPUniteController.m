//
//  YPUniteController.m
//  YPPageView
//
//  Created by 王艳苹 on 2019/8/7.
//  Copyright © 2019 王艳苹. All rights reserved.
//

#import "YPUniteController.h"
#import "YPSubUniteController.h"

#import "YPFrameConfig.h"

#import "YPSegmentStyle.h"
#import "YPScrollPageView.h"
#import "YPScrollPageViewDelegate.h"

@interface YPUniteController ()<YPScrollPageViewDelegate>

@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) YPScrollPageView *pageView;

@end

@implementation YPUniteController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.pageView reloadWithNewTitles:self.titleArray];
}

- (NSInteger)numberOfChildViewControllers{
    return self.titleArray.count;
}

- (UIViewController *)childViewController:(UIViewController *)reuseViewController forIndex:(NSInteger)index{
    YPSubUniteController *vc = [[YPSubUniteController alloc]init];
    return vc;
}

- (YPScrollPageView *)pageView{
    if (!_pageView) {
        YPSegmentStyle *style = [[YPSegmentStyle alloc]init];
        style.selectedItemType = YPSelectedItemFontBigger;
        style.itemWidthType = YPItemWidthAdaptionByFont;
        _pageView = [[YPScrollPageView alloc]initWithFrame:CGRectMake(0,__kNavigationBarHeight__, __kScreenWidth__, __kScreenHeight__ - __kNavigationBarHeight__) segmentStyle:style titles:self.titleArray parentViewController:self delegate:self];
        [self.view addSubview:_pageView];
    }
    return _pageView;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"正在抢购",@"待抢购",@"待抢购",@"待抢购",@"待抢购",@"待抢购"].mutableCopy;
    }
    return _titleArray;
}

@end
