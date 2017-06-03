//
//  ViewController.m
//  ZYWBezierCurveLine
//
//  Created by 张有为 on 2017/5/27.
//  Copyright © 2017年 zyw113. All rights reserved.
//

#import "ViewController.h"
#import "ZYWSlipLineView.h"
#import "ZYWWetherModel.h"

@interface ViewController ()
@property (nonatomic,strong) ZYWSlipLineView *slipLine;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  = @"滑动折线图";
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(80);
        make.height.equalTo(@(250));
    }];
    
    _slipLine = [[ZYWSlipLineView alloc] init];
    _slipLine.backgroundColor = [UIColor colorWithHexString:@"8B6969"];
    [_scrollView addSubview:_slipLine];
    [_slipLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.height.equalTo(@(200));
        make.top.equalTo(_scrollView);
    }];
    
    NSMutableArray *wetherArray = [NSMutableArray array];
    NSArray *wetherCode = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];
    for (NSInteger i = 0;i<24;i++)
    {
        NSInteger code = arc4random() % (wetherCode.count-1) +1;
        NSInteger temper = arc4random() % 30;
        NSString *time;
        if (i <9)
        {
            time = [NSString stringWithFormat:@"0%ld:00",i+1];
        }
       
        else
        {
            time = [NSString stringWithFormat:@"%ld:00",i+1];
        }
        
        ZYWWetherModel *model = [ZYWWetherModel new];
         [wetherArray addObject:model];
        model.date = time;
        model.temper = [NSString stringWithFormat:@"%ld℃",temper];
        if ((i+1) % 3 == 0)
        {
            model.imageCode = [NSString stringWithFormat:@"%ld",code];
        }
    }
    static NSInteger lastIndex = 0;
    for (NSInteger i = 0;i<wetherArray.count;i++)
    {
        if ((i+1) % 3 == 0)
        {
            for (NSInteger index = lastIndex; index<i; index++)
            {
                ZYWWetherModel *localModel = wetherArray[i];
                ZYWWetherModel *model = wetherArray[index];
                model.imageCode = [NSString stringWithFormat:@"%@",localModel.imageCode];
            }
            lastIndex = i;
        }
    }
    _slipLine.dataArray = wetherArray;
    _slipLine.leftMargin = 50;
    _slipLine.rightMargin = 50;
    _slipLine.topMargin = 10;
    _slipLine.bottomMargin = 10;
    [_slipLine stockFill];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
