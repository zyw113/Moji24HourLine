//
//  ZYWWetherModel.h
//  ZYWBezierCurveLine
//
//  Created by 张有为 on 2017/6/1.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYWWetherModel : NSObject

@property (nonatomic,copy) NSString *date;
@property (nonatomic,strong) NSString *imageCode;
@property (nonatomic,copy) NSString *temper;
@property (nonatomic,assign) BOOL isDrawImage;

@end
