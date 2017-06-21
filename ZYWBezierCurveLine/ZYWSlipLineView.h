//
//  ZYWSlipLineView.h
//  ZYWBezierCurveLine
//
//  Created by 张有为 on 2017/5/27.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYWWetherModel.h"
@interface ZYWSlipLineView : UIView

@property (nonatomic,assign) CGFloat lineSpace;
@property (nonatomic,assign) CGFloat maxY;
@property (nonatomic,assign) CGFloat minY;
@property (nonatomic,assign) CGFloat scaleY;
@property (nonatomic,assign) CGFloat leftMargin;
@property (nonatomic,assign) CGFloat rightMargin;
@property (nonatomic,assign) CGFloat topMargin;
@property (nonatomic,assign) CGFloat bottomMargin;
@property (nonatomic,strong) NSMutableArray<ZYWWetherModel*>*dataArray;

- (void)stockFill;

@end
