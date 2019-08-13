//
//  YPHeader.h
//  YPPageView
//
//  Created by 王艳苹 on 2019/7/17.
//  Copyright © 2019 王艳苹. All rights reserved.
//

#ifndef YPHeader_h
#define YPHeader_h

#import "UIView+YPExtention.h"

/** RGB颜色 */
#define YPColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define YPColorAlpha(r,g,b,alp) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(alp)]
//随机色
#define YPRandomColor [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1]

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
///状态栏高
#define StatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)
#define StatusBarAndNavigationBarHeight (StatusBarHeight + 44.f)
#define WEAKSELF      __weak typeof(self) weakSelf = self;

#endif /* YPHeader_h */
