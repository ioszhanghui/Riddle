//
//  DataHelper.m
//  Riddle
//
//  Created by zhph on 2018/3/14.
//  Copyright © 2018年 小飞鸟. All rights reserved.
//

#import "DataHelper.h"

@implementation DataHelper
/*保存数据*/
+(void)saveData:(NSString*)key Value:(NSString*)value{
    [[NSUserDefaults standardUserDefaults]setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];;
}
/*获取数据*/
+(NSString*)getDataForKey:(NSString*)key{
      return [[NSUserDefaults standardUserDefaults]objectForKey:key];
}

@end
