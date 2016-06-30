//
//  ScanViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ScanViewController.h"
#import "RecordDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MainViewController.h"
#import "MobClick.h"
#import "UnknowViewController.h"
#import "UnrecognizedViewController.h"
#import "UIButton+EnlargeEdge.h"

@import AVFoundation;

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,CLLocationManagerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

//管道--连接输出 输入流
@property(nonatomic,strong)AVCaptureSession *session;
//用于展示输出流到界面上的视图
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *videoLayer;

@property(nonatomic,strong)UIImageView *imageView;

@property (nonatomic , copy)NSString *authCode;//c码
@property (nonatomic , copy)NSString *barCode;//条码

@property (nonatomic , strong)CLLocationManager *myLocationManager;
@property (nonatomic , strong)CLLocation *checkinLocation;
@property (nonatomic , strong)NSString *currentlatitude;
@property (nonatomic , strong)NSString *currentLongitude;
@property (nonatomic ,strong)CLGeocoder *myGeocoder;
@property (nonatomic , strong) UIButton *btn;

@property (nonatomic , strong)UIView *alert;
@property (nonatomic , copy)NSString *labelText;

@property (nonatomic , strong)CIContext *context;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //定位
    //初始化manager对象
    self.myLocationManager = [[CLLocationManager alloc] init];
    //设置代理
    self.myLocationManager.delegate = self;
    [self.myLocationManager startUpdatingLocation];
    
    
    //获取后置摄像头的管理对象,capture:捕获
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //摄像头捕获输入流
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"error %@",error);
        return;
    }
    //创建输出流-->把图像输入到屏幕上显示
    AVCaptureMetadataOutput *output = [AVCaptureMetadataOutput new];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //需要一个管道连接输入和输出
    _session = [AVCaptureSession new];
    [_session addInput:input];
    [_session addOutput:output];
    //管道可以规定质量， 流畅/高清..
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
#warning 设置输出流监听 二维码/条形码,必须在管道接通之后设置！！！
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode93Code];
    //设置扫描区域，默认为全屏
    //output.rectOfInterest = CGRectMake(0.2f, 0.2f, 0.6f, 0.6f);
    //把画面输出到屏幕上，给用户看
    _videoLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _videoLayer.frame = self.view.frame;
    [self.view.layer addSublayer:_videoLayer];
    //启动管道
    [_session startRunning];
    
    
    //边框
    //CALayer *stroke = [CALayer layer];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height), NO, 0);
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 200, 200)];
//    path.lineWidth = 2;
//    [[UIColor greenColor] setStroke];
//    [path stroke];
//    //区域外绘图无效
//    [path addClip];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    [[[UIColor blackColor] colorWithAlphaComponent:0.7] setFill];
    [[UIColor redColor]setStroke];
    
    CGMutablePathRef screenPath = CGPathCreateMutable();
    CGPathAddRect(screenPath, NULL, self.view.bounds);
    
    CGMutablePathRef scanPath = CGPathCreateMutable();
    CGPathAddRect(scanPath, NULL, CGRectMake(0,(height-250)/2.0, width, 250));
    
    UIBezierPath *redLinePath = [UIBezierPath bezierPath];
    [redLinePath moveToPoint:CGPointMake(0, height/2.0)];
    [redLinePath addLineToPoint:CGPointMake(width, height/2.0)];
    redLinePath.lineWidth = 1;
//    CGPathMoveToPoint(redLinePath, NULL, 0, height/2.0);
//    CGPathAddLineToPoint(redLinePath, NULL, width, height/2.0);

    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddPath(path, NULL, screenPath);
    CGPathAddPath(path, NULL, scanPath);
    //画阴影
    CGContextAddPath(ctx, path);
    CGContextDrawPath(ctx, kCGPathEOFill); // kCGPathEOFill
    //描绿框
//    CGContextAddPath(ctx, scanPath);
//    CGContextDrawPath(ctx, kCGPathStroke);
    //描红线
    [redLinePath stroke];
    
    //尝试画字符串,不知道为什么文字无法居中，最后还是加了个label
//    NSString *str = @"请将商品条码/CA商检码对准红线";
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:18];
//    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.alignment = NSTextAlignmentCenter;
//    attrs[NSParagraphStyleAttributeName] = paragraphStyle;
//    //[str drawAtPoint:CGPointMake(30, 100) withAttributes:attrs];
//    // 能够根据字符串的内容,在指定宽度的情况下,算出
//    // 刚好能够装下所有文字的高度
//    CGRect strRect = [str boundingRectWithSize:CGSizeMake(width, 998) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];
//    // 画在指定的矩形区域内
//    [str drawInRect:CGRectMake(0, width/2.0+284,strRect.size.width,strRect.size.height) withAttributes:attrs];
    
    CGPathRelease(screenPath);
    CGPathRelease(scanPath);
    CGPathRelease(path);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _imageView = [[UIImageView alloc]initWithImage:image];
    [self.view addSubview:_imageView];

    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height));
        make.center.mas_equalTo(self.view);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"请将商品条码/CA商检码对准红线";
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(width/2.0 + 284);
    }];
    
    UIImageView *filterImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"滤镜"]];
    [self.view addSubview:filterImageView];
    [filterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
//    _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QrcodeBoard"]];
//    [self.view addSubview:self.imageView];
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view);
//        make.centerY.mas_equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(300, 300));
//    }];
    
    
    
    //重新设置导航栏，隐藏原生导航栏，手动绘制新的导航栏，使右滑手势跳转时能让导航栏跟着变化
    [self setNavigationBar];
    
//    EAGLContext *eaglContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
//    //NSDictionary *options = [NSDictionary dictionaryWithObject:nil forKey:kCIContextWorkingColorSpace];
//    self.context = [CIContext contextWithEAGLContext:eaglContext options:nil];
    
}

-(void)setNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"扫一扫";
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backToMainViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(80, 44));
    }];
    //手动添加highlight效果
    button.tag = 101;
    [button addTarget:self action:@selector(tapBack:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(tapUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    UIImage *image = [UIImage imageNamed:@"返回箭头"];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [button addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(13);
        make.size.mas_equalTo(CGSizeMake(11, 19));
    }];
    
    //由于改写了leftBarButtonItem,所以需要重新定义右滑返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
}

-(void)tapBack:(UIButton *)button
{
    button.alpha = 0.5;
}
-(void)tapUp:(UIButton *)button
{
    button.alpha = 1;
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //友盟页面点击统计
    [MobClick beginLogPageView:@"扫一扫"];//("PageOne"为页面名称，可自定义)
    //禁用侧滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
//    self.navigationItem.title = @"扫一扫";
//    
//    [self.navigationController setNavigationBarHidden:NO];
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
//
//    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
//    
//    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.btn.frame = CGRectMake(0, 0, 80, 44);
//    self.btn.userInteractionEnabled = YES;
//    [self.btn setTitle:@"返回" forState:UIControlStateNormal];
//    UIImage *image = [UIImage imageNamed:@"返回箭头"];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 13, 11, 19)];
//    
//    imageView.image = image;
//    [self.btn addSubview:imageView];
//    
//    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:self.btn];
//    self.navigationItem.leftBarButtonItem = back;
//    
//    
//    imageView.userInteractionEnabled = YES;
//    self.btn.userInteractionEnabled = YES;
//    //[self.navigationController.navigationBar addSubview:self.btn];
//    
//    
//    [self.btn addTarget: self action: @selector(backToMainViewController) forControlEvents: UIControlEventTouchUpInside];
//    
//    //由于改写了leftBarButtonItem,所以需要重新定义右滑返回手势
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"扫一扫"];//友盟页面统计
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)backToMainViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}





#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //NSLog(@"locations is %@",locations);
    
    CLLocation *location = [locations lastObject];
    
    self.currentLongitude = [NSString stringWithFormat:@"%lf", location.coordinate.longitude];
    //将纬度现实到label上
    self.currentlatitude = [NSString stringWithFormat:@"%lf", location.coordinate.latitude];
    
    //NSLog(@"%10@",self.currentLongitude);
    //NSLog(@"%10@",self.currentlatitude);
    
    //    if (![WGS84TOGCJ02 isLocationOutOfChina:[location coordinate]]) {
    //        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:location.coordinate];
    //        NSLog(@"%f/%f",coord.latitude,coord.longitude);
    //
    //        CLLocation *loc = [[CLLocation alloc]initWithLatitude:coord.latitude longitude:coord.longitude];
    
    
    self.myGeocoder = [[CLGeocoder alloc] init];
    [self.myGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(error == nil && [placemarks count]>0)
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {////四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             
             NSString *subThoroughfare=placemark.subThoroughfare;
//             NSLog(@"%@",subThoroughfare);
//             NSLog(@"name = %@",placemark.name);
//             NSLog(@"!!!%@",city);
//             NSLog(@"%@",placemark);
             
             self.positionInfo = placemark.name;
//             NSLog(@"%@",self.positionInfo);
             
         }
         else if(error==nil && [placemarks count]==0){
             NSLog(@"No results were returned.");
         }
         else if(error != nil) {
             NSLog(@"An error occurred = %@", error);
         }
     }];
    //    }
    [self.myLocationManager stopUpdatingLocation];
}


#pragma mark - 当扫描到我们想要的数据时，触发
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    //metadataObjects 数组中 存放的就是扫描出得数据
    if (metadataObjects.count>0)
    {
        //如果扫描到，关闭管道，去掉扫描显示
        [_session stopRunning];
        //[_videoLayer removeFromSuperlayer];
        //[_imageView removeFromSuperview];
        //拿到扫描到得数据
        AVMetadataMachineReadableCodeObject *obj = metadataObjects.firstObject;
        if (obj.stringValue.length > 0)
        {
            //判断是否为带http的c码
            if ([obj.stringValue rangeOfString:@"http"].location != NSNotFound)
            {
//                NSLog(@"有http");
                //NSLog(@"...%@",obj.stringValue);
                NSString *productInfoId = nil;
                NSString *token = @"c=";
                NSRange range = [obj.stringValue rangeOfString:token];
                if (range.location != NSNotFound)
                {
                    productInfoId = [obj.stringValue substringFromIndex:range.location+token.length];
                    range = [productInfoId rangeOfString:@"&"];
                    if (range.location != NSNotFound)
                    {
                        productInfoId = [productInfoId substringToIndex:range.location];
                    }
                }else
                {
                    //
                }
                if ([productInfoId length] > 0)
                {

                    self.authCode = productInfoId;
                    [self getDataWithString:self.authCode];
                    
                    RecordDetailViewController *recordDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"recordDetailViewController"];
                    recordDetailVC.judgeStr = self.authCode;
                    recordDetailVC.codeStr = productInfoId;//防止二维码码值没有28位导致调用错误的接口
                    recordDetailVC.sugueStr = @"scan";
                    recordDetailVC.date = [self getNowDate];
                    recordDetailVC.onlyStr = @"扫描页";
                    
                    MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];

                    [self.navigationController pushViewController:recordDetailVC animated:YES];
                    
                    //跳转后直接将扫描页从navigationController中移除，返回时直接返回主页面，跳过扫描页
                    [self.navigationController setViewControllers:@[mainVC,recordDetailVC] animated:YES];
                    
                    [_videoLayer removeFromSuperlayer];
                    [_imageView removeFromSuperview];
                }
                //二维码不识别 http://weixin.qq.com/r/10xmfp3EIsBdrdkd9xnF
                else
                {
   
                    NSLog(@"认证码格式错误");
                    
                    self.alert = [[UIView alloc] initWithFrame:CGRectMake(33.5/320.0*kScreenWidth, 202/568.0*kScreenHeight, self.view.frame.size.width - 2 * 33.5/320.0*kScreenWidth, 110/568.0*kScreenHeight)];
                    self.alert.backgroundColor = [UIColor whiteColor];
                    self.alert.clipsToBounds = YES;
                    self.alert.layer.cornerRadius = 6.0;
                    self.alert.layer.borderWidth = 1.0;
                    self.alert.layer.borderColor = [[UIColor whiteColor] CGColor];
                    
                    [self.view addSubview:self.alert];
                    
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 19, 62/667.0*kScreenHeight, 62/667.0*kScreenHeight)];
                    imageView.image = [UIImage imageNamed:@"地球"];
                    
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 17/568.0*kScreenWidth, 16/568.0*kScreenHeight, 120/320.0*kScreenWidth, 13)];
                    label.text = @"二维码内容:";
                    label.font = [UIFont systemFontOfSize:13];
                    label.textColor = UIColorFromRGB(0x3e3e3e);
                    [self.alert addSubview:label];
                    
                    
                    
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                    button.frame = CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame) + 16/568.0*kScreenHeight, self.alert.frame.size.width - imageView.frame.size.width - 14/320.0*kScreenWidth - 17/320.0*kScreenWidth, 30/320.0*kScreenWidth);
                    //点击方法还未实现，实现时记得去除扫描框，其实不去除好像也没事
                    //[_videoLayer removeFromSuperlayer];
                    //[_imageView removeFromSuperview];
                    [button addTarget:self action:@selector(enterWeb) forControlEvents:UIControlEventTouchUpInside];
                    //                button.backgroundColor = [UIColor cyanColor];
                    
                    [self.alert addSubview:button];
                    
                    
                    
                    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x, CGRectGetMaxY(label.frame) + 16/568.0*kScreenHeight, 150/320.0*kScreenWidth, 30/320.0*kScreenWidth)];
                    label2.text = obj.stringValue;
                    //                label2.backgroundColor = [UIColor redColor];
                    self.labelText = label2.text;
                    label2.numberOfLines = 0;
                    label2.font = [UIFont systemFontOfSize:12];
                    label2.textColor = UIColorFromRGB(0x3db6fb);
                    [self.alert addSubview:label2];
                    
                    UIImageView *smallView = [[UIImageView alloc] initWithFrame:CGRectMake((253-20)/320.0*kScreenWidth, label2.frame.origin.y+10, 7, 12)];
                    smallView.image = [UIImage imageNamed:@"互联网提示－箭头"];
                    //                smallView.backgroundColor = [UIColor redColor];
                    [self.alert addSubview:smallView];
                    
                    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x,CGRectGetMaxY(label2.frame) + 16/568.0*kScreenHeight, 180/320.0*kScreenWidth, 11)];
                    label3.text = @"无法确认网址安全性，谨慎访问";
                    label3.numberOfLines = 0;
                    label3.font = [UIFont systemFontOfSize:11];
                    label3.textColor = UIColorFromRGB(0x646464);
                    [self.alert addSubview:label3];
                    
                    UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame), label.frame.origin.y, 10, 10)];
                    [closeButton setImage:[UIImage imageNamed:@"叉"] forState:UIControlStateNormal];
                    [closeButton addTarget:self action:@selector(closeAlert:) forControlEvents:UIControlEventTouchUpInside];
                    [closeButton setEnlargeEdge:20];
                    [self.alert addSubview:closeButton];
                    
                    [self.alert addSubview:imageView];
                }

            }
            else{
                //NSLog(@"条码执行区域");
                NSString *str = obj.stringValue;
                //NSLog(@"%@",str);
                self.barCode = str;
#pragma mark 如果是十三位的纯数字，则说明是条码,14位的是zara的条码
                if ([self isPureFloat:self.barCode] && self.barCode.length >= 10 && self.barCode.length <= 14)
                {
                    //zara的条码
                    if (self.barCode.length == 14) {
                        self.barCode = [self.barCode substringToIndex:11];
                    }
                    [self getDataWithString:self.barCode];
#warning 此处代码方法有问题
                    //                [self postInfoToServer];
                    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
                    NSString *stringInt = [NSString stringWithFormat:@"%d",0];
                    [manager.requestSerializer setValue:stringInt forHTTPHeaderField:@"Client-Flag"];
                    NSString *url = [NSString stringWithFormat:@"%@/%@%@",kUrl,kbarCodeUrl,self.barCode];
                    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        if ([responseObject[@"Result"] integerValue] == 0) {
                            RecordDetailViewController *recordDetailVC = [[RecordDetailViewController alloc] init];
                            recordDetailVC.judgeStr = self.barCode;
                            
                            recordDetailVC.onlyStr = @"扫描页";
                            
                            NSString *date = [self getNowDate];
                            recordDetailVC.date = date;
                            
                            MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
                            
                            [self.navigationController pushViewController:recordDetailVC animated:YES];
                            
                            //跳转后直接将扫描页从navigationController中移除，返回时直接返回主页面，跳过扫描页
                            [self.navigationController setViewControllers:@[mainVC,recordDetailVC] animated:YES];
                            
                            [_videoLayer removeFromSuperlayer];
                            [_imageView removeFromSuperview];
                            
                        }else{
                            //没有查到该商品的信息（仅供参考）
//                            NSLog(@"%@",responseObject[@"FailInfo"]);
//                            NotRecognitionViewController *notVC = [[NotRecognitionViewController alloc] init];
//                            notVC.textStr = s.data;
//                            [self.navigationController pushViewController:notVC animated:YES];
                            UnrecognizedViewController *unrecVC = [[UnrecognizedViewController alloc]init];
                            [self.navigationController pushViewController:unrecVC animated:YES];
                            MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
                            //跳转后直接将扫描页从navigationController中移除，返回时直接返回主页面，跳过扫描页
                            [self.navigationController setViewControllers:@[mainVC,unrecVC] animated:YES];
                            
                            
                        }

                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        NSLog(@"%@",error);
                    }];
                    
                    
//                    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//                    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//                    NSString *stringInt = [NSString stringWithFormat:@"%d",0];
//                    [manager.requestSerializer setValue:stringInt forHTTPHeaderField:@"Client-Flag"];
//                    NSString *url = [NSString stringWithFormat:@"%@/%@%@",kUrl,kbarCodeUrl,s.data];
//                    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                        NSLog(@"%@",responseObject);
//                        if ([responseObject[@"Result"] integerValue] == 0) {
//                            RecordDetailViewController *recordDetailVC = [[RecordDetailViewController alloc] init];
//                            [self.navigationController pushViewController:recordDetailVC animated:YES];
//                            recordDetailVC.barCode = s.data;
//                            
//                            recordDetailVC.onlyStr = @"扫描页";
//                            
//                            NSString *date = [self getNowDate];
//                            recordDetailVC.date = date;
//                            
//                            NSLog(@"%@",recordDetailVC.barCode);
//                        }else{
//                            //没有查到该商品的信息（仅供参考）
//                            NSLog(@"%@",responseObject[@"FailInfo"]);
//                            NotRecognitionViewController *notVC = [[NotRecognitionViewController alloc] init];
//                            notVC.textStr = s.data;
//                            [self.navigationController pushViewController:notVC animated:YES];
//                            
//                            
//                        }
//                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                        NSLog(@"%@",error);
//                    }];
                }
                //如果不是条码，则文本显示
                else {
                    NSString *str = nil;
                    //                    if ([s.data canBeConvertedToEncoding:NSShiftJISStringEncoding]) {
                    //
                    //                        str = [NSString stringWithCString:[s.data cStringUsingEncoding:NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];//防止乱码
                    //                        NSLog(@"%@",str);
                    //                    }else{
                    //                        str = s.data;
                    //                    }
                    if ([obj.stringValue canBeConvertedToEncoding:NSShiftJISStringEncoding])
                    {
                        str = [NSString stringWithCString:[obj.stringValue cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];//防止乱码
                        
                        
                    }else{
                        str = obj.stringValue;
                    }
                    
                    UnknowViewController *unknowVC = [[UnknowViewController alloc] init];
                    unknowVC.urlString = str;
                    MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
                    [self.navigationController pushViewController:unknowVC animated:YES];
                    [self.navigationController setViewControllers:@[mainVC,unknowVC] animated:YES];
                    return;
                }
                
                //将s.data发送给后台，进行判断
                //                RecordDetailViewController *recordDetailVC = [[RecordDetailViewController alloc] init];
                //                [self.navigationController pushViewController:recordDetailVC animated:YES];
                //                recordDetailVC.barCode = s.data;
                //                NSLog(@"%@",recordDetailVC.barCode);
            }

        }
        
    }
}

//-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
//{
//    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
//    CIImage *outputImage = [[CIImage alloc]initWithCVPixelBuffer:imageBuffer];
//    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectMono"];
//    [filter setValue:outputImage forKey:@"kCIInputImageKey"];
//    outputImage = filter.outputImage;
//    
//    
//}


-(void)enterWeb
{
    UnknowViewController *unknowVC = [self.storyboard instantiateViewControllerWithIdentifier:@"unknowViewController"];
    unknowVC.urlString = self.labelText;
    MainViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mainViewController"];
    [self.navigationController pushViewController:unknowVC animated:YES];
    [self.navigationController setViewControllers:@[mainVC,unknowVC] animated:YES];
}

- (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

-(void)closeAlert:(UIButton *)sender
{
    NSLog(@"closeAlert");
    [self.alert removeFromSuperview];
    [_session startRunning];
}


//获取当前日期
-(NSString *)getNowDate
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    //NSLog(@"%@",locationString);
    return locationString;
}

//获取用户的位置信息以及手机型号
-(void)getDataWithString:(NSString *)string;
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *catoken = [userDefaults objectForKey:@"CA-Token"];
    [manager.requestSerializer setValue:catoken forHTTPHeaderField:@"CA-Token"];
    NSString *stringInt = [NSString stringWithFormat:@"%d",0];
    [manager.requestSerializer setValue:stringInt forHTTPHeaderField:@"Client-Flag"];
    
    
    
    
//    NSLog(@"%@",self.positionInfo);
//    NSLog(@"%@",self.currentlatitude);
//    NSLog(@"%@",self.currentLongitude);
    NSString *strSysVersion = [[UIDevice currentDevice] systemVersion];
//    NSLog(@"系统版本号：%@", strSysVersion);
    NSString* phoneModel = [[UIDevice currentDevice] model];
//    NSLog(@"手机型号: %@",phoneModel );
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
//    NSLog(@"%f,%f",width,height);
    NSString *winsize= [NSString stringWithFormat:@"%.2f*%.2f",width,height];
//    NSLog(@"%@",winsize);
    NSString *username = [userDefaults objectForKey:@"username"];
    NSString *userid = [userDefaults objectForKey:@"userid"];
    NSString *roleid = [userDefaults objectForKey:@"roleid"];
    
    
//    NSLog(@"%@/%@",userid,roleid);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    if (self.authCode == nil) {
        if (self.positionInfo == nil) {
            [dic setValue:string forKey:@"barCode"];
            [dic setValue:phoneModel forKey:@"model"];
            [dic setValue:strSysVersion forKey:@"versioninfo"];
            [dic setValue:winsize forKey:@"winsize"];
            [dic setValue:phoneModel forKey:@"manufacturer"];
            
            
        }else{
            [dic setValue:string forKey:@"barCode"];
            [dic setValue:phoneModel forKey:@"model"];
            [dic setValue:strSysVersion forKey:@"versioninfo"];
            [dic setValue:winsize forKey:@"winsize"];
            [dic setValue:phoneModel forKey:@"manufacturer"];
            [dic setValue:self.positionInfo forKey:@"uposition"];
            [dic setValue:self.currentlatitude forKey:@"latitude"];
            [dic setValue:self.currentLongitude forKey:@"longitude"];
            
            
            
            
        }
        
    }if (self.barCode == nil) {
        if (self.positionInfo == nil) {
            [dic setValue:string forKey:@"authCode"];
            [dic setValue:phoneModel forKey:@"model"];
            [dic setValue:strSysVersion forKey:@"versioninfo"];
            [dic setValue:winsize forKey:@"winsize"];
            [dic setValue:phoneModel forKey:@"manufacturer"];
            
        }else{
            [dic setValue:string forKey:@"authCode"];
            [dic setValue:phoneModel forKey:@"model"];
            [dic setValue:strSysVersion forKey:@"versioninfo"];
            [dic setValue:winsize forKey:@"winsize"];
            [dic setValue:phoneModel forKey:@"manufacturer"];
            [dic setValue:self.positionInfo forKey:@"uposition"];
            [dic setValue:self.currentlatitude forKey:@"latitude"];
            [dic setValue:self.currentLongitude forKey:@"longitude"];
            
            
        }
    }
    
    if ([userDefaults objectForKey:@"userid"]) {
        
        [dic setValue:userid forKey:@"userid"];
    }
    if ([userDefaults objectForKey:@"username"]) {
        [dic setValue:username forKey:@"username"];
    }
    if ([userDefaults objectForKey:@"roleid"]) {
        [dic setValue:roleid forKey:@"roleid"];
    }
    //NSLog(@"%@",dic);
    NSString *str = [self dictionaryToJson:dic];
    
    NSDictionary *param = @{@"json":str};
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kPositionInfoUrl];
    
    [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//把字典转化成json串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
