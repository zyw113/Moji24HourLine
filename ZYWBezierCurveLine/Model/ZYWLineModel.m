//
//  ZYWLineModel.m
//  ZYWBezierCurveLine
//
//  Created by 张有为 on 2017/5/27.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWLineModel.h"

@implementation ZYWLineModel

+(instancetype)initPositon:(CGFloat)xPositon yPosition:(CGFloat)yPosition color:(UIColor*)color
{
    ZYWLineModel *model = [[ZYWLineModel alloc] init];
    model.xPosition = xPositon;
    model.yPosition = yPosition;
    model.lineColor = color;
    return model;
}

@end
