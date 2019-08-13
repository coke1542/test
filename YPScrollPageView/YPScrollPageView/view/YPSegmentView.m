//
//  YPSegmentView.m
//  YouBuy
//
//  Created by 王艳苹 on 2019/3/12.
//  Copyright © 2019 王艳苹. All rights reserved.
//

#import "YPSegmentView.h"
#import "YPSegmentStyle.h"
#import "YPSegmentItem.h"
#import "UIView+YPExtention.h"

static NSString *const menuCell = @"menuCell";

@interface YPSegmentView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/** item的高度 */
@property (nonatomic,assign) CGFloat itemHeight;
/**collectionView */
@property (nonatomic,strong) UICollectionView *collectionViewBottom;
/**flowLayout */
@property (nonatomic,strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) UIView *lineView;
/** 滚动视图的长度 */
@property (nonatomic,assign) CGFloat segmentViewWidth;
/** itemWidth数组 */
@property (nonatomic,strong) NSMutableArray *itemWidthArray;
/** 下划线长度数组 */
@property (nonatomic,strong) NSMutableArray *UnderlineWidthArray;
/**颜色差值数组*/
@property (nonatomic,strong) NSArray *deltaRGBA;
/**颜色数组*/
@property (nonatomic,strong) NSArray *normalColorRGBA;
/**选中颜色数组*/
@property (nonatomic,strong) NSArray *selectedColorRGBA;
/**即将划过去的标题下标*/
@property (nonatomic,assign) NSInteger oldIndex;
/**即将划过去的标题颜色*/
@property (nonatomic,strong) UIColor *oldColor;
/**即将显示的标题下标*/
@property (nonatomic,assign) NSInteger currentIndex;
/**即将显示的标题颜色*/
@property (nonatomic,strong) UIColor *currentColor;
/**即将划过去标题文字*/
@property (nonatomic,strong) UIFont *oldFont;
/**即将显示的标题文字*/
@property (nonatomic,strong) UIFont *currentFont;
/**是否正在拖动滚动视图*/
@property (nonatomic,assign) BOOL isDragScrollView;

@property (nonatomic,strong) NSMutableSet *indexPathPSet;

@end

@implementation YPSegmentView

#pragma mark ---- 初始化
+ (instancetype)segmentViewWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles{
    YPSegmentView *segmentView = [[YPSegmentView alloc] initWithFrame:frame];
    segmentView.backgroundColor = [UIColor whiteColor];
    segmentView.titles = [titles copy];
    segmentView.segmentViewWidth = frame.size.width;
    return segmentView;
}

- (void)setBackgroundView:(UIView *)backgroundView{
    [_backgroundView removeFromSuperview];
    _backgroundView = backgroundView;
    [self addSubview:_backgroundView];
    [self sendBackgroundToBack];
}

- (void)deleteUnderLineStyleByIndex:(NSInteger)index isDelete:(BOOL)isDelete{
    if (![self.indexPathPSet containsObject:@(index)] && !isDelete) {
        [self.indexPathPSet addObject:@(index)];
        [self.collectionViewBottom reloadData];
    }
    if ([self.indexPathPSet containsObject:@(index)] && isDelete) {
        [self.indexPathPSet removeObject:@(index)];
        [self.collectionViewBottom reloadData];
    }
}

- (void)sendBackgroundToBack{
    if (self.backgroundView) {
        [self sendSubviewToBack:self.backgroundView];
    }
}

- (void)reloadData{
    [self.itemWidthArray removeAllObjects];
    [self.itemWidthArray removeAllObjects];
    UIFont *itemFont = self.segmentStyle.titleTextFont;
    UIFont *underlineFont = self.segmentStyle.titleTextFont;
    if (self.segmentStyle.selectedItemType != YPSelectedItemUnderLine) {//
        itemFont = self.segmentStyle.titleTextFont.pointSize > self.segmentStyle.selectedTitleTextFont.pointSize?self.segmentStyle.titleTextFont:self.segmentStyle.selectedTitleTextFont;
        underlineFont = self.segmentStyle.underlineWidthType == YPUnderLineWidthBySelectedFont?self.segmentStyle.selectedTitleTextFont:self.segmentStyle.titleTextFont;
    }
    for (int i = 0; i < _titles.count; i++) {
        CGFloat itemWidth = self.segmentStyle.itemWidth;
        if (self.segmentStyle.itemWidthType != YPItemWidthFixation) {//根据字体自适应
            itemWidth = [self getSingleWidthByString:_titles[i] withFontSize:itemFont];
        }
        [_itemWidthArray addObject:@(itemWidth)];
        CGFloat lineWidth = self.segmentStyle.lineWidth;
        if (self.segmentStyle.underlineWidthType != YPUnderLineWidthFixation) {//根据字体自适应
            lineWidth = [self getSingleWidthByString:_titles[i] withFontSize:underlineFont];
        }
        [_UnderlineWidthArray addObject:@(lineWidth)];
    }
    [self reload];
}

#pragma mark ---- init
- (void)initialization {
    _itemHeight = self.bounds.size.height;
    _segmentViewWidth = self.bounds.size.width;
    _itemWidthArray = [NSMutableArray array];
    _UnderlineWidthArray = [NSMutableArray array];
}

- (void)setupContentView {
    self.backgroundColor = self.segmentStyle.menuBackgroundColor;
    [self addSubview:self.collectionViewBottom];
    [self sendBackgroundToBack];
}

// 代码初始化
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupContentView];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialization];
        [self setupContentView];
    }
    return self;
}
#pragma mark ---- public method
- (void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex {
    if (oldIndex < 0 || oldIndex >= self.titles.count || currentIndex < 0 ||currentIndex >= self.titles.count) {
        return;
    }
    self.isDragScrollView = YES;
    self.oldIndex = oldIndex;
    self.currentIndex = currentIndex;
    if (self.segmentStyle.isUnderlineGraduallyVaried) {
        CGFloat wDistance = [self.UnderlineWidthArray[currentIndex] integerValue] - [self.UnderlineWidthArray[oldIndex] integerValue];
        CGFloat itemWidth = self.segmentStyle.itemWidth;
        CGFloat lineWidth = self.segmentStyle.lineWidth;
        CGFloat oldX = 0;
        if (self.segmentStyle.itemWidthType != YPItemWidthFixation) {
            itemWidth = [self.itemWidthArray[oldIndex] floatValue] + self.segmentStyle.itemSpace * 2;
            for (int i = 0; i < oldIndex; i++) {
                oldX += itemWidth;
            }
        }else{
            oldX = self.segmentStyle.itemWidth * oldIndex;
        }
        if (self.segmentStyle.underlineWidthType != YPUnderLineWidthFixation) {
            lineWidth = [self.UnderlineWidthArray[oldIndex] floatValue];
        }
        CGFloat lineSpace = self.segmentStyle.itemSpace + (itemWidth - lineWidth) * 0.5;
        oldX += lineSpace;
        CGFloat currentX = 0;
        if (self.segmentStyle.itemWidthType != YPItemWidthFixation) {
            itemWidth = [self.itemWidthArray[currentIndex] floatValue] + self.segmentStyle.itemSpace * 2;
            for (int i = 0; i < currentIndex; i++) {
                currentX += [self.itemWidthArray[i] floatValue] + self.segmentStyle.itemSpace * 2;
            }
        }else{
            currentX = self.segmentStyle.itemWidth * currentIndex;
        }
        if (self.segmentStyle.underlineWidthType != YPUnderLineWidthFixation) {
            lineWidth = [self.UnderlineWidthArray[currentIndex] floatValue];
        }
        lineSpace = self.segmentStyle.itemSpace + (itemWidth - lineWidth) * 0.5;
        currentX += lineSpace;
        CGFloat xDistance = currentX - oldX;
        self.lineView.x = oldX + xDistance * progress;
        self.lineView.width = [self.UnderlineWidthArray[oldIndex] floatValue] + wDistance * progress;
    }
    // 渐变
    if (self.segmentStyle.isColorGraduallyVaried) {
        self.oldColor = [UIColor  colorWithRed:[self.selectedColorRGBA[0] floatValue] + [self.deltaRGBA[0] floatValue] * progress
                                         green:[self.selectedColorRGBA[1] floatValue] + [self.deltaRGBA[1] floatValue] * progress
                                          blue:[self.selectedColorRGBA[2] floatValue] + [self.deltaRGBA[2] floatValue] * progress
                                         alpha:[self.selectedColorRGBA[3] floatValue] + [self.deltaRGBA[3] floatValue] * progress];
        
        self.currentColor = [UIColor  colorWithRed:[self.normalColorRGBA[0] floatValue] - [self.deltaRGBA[0] floatValue] * progress
                                             green:[self.normalColorRGBA[1] floatValue] - [self.deltaRGBA[1] floatValue] * progress
                                              blue:[self.normalColorRGBA[2] floatValue] - [self.deltaRGBA[2] floatValue] * progress
                                             alpha:[self.normalColorRGBA[3] floatValue] - [self.deltaRGBA[3] floatValue] * progress];
        
        [self reload];
    }
}
//结束渐变
- (void)adjustTitleOffSetToCurrent{
    self.isDragScrollView = NO;
    [self reload];
}

#pragma mark ---- life circles
- (void)layoutSubviews {
    [super layoutSubviews];
    self.itemHeight = self.bounds.size.height;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
    self.collectionViewBottom.frame = CGRectMake(0,0, self.segmentViewWidth, self.itemHeight);
    CGFloat sum = [[self.titles valueForKeyPath:@"@sum.floatValue"] floatValue];
    CGFloat contentW = sum;
    CGFloat itemWidth = [self.itemWidthArray.firstObject floatValue];
    if (self.segmentStyle.itemWidthType != YPItemWidthFixation) {
        contentW = sum + self.segmentStyle.itemSpace * 2 * (self.itemWidthArray.count - 1);
        itemWidth = [self.itemWidthArray.firstObject floatValue] + self.segmentStyle.itemSpace * 2;
    }
    self.collectionViewBottom.contentSize = CGSizeMake(contentW, 0);
    if (self.segmentStyle.selectedItemType == YPSelectedItemFontBigger) {//字体变大
        self.lineView.hidden = YES;
    }else{
        self.lineView.hidden = NO;
        CGFloat lineWidth = [self.UnderlineWidthArray.firstObject floatValue];
        CGFloat lineSpace = self.segmentStyle.itemSpace +  (itemWidth - lineWidth) * 0.5;
        self.lineView.frame = CGRectMake(lineSpace, self.itemHeight - self.segmentStyle.lineHeight,lineWidth, self.segmentStyle.lineHeight);
    }
    if (self.selectIndex != 0) {
        [self selectItemAtIndex:self.selectIndex];
    }
}
#pragma makr ----- UIScrollViewDelegate
// 当有滚动的时候就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    [_collectionViewBottom setContentOffset:collectionView.contentOffset];
}

// 当手动拖拽结束后调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == NO) {
        YPSegmentItem *cell = [self getItemWithLocation:_collectionViewBottom.center];
        if (cell) {
            [self refreshContentOffsetItemByIndex:cell.indexPath.row];
            if (_clickIndexBlock) {
                _clickIndexBlock(cell.indexPath.row);
            }
        }
    }
}
// setContentOffset改变 且 滚动动画结束后会 调用
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.collectionViewBottom.userInteractionEnabled = YES;
}
// 获取屏幕中指定点所在的cell
- (YPSegmentItem *)getItemWithLocation:(CGPoint)location {
    CGPoint tableLocation = [self convertPoint:location toView:_collectionViewBottom];
    NSIndexPath *selectedPath = [_collectionViewBottom indexPathForItemAtPoint:tableLocation];
    YPSegmentItem *cell = [_collectionViewBottom dequeueReusableCellWithReuseIdentifier:menuCell forIndexPath:selectedPath];
    return cell;
}

- (void)refreshContentOffsetItemByIndex:(NSInteger)index{
    if (self.itemWidthArray.count > index) {
        self.selectIndex = index;
        CGFloat itemWidth = self.segmentStyle.itemWidth;
        CGFloat itemX = 0;
        if (self.segmentStyle.itemWidthType != YPItemWidthFixation) {
            itemWidth = [self.itemWidthArray[index] floatValue] + self.segmentStyle.itemSpace * 2;
            for (int i = 0; i < index; i++) {
                itemX += [self.itemWidthArray[i] floatValue] + self.segmentStyle.itemSpace * 2;
            }
        }else{
            itemX = self.segmentStyle.itemWidth * index;
        }
        CGFloat width = _collectionViewBottom.bounds.size.width;
        CGSize contentSize = _collectionViewBottom.contentSize;
        CGFloat targetX;
        if ((contentSize.width - itemX) <= width / 2) {
            targetX = contentSize.width - width;
        }else{
            targetX = itemX - width / 2 + self.segmentStyle.itemWidth / 2;
        }
        targetX = targetX > 0 ? targetX : 0;
        [_collectionViewBottom setContentOffset:CGPointMake(targetX, 0) animated:YES];
        if (self.segmentStyle.selectedItemType != YPSelectedItemFontBigger) {
            [UIView animateWithDuration:0.3 animations:^{
                CGFloat lineWidth = self.segmentStyle.lineWidth;
                if (self.segmentStyle.underlineWidthType != YPUnderLineWidthFixation) {
                    lineWidth = [self.UnderlineWidthArray[index] floatValue];
                }
                CGFloat lineSpace = self.segmentStyle.itemSpace + (itemWidth - lineWidth) * 0.5;
                self.lineView.frame = CGRectMake(itemX + lineSpace,self.itemHeight - self.segmentStyle.lineHeight,lineWidth, self.segmentStyle.lineHeight);
            }];
        }
        [self reload];
    }
}
#pragma mark ---- UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YPSegmentItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:menuCell forIndexPath:indexPath];
    NSString *title = self.titles[indexPath.row];
    cell.titleText = title;
    cell.titleLabelHeight = self.segmentStyle.titleTextHeight;
    cell.underLineWidth = [self getSingleWidthByString:cell.titleText withFontSize:self.segmentStyle.titleTextFont];
    cell.isShowUnderLine = NO;
    if (indexPath.row == self.oldIndex && self.segmentStyle.isColorGraduallyVaried && self.isDragScrollView) {
        cell.titleColor = self.oldColor;
    }else if (indexPath.row == self.currentIndex &&self.segmentStyle.isColorGraduallyVaried && self.isDragScrollView) {
        cell.titleColor = self.currentColor;
        if (self.segmentStyle.selectedItemType != YPSelectedItemUnderLine) {
            cell.titleTextFont = self.segmentStyle.selectedTitleTextFont;;
        }
    }else if (indexPath.row == self.selectIndex) {
        cell.titleColor = self.segmentStyle.selectedTitleColor;
        if (self.segmentStyle.selectedItemType != YPSelectedItemUnderLine) {
            cell.titleTextFont = self.segmentStyle.selectedTitleTextFont;;
        }
    }else{
        cell.titleColor = self.segmentStyle.normalTitleColor;
        cell.titleTextFont = self.segmentStyle.titleTextFont;
    }
    if ([self.indexPathPSet containsObject:@(indexPath.row)] && indexPath.row == self.selectIndex) {
        cell.isShowUnderLine = YES;
        cell.titleColor = self.segmentStyle.selectedTitleColor;
        cell.titleTextFont = self.segmentStyle.titleTextFont;
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    YPSegmentItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:menuCell forIndexPath:indexPath];
    if (cell && !self.segmentStyle.isDrag) {
        [self refreshContentOffsetItemByIndex:indexPath.row];
        if (_clickIndexBlock) {
            _clickIndexBlock(indexPath.row);
        }
    }
}
#pragma mark ---- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat itemWidth = self.segmentStyle.itemWidth;
    if (self.segmentStyle.itemWidthType != YPItemWidthFixation && indexPath.row < self.itemWidthArray.count) {
        itemWidth = [_itemWidthArray[indexPath.row] floatValue] + self.segmentStyle.itemSpace * 2;
    }
    return CGSizeMake(itemWidth, self.itemHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,self.segmentStyle.itemSpace, 0,self.segmentStyle.itemSpace);
}
// 两个cell之间的最小间距，是由API自动计算的，只有当间距小于该值时，cell会进行换行
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
// 两行之间的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
#pragma mark ---- private method
// 设置选中指定下标的item
- (void)selectItemAtIndex:(NSInteger)selectIndex {;
    [self refreshContentOffsetItemByIndex:selectIndex];
    if (_clickIndexBlock) {
        _clickIndexBlock(selectIndex);
    }
}

- (void)reload {
    [self.collectionViewBottom reloadData];
}

- (CGFloat)getSingleWidthByString:(NSString *)string withFontSize:(UIFont *)font{
    //1.最大允许绘制的文本范围
    CGSize size = CGSizeMake(MAXFLOAT,ceil(font.lineHeight));
    //2.配置计算时的行截取方法
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:0];
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    //3.计算
    CGFloat width = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.width;
    return width;
}
#pragma mark ---- setter
- (void)setSelectIndex:(NSInteger)selectIndex {
    _selectIndex = selectIndex;
    if (_selectIndex != selectIndex) {
        [self selectItemAtIndex:selectIndex];
    }
}
#pragma mark ---- getter
- (YPSegmentStyle *)segmentStyle{
    if (!_segmentStyle) {
        _segmentStyle = [[YPSegmentStyle alloc]init];
    }
    return _segmentStyle;
}
- (UICollectionView *)collectionViewBottom {
    if (!_collectionViewBottom) {
        _collectionViewBottom = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        [_collectionViewBottom registerClass:[YPSegmentItem class] forCellWithReuseIdentifier:menuCell];
        _collectionViewBottom.backgroundColor = [UIColor clearColor];
        _collectionViewBottom.showsHorizontalScrollIndicator = NO;
        _collectionViewBottom.decelerationRate = 0;
        _collectionViewBottom.delegate = self;
        _collectionViewBottom.dataSource = self;
    }
    return _collectionViewBottom;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0,self.itemHeight - 1,self.segmentStyle.itemWidth,1)];
        _lineView.hidden = YES;
        _lineView.backgroundColor = [UIColor redColor];
        [self.collectionViewBottom addSubview:_lineView];
        [self.collectionViewBottom bringSubviewToFront:self.lineView];
    }
    return _lineView;
}

- (NSMutableSet *)indexPathPSet{
    if (!_indexPathPSet) {
        _indexPathPSet = [NSMutableSet set];
    }
    return _indexPathPSet;
}

- (NSArray *)deltaRGBA {
    if (_deltaRGBA == nil) {
        NSArray *normalColorRgb = self.normalColorRGBA;
        NSArray *selectedColorRgb = self.selectedColorRGBA;
        
        NSArray *delta;
        if (normalColorRgb && selectedColorRgb) {
            CGFloat deltaR = [normalColorRgb[0] floatValue] - [selectedColorRgb[0] floatValue];
            CGFloat deltaG = [normalColorRgb[1] floatValue] - [selectedColorRgb[1] floatValue];
            CGFloat deltaB = [normalColorRgb[2] floatValue] - [selectedColorRgb[2] floatValue];
            CGFloat deltaA = [normalColorRgb[3] floatValue] - [selectedColorRgb[3] floatValue];
            delta = [NSArray arrayWithObjects:@(deltaR), @(deltaG), @(deltaB), @(deltaA), nil];
            _deltaRGBA = delta;
            
        }
    }
    return _deltaRGBA;
}

- (NSArray *)normalColorRGBA {
    if (!_normalColorRGBA) {
        NSArray *normalColorRGBA = [self getColorRGBA:self.segmentStyle.normalTitleColor];
        NSAssert(normalColorRGBA, @"设置普通状态的文字颜色时 请使用RGBA空间的颜色值");
        _normalColorRGBA = normalColorRGBA;
        
    }
    return  _normalColorRGBA;
}

- (NSArray *)selectedColorRGBA {
    if (!_selectedColorRGBA) {
        NSArray *selectedColorRGBA = [self getColorRGBA:self.segmentStyle.selectedTitleColor];
        NSAssert(selectedColorRGBA, @"设置选中状态的文字颜色时 请使用RGBA空间的颜色值");
        _selectedColorRGBA = selectedColorRGBA;
        
    }
    return  _selectedColorRGBA;
}

- (NSArray *)getColorRGBA:(UIColor *)color {
    CGFloat numOfcomponents = CGColorGetNumberOfComponents(color.CGColor);
    NSArray *rgbaComponents;
    if (numOfcomponents == 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        rgbaComponents = [NSArray arrayWithObjects:@(components[0]), @(components[1]), @(components[2]), @(components[3]), nil];
    }
    return rgbaComponents;
    
}

- (void)dealloc {
    _collectionViewBottom.delegate = nil;
}

@end
