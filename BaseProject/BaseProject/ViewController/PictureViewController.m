//
//  PictureViewController.m
//  CACheck
//
//  Created by 刘子琨 on 15/10/26.
//  Copyright (c) 2015年 刘子琨. All rights reserved.
//

#import "PictureViewController.h"
#import "UIImageView+WebCache.h"
#import "RecordDetailViewController.h"
#import "SDCycleScrollView.h"


@interface PictureViewController ()<UIScrollViewDelegate>{

UIImage* srcImage;

CGFloat currentScale;
}
@property (nonatomic , strong)UIImageView *imageView;
@property (nonatomic , strong)UIView *gestureView;
@property (nonatomic , strong)UIScrollView *scrollView;
@end

@implementation PictureViewController

UIImage* srcImage;

CGFloat currentScale;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
  
    // Do any additional setup after loading the view.
//    NSLog(@"%@",self.url);
//    NSLog(@"%@",self.urlArray);
//    NSLog(@"%ld",self.index);
    //图片展示
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width * (self.urlArray.count ), self.imageView.image.size.height);
    
    
    
    
    for (int i = 0; i < self.urlArray.count; i++) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        [self.scrollView addSubview:self.imageView];
        [self.imageView sd_setImageWithURL:[self.urlArray objectAtIndex:i]];
       

        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.imageView.userInteractionEnabled = YES;
        self.imageView.multipleTouchEnabled = YES;
        
        UIPinchGestureRecognizer *gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
        [self.imageView addGestureRecognizer:gesture];
    }
    [self choseImageAtIndex:self.index];

    [self.view addSubview:self.scrollView];
    

   
    //为imageview添加轻拍手手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
//     给imageView添加手势
    [self.view addGestureRecognizer:tapGesture];


    

    self.gestureView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height)];
    //    self.gestureView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.gestureView];
    
    
    
    
    [self.gestureView addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];

    
    
    
    /*
//    self.view.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:73.0/255.0 blue:73.0/255.0 alpha:1.0];

    self.gestureView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height)];
//    self.gestureView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.gestureView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        scrollView.contentSize = CGSizeMake(self.imageView.frame.size.width,self.imageView.frame.size.height);
    

    [self.gestureView addSubview:scrollView];
    [scrollView addSubview:self.imageView];
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
    [self.gestureView addGestureRecognizer:pinchGesture];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 180.0/667*kScreenHeight,  self.view.frame.size.width, 300/667.0*kScreenHeight)];
    [self.gestureView addSubview:self.imageView];
//    self.imageView.backgroundColor= [UIColor redColor];
    if (self.url != nil) {
        
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.url] placeholderImage:nil];
//        [self imageCompressForSize:self.imageView.image targetSize:CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height)];
        [self imageCompressForWidth:self.imageView.image targetWidth:self.imageView.frame.size.height];
        
    }else{
        self.imageView.image = [self.urlArray firstObject];
    }


    //为imageview添加轻拍手手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    // 给imageView添加手势
    [self.gestureView addGestureRecognizer:tapGesture];
     */
}
-(void)choseImageAtIndex:(NSInteger)index
{
    index = self.index;
    [self.scrollView setContentOffset:CGPointMake(index * self.view.frame.size.width, 0) animated:YES];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"将要开始滑动");
   
    


    
}


-(void)tapGestureAction:(UITapGestureRecognizer *)sender
{
    //NSLog(@"点击了图片");
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"图片" forKey:@"pic"];

    self.suger = @"图片";
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)pinchAction:(UIPinchGestureRecognizer *)pinchGesture
{
    //NSLog(@"检测到捏合手势");
    //检测到捏合手势，然后我们让gestureView缩放
    self.gestureView.transform = CGAffineTransformScale(self.gestureView.transform, pinchGesture.scale, pinchGesture.scale);
    //上次捏合的比例置为1
    pinchGesture.scale = 1;
    
}

-(void)tapAction:(UIPinchGestureRecognizer *)sender
{
    //    NSLog(@"-------------");
    sender.view.transform = CGAffineTransformScale(sender.view.transform, sender.scale, sender.scale);
    sender.scale = 1;
    //NSLog(@"触摸了");
    NSLog(@"%ld", sender.view.tag);
    //判断代理是否存在并且完成了代理方法
//    if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(jumpToOneViewControllerWithIndex:)]) {
//        [self.myDelegate jumpToOneViewControllerWithIndex:sender.view.tag];
//    }
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"详情页图片"];
    self.navigationController.navigationBar.alpha = 0;
//      self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"详情页图片"];
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
