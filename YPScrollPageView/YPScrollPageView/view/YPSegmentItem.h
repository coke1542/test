//
//  YPSegmentItem.h
//  YouBuy
//
//  Created by 王艳苹 on 2019/3/12.
//  Copyright © 2019 王艳苹. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface YPSegmentItem : UICollectionViewCell

/** 标题内容 */
@property (nonatomic,copy) NSString  *titleText;
/** 标题文字颜色 */
@property (nonatomic,strong) UIColor *titleColor;
/** 标题文字字体 */
@property (nonatomic,strong) UIFont  *titleTextFont;
/** 标题label的高度 */
@property (nonatomic,assign) CGFloat titleLabelHeight;
/** indexPath */
@property (nonatomic,strong) NSIndexPath *indexPath;
/** 是否显示文字下划线 */
@property (nonatomic,assign) BOOL isShowUnderLine;
/** 文字下划线的颜色 */
@property (nonatomic,assign) CGFloat underLineWidth;

@end
