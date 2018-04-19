//
//  ViewController.m
//  GLScrollView
//
//  Created by gulu on 2018/4/14.
//  Copyright © 2018年 gulu. All rights reserved.
//

#import "ViewController.h"
#import "GLScrollView.h"

@interface ViewController ()<GLScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLScrollView *glScrollView = [[GLScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 166)];
    glScrollView.imageInterval = 16;
    glScrollView.leftMargin = 24;
    glScrollView.topMargin = 14;
    glScrollView.bottomMargin = 17;
    glScrollView.imageViewCornerRadius = 6;
    glScrollView.autoSelectPageTime = 0;
    glScrollView.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.97 green:0.83 blue:0.18 alpha:1.00];
    glScrollView.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
    glScrollView.pageControl.frame = CGRectMake(0, glScrollView.frame.size.height - 14, glScrollView.frame.size.width, 14);
    glScrollView.imageArray = @[[UIImage imageNamed:@"1.png"], [UIImage imageNamed:@"2.png"], [UIImage imageNamed:@"3.png"], [UIImage imageNamed:@"4.png"]];
    
    glScrollView.imageShadowOffset = CGSizeMake(2, 5);
    glScrollView.imageShadowOpacity = 0.5;
    glScrollView.imageShadowRadius = 5;
    glScrollView.delegate = self;
    
    [self.view addSubview:glScrollView];
}

- (void)glScrollViewDidTouchImage:(NSInteger)index {
    NSLog(@"%ld", (long)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
