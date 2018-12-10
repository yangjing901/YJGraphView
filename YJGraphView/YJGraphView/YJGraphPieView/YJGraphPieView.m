//
//  YJGraphPieView.m
//  YJGraphView
//
//  Created by Yang on 2018/12/6.
//  Copyright © 2018 YangJing. All rights reserved.
//

#import "YJGraphPieView.h"

@implementation YJGraphPieView

- (void)setDataArray:(NSMutableArray<NSNumber *> *)dataArray {
    
    //check data
    CGFloat totalPersent = 0;

    //将数组按从小到大顺序排序,顺带检测数据，饼状图数据总和不应该超过1
    for (NSInteger i = 0, count = dataArray.count-1; i < count; i++) {
        CGFloat persent0 = [dataArray[i] floatValue];
        totalPersent += persent0;
        if (totalPersent > 1) {
            NSLog(@"yangjing_%@: totalPersent > 1", NSStringFromClass([self class]));
            return;
        }
        
        for (NSInteger j = 0, count = dataArray.count - 1 - i; j < count; j++) {
            CGFloat persent1 = [dataArray[j] floatValue];
            CGFloat persent2 = [dataArray[j+1] floatValue];
            if (persent2 < persent1) {
                [dataArray exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
        }

    }
    
    CGFloat viewWidth = CGRectGetWidth(self.bounds);
    CGFloat viewHeight = CGRectGetHeight(self.bounds);

    //饼图半径
    CGFloat radius = (viewWidth-120)/2;
    //饼图中心
    CGPoint center = CGPointMake(viewWidth/2, viewWidth/2);
    //饼图起始角度
    CGFloat currentAngle = -M_PI/2.0;
    //画图
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
        CGFloat linePointY;
        
        if (centerAngle > -M_PI/2.0 && centerAngle <= 0) {
            targetPointX = center.x + (targetPointX + 5);
            targetPointY = center.y - (targetPointY + 5);
            
            linePointY = descHeight*(i+1);
            [path2 moveToPoint:CGPointMake(targetPointX, targetPointY)];
            [path2 addLineToPoint:CGPointMake(viewWidth-40, linePointY)];
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
            
            linePointY = descHeight*(i+1)+center.y;
            [path2 moveToPoint:CGPointMake(targetPointX, targetPointY)];
            [path2 addLineToPoint:CGPointMake(viewWidth-40, linePointY)];
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
            
        } else if (centerAngle > M_PI/2.0 && centerAngle <= M_PI) {
            targetPointX = center.x - (targetPointX + 5);
            targetPointY = center.y + (targetPointY + 5);
            
            linePointY = descHeight*(i+1)+center.y;
            [path2 moveToPoint:CGPointMake(targetPointX, targetPointY)];
            [path2 addLineToPoint:CGPointMake(40, linePointY)];
            [path2 addLineToPoint:CGPointMake(0, linePointY)];
            
            UILabel *itemLabel = ({
                UILabel *label = [[UILabel alloc] init];
                label.font = [UIFont systemFontOfSize:10];
                label.textColor = fillColor;
                label.textAlignment = NSTextAlignmentLeft;
                label.adjustsFontSizeToFitWidth = YES;
                label.text = [NSString stringWithFormat:@"%.0f%%", persent*100];
                label;
            });
            [self addSubview:itemLabel];
            itemLabel.frame = CGRectMake(0, linePointY-[UIFont systemFontOfSize:6].lineHeight-3, 60, [UIFont systemFontOfSize:6].lineHeight);
            
        } else {
            targetPointX = center.x - (targetPointX + 5);
            targetPointY = center.y - (targetPointY + 5);
            
            linePointY = descHeight*(i+1);
            [path2 moveToPoint:CGPointMake(targetPointX, targetPointY)];
            [path2 addLineToPoint:CGPointMake(40, linePointY)];
            [path2 addLineToPoint:CGPointMake(0, linePointY)];
            
            UILabel *itemLabel = ({
                UILabel *label = [[UILabel alloc] init];
                label.font = [UIFont systemFontOfSize:10];
                label.textColor = fillColor;
                label.textAlignment = NSTextAlignmentLeft;
                label.adjustsFontSizeToFitWidth = YES;
                label.text = [NSString stringWithFormat:@"%.0f%%", persent*100];
                label;
            });
            [self addSubview:itemLabel];
            itemLabel.frame = CGRectMake(0, linePointY-[UIFont systemFontOfSize:6].lineHeight-3, 60, [UIFont systemFontOfSize:6].lineHeight);
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
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:viewWidth/2 startAngle:-M_PI/2.0 endAngle:2*M_PI-M_PI/2.0 clockwise:YES];

    //画圆
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    shapeLayer.strokeColor = self.backgroundColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = viewWidth;
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;

    //设置动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 3;
    pathAnimation.repeatCount = 1;
    pathAnimation.removedOnCompletion = YES;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}

@end
