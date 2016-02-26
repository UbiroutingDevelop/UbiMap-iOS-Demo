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

	#import "UbiLoader.h"
	
	// 填入您的Key
	[UbiLoader registWithKey:@"850ad59d5a41065a75fa33672cad5004"];
	
资源文件，地图文件加载

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
	
地图文件加载：

	@property(strong,nonatomic)UbiMapView *map;
	
	
	_map = [[UbiMapView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) WithMapId:mapId];
    [self.view addSubview:_map];