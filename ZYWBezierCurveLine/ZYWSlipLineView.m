//
//  ZYWSlipLineView.m
//  ZYWBezierCurveLine
//
//  Created by 张有为 on 2017/5/27.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWSlipLineView.h"
#import "UIBezierPath+LxThroughPointsBezier.h"
#import "ZYWTemperView.h"
#import "ZYWWetherModel.h"

#define timeLayerHeight 20
#define tempViewHeight 40

@interface ZYWSlipLineView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *superScrollView;
@property (nonatomic,strong) NSMutableArray<ZYWLineModel*> *modelPostionArray;
@property (nonatomic,strong) CAShapeLayer *lineLayer;
@property (nonatomic,strong) CAShapeLayer *circleLayer;
@property (nonatomic,strong) CAShapeLayer *timerLayer;
@property (nonatomic,strong) ZYWTemperView *tempView;
@property (nonatomic,assign) NSInteger currentIndex;//当前模型下标
@property (nonatomic,assign) NSInteger imageIndex;//当前显示的image下标
@property (nonatomic,strong) NSMutableArray *indexArray;//记录所需绘制图片的下标

@end

@implementation ZYWSlipLineView

#pragma mark setter

-(NSMutableArray*)modelPostionArray
{
    if (!_modelPostionArray)
    {
        _modelPostionArray = [NSMutableArray array];
    }
    return _modelPostionArray;
}

-(NSMutableArray*)indexArray
{
    if (!_indexArray)
    {
        _indexArray = [NSMutableArray array];
    }
    return _indexArray;
}

#pragma mark draw

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.modelPostionArray.count)
    {
        [self drawLineLayer];
        [self drawCircleLayer];
        [self drawTimerLayer];
    }
}

/**
 绘制曲线
 */
-(void)drawLineLayer
{
    ZYWLineModel *model = self.modelPostionArray.firstObject;
    _tempView.centerX = model.xPosition;
    _tempView.y = model.yPosition - _tempView.height - 10 ;
 
    _tempView.date = _dataArray[[_indexArray .firstObject integerValue]].temper;
    _tempView.imageName = _dataArray[[_indexArray .firstObject integerValue]].imageCode;
    NSMutableArray *pointsArray = [NSMutableArray array];
    for (ZYWLineModel *model in _modelPostionArray) {
        NSValue *value = [NSValue valueWithCGPoint:CGPointMake(model.xPosition, model.yPosition)];
        [pointsArray addObject:value];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:[pointsArray.firstObject CGPointValue]];
    [path addBezierThroughPoints:pointsArray];
    
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.path = path.CGPath;
    self.lineLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.lineLayer.fillColor = [[UIColor clearColor] CGColor];
    self.lineLayer.lineWidth = 1;
    self.lineLayer.lineCap = kCALineCapRound;
    self.lineLayer.lineJoin = kCALineJoinRound;
    self.lineLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.lineLayer];
}

/**
 绘制圆点
 */
-(void)drawCircleLayer
{
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.fillColor = [[UIColor clearColor] CGColor];
    self.circleLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.circleLayer];
    for (ZYWLineModel *model in _modelPostionArray)
    {
        CAShapeLayer *subLayer = [[CAShapeLayer alloc] init];
        subLayer.fillColor = [UIColor whiteColor].CGColor;
        UIBezierPath *circle = [UIBezierPath bezierPath];
        [circle addArcWithCenter:CGPointMake(model.xPosition, model.yPosition) radius:3
                      startAngle:0
                        endAngle:2*M_PI
                       clockwise:YES];
        subLayer.path = circle.CGPath;
        [self.circleLayer addSublayer:subLayer];
    }
}

/**
 时间
 */
-(void)drawTimerLayer
{
    self.timerLayer = [CAShapeLayer layer];
    self.timerLayer.fillColor = [[UIColor clearColor] CGColor];
    self.timerLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.timerLayer];
    
    [_dataArray enumerateObjectsUsingBlock:^(ZYWWetherModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        ZYWLineModel *postionModel = _modelPostionArray[idx];
        
        CATextLayer *layer = [CATextLayer layer];
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.fontSize = 13.f;
        layer.alignmentMode = kCAAlignmentCenter;
        layer.foregroundColor = [UIColor whiteColor].CGColor;
        layer.string = model.date;
        layer.position = CGPointMake(postionModel.xPosition,self.height - timeLayerHeight/2);
        layer.bounds = CGRectMake(0, 0, 60, timeLayerHeight);
        [self.timerLayer addSublayer:layer];
    }];
}

-(void)addWetherImages
{
    for (NSInteger i = 0;i < _dataArray.count; i++)
    {
        ZYWWetherModel *model = _dataArray[i];
        ZYWLineModel *postionModel = _modelPostionArray[i];
        if (model.isDrawImage)
        {
            static NSInteger index = 0;
            UIImageView *imageView = [UIImageView new];
            [self addSubview:imageView];
            imageView.center = CGPointMake(postionModel.xPosition, postionModel.yPosition - 15);
            imageView.bounds = CGRectMake(0, 0, 30, 30);
            imageView.tag = i;
            imageView.image = [UIImage imageNamed:model.imageCode];
            ++ index;
        }
    }
}

#pragma mark postion

-(void)calcuteModelPostion
{
    __weak typeof(self) this = self;
    [_dataArray enumerateObjectsUsingBlock:^(ZYWWetherModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat value = [obj.temper floatValue];
        CGFloat xPostion = this.lineSpace*idx + this.leftMargin;
        CGFloat yPostion = (this.maxY - value)*this.scaleY + this.topMargin + 50;
        ZYWLineModel *lineModel = [ZYWLineModel initPositon:xPostion yPosition:yPostion color:[UIColor redColor]];
        [this.modelPostionArray addObject:lineModel];
    }];
}

#pragma mark 运动的view

-(void)addTempView
{
    _tempView = [[ZYWTemperView alloc] initWithFrame:CGRectMake(0, 0, 80, tempViewHeight)];
    [self.superScrollView addSubview:_tempView];
}

#pragma mark scrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGSize size = scrollView.contentSize;
    CGFloat x = (_dataArray.count - 1) * self.lineSpace * scrollView.contentOffset.x / (size.width - scrollView.width) + self.leftMargin;
    
    if (x > (size.width - self.rightMargin))
    {
         ZYWLineModel *model = self.modelPostionArray.lastObject;
         x = model.xPosition;
        _imageIndex = [_indexArray.lastObject integerValue];
        _currentIndex = self.modelPostionArray.count - 1;
    }
    
    if (x <= self.leftMargin)
    {
        ZYWLineModel *model = self.modelPostionArray.firstObject;
        x = model.xPosition;
        _imageIndex = [_indexArray.firstObject integerValue];
        _currentIndex = 0;
    }
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionOverrideInheritedCurve animations:^{
        if (_currentIndex == 0)
        {
            UIImageView *prevImage = [self viewWithTag:[_indexArray.firstObject integerValue]];
            prevImage.alpha = 1;
        }
        
        else
        {
            UIImageView *prevImage = [self viewWithTag:_currentIndex-1];
            if (!prevImage)
            {
                prevImage = [self viewWithTag:_currentIndex+1];
            }
            prevImage.alpha = 1;
        }
        
        UIImageView *currentImage = [self viewWithTag:_currentIndex];
        currentImage.alpha = 0;
    } completion:^(BOOL finished) {
    }];
    
    self.alpha = 1;
    CGFloat y = [self getLableyAxisWithX:x] - _tempView.height - 10 > 0 ? [self getLableyAxisWithX:x] - _tempView.height - 10 : 0;
    _tempView.centerX = x;
    _tempView.y = y;
    _tempView.date = _dataArray[_currentIndex].temper;
    _tempView.imageName = _dataArray[_imageIndex].imageCode;
}

#pragma mark publicMethod

-(void)initConfig
{
    self.lineSpace = DEVICE_WIDTH / 10.f ;
    CGFloat  contentWidth = self.lineSpace*(_dataArray.count - 1) + self.leftMargin + self.rightMargin;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(contentWidth);
    }];
    [self.superScrollView setContentSize:CGSizeMake(contentWidth, 0)];
    
    self.maxY = CGFLOAT_MIN;
    self.minY  = CGFLOAT_MAX;
    
    for (ZYWWetherModel *model in _dataArray) {
        self.minY = self.minY < [model.temper integerValue] ? self.minY : [model.temper integerValue];
        self.maxY = self.maxY >[model.temper integerValue] ? self.maxY : [model.temper integerValue];
    }
    
    [self calcuteWetherCode];
    self.scaleY = (self.height - self.topMargin - self.bottomMargin - timeLayerHeight - tempViewHeight)/(self.maxY-self.minY);
}


/**
 计算一个区间天气code，相同code的只保留最后一个
 */
-(void)calcuteWetherCode
{
    for (NSInteger i = 0;i < _dataArray.count; i++)
    {
        ZYWWetherModel *mode = _dataArray[i];
        if (i == 0)
        {
            continue;
        }
        
        NSInteger code = [mode.imageCode integerValue];
        ZYWWetherModel *prevModel = _dataArray[i-1];
        NSInteger prevCode = [prevModel.imageCode integerValue];
        
        if (code != prevCode || _dataArray.count - 1 == i)
        {
            if (i == _dataArray.count - 1)
            {
                ZYWWetherModel *lastModel = _dataArray.lastObject;
                lastModel.isDrawImage = YES;
            }
            
            else
            {
                prevModel.isDrawImage = YES;
            }
            [self.indexArray addObject:@(i-1)];
        }
    }
}

/**
 填充方法
 */
-(void)stockFill
{
    [self layoutIfNeeded];
    [self initConfig];
    [self calcuteModelPostion];
    [self addTempView];
    [self addWetherImages];
}

-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.superScrollView = (UIScrollView*)self.superview;
    self.superScrollView.delegate = self;
}

/**
 获取任意一点的y轴坐标

 @param xAxis x轴坐标
 @return y轴坐标
 */
-(CGFloat)getLableyAxisWithX:(CGFloat)xAxis;
{
    CGPoint startPoint,endPoint;
    NSInteger index;
    CGFloat sum = self.leftMargin;
    for (index = 0; index < _dataArray.count; index++)
    {
        sum += self.lineSpace;
        if (xAxis < sum)
        {
            startPoint = CGPointMake(_modelPostionArray[index].xPosition, _modelPostionArray[index].yPosition);
            _currentIndex = index;
            break;
        }
    }
   
    for (NSInteger i = 0; i < self.indexArray.count; i++)
    {
        if (index +1 <= [_indexArray[i] integerValue])
        {
            _imageIndex = [_indexArray[i] integerValue];
            break;
        }
    }

    if (index + 1 >= _dataArray.count)
    {
        _imageIndex = [_indexArray.lastObject integerValue];
        return _modelPostionArray[_dataArray.count-1].yPosition;
    }
    
    endPoint = CGPointMake(_modelPostionArray[index+1].xPosition, _modelPostionArray[index+1].yPosition);
    CGFloat k = (endPoint.y - startPoint.y) / (endPoint.x -startPoint.x);
    CGFloat y = k *(xAxis - startPoint.x) + startPoint.y;
    return y;
}

@end
