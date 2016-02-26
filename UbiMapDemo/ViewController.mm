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

#define HEIGHT self.view.frame.size.height

#define WIDTH  self.view.frame.size.width

@interface ViewController ()

@property(strong,nonatomic)UbiMapDownloader*filedown;

@property(strong,nonatomic)UbiMapView *map;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UbiMap";
    
    //初始化mapdonw类
    _filedown = [[UbiMapDownloader alloc] init];
    NSInteger mapId = 1000361;
    //调用资源文件加载
    [_filedown downResourceWithStatus:^(int status) {
        if (status != 3) {
            //在状态码不为3的时候，调动map文件加载
            [_filedown downMapsWithMapId:mapId Status:^(int status) {
                if (status != 3) {
                    //资源，map以准备完成，加载地图
                    _map = [[UbiMapView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) WithMapId:mapId];
                    [self.view addSubview:_map];
                    
                    //更新点，角度，跟随模式测试
                    
                    [self layoutView];
                }
            }];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//测试数据为随机生成，无规律性
//移动测试
- (void)movePoint{
    [_map refreshPosition:CGPointMake(arc4random()%10/10.f, arc4random()%10/10.f)];
}
//转向测试
- (void)rotatoAngle{
    [_map refreshAngle:arc4random()%360];
}
//跟随模式
- (void)followModel{
    [_map followMode];
}

- (void)layoutView{
    UIButton *point = [[UIButton alloc] initWithFrame:CGRectMake(10.f, HEIGHT - 60.f, (WIDTH-40.f)/3.f, 40.f)];
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
                     
}
@end
