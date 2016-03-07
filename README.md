UbiMap demo
===
#1 准备工作

![alt phone](http://ubirouting.com/imageUse/UbiMap.gif)


获取识途矢量地图SDK：[https://github.com/UbiroutingDevelop/UbiMap_iOS-SDK.git](https://github.com/UbiroutingDevelop/UbiMap_iOS-SDK.git)

- include文件夹，内包含所需头文件
- libSTUBIMap.a
- Shader.bundle

将SDK文件导入工程，include文件夹中有三个声明文件，将要引用UbiMapView.h声明文件的类后缀要从“.m”修改为“.mm”。

引入静态库：libz.tbd


info.plist文件：SDK加载资源采用http模式，info.plist文件中需要加入Key:App Transport Security Settings 并在此Dictionary中加入一个item Key:Allow Arbitrary Loads  Value:YES

![alt phone](http://ubirouting.com/imageUse/ubimaplibs_info.png)

#2 SDK调用

SDK使用有两个过程，首先预下载一个资源包，然后在资源包完整的情况下载相应的地图文件，资源包需要每次检查是否需要更新，一般只需加载一次即可。

调用UbiLoader.h进行key验证,一般放在appdelegate.m中进行验证
```objective-c

	#import "UbiLoader.h"
	
	// 填入您的Key
	[UbiLoader registWithKey:@"850ad59d5a41065a75fa33672cad5004"];
```
	
资源文件，地图文件加载

```objective-c

	#import "UbiMapDownloader.h"
	
	@property(strong,nonatomic)UbiMapDownloader* filedown;
	- (void)viewDidLoad {
		_filedown = [[UbiMapDownloader alloc] init];
		//测试mapid
		_mapId = 1000361;
		[_filedown downResourceWithStatus:^(int status) {
        	if (status != 3) {
	            //在状态码不为3的时候，调动map文件加载
	            [_filedown downMapsWithMapId:mapId Status:^(int status) {
		                if (status != 3) {
		                  //进入这里表示资源文件，和相应的地图文件加载没有问题
						}
		        }];
	        }
    	}];
	}
	//status值说明，请查阅SDK注释
```
	
地图文件加载：

```objective-c
	@property(strong,nonatomic)UbiMapView *map;
	
	_map = [[UbiMapView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) WithMapId:mapId];
	[self.view addSubview:_map];
```
    
#3 定位点

##3.1 坐标

```objective-c

	/**
 	 *  更新坐标点
 	 *
 	 *  @param point locationPoint
 	 */
	- (void)refreshPosition:(CGPoint)point;
```

##3.2 角度

```objective-c
	/**
	 *  更新角度
	 *
	 *  @param angle angle
	 */
	- (void)refreshAngle:(float)angle;
```

##3.3 跟随模式

```objective-c
	/**
	 *  跟随模式，默认关闭
	 */
	- (void)followMode;
```
	
#4 地图POI介绍

识途矢量地图上包含2种POI：

- UbiMapMark，无区域的POI, 即该POI在地图上仅显示为一个单独的图标，常用来表示电梯、ATM、厕所、问讯处等。此类POI在实际环境中占据的区域较少，所以往往用一个单独的图标来表示；
 
![alt:markexample](http://www.ubirouting.com/imageUse/ubimap_mark_example.jpg)

- UbiMapArea, 区域POI, 即该POI在地图上显示为一个多边形，并且带有店铺图标和文字。常用来表示店铺、停车位等比较大的区域。

![alt:area example](http://www.ubirouting.com/imageUse/ubimap_area_example.jpg)

上述2类POI均继承自UbiMapModel.

#5 点击事件

UbiMapView.h文件增加了一个必须实现的代理，mapViewDataDelegate，这个代理是响应点击map事件后返回的模型数据，供导航以及显示信息所用：

```objective-c
	@protocol mapViewDataDelegate <NSObject>

	@required	
	/**
	 *  点击页面区域返回点击数据
	 *
	 *  @param data data为被点击区域信息
	 */
	- (void)getclickAreaData:(UbiMapModel *)data;

	@end
```

#6 导航

```objective-c

	/**
	 *  设置当前点为导航起点
	 */
	- (void)setCurrentPositionAsStart;
	/**
	 *  设置导航起点
	 *
	 *  @param point 起点数据模型对象
	 */
	- (void)setAsStart:(UbiMapModel *)point;
	/**
	 *  设置导航终点
	 *
	 *  @param point 终点数据模型对象
	 */
	- (void)setAsEnd:(UbiMapModel *)point;
	/**
	 *  绘制导航路线
	 *
	 *  @param start 起点数据模型对象 （若设置当前点为起点，start穿nil）
	 *  @param end   终点数据模型对象
	 */
	- (void)navigateWithStart:(UbiMapModel *)start andEnd:(UbiMapModel *)end;
```

#7 要点说明

1.注意,代理返回的UbiMapRegional对象其实是UbiMapArea或者UbiMapMark的一个实例对象，如果要使用子类的特有属性，请自行判断代理返回的UbiMapRegional对象，是UbiMapArea，还是UbiMapMark，然后再使用对应的属性。（isMemberOfClass:）

2.导入SDK只在，在shader.bundle文件中删除掉info.plist文件，否则影响程序上传。
