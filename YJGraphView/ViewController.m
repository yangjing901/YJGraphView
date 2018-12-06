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
#import "YJGraphPieView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    YJGraphPieView *pieView = ({
        YJGraphPieView *view = [[YJGraphPieView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view;
    });
    [self.view addSubview:pieView];
    
    pieView.frame = CGRectMake(20, 20, CGRectGetWidth([UIScreen mainScreen].bounds)-40, CGRectGetWidth([UIScreen mainScreen].bounds)-40);
    
    [pieView setDataArray:@[@(0.25), @(0.25), @(0.25), @(0.25)]];
}


@end
