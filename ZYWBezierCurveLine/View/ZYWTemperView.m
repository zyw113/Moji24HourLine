//
//  ZYWTemperView.m
//  ZYWBezierCurveLine
//
//  Created by 张有为 on 2017/6/1.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ZYWTemperView.h"

#define RADIUS 5
#define AllowSize  CGSizeMake(6, 6)

@interface ZYWTemperView()

@property (nonatomic,strong) CAShapeLayer *lineLayer;
@property (nonatomic,strong) UILabel *tempLabel;
@property (nonatomic,strong) UIImageView *wetherImage;

@end

@implementation ZYWTemperView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.alpha = 0.5;
        [self addCirLayer];
        [self addSubview];
    }
    return self;
}

-(void)addCirLayer
{
    self.lineLayer = [CAShapeLayer layer];
    self.lineLayer.strokeColor = [UIColor clearColor].CGColor;
    self.lineLayer.fillColor = [[UIColor whiteColor] CGColor];
    self.lineLayer.lineWidth = 1;
    self.lineLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.lineLayer];
    
    CGSize size = self.size;
    UIBezierPath *path = [UIBezierPath bezierPath];
    double offsetH = size.height - RADIUS*2 - AllowSize.height;
    double offsetW = (size.width - RADIUS*2)/2;
    CGPoint point = CGPointMake(RADIUS, 0);
    [path moveToPoint:point];
    point.x += size.width - RADIUS*2;
    point.y += RADIUS;
    [path addArcWithCenter:point radius:RADIUS startAngle:M_PI*3/2 endAngle:0 clockwise:YES];
    point.x += RADIUS;
    point.y += offsetH;
    [path addLineToPoint:point];
    point.x -= RADIUS;
    [path addArcWithCenter:point radius:RADIUS startAngle:0 endAngle:M_PI/2 clockwise:YES];
    point.y += RADIUS;
    point.x -= offsetW;
    [path addLineToPoint:point];
    point.x -= AllowSize.width/2;
    point.y += AllowSize.height;
    [path addLineToPoint:point];
    point.x -= AllowSize.width/2;
    point.y -= AllowSize.height;
    [path addLineToPoint:point];
    point.x-= offsetW;
    [path addLineToPoint:point];
    point.y -= RADIUS;
    [path addArcWithCenter:point radius:RADIUS startAngle:M_PI/2 endAngle:M_PI clockwise:YES];
    point.x -= RADIUS;
    point.y -= offsetH;
    [path addLineToPoint:point];
    point.x += RADIUS;
    [path addArcWithCenter:point radius:RADIUS startAngle:M_PI endAngle:M_PI*3/2 clockwise:YES];
    [path closePath];
    self.lineLayer.path = path.CGPath;
}

-(void)addSubview
{
    _tempLabel = [UILabel new];
    [self addSubview:_tempLabel];
    _tempLabel.textColor = [UIColor colorWithHexString:@"CD3333"];
    _tempLabel.font = [UIFont systemFontOfSize:14];
    [_tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(5));
        make.centerY.equalTo(self);
    }];
    
    _wetherImage = [UIImageView new];
    [self addSubview:_wetherImage];
    [_wetherImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-5));
        make.centerY.equalTo(self);
        make.size.mas_offset(CGSizeMake(30, 30));
        make.left.mas_greaterThanOrEqualTo(_tempLabel.mas_right).offset(5);
    }];
}

-(void)setDate:(NSString *)date
{
    if (_date != date)
    {
        _date = date;
        _tempLabel.text = _date;
    }
}

-(void)setImageName:(NSString *)imageName
{
    if (_imageName != imageName)
    {
        _imageName = imageName;
        _wetherImage.image = [UIImage imageNamed:_imageName];
    }
}

@end
