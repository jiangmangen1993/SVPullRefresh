//
//  TBURefreshView.m
//  SVPullToRefreshDemo
//
//  Created by ShenXing on 2017/5/9.
//  Copyright © 2017年 Home. All rights reserved.
//

#import "TBURefreshView.h"

@implementation CircleProgressLayer

- (void)drawInContext:(CGContextRef)ctx {
    CGFloat radius = self.bounds.size.width / 2;
    CGFloat lineWidth = 1.0;
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius - lineWidth / 2 startAngle: - M_PI/2 + 0.1f endAngle:M_PI * 3.f / 2.f * self.progress  - 0.2f clockwise:YES];
    CGContextSetRGBStrokeColor(ctx, 0.6, 0.6, 0.6, 1.0);
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextAddPath(ctx, path.CGPath);
    CGContextStrokePath(ctx);
}

- (instancetype)initWithLayer:(CircleProgressLayer *)layer {
    if (self = [super initWithLayer:layer]) {
        self.progress = layer.progress;
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"progress"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

@end


@interface TBURefreshView ()<CAAnimationDelegate>
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) SVPullToRefreshState state;

@property (nonatomic, strong) CircleProgressLayer *circleProgressLayer;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation TBURefreshView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self.layer addSublayer:self.circleProgressLayer];
        
        [self addSubview:self.arrowImageView];
        [self addSubview:self.statusLabel];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#define HEARD_H 60.0f

#pragma mark - CustomRefreshViewDelegate
- (void)updateProgress:(CGFloat)progress forState:(SVPullToRefreshState)state{
//    NSLog(@"progress %.2f ",progress);
//    NSLog(@"state %lu", (unsigned long)state);

    if(fabs(progress - _progress) < 0.0001 && state == _state){
        
    }
    else{
//        NSLog(@"do real loading ..... view");
        if(state == SVPullToRefreshStateTriggered && self.state == SVPullToRefreshStateStopped){
            _statusLabel.text = @"释放即可刷新...";
        }
        else if(state == SVPullToRefreshStateLoading && self.state == SVPullToRefreshStateTriggered){
            _statusLabel.text = @"加载中...";
            //箭头动画 - fade out消失
            [self imageViewAnimationShow:NO];
            //弧度 - 开始转圈
            [self circlLayerAnimationRotate:YES];
        }
        else if(state == SVPullToRefreshStateStopped && self.state == SVPullToRefreshStateLoading){
            //箭头动画 - fade in显示
            [self imageViewAnimationShow:YES];
            //弧度 转圈停止 归0
            [self circlLayerAnimationRotate:NO];
        }
        
        self.progress = progress;
        self.state = state;
        
        if (self.state == SVPullToRefreshStateStopped){
            _statusLabel.text = @"下拉即可刷新...";
        }
    }
}

#pragma mark - private
- (void)imageViewAnimationShow:(BOOL)bShow{
    //to do...
    _arrowImageView.hidden = !bShow;
}

- (void)circlLayerAnimationRotate:(BOOL)bRotate{
    //to do...
    if (bRotate) {
        // 旋转动画
        CABasicAnimation * rotaion = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotaion.duration = 1;
        rotaion.removedOnCompletion = NO;
        rotaion.fillMode = kCAFillModeForwards;
        rotaion.repeatCount = 100;
        rotaion.toValue = [NSNumber numberWithFloat:M_PI*2];
        [_circleProgressLayer addAnimation:rotaion forKey:@"rotationAnimation"];
    }
    else{
        [_circleProgressLayer removeAnimationForKey:@"rotationAnimation"];
    }
}

#pragma mark - setter & getter

- (void)setProgress:(CGFloat)progress {
    CABasicAnimation * ani = [CABasicAnimation animationWithKeyPath:@"progress"];
    ani.duration = 5.0 * fabs(progress - _progress);
    ani.toValue = @(progress);
    ani.removedOnCompletion = YES;
    ani.fillMode = kCAFillModeForwards;
    ani.delegate = self;
    [self.circleProgressLayer addAnimation:ani forKey:@"progressAni"];
    
    _progress = progress;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.circleProgressLayer.progress = self.progress;
}

- (UILabel *)statusLabel{
    if (!_statusLabel){
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.frame.size.width - 20 - 30, 20)];
        _statusLabel.font = [UIFont systemFontOfSize:10];
        _statusLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _statusLabel;
}
#define CIRCLE_WH 30.0f
- (UIImageView *)arrowImageView{
    if (!_arrowImageView){
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(1,1,18,18)];
        _arrowImageView.image = [UIImage imageNamed:@"pull_arrow"];
        _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
        _arrowImageView.clipsToBounds = YES;
    }
    return _arrowImageView;
}

- (CircleProgressLayer *)circleProgressLayer{
    if(!_circleProgressLayer){
        _circleProgressLayer = [CircleProgressLayer layer];
        _circleProgressLayer.frame = CGRectMake(0, 0, 20, 20);
        _circleProgressLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _circleProgressLayer;
}

@end
