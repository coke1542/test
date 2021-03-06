//
//  ViewController.m
//  YPScrollPageView
//
//  Created by 王艳苹 on 2019/8/12.
//  Copyright © 2019 王艳苹. All rights reserved.
//

#import "ViewController.h"
#import "YPUniteController.h"
#import "YPPartController.h"
#import "YPColorConfig.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTableView.backgroundColor = [UIColor whiteColor];
}

- (UIView *)setTestViewByFrame:(CGRect)frame{
    UIView *testView = [[UIView alloc]init];
    testView.frame = frame;
    testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:testView];
    return testView;
}
//视觉效果
- (void)setEffect{
    UIView *testView = [self setTestViewByFrame:CGRectMake(200, 100,100, 100)];
    CGFloat effectOffset = 10.f;
    UIInterpolatingMotionEffect *effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    effectX.maximumRelativeValue = @(effectOffset);
    effectX.minimumRelativeValue = @(-effectOffset);
    
    UIInterpolatingMotionEffect *effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    effectY.maximumRelativeValue = @(effectOffset);
    effectY.minimumRelativeValue = @(-effectOffset);
    
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[effectX, effectY];
    
    [testView addMotionEffect:group];
}

- (void)siteBySuperView{
    UIView *testView = [self setTestViewByFrame:CGRectMake(200, 300,100, 100)];
    //    typedef NS_OPTIONS(NSUInteger, UIViewAutoresizing) {
    //        UIViewAutoresizingNone                 = 0,
    //        UIViewAutoresizingFlexibleLeftMargin   = 1 << 0,
    //        UIViewAutoresizingFlexibleWidth        = 1 << 1,
    //        UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
    //        UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
    //        UIViewAutoresizingFlexibleHeight       = 1 << 4,
    //        UIViewAutoresizingFlexibleBottomMargin = 1 << 5
    //    };
    testView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
}

#pragma mark ---- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *titleStr = self.dataArray[indexPath.row];
    if ([titleStr isEqualToString:@"联合使用"]) {//暂时没有登录
        YPUniteController *vc = [[YPUniteController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([titleStr isEqualToString:@"分开使用"]) {//进入小喇叭首页
        YPPartController *vc = [[YPPartController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark ---- UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"联合使用",@"分开使用"].mutableCopy;
    }
    return _dataArray;
}

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
}

@end

