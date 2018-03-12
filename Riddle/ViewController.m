//
//  ViewController.m
//  Riddle
//
//  Created by 小飞鸟 on 2018/3/13.
//  Copyright © 2018年 小飞鸟. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<CAAnimationDelegate>

/*筛子*/
@property(nonatomic,strong)UILabel * label;
@property(nonatomic,strong)CALayer * layer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.label];
    
//    CALayer * layer =[CALayer layer];
//    layer.backgroundColor = [UIColor redColor].CGColor;
//    layer.bounds=CGRectMake(100, 100, 100, 100);
//    layer.anchorPoint=CGPointZero;
//    layer.position=CGPointMake(0, 0);
//    [self.view.layer addSublayer:layer];
//    self.layer= layer;
    
}

-(UILabel *)label{
    if (!_label) {
        _label=[UILabel new];
        _label.backgroundColor=[UIColor greenColor];
        _label.textAlignment=NSTextAlignmentCenter;
        _label.textColor=[UIColor redColor];
        _label.frame =CGRectMake(10, 10, 50, 50);
        _label.text=@"1";
    }
    return _label;
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];

    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue=[NSValue valueWithCGPoint:CGPointMake(self.label.center.x, self.label.center.y)];
    animation.toValue=[NSValue valueWithCGPoint:CGPointMake(200, 300)];
  
    CABasicAnimation * ani =[CABasicAnimation animation];
    ani.keyPath = @"transform.rotation";//动画形式 transform  bounds  KVC的键路径  transform.translation 旋转的键值  transform.scale 缩放 transform.rotation 移动 transform.scale.x -》x方向旋转
    //结束点
    ani.toValue = @(M_PI*2);
    
    CAAnimationGroup * aniGroup = [CAAnimationGroup animation];
    aniGroup.animations = @[ani,animation];
    aniGroup.duration = 2.0f;
    aniGroup.fillMode = kCAFillModeForwards;
    aniGroup.removedOnCompletion=NO;
    aniGroup.repeatCount = 1.f;
    aniGroup.delegate=self;
    aniGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //动画结束不移除动画
    aniGroup.removedOnCompletion =NO;
    [self.label.layer addAnimation:aniGroup forKey:@"group"];
}

#pragma mark 动画开始
-(void)animationDidStart:(CAAnimation *)anim{
    
    
}

#pragma mark 动画结束
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    
}



@end
