//
//  GLScrollView.h
//  GLScrollView
//
//  Created by gulu on 2018/4/14.
//  Copyright © 2018年 gulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLScrollViewDelegate <NSObject>

@optional

/**
 中间图片被点击

 @param index 点击的图片序号
 */
-(void)glScrollViewDidTouchImage:(NSInteger)index;

@end

@interface GLScrollView : UIView

@property (nonatomic, weak) id<GLScrollViewDelegate> delegate;

@property (nonatomic, strong) UIPageControl *pageControl;

/**
 图片数组
 */
@property (nonatomic, strong) NSArray *imageArray;

/**
 图片间隔
 */
@property (nonatomic, assign) CGFloat imageInterval;

/**
 图片上边距
 */
@property (nonatomic, assign) CGFloat topMargin;

/**
 图片下边距
 */
@property (nonatomic, assign) CGFloat bottomMargin;


/**
 图片左边距,左边图片露出屏幕的大小
 */
@property (nonatomic, assign) CGFloat leftMargin;

/**
 图片右边距，右边图片露出屏幕的大小
 */
@property (nonatomic, assign) CGFloat rightMargin;

/**
 图片圆角设置
 */
@property (nonatomic, assign) CGFloat imageViewCornerRadius;

/**
 图片阴影参数设置
 */
@property (nonatomic, assign) CGFloat imageShadowOpacity;

/**
 图片阴影参数设置
 */
@property (nonatomic, assign) CGFloat imageShadowRadius;

/**
 图片阴影参数设置
 */
@property (nonatomic, assign) CGSize imageShadowOffset;

/**
 图片阴影参数设置
 */
@property (nonatomic, strong) UIColor *imageShadowColor;


/**
 自动轮播时间间隔，0为不自动轮播，默认为不自动轮播
 */
@property (nonatomic, assign) double autoSelectPageTime;

@end
