//
//  ViewController.m
//  YJGraphView
//
//  Created by Yang on 2018/12/5.
//  Copyright © 2018 YangJing. All rights reserved.
//

#import "ViewController.h"

#import "YJGraphBrokenLineView.h"
#import "YJGraphBarView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    YJGraphBarView *barView = ({
        YJGraphBarView *view = [[YJGraphBarView alloc] init];
        view.backgroundColor = [UIColor lightGrayColor];
        view;
    });
    [self.view addSubview:barView];
    
    barView.frame = CGRectMake(20, 20, CGRectGetWidth([UIScreen mainScreen].bounds)-40, CGRectGetWidth([UIScreen mainScreen].bounds)/4*3);
    
    [barView setXAxisItems: @[@"1 月",@"2 月",@"3 月",@"4 月",@"5 月",@"6 月",@"7 月",@"8 月",@"9 月",@"10 月",@"11 月",@"12 月"] autoFitWidth:NO];
    [barView setYAxisMaxItem:10000 minItem:1000 itemCount:6];

    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 12; i++) {
        NSInteger num = random()%10000 + random()%1000;
        [dataArray addObject:[NSNumber numberWithInteger:num]];
    }
    [barView setDataArray:dataArray lineColor:[UIColor greenColor]];
}


@end
