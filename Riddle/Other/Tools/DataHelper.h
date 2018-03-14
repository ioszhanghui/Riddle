//
//  DataHelper.h
//  Riddle
//
//  Created by zhph on 2018/3/14.
//  Copyright © 2018年 小飞鸟. All rights reserved.
//

#import <Foundation/Foundation.h>

#define  Sound @"Sound"//音效
#define Shake @"Shake"//摇晃

@interface DataHelper : NSObject
/*保存数据*/
+(void)saveData:(NSString*)key Value:(NSString*)value;
/*获取数据*/
+(NSString*)getDataForKey:(NSString*)key;
@end
