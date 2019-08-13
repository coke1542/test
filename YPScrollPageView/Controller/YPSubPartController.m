//
//  YPSubPartController.m
//  YPPageView
//
//  Created by 王艳苹 on 2019/8/7.
//  Copyright © 2019 王艳苹. All rights reserved.
//

#import "YPSubPartController.h"
#import "YPPartController.h"

#import "YPHeader.h"

@interface YPSubPartController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation YPSubPartController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainTableView.backgroundColor = [UIColor whiteColor];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    YPPartController *parentVC = (YPPartController *)self.parentViewController;
    CGFloat scrollOffset = scrollView.contentOffset.y;
    parentVC.isDeleteUnderlineStyle = scrollOffset < 10;
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
        _dataArray = @[@"第一行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行",@"其他行"].mutableCopy;
    }
    return _dataArray;
}

- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.width, self.view.height - StatusBarHeight - 50) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_mainTableView];
    }
    return _mainTableView;
}

@end
