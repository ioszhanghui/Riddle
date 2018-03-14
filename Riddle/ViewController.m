//
//  ViewController.m
//  Riddle
//
//  Created by 小飞鸟 on 2018/3/13.
//  Copyright © 2018年 小飞鸟. All rights reserved.
//

#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "YYKit.h"
#import "ZHSetView.h"

@interface ViewController ()<CAAnimationDelegate>

@property(nonatomic,strong)CALayer * layer;
/*需要添加的筛子*/
@property(nonatomic,strong)NSMutableArray * layers;
/*添加所有的点*/
@property(nonatomic,strong)NSMutableArray * points;

@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIImageView *BGView;

@end

//筛子的个数
static NSInteger numCount =5;

//距离边缘的距离
#define  kmargin 8

@implementation ViewController


-(NSMutableArray *)layers{
    if (!_layers) {
        _layers = [NSMutableArray array];
    }
    return _layers;
}


-(NSMutableArray *)points{
    if (!_points) {
        _points = [NSMutableArray array];
    }
    return _points;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder]; 
 
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.showLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30];
}

- (IBAction)setBtnAction:(id)sender {
    
    [[ZHSetView loadView]showInWindow:^(NSInteger index) {
        
    }];;
    
}
- (IBAction)reduceBtnAction:(id)sender {
    
    //最少个数为1
    if (numCount==1) {
        return;
    }
    numCount--;
    [self resetLabelContent];
}
#pragma mark 修改文字的内容
-(void)resetLabelContent{
    self.showLabel.text = [@(numCount) stringValue];
}
- (IBAction)addNumAction:(id)sender {
    //最多的个数10
    if (numCount==10) {
        return;
    }
    numCount++;
    [self resetLabelContent];
}
- (IBAction)shakeAction:(id)sender {
    //播放摇晃的段音频
    [self playSoundFile:@"shake"];
    [self removeBeforeLayer];
    [self removeAllPoints];
    [self createSaizi];
}

#pragma mark 动画开始
-(void)animationDidStart:(CAAnimation *)anim{
    //播放滚动的音频
    [self playSoundFile:@"roll"];
}

#pragma mark 移除之前的layer
-(void)removeBeforeLayer{
    for(CALayer * layer in self.layers){
        [layer removeFromSuperlayer];
    }
}
#pragma mark 移除所有的点
-(void)removeAllPoints{
    [self.points removeAllObjects];
}

#pragma mark 创建筛子
-(void)createSaizi{
    
    for (NSInteger i=0; i< numCount; i++) {
        
        CALayer * layer =[CALayer layer];
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.bounds=CGRectMake(0, 0, 60, 60);
        layer.anchorPoint=CGPointZero;
        NSString * imageName  = [NSString stringWithFormat:@"SZ_%02d",(arc4random()%6+1)];
        layer.contents = (__bridge id)[UIImage imageNamed:imageName].CGImage;
        layer.position=CGPointMake(-60, -60);
        [self.BGView.layer addSublayer:layer];
        
        CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.fromValue=[NSValue valueWithCGPoint:CGPointMake(self.layer.center.x, self.layer.center.y)];
        animation.toValue=[NSValue valueWithCGPoint:[self setSaiziScrollPoint]];
        
        CABasicAnimation * ani =[CABasicAnimation animation];
        ani.keyPath = @"transform.rotation";//动画形式 transform  bounds  KVC的键路径  transform.translation 旋转的键值  transform.scale 缩放 transform.rotation 移动 transform.scale.x -》x方向旋转
        //结束点
        ani.toValue = @(M_PI*2);
        
        CAAnimationGroup * aniGroup = [CAAnimationGroup animation];
        aniGroup.animations = @[ani,animation];
        aniGroup.duration = 1.0f;
        aniGroup.fillMode = kCAFillModeForwards;
        aniGroup.removedOnCompletion=NO;
        aniGroup.repeatCount = 1.f;
        aniGroup.delegate=self;
        aniGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        //动画结束不移除动画
        aniGroup.removedOnCompletion =NO;
        [layer addAnimation:aniGroup forKey:@"group"];
        
        [self.layers addObject:layer];
    }
}

#pragma mark 动画结束
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
  
}

#pragma mark 播放短频音效
-(void)playSoundFile:(NSString*)fileName{
    
    // 声明要保存音效文件的变量
    SystemSoundID soundID;
    
    // 加载文件
    NSURL *fileURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileURL), &soundID);
    
    // 播放短频音效
    AudioServicesPlayAlertSound(soundID);
    
    // 增加震动效果，如果手机处于静音状态，提醒音将自动触发震动
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

#pragma mark 获取塞子可滚动的区域
-(CGPoint)setSaiziScrollPoint{
    
    CGFloat width = self.view.width;//宽度
    CGFloat imageHight = 500;
    
    CGFloat imageWidth = 60;//图片宽度
    //最小x
    CGFloat minX = imageWidth+ kmargin;
    //最大X
    CGFloat maxX = width- imageWidth-kmargin;
    //最小y
    CGFloat minY = imageWidth + kmargin;
    //最小y
    CGFloat maxY = imageHight-(imageWidth + kmargin);
    CGPoint point = CGPointMake([self getRandomNumber:minX to:maxX], [self getRandomNumber:minY to:maxY]);

    while([self isRepeatData:point]){
       point = CGPointMake([self getRandomNumber:minX to:maxX], [self getRandomNumber:minY to:maxY]);
    }
    
    [self.points addObject:NSStringFromCGPoint(point)];
    
    return point;
}

#pragma mark  数据是否重复
-(BOOL)isRepeatData:(CGPoint)point{
    
    BOOL isRepeat = NO;
    for (NSInteger i=0; i<self.points.count; i++) {
        CGPoint point1 = CGPointFromString([self.points  objectAtIndex:i]);
        if ((abs(((int)point.x -(int)point1.x)))<70&&(abs((int)point.y - (int)point1.y))<70) {
            isRepeat = YES;
            break;
        }
    }
    return isRepeat;
}

#pragma mark获取随机数
-(float)getRandomNumber:(int)from to:(int)to{
    return from + arc4random()%(to-from);
}

#pragma mark 摇一摇
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    //开始摇一摇调用 点击方法
    [self shakeAction:nil];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
}


@end
