//
//  YJGraphPieView.h
//  YJGraphView
//
//  Created by Yang on 2018/12/6.
//  Copyright © 2018 YangJing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJGraphPieView : UIView
/**
 *  设置数据源 （数据源数量应与横轴坐标数对应）
 *  dataArray : 数据源
 *  lineColor : 条形颜色
 */
- (void)setDataArray:(NSArray<NSNumber *> *)dataArray;

@end

NS_ASSUME_NONNULL_END
