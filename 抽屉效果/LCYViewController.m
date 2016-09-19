//
//  LCYViewController.m
//  抽屉效果
//
//  Created by LCY on 16/6/3.
//  Copyright © 2016年 lincuiyuan. All rights reserved.
//

#import "LCYViewController.h"

@interface LCYViewController ()
/***/
@property (nonatomic, strong) UIView *mainView;
/***/
@property (nonatomic, strong) UIView *leftView;
/***/
@property (nonatomic, strong) UIView *rightView;

@end

@implementation LCYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加view
    [self addView];
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [self.mainView addGestureRecognizer:pan];
    //添加点击手势:点击屏幕 回到原始位置
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tapGes];
    
}


//自动定位到的位置
#define targetR 275
#define targetL -275
//点击时调用
- (void)tap
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.mainView.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        
    }];
}
//当拖动的时候调用
- (void)pan:(UIPanGestureRecognizer *)pan
{
    //获取偏移量
    CGPoint tranrP = [pan translationInView:self.mainView];
    //给定一个偏移量.计算mianVC的frame
    self.mainView.frame = [self frameWithOffset:tranrP.x];
    
    //判断mainView的X轴是大于0,rightView就隐藏
    if (self.mainView.frame.origin.x > 0) {
        self.rightView.hidden = YES;
    }else if(self.mainView.frame.origin.x < 0)
    {
        self.rightView.hidden = NO;
    }
    
    
    
    CGFloat target = 0;
    //判断手势的状态,自动定位
    //如果停止点击
    if (pan.state == UIGestureRecognizerStateEnded) {
        //如果mianview的x值大于屏幕宽度的一半
        if (self.mainView.frame.origin.x > ([UIScreen mainScreen].bounds.size.width * 0.5)) {
            //自动定位到右侧
            target = targetR;
        }
        else if(CGRectGetMaxX(self.mainView.frame) < ([UIScreen mainScreen].bounds.size.width * 0.5))
        {
            //自动定位到左侧
            target = targetL;
        }
        
        
        //开始自动定位
        //计算偏移量
        CGFloat offset = target - self.mainView.frame.origin.x;
        //添加动画
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.99 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            //给一个偏移量计算mianView的frame
            self.mainView.frame = [self frameWithOffset:offset];
        } completion:nil];
        
    }
    
    
    //复位
    [pan setTranslation:CGPointZero inView:self.mainView];
}



//给定一个偏移量.计算mianVC的frame
- (CGRect)frameWithOffset:(CGFloat)offset
{
    CGRect frame = self.mainView.frame;
    //计算X值
    frame.origin.x = frame.origin.x + offset;
    //计算Y值 绝对值fabs : 因为frame.origin.x会出现负数 使y值也变为负数
    frame.origin.y = fabs(frame.origin.x * 100 / [UIScreen mainScreen].bounds.size.width);
    //计算高度    : 屏幕的高度 - 2 * y
    frame.size.height = [UIScreen mainScreen].bounds.size.height - (frame.origin.y * 2);
    return frame;
}



//添加View
- (void)addView
{
    UIView *leftVC = [[UIView alloc]initWithFrame:self.view.bounds];
    leftVC.backgroundColor = [UIColor redColor];
    [self.view addSubview:leftVC];
    self.leftView = leftVC;
    
    UIView *rightVC = [[UIView alloc]initWithFrame:self.view.bounds];
    rightVC.backgroundColor = [UIColor greenColor];
    [self.view addSubview:rightVC];
    self.rightView = rightVC;
    
    UIView *mianVC = [[UIView alloc]initWithFrame:self.view.bounds];
    mianVC.backgroundColor = [UIColor blueColor];
    [self.view addSubview:mianVC];
    self.mainView = mianVC;
    
}


@end
