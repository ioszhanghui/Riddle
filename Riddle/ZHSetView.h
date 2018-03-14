//
//  ZHSetView.h
//  Riddle
//
//  Created by 小飞鸟 on 2018/3/13.
//  Copyright © 2018年 小飞鸟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataHelper.h"

typedef void(^BtnBlock)(NSInteger index);

@interface ZHSetView : UIView

/*加载视图*/
+(instancetype)loadView;

/*点击block*/
-(void)showInWindow:(BtnBlock)btnBlock;

@end
