//
//  ViewController.m
//  YJGraphView
//
//  Created by Yang on 2018/12/5.
//  Copyright © 2018 YangJing. All rights reserved.
//

#import "ViewController.h"

#import "YJGraphBrokenLineView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    YJGraphBrokenLineView *brokenLineView = ({
        YJGraphBrokenLineView *view = [[YJGraphBrokenLineView alloc] init];
        view.backgroundColor = [UIColor lightGrayColor];
        view;
    });
    [self.view addSubview:brokenLineView];
    
    brokenLineView.frame = CGRectMake(20, 20, CGRectGetWidth([UIScreen mainScreen].bounds)-40, CGRectGetWidth([UIScreen mainScreen].bounds)/4*3);
    
    [brokenLineView setXAxisItems: @[@"1 月",@"2 月",@"3 月",@"4 月",@"5 月",@"6 月",@"7 月",@"8 月",@"9 月",@"10 月",@"11 月",@"12 月"] autoFitWidth:YES];
    [brokenLineView setYAxisMaxItem:10000 minItem:1000 itemCount:6];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 12; i++) {
        NSInteger num = random()%10000 + random()%1000;
        [dataArray addObject:[NSNumber numberWithInteger:num]];
    }
    [brokenLineView setDataArray:dataArray lineColor:[UIColor greenColor]];
    
    NSMutableArray *dataArray2 = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 12; i++) {
        NSInteger num = random()%10000 + random()%1000;
        [dataArray2 addObject:[NSNumber numberWithInteger:num]];
    }
    [brokenLineView setDataArray:dataArray2 lineColor:[UIColor redColor]];

}


@end
