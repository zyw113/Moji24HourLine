//
//  ZYWLineModel.h
//  ZYWBezierCurveLine
//
//  Created by 张有为 on 2017/5/27.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ZYWLineModel : NSObject
@property (nonatomic,assign) CGFloat xPosition;
@property (nonatomic,assign) CGFloat yPosition;
@property (nonatomic,strong) UIColor *lineColor;

+ (instancetype)initPositon:(CGFloat)xPositon yPosition:(CGFloat)yPosition color:(UIColor*)color;

@end
