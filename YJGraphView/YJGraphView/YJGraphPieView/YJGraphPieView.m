//
//  YJGraphPieView.m
//  YJGraphView
//
//  Created by Yang on 2018/12/6.
//  Copyright © 2018 YangJing. All rights reserved.
//

#import "YJGraphPieView.h"

@implementation YJGraphPieView

- (void)setDataArray:(NSArray<NSNumber *> *)dataArray {
    
    //check data
    CGFloat totalPersent = 0;

    for (NSInteger i = 0, count = dataArray.count-1; i < count; i++) {
        CGFloat persent1 = [dataArray[i] floatValue];
        for (NSInteger j = 1, count = dataArray.count; i < count; i++) {
            CGFloat persent2 = [dataArray[j] floatValue];
        
        }

    }
    
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.bounds);

    CGFloat radius = (viewWidth-120)/2;
    CGPoint center = CGPointMake(viewWidth/2, viewWidth/2);
    
    CGFloat currentAngle = -M_PI/2.0;

    for (NSInteger i = 0, count = dataArray.count; i < count; i++) {
        
        CGFloat persent = [dataArray[i] floatValue];
        CGFloat startAngle = currentAngle;
        CGFloat endAngle = currentAngle + 2*M_PI*persent;
        currentAngle = endAngle;
        
        //画扇形
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:center];
        [path addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        //随机颜色
        UIColor *fillColor = [UIColor colorWithRed:(float)(arc4random()%100)/100 green:(float)(arc4random()%100)/100 blue:(float)(arc4random()%100)/100 alpha:1];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer new];
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        shapeLayer.fillColor = fillColor.CGColor;
        shapeLayer.path = path.CGPath;
        [self.layer addSublayer:shapeLayer];
        
        //标注
        CGFloat centerAngle = (endAngle-startAngle)/2+startAngle;
        
        CGFloat targetPointX = fabs(sqrt((radius*radius)/(1+tan(centerAngle)*tan(centerAngle))));
        CGFloat targetPointY = fabs(tan(centerAngle)*targetPointX);
        
        //画标注线
        UIBezierPath *path2 = [UIBezierPath bezierPath];
        
        CGFloat descHeight = [UIFont systemFontOfSize:10].lineHeight+10;
        
        if (centerAngle > -M_PI/2.0 && centerAngle <= 0) {
            targetPointX = center.x + (targetPointX + 5);
            targetPointY = center.y - (targetPointY + 5);
            
            CGFloat linePointY = descHeight*(i+1);
            CGFloat linePointX = center.x + fabs((center.y-linePointY)/tan(centerAngle));

            [path2 moveToPoint:CGPointMake(targetPointX, targetPointY)];
            [path2 addLineToPoint:CGPointMake(linePointX, linePointY)];
            [path2 addLineToPoint:CGPointMake(viewWidth, linePointY)];
            
            UILabel *itemLabel = ({
                UILabel *label = [[UILabel alloc] init];
                label.font = [UIFont systemFontOfSize:10];
                label.textColor = fillColor;
                label.textAlignment = NSTextAlignmentRight;
                label.adjustsFontSizeToFitWidth = YES;
                label.text = [NSString stringWithFormat:@"%.0f%%", persent*100];
                label;
            });
            [self addSubview:itemLabel];
            itemLabel.frame = CGRectMake(viewWidth-60, linePointY-[UIFont systemFontOfSize:6].lineHeight-3, 60, [UIFont systemFontOfSize:6].lineHeight);

        } else if (centerAngle > 0 && centerAngle <= M_PI/2.0) {
            targetPointX = center.x + (targetPointX + 5);
            targetPointY = center.y + (targetPointY + 5);
            
            CGFloat linePointY = descHeight*(i+1)+center.y;
            CGFloat linePointX = center.x + fabs((linePointY-center.y)/tan(centerAngle));
            
            [path2 moveToPoint:CGPointMake(targetPointX, targetPointY)];
            [path2 addLineToPoint:CGPointMake(linePointX, linePointY)];
            [path2 addLineToPoint:CGPointMake(viewWidth, linePointY)];
            
            UILabel *itemLabel = ({
                UILabel *label = [[UILabel alloc] init];
                label.font = [UIFont systemFontOfSize:10];
                label.textColor = fillColor;
                label.textAlignment = NSTextAlignmentRight;
                label.text = [NSString stringWithFormat:@"%.0f%%", persent*100];
                label.adjustsFontSizeToFitWidth = YES;
                label;
            });
            [self addSubview:itemLabel];
            itemLabel.frame = CGRectMake(viewWidth-60, linePointY-[UIFont systemFontOfSize:6].lineHeight-3, 60, [UIFont systemFontOfSize:6].lineHeight);
            
        } else if (centerAngle > M_PI/2.0 && centerAngle <= M_PI) {
            targetPointX = center.x - (targetPointX + 5);
            targetPointY = center.y + (targetPointY + 5);
            
            CGFloat linePointY = viewHeight/(count*2)*(i+1);
            CGFloat linePointX = center.x + fabs((center.y-linePointY)/tan(centerAngle));
            
            [path2 moveToPoint:CGPointMake(targetPointX, targetPointY)];
            [path2 addLineToPoint:CGPointMake(linePointX, linePointY)];
            [path2 addLineToPoint:CGPointMake(viewWidth, linePointY)];
            
        } else {
            targetPointX = center.x - (targetPointX + 5);
            targetPointY = center.y - (targetPointY + 5);
            
            CGFloat linePointY = viewHeight/(count*2)*(i+1);
            CGFloat linePointX = center.x + fabs((center.y-linePointY)/tan(centerAngle));
            
            [path2 moveToPoint:CGPointMake(targetPointX, targetPointY)];
            [path2 addLineToPoint:CGPointMake(linePointX, linePointY)];
            [path2 addLineToPoint:CGPointMake(viewWidth, linePointY)];
        }
        
        UIView *pointView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = fillColor;
            view.layer.cornerRadius = 2;
            view;
        });
        [self addSubview:pointView];
        pointView.frame = CGRectMake(0, 0, 4, 4);
        pointView.center = CGPointMake(targetPointX, targetPointY);
        
        CAShapeLayer *shapeLayer2 = [CAShapeLayer new];
        shapeLayer2.strokeColor = fillColor.CGColor;
        shapeLayer2.fillColor = [UIColor clearColor].CGColor;
        shapeLayer2.path = path2.CGPath;
        shapeLayer2.lineWidth = 1;
        [self.layer addSublayer:shapeLayer2];
        
    }
    
    if (currentAngle < 2*M_PI-M_PI/2.0) {
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(viewWidth/2, viewWidth/2)];
        [path addArcWithCenter:CGPointMake(viewWidth/2, viewWidth/2) radius:radius startAngle:currentAngle endAngle:2*M_PI-M_PI/2.0 clockwise:YES];
        
        //画圆
        UIColor *fillColor = [UIColor colorWithRed:(float)(arc4random()%100)/100 green:(float)(arc4random()%100)/100 blue:(float)(arc4random()%100)/100 alpha:1];
        CAShapeLayer *shapeLayer = [CAShapeLayer new];
        shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        shapeLayer.fillColor = fillColor.CGColor;
        shapeLayer.path = path.CGPath;
        [self.layer addSublayer:shapeLayer];
    }
    
//    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(viewWidth/2, viewWidth/2) radius:viewWidth/2 startAngle:-M_PI/2.0 endAngle:2*M_PI-M_PI/2.0 clockwise:YES];
//
//    //画圆
//    CAShapeLayer *shapeLayer = [CAShapeLayer new];
//    shapeLayer.strokeColor = self.backgroundColor.CGColor;
//    shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    shapeLayer.lineWidth = viewWidth/2;
//    shapeLayer.path = path.CGPath;
//    self.layer.mask = shapeLayer;
//
//    //设置动画
//    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimation.duration = 3;
//    pathAnimation.repeatCount = 1;
//    pathAnimation.removedOnCompletion = YES;
//    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
//    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
//    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

@end
