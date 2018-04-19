# GLScrollView
图片轮播控件，可以用作APP首页的广告展示，商品图片展示等。你可以自己设置图片的边距，图片阴影，圆角等。

# 效果图
[![](/ScreenShot.png)]

# 安装
## 使用CocoaPods安装
```
pod 'GLScrollView', '~> 0.0.1'
```
## 直接下载源码安装
下载源码后，把GLScrollView文件夹拖入项目中即可。
# 如何使用
```Objective-c
#import "GLScrollView.h"
...
GLScrollView *glScrollView = [[GLScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 166)];
glScrollView.imageInterval = 16;                //设置图片间距
glScrollView.leftMargin = 24;                   //设置左边图片露出屏幕的距离
glScrollView.topMargin = 14;                    //设置顶部边距
glScrollView.bottomMargin = 17;                 //设置底部边距
glScrollView.imageViewCornerRadius = 6;         //图片圆角
glScrollView.autoSelectPageTime = 0;            //图片自动轮播的时间，0表示不自动轮播，不设置默认为不自动轮播

//设置pageControl
glScrollView.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.97 green:0.83 blue:0.18 alpha:1.00];
glScrollView.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.00];
glScrollView.pageControl.frame = CGRectMake(0, glScrollView.frame.size.height - 14, glScrollView.frame.size.width, 14);

//设置要显示的图片数组
glScrollView.imageArray = @[[UIImage imageNamed:@"1.png"], [UIImage imageNamed:@"2.png"], [UIImage imageNamed:@"3.png"], [UIImage imageNamed:@"4.png"]];
    
//设置图片阴影
glScrollView.imageShadowOffset = CGSizeMake(2, 5);
glScrollView.imageShadowOpacity = 0.5;
glScrollView.imageShadowRadius = 5;

//设置代理
glScrollView.delegate = self;
    
[self.view addSubview:glScrollView];
```

```Objective-c
//代理方法，当点击中间图片时候回调，index为点击的图片序号，序号从0开始记
- (void)glScrollViewDidTouchImage:(NSInteger)index {
    NSLog(@"%ld", (long)index);
}
```
