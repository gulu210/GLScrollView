//
//  GLScrollView.m
//  GLScrollView
//
//  Created by gulu on 2018/4/14.
//  Copyright © 2018年 gulu. All rights reserved.
//

#import "GLScrollView.h"

@interface GLScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSMutableArray *shadowViews;

@property (nonatomic, assign) CGFloat startContentOffsetX;
@property (nonatomic, assign) CGFloat willEndContentOffsetX;
@property (nonatomic, assign) CGFloat endContentOffsetX;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GLScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initTimerFunction];
    }
    return self;
}

- (void)layoutSubviews {
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        return self.scrollView;
    }
    return nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self changeShadowAlaph];
}

//当滑动开始的时候 ，停止计数器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //取消定时器任务
    [self.timer invalidate];
}
//当滑动停止时启动定时器任务
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.timer fire];
    //设置自动滚动定时任务
    [self initTimerFunction];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //获取当前scrollview 的X轴方向的 偏移量
    CGFloat offset = self.scrollView.contentOffset.x;
    //每个图片页面的宽度
    CGFloat pageWi = self.frame.size.width - self.leftMargin - self.rightMargin;
    //设置当前的显示位置
    self.pageControl.currentPage = offset/pageWi;
}

#pragma mark -

- (void)handleSingleTap:(UITapGestureRecognizer*)sender {
    CGPoint point = [sender locationInView:self.scrollView];
    NSInteger index = point.x / self.scrollView.frame.size.width;
    if (index != self.pageControl.currentPage) {
        [self selectPage:index];
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(glScrollViewDidTouchImage:)]) {
            [self.delegate glScrollViewDidTouchImage:index];
        }
    }
}

#pragma mark - private methods

-(void)initTimerFunction{
    if (self.autoSelectPageTime == 0) {
        return;
    }
    //创建计时器
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoSelectPageTime target:self selector:@selector(autoSelectPage) userInfo:nil repeats:YES];
    NSRunLoop *mainLoop = [NSRunLoop mainRunLoop];
    
    [mainLoop addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.timer = timer;
}

- (void)addImageViews {
    for (int i = 0; i < self.imageArray.count; i ++) {
        UIView *shadowView = [[UIView alloc] init];
        shadowView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:shadowView];
        [self.shadowViews addObject:shadowView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.imageArray[i]];
        [self.scrollView addSubview:imageView];
        [self.imageViews addObject:imageView];
    }
    
    [self changeImageViewsFrame];
    [self setImageShadow];
    [self changeShadowAlaph];
}

- (void)changeImageViewsFrame {
    CGFloat imageW = self.scrollView.frame.size.width - self.imageInterval;
    CGFloat imageH = self.scrollView.frame.size.height;
    for (int i = 0; i < self.imageViews.count; i ++) {
        UIImageView *imageView = self.imageViews[i];
        UIView *shadowView  = self.shadowViews[i];
        imageView.frame = CGRectMake(self.imageInterval / 2 + self.imageInterval * i + imageW * i, 0, imageW, imageH);
        shadowView.frame = CGRectMake(self.imageInterval / 2 + self.imageInterval * i + imageW * i, 0, imageW, imageH);
        shadowView.layer.cornerRadius = _imageViewCornerRadius;
        imageView.layer.cornerRadius = _imageViewCornerRadius;
        imageView.layer.masksToBounds = YES;
    }
    self.scrollView.contentSize = CGSizeMake((imageW + self.imageInterval) * self.imageViews.count, 0);
}

- (void)selectPage:(NSInteger)index {
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = (self.frame.size.width - self.leftMargin - self.rightMargin) * index;
    [self.scrollView setContentOffset:offset animated:YES];
    self.pageControl.currentPage = index;
}

- (void)autoSelectPage {
    //取出当前的偏移量
    CGPoint offset =  self.scrollView.contentOffset;
    //取出当前的设置显示 的page指示
    NSInteger  currentPage = self.pageControl.currentPage;
    
    if (currentPage == self.imageArray.count - 1) {
        //设置为初始值
        currentPage = 0;
        offset = CGPointZero;
        //更新offset
        [self.scrollView setContentOffset:offset animated:YES];
    }else{
        currentPage++;
        offset.x += self.frame.size.width - self.leftMargin - self.rightMargin;
        //更新offset
        [self.scrollView setContentOffset:offset animated:YES];
    }
    //更新pageControl显示
    self.pageControl.currentPage = currentPage;
}

- (void)setImageShadow {
    for (UIView *shadowView in self.shadowViews) {
        shadowView.layer.shadowColor = self.imageShadowColor.CGColor;
        shadowView.layer.shadowOffset = self.imageShadowOffset;
        shadowView.layer.shadowOpacity = self.imageShadowOpacity;
        shadowView.layer.shadowRadius = self.imageShadowRadius;
    }
}

- (void)changeShadowAlaph {
    CGFloat scrollOffSetX = self.scrollView.contentOffset.x;
    
    CGFloat w = self.frame.size.width - self.leftMargin - self.rightMargin;
    for (int i = 0; i < self.shadowViews.count; i ++) {
        UIView *shadowView = self.shadowViews[i];
        shadowView.alpha = 1 - (fabs(scrollOffSetX - w * i)) / w;
    }
}

#pragma mark - getters and setters

- (UIScrollView*)scrollView {
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.leftMargin, 0, self.bounds.size.width - self.leftMargin - self.rightMargin, self.bounds.size.height)];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.clipsToBounds = NO;
        self.scrollView.delegate = self;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self.scrollView addGestureRecognizer:singleTap];
    }
    return _scrollView;
}

- (UIPageControl*)pageControl {
    if (_pageControl == nil) {
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 30, self.frame.size.width, 30)];
    }
    return _pageControl;
}

- (void)setImageArray:(NSArray *)imageArray {
    if (_imageArray != imageArray) {
        _imageArray = imageArray;
        self.pageControl.numberOfPages = imageArray.count;
        [self addImageViews];
    }
}

- (void)setAutoSelectPageTime:(double)autoSelectPageTime {
    _autoSelectPageTime = autoSelectPageTime;
    [self.timer invalidate];
    [self initTimerFunction];
}

- (NSMutableArray*)imageViews {
    if (_imageViews == nil) {
        self.imageViews = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return _imageViews;
}

- (NSMutableArray*)shadowViews {
    if (_shadowViews == nil) {
        self.shadowViews = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return _shadowViews;
}

- (void)setImageInterval:(CGFloat)imageInterval {
    _imageInterval = imageInterval;
    [self changeImageViewsFrame];
}

- (void)setBottomMargin:(CGFloat)bottomMargin {
    _bottomMargin = bottomMargin;
    self.scrollView.frame = CGRectMake(self.leftMargin, self.topMargin, self.bounds.size.width - self.leftMargin - self.rightMargin, self.bounds.size.height - self.topMargin - self.bottomMargin);
}

- (void)setTopMargin:(CGFloat)topMargin {
    _topMargin = topMargin;
    self.scrollView.frame = CGRectMake(self.leftMargin, self.topMargin, self.bounds.size.width - self.leftMargin - self.rightMargin, self.bounds.size.height - self.topMargin - self.bottomMargin);
}

- (void)setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
    if (self.rightMargin == 0) {
        _rightMargin = leftMargin;
    }
    self.scrollView.frame = CGRectMake(self.leftMargin, self.topMargin, self.bounds.size.width - self.leftMargin - self.rightMargin, self.bounds.size.height - self.topMargin - self.bottomMargin);
}

- (void)setRightMargin:(CGFloat)rightMargin {
    _rightMargin = rightMargin;
    if (self.leftMargin == 0) {
        _leftMargin = rightMargin;
    }
    self.scrollView.frame = CGRectMake(self.leftMargin, self.topMargin, self.bounds.size.width - self.leftMargin - self.rightMargin, self.bounds.size.height - self.topMargin - self.bottomMargin);
}

- (void)setImageViewCornerRadius:(CGFloat)imageViewCornerRadius {
    _imageViewCornerRadius = imageViewCornerRadius;
    for (UIImageView *imageView in self.imageViews) {
        imageView.layer.cornerRadius = _imageViewCornerRadius;
        imageView.layer.masksToBounds = YES;
    }
}

- (void)setImageShadowColor:(UIColor *)imageShadowColor {
    if (_imageShadowColor != imageShadowColor) {
        _imageShadowColor = imageShadowColor;
        [self setImageShadow];
    }
}

- (void)setImageShadowOffset:(CGSize)imageShadowOffset {
    _imageShadowOffset = imageShadowOffset;
    [self setImageShadow];
}

- (void)setImageShadowRadius:(CGFloat)imageShadowRadius {
    _imageShadowRadius = imageShadowRadius;
    [self setImageShadow];
}

- (void)setImageShadowOpacity:(CGFloat)imageShadowOpacity {
    _imageShadowOpacity = imageShadowOpacity;
    [self setImageShadow];
}

@end
