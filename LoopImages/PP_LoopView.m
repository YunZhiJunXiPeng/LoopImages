//
//  LoopView.m
//  LoopImages
//
//  Created by 小超人 on 16/9/23.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//

#import "PP_LoopView.h"
#import "PP_LoadImageManagar.h"
/**  宏定义 */
#define kScreenH self.bounds.size.height
#define kScreenW  self.bounds.size.width
#define PPLog NSLog(@"当前的的方法名--->%s",__func__);
// 弱应用
#define PPWeakSelf(type)  __weak typeof(type) weak##type = type;

@interface PP_LoopView ()

@property (assign, nonatomic) NSInteger currentIndex;// 当前展示视图对应的下标
@property (assign, nonatomic) NSInteger nextIndex; // 对应的下一个坐标
@property (assign, nonatomic) NSInteger previousIndex;// 对应上一个坐标
@property (strong, nonatomic) UIPanGestureRecognizer *pan;// 手势
@property (strong, nonatomic) NSArray<NSString *> *imageNames;// 存照片的名字数组
@property (strong, nonatomic) UIImageView *currentImage;// 当前展示的照片
@property (strong, nonatomic) UIImageView *nextImage; // 将要展示的照片
@property (assign, nonatomic) BOOL fromNetwork; // 记录传入的是否是网址照片
@property (strong, nonatomic) NSTimer *changeImageTime; // 定时器


@end
// 定义一个滑动方向枚举 手势停止的时候判断需要展示哪一张照片
typedef enum : NSUInteger
{
    MoveDirectionLeft,
    MoveDirectionRight,
} MoveDirection;


@implementation PP_LoopView

// 获取当前下标下一个坐标
- (NSInteger)nextIndex
{
    return _currentIndex >= _imageNames.count - 1 ? 0 : _currentIndex + 1;
}
// 获取当前下标的上一个坐标
- (NSInteger)previousIndex
{
    return _currentIndex == 0 ? _imageNames.count - 1 : _currentIndex - 1;
}
// 根据下标取到照片
- (UIImage *)getImageForIndex:(NSInteger)index
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@",_imageNames[index]]];
}

// 根据下标从网络获取图片
- (void)getNetWorkImageIndex:(NSInteger)index imageView:(UIImageView *)image
{
    PPWeakSelf(image);
    [[PP_LoadImageManagar shareImageDownManagar] getImageUrlString:_imageNames[index] delegate:nil successfulBlock:^(UIImage *returnImage) {
        weakimage.image = returnImage;
    }];
}



// 初始化方法
- (instancetype)initWithImageArray:(NSArray <NSString *>*)imageArray
                              fram:(CGRect)frame
                       fromNetWork:(BOOL)fromNetwork
{
    if (self = [super initWithFrame:frame])
    {
        self.clipsToBounds = YES;// 超出的范围不显示
        _imageNames = imageArray;
        _fromNetwork = fromNetwork;
        _currentIndex = 0;
        _currentImage = [[UIImageView alloc] initWithFrame:self.bounds];
        _currentImage.userInteractionEnabled = YES;
        _currentImage.contentMode = UIViewContentModeScaleToFill;
        _currentImage.clipsToBounds = YES;
        // 判断执行网络请求的还是直接是工程的照片
        _fromNetwork ? [self getNetWorkImageIndex:_currentIndex imageView:_currentImage] : [_currentImage setImage:[self getImageForIndex:_currentIndex]];
        
        //_currentImage.image = [self getImageForIndex:_currentIndex];
        [self insertSubview:_currentImage atIndex:1];
        
        // 下一张图片
        _nextImage = [[UIImageView alloc] init];
        _nextImage.contentMode = UIViewContentModeScaleToFill;
        _nextImage.clipsToBounds = YES;
        _nextImage.userInteractionEnabled = YES;
        [self insertSubview:_nextImage atIndex:0];
        
        // 添加平移手势
        // pan手势处理切换
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panChangeImage:)];
        [self addGestureRecognizer:_pan];
        
        // 定时器
        [self addTime];
           }
    return self;
}

- (void)addTime
{
    _changeImageTime = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(changeActionForTime) userInfo:nil repeats:YES];
    // iOS10
//    __weak typeof(*&self) weakSelf = self;
//    _changeImageTime = [NSTimer scheduledTimerWithTimeInterval:1.5f repeats:YES block:^(NSTimer * _Nonnull timer)
//    {
//        // 设置下一张照片
//        weakSelf.nextImage.image = [weakSelf getImageForIndex:weakSelf.nextIndex];
//        weakSelf.nextImage.frame = CGRectOffset(_currentImage.frame, kScreenW, 0);
//        [weakSelf leftOut:weakSelf.currentImage rightIn:weakSelf.nextImage duration:0.5f];
//        weakSelf.currentIndex = weakSelf.nextIndex;// 改变当前展示的下标
//        // 交换 _nextImage 和 _currentImage 指针指向，这样的话当前的指针指向就是展示在当前的界面的图片
//        UIImageView *temp = weakSelf.nextImage;
//        weakSelf.nextImage = weakSelf.currentImage;
//        weakSelf.currentImage = temp;
//        
//    }];
}
- (void)changeActionForTime
{
    // 设置下一张照片
     _fromNetwork ? [self getNetWorkImageIndex:self.nextIndex imageView:self.nextImage] : [self.nextImage setImage:[self getImageForIndex:self.nextIndex]];
    
    self.nextImage.frame = CGRectOffset(_currentImage.frame, kScreenW, 0);
    [self leftOut:self.currentImage rightIn:self.nextImage duration:0.5f];
    self.currentIndex = self.nextIndex;// 改变当前展示的下标
    // 交换 _nextImage 和 _currentImage 指针指向，这样的话当前的指针指向就是展示在当前的界面的图片
    UIImageView *temp = self.nextImage;
    self.nextImage = self.currentImage;
    self.currentImage = temp;

}



// 切换图片
- (void)panChangeImage:(UIPanGestureRecognizer *)pan
{
    // 手势的时候先移除 time
    [self.changeImageTime invalidate];
    self.changeImageTime = nil;
    
    // 向左滑 x 为负 向右滑 x 为正  （末位置 减 初始位置）
    CGPoint panOffSet = [pan translationInView:self];
    float changeX = panOffSet.x;
    NSLog(@"-------->%f",changeX);
    // 获取 当前的视图位置
    CGRect frame = _currentImage.frame;
    // 清空手势的偏移量
    [_pan setTranslation:(CGPointZero) inView:self];

    // 处理左右视图
    float resulet = frame.origin.x + (changeX < 0 ? - DBL_EPSILON : DBL_EPSILON);
   //  小于 0 就是向左滑动了 大于 0 就是向右 滑动 了
    resulet <= 0 ? [self leftScroll:changeX frame:frame] : [self rightScroll:changeX frame:frame] ;

}

// 当前照片左滑动  出现右侧照片
- (void)leftScroll:(float)offX frame:(CGRect)frame
{
    float tempX = frame.origin.x + offX;
    // 移动当前的图片
    _currentImage.frame = CGRectMake(tempX, frame.origin.y, frame.size.width, frame.size.height);
    // 设置下一张照片
     _fromNetwork ? [self getNetWorkImageIndex:self.nextIndex imageView:self.nextImage] : [self.nextImage setImage:[self getImageForIndex:self.nextIndex]];
    
    _nextImage.frame = CGRectOffset(_currentImage.frame, kScreenW, 0);
    
    // 收拾停止的时候
    if (_pan.state == UIGestureRecognizerStateEnded)
    {
        // 恢复定时器
        [self addTime];
        // 判断手势停止的时候展示哪一个 照片
        MoveDirection result = tempX <= - kScreenW / 2 ? [self leftOut:_currentImage rightIn:_nextImage duration:0.3f] : [self leftIn:_currentImage rightOut:_nextImage duration:0.3f];
      
        // 判断需要当先展示的是下张图片的时候  去操作
        if (result == MoveDirectionLeft)
        {
            _currentIndex = self.nextIndex;// 改变当前展示的下标
            // 交换 _nextImage 和 _currentImage 指针指向，这样的话当前的指针指向就是展示在当前的界面的图片
            UIImageView *temp = _nextImage;
            _nextImage = _currentImage;
            _currentImage = temp;
        }

    }

    
}
// 当前图片右滑动 出现左侧照片
- (void)rightScroll:(float)offX frame:(CGRect)frame
{
    float tempX = frame.origin.x + offX;
    // 移动当前的图片
    _currentImage.frame = CGRectMake(tempX, frame.origin.y, frame.size.width, frame.size.height);
    // 设置上一张照片
   // _nextImage.image = [self getImageForIndex:self.previousIndex];
    
    _fromNetwork ? [self getNetWorkImageIndex:self.previousIndex imageView:self.nextImage] : [self.nextImage setImage:[self getImageForIndex:self.previousIndex]];
    
    _nextImage.frame = CGRectOffset(_currentImage.frame, -kScreenW, 0);
    
    // 收拾停止的时候
    if (_pan.state == UIGestureRecognizerStateEnded)
    {
        // 恢复定时器
        [self addTime];
        
        // 判断手势停止的时候展示哪一个 照片
        MoveDirection result = tempX <= kScreenW / 2 ? [self leftOut:_nextImage rightIn:_currentImage duration:0.3f] : [self leftIn:_nextImage rightOut:_currentImage duration:0.3f];
        
        // 要展示上一张照片
        if (result == MoveDirectionRight)
        {
            _currentIndex = self.previousIndex;
            UIImageView *temp = _nextImage;
            _nextImage = _currentImage;
            _currentImage = temp;
        }
    }
}

// 展示右侧的图片
- (MoveDirection)leftOut:(UIImageView *)leftView rightIn:(UIImageView *)rightView duration:(NSTimeInterval)duration
{
    /*
     当手势结束的时候  左边的 ImageView 滑出视线之外  右侧的 ImageView 占据整个屏幕
     */
    [UIView animateWithDuration:duration animations:^{
        leftView.frame = CGRectOffset(self.bounds, - kScreenW, 0);
        rightView.frame = self.bounds;
    } completion:^(BOOL finished) {
        
        
    }];
    return MoveDirectionLeft;
}
- (MoveDirection)leftIn:(UIImageView *)leftView rightOut:(UIImageView *)rightView duration:(NSTimeInterval)duration
{
    /*
     当手势结束的时候  展示位于左边的照片 右侧的看不见
     */
    [UIView animateWithDuration:duration animations:^{
        rightView.frame = CGRectOffset(self.bounds, kScreenW, 0);
        leftView.frame = self.bounds;
    } completion:^(BOOL finished) {
        
    }];
    return MoveDirectionRight;
}


/**
 更新图片数据的方法
 */
- (void)changeImageArray:(NSArray *)newArray fromNetWork:(BOOL)fromNetWork
{
    self.imageNames = newArray;
    _fromNetwork = fromNetWork;
}









@end
