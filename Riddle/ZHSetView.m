//
//  ZHSetView.m
//  Riddle
//
//  Created by 小飞鸟 on 2018/3/13.
//  Copyright © 2018年 小飞鸟. All rights reserved.
//

#import "ZHSetView.h"
#import "Masonry.h"
#import "YYKit.h"

@interface ZHSetView()
@property (weak, nonatomic) IBOutlet UIImageView *BgView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
/*音效*/
@property(nonatomic,strong)UIButton * soundBtn;
/*摇一摇按钮*/
@property(nonatomic,strong)UIButton * yaoBtn;
/*QQ控件按钮*/
@property(nonatomic,strong)UIButton * zoneBtn;
/*分享按钮*/
@property(nonatomic,strong)UIButton * shareBtn;
/*点击的按钮*/
@property(nonatomic,copy) BtnBlock btnBlock;

@end

@implementation ZHSetView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    CGFloat width =[UIScreen mainScreen].bounds.size.width;
    CGFloat hight =[UIScreen mainScreen].bounds.size.height;
    self.frame=CGRectMake(0, 0, width, hight);
    
    self.BgView.userInteractionEnabled = YES;
    [self.closeBtn removeFromSuperview];
    [self.BgView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.BgView).mas_equalTo(-2);
    }];
    
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchDown];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BgView).offset(-10);
        make.right.equalTo(self.BgView).offset(-10);
    }];
    
    self.soundBtn=  [self createWithLabelName:@"音效" Frame:CGRectMake(0, 58, self.width, 60) BtnTag:1001];
    self.soundBtn.selected = [[DataHelper getDataForKey:Sound]isEqualToString:@"0"]? NO:YES;
    self.yaoBtn = [self createWithLabelName:@"摇一摇" Frame:CGRectMake(0, 120, self.width, 60) BtnTag:1002];
    self.yaoBtn.selected = [[DataHelper getDataForKey:Shake]isEqualToString:@"0"]? NO:YES;
    
    self.zoneBtn = [self createBtnWithSupview:self.BgView NormalImg:@"QQZone" SelectImg:@"QQZone" Tag:1003];
    [self.zoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.BgView).mas_equalTo(73);
        make.bottom.equalTo(self.BgView).offset(-82);
    }];
     self.shareBtn = [self createBtnWithSupview:self.BgView NormalImg:@"shareIcon" SelectImg:@"shareIcon" Tag:1003];
    
    self.shareBtn.backgroundColor=[UIColor colorWithRed:107/255.0 green:53/255.0 blue:27/255.0 alpha:1.0];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.BgView).offset(-73);
        make.bottom.equalTo(self.BgView).offset(-82);
    }];
}


+(instancetype)loadView{

    return [[[UINib nibWithNibName:@"ZHSetView" bundle:nil] instantiateWithOwner:self options:nil] lastObject];
}


#pragma mark 创建按钮
-(UIButton*)createWithLabelName:(NSString*)labelText Frame:(CGRect)frame BtnTag:(NSInteger)tag{
    
    UIView * View =[[UIView alloc]initWithFrame:frame];
    UILabel * label =[UILabel new];
    [self.BgView addSubview:View];
    
    [View addSubview:label];
    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:27];
    label.text=labelText;
    label.textColor= [UIColor colorWithRed:103/225.0 green:45/255.0 blue:20/255.0 alpha:1.0];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(24);
        make.top.equalTo(@(0));
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(28);
    }];
    
    UIButton * btn = [self createBtnWithSupview:View NormalImg:@"NOGou" SelectImg:@"haveGou" Tag:tag];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.BgView.mas_right).offset(-28);;
        make.top.mas_equalTo(0);
    }];
    
    return btn;
}

-(UIButton*)createBtnWithSupview:(UIView*)View NormalImg:(NSString*)normal SelectImg:(NSString*)selectImg Tag:(NSInteger)tag{
    
    UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
    [View addSubview:btn];
    [btn setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectImg] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
    btn.tag = tag;
    [btn.imageView sizeToFit];
    return btn;
}


#pragma mark 按钮点击
-(void)btnClicked:(UIButton*)btn{
    
    switch (btn.tag) {
        case 1001:{
            //音效
            self.soundBtn.selected = !self.soundBtn.selected;
            [DataHelper saveData:Sound Value:[@(self.soundBtn.selected) stringValue]];
            
            break;
        }
        case 1002:{
            //摇一摇
            self.yaoBtn.selected = !self.yaoBtn.selected;
              [DataHelper saveData:Shake Value:[@(self.yaoBtn.selected) stringValue]];
            
            break;
        }
        case 1003:
        case 1004:{
            //QQZone
            //分享
            if (self.btnBlock) {
                self.btnBlock(btn.tag);
            }
            break;
        }
            
        default:
            break;
    }
    
    
    
}


-(void)showInWindow:(void(^)(NSInteger index))ClickBlock{
    
    self.btnBlock =ClickBlock;
    [self showWithAlert:self.BgView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

/**
 添加Alert入场动画
 @param alert 添加动画的View
 */
- (void)showWithAlert:(UIView*)alert{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.5;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}


/** 添加Alert出场动画 */
- (void)dismissAlert{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    } ];
    
}


- (void)closeAction{
    
    [self dismissAlert];
}


@end
