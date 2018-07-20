//
//  TBURefreshView.h
//  SVPullToRefreshDemo
//
//  Created by ShenXing on 2017/5/9.
//  Copyright © 2017年 Home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"

@interface CircleProgressLayer : CALayer
@property (nonatomic, assign) CGFloat progress;
@end

@interface TBURefreshView : UIView <CustomRefreshViewDelegate>

@end
