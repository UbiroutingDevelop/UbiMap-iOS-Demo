//
//  ViewController.m
//  UbiMapDemo
//
//  Created by 刘涛 on 16/2/25.
//  Copyright © 2016年 ShiTu. All rights reserved.
//

#import "ViewController.h"
#import "UbiMapDownloader.h"
#import "UbiMapView.h"
#import "UbiMapModel.h"
#import "UbiMapArea.h"
#import "UbiMapMark.h"
#import "UbiMapFile.h"

#define HEIGHT self.view.frame.size.height

#define WIDTH  self.view.frame.size.width

@interface ViewController ()<mapViewDataDelegate>

@property(strong,nonatomic)UbiMapDownloader*filedown;

@property(strong,nonatomic)UbiMapView *map;

@property(strong,nonatomic)UbiMapModel *data;

@property(strong,nonatomic)UbiMapModel *startPoint;

@property(strong,nonatomic)UbiMapModel *endPoint;

@property(strong,nonatomic)UbiMapFile *file;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UbiMap";
    
    //初始化mapdonw类
    _filedown = [[UbiMapDownloader alloc] init];
    NSInteger mapId = 1001086;
    //调用资源文件加载
    [_filedown downResourceWithStatus:^(int status) {
        if (status != 3) {
            //在状态码不为3的时候，调动map文件加载
            [_filedown downMapsWithMapId:mapId Status:^(int status) {
                if (status != 3) {
                    //资源，map以准备完成，加载地图
                    _map = [[UbiMapView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) WithMapId:mapId];
                    _map.dataDelegate = self;
                    
                    [self.view addSubview:_map];
                    
                    //更新点，角度，跟随模式测试
                    
                    [self layoutView];
                }
            }];
        }
    }];
    //不加载地图，只读map文件信息
//    _file = [[UbiMapFile alloc]initWithMapId:1001086];
//    UbiMapFile *file = _file;
//    _file.dataLoading = ^{
//        NSLog(@"%@",file.allData);
//    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getclickAreaData:(UbiMapModel *)data{
    NSLog(@"%d",[data isMemberOfClass:[UbiMapArea class]]);
    NSLog(@"%d",[data isMemberOfClass:[UbiMapMark class]]);
    self.data = data;
}
//测试数据为随机生成，无规律性
//移动测试
- (void)movePoint{
    [_map refreshPosition:CGPointMake(arc4random()%1000, arc4random()%400)];
}
//转向测试
- (void)rotatoAngle{
    [_map refreshAngle:arc4random()%360];
}
//跟随模式
- (void)followModel{
    [_map followMode];
}
- (void)chooseStart{
    self.startPoint = self.data;
    [_map setAsStart:_startPoint];
}
- (void)chooseEnd{
    self.endPoint = self.data;
    [_map setAsEnd:_endPoint];

}
- (void)renderLine{
    [_map navigateWithStart:_startPoint andEnd:_endPoint];
}
- (void)chooseCurrent{
    [_map setCurrentPositionAsStart];
}
- (void)layoutView{
    UIButton *point = [[UIButton alloc] initWithFrame:CGRectMake(10.f, HEIGHT - 100.f, (WIDTH-40.f)/3.f, 40.f)];
    [point setTitle:@"移动" forState:UIControlStateNormal];
    [point setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [point addTarget:self action:@selector(movePoint) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:point];
    
    UIButton *angle = [[UIButton alloc] initWithFrame:CGRectMake(point.frame.origin.x+point.frame.size.width+10.f, point.frame.origin.y, point.frame.size.width, 40.f)];
    [angle setTitle:@"旋转" forState:UIControlStateNormal];
    [angle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [angle addTarget:self action:@selector(rotatoAngle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:angle];
    
    
    UIButton *follow = [[UIButton alloc] initWithFrame:CGRectMake(angle.frame.origin.x+angle.frame.size.width+10.f, angle.frame.origin.y, angle.frame.size.width, 40.f)];
    [follow setTitle:@"跟随" forState:UIControlStateNormal];
    [follow setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [follow addTarget:self action:@selector(followModel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:follow];
    
    UIButton *start = [[UIButton alloc] initWithFrame:CGRectMake(10.f, HEIGHT - 50.f, (WIDTH-40.f)/3.f, 40.f)];
    [start setTitle:@"起点" forState:UIControlStateNormal];
    [start setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [start addTarget:self action:@selector(chooseStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:start];
    
    UIButton *current = [[UIButton alloc] initWithFrame:CGRectMake(10.f, HEIGHT - 150.f, (WIDTH-40.f)/3.f, 40.f)];
    [current setTitle:@"当前点" forState:UIControlStateNormal];
    [current setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [current addTarget:self action:@selector(chooseCurrent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:current];
    
    
    
    UIButton *end = [[UIButton alloc] initWithFrame:CGRectMake(start.frame.origin.x+start.frame.size.width+10.f, start.frame.origin.y, start.frame.size.width, 40.f)];
    [end setTitle:@"终点" forState:UIControlStateNormal];
    [end setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [end addTarget:self action:@selector(chooseEnd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:end];
    
    
    UIButton *line = [[UIButton alloc] initWithFrame:CGRectMake(end.frame.origin.x+end.frame.size.width+10.f, end.frame.origin.y, end.frame.size.width, 40.f)];
    [line setTitle:@"画线" forState:UIControlStateNormal];
    [line setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [line addTarget:self action:@selector(renderLine) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:line];
    
    
}
@end
