//
//  FavoriteGoodsViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/6/23.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "FavoriteGoodsViewController.h"
#import <AdSupport/AdSupport.h>

#define kScreenScale (self.view.bounds.size.height/667.0)
#define kScreenWidthScale (self.view.bounds.size.width/375.0)

@interface FavoriteGoodsViewController ()
@property(strong,nonatomic)UIImageView *foodImageView;
@property(strong,nonatomic)UIImageView *momAndBabyImageView;
@property(strong,nonatomic)UIImageView *wineImageView;
@property(strong,nonatomic)UIImageView *cosmeticImageView;
@property(strong,nonatomic)UIImageView *homeApplianceImageView;
@property(strong,nonatomic)UIImageView *digitalImageView;
@property(strong,nonatomic)UIImageView *healthImageView;
@property(strong,nonatomic)UIImageView *homeFurnishingsImageView;
@property(strong,nonatomic)UIImageView *everydayUseImageView;
@property(strong,nonatomic)UIButton *confirmButton;

@property(strong,nonatomic)NSMutableArray *favorArray;

@end

@implementation FavoriteGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.favorArray = [NSMutableArray array];
    self.view.tag = 10;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favorNumArray = [userDefaults objectForKey:@"favorNumArray"];
    NSLog(@"favorArray:%@",favorNumArray);
    
    //设置喜好选择图
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.tag = 11;
    titleLabel.text = @"选择你感兴趣的进口商品";
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0){
        titleLabel.font = [UIFont fontWithName:@"PingFangSC-Thin" size:25];
    }else{
        titleLabel.font = [UIFont systemFontOfSize:25];
    }
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(78.5*kScreenScale);
    }];
    self.foodImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"食品"]];
    _foodImageView.tag = 1;
    UITapGestureRecognizer *foodTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(favorTap:)];
    [_foodImageView addGestureRecognizer:foodTap];
    _foodImageView.userInteractionEnabled = YES;
    [self.view addSubview:_foodImageView];
    [_foodImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(titleLabel.mas_bottom).mas_equalTo((60+31)*kScreenScale);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *foodLabel = [[UILabel alloc]init];
    foodLabel.text = @"食品";
    foodLabel.tag = 12;
    foodLabel.textColor = UIColorFromRGB(0xa0a0a0);
    foodLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:foodLabel];
    [foodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_foodImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_foodImageView);
    }];
    
    self.momAndBabyImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"母婴"]];
    _momAndBabyImageView.tag = 0;
    UITapGestureRecognizer *momAndBabyTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(favorTap:)];
    [_momAndBabyImageView addGestureRecognizer:momAndBabyTap];
    _momAndBabyImageView.userInteractionEnabled = YES;
    [self.view addSubview:_momAndBabyImageView];
    [_momAndBabyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_foodImageView);
        make.centerX.mas_equalTo(_foodImageView).mas_equalTo(-110.5*kScreenWidthScale);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *momAndBabyLabel = [[UILabel alloc]init];
    momAndBabyLabel.text = @"母婴";
    momAndBabyLabel.tag = 13;
    momAndBabyLabel.textColor = UIColorFromRGB(0xa0a0a0);
    momAndBabyLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:momAndBabyLabel];
    [momAndBabyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_momAndBabyImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_momAndBabyImageView);
    }];
    
    self.wineImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"酒类"]];
    _wineImageView.tag = 2;
    UITapGestureRecognizer *wineTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(favorTap:)];
    [_wineImageView addGestureRecognizer:wineTap];
    _wineImageView.userInteractionEnabled = YES;
    [self.view addSubview:_wineImageView];
    [_wineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_foodImageView);
        make.centerX.mas_equalTo(_foodImageView).mas_equalTo(110.5*kScreenWidthScale);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *wineLabel = [[UILabel alloc]init];
    wineLabel.text = @"酒类";
    wineLabel.textColor = UIColorFromRGB(0xa0a0a0);
    wineLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:wineLabel];
    [wineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_wineImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_wineImageView);
    }];
    
    self.cosmeticImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"彩妆护肤"]];
    _cosmeticImageView.tag = 3;
    UITapGestureRecognizer *cosmeticTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(favorTap:)];
    [_cosmeticImageView addGestureRecognizer:cosmeticTap];
    _cosmeticImageView.userInteractionEnabled = YES;
    [self.view addSubview:_cosmeticImageView];
    [_cosmeticImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_momAndBabyImageView);
        make.centerY.mas_equalTo(_momAndBabyImageView).mas_equalTo(110.5*kScreenWidthScale);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *cosmeticLabel = [[UILabel alloc]init];
    cosmeticLabel.text = @"彩妆护肤";
    cosmeticLabel.textColor = UIColorFromRGB(0xa0a0a0);
    cosmeticLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:cosmeticLabel];
    [cosmeticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_cosmeticImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_cosmeticImageView);
    }];
    
    self.homeApplianceImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"家电"]];
    _homeApplianceImageView.tag = 4;
    UITapGestureRecognizer *homeApplianceTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(favorTap:)];
    [_homeApplianceImageView addGestureRecognizer:homeApplianceTap];
    _homeApplianceImageView.userInteractionEnabled = YES;
    [self.view addSubview:_homeApplianceImageView];
    [_homeApplianceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(_cosmeticImageView);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *homeApplianceLabel = [[UILabel alloc]init];
    homeApplianceLabel.text = @"家电";
    homeApplianceLabel.textColor = UIColorFromRGB(0xa0a0a0);
    homeApplianceLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:homeApplianceLabel];
    [homeApplianceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_homeApplianceImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_homeApplianceImageView);
    }];
    
    self.digitalImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"数码"]];
    _digitalImageView.tag = 5;
    UITapGestureRecognizer *digitalTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(favorTap:)];
    [_digitalImageView addGestureRecognizer:digitalTap];
    _digitalImageView.userInteractionEnabled = YES;
    [self.view addSubview:_digitalImageView];
    [_digitalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_wineImageView);
        make.centerY.mas_equalTo(_cosmeticImageView);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *digitalLabel = [[UILabel alloc]init];
    digitalLabel.text = @"数码";
    digitalLabel.textColor = UIColorFromRGB(0xa0a0a0);
    digitalLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:digitalLabel];
    [digitalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_digitalImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_digitalImageView);
    }];
    
    self.healthImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"保健"]];
    _healthImageView.tag = 6;
    UITapGestureRecognizer *healthTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(favorTap:)];
    [_healthImageView addGestureRecognizer:healthTap];
    _healthImageView.userInteractionEnabled = YES;
    [self.view addSubview:_healthImageView];
    [_healthImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_cosmeticImageView);
        make.centerY.mas_equalTo(_cosmeticImageView).mas_equalTo(110.5*kScreenWidthScale);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *healthLabel = [[UILabel alloc]init];
    healthLabel.text = @"保健";
    healthLabel.textColor = UIColorFromRGB(0xa0a0a0);
    healthLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:healthLabel];
    [healthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_healthImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_healthImageView);
    }];
    
    self.homeFurnishingsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"家居"]];
    _homeFurnishingsImageView.tag = 7;
    UITapGestureRecognizer *homeFurnishingsTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(favorTap:)];
    _homeFurnishingsImageView.userInteractionEnabled = YES;
    [_homeFurnishingsImageView addGestureRecognizer:homeFurnishingsTap];
    [self.view addSubview:_homeFurnishingsImageView];
    [_homeFurnishingsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(_healthImageView);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *homeFurnishingsLabel = [[UILabel alloc]init];
    homeFurnishingsLabel.text = @"家居";
    homeFurnishingsLabel.textColor = UIColorFromRGB(0xa0a0a0);
    homeFurnishingsLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:homeFurnishingsLabel];
    [homeFurnishingsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_homeFurnishingsImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_homeFurnishingsImageView);
    }];
    
    self.everydayUseImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"日用品"]];
    _everydayUseImageView.tag = 8;
    UITapGestureRecognizer *everydayUseTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(favorTap:)];
    _everydayUseImageView.userInteractionEnabled = YES;
    [_everydayUseImageView addGestureRecognizer:everydayUseTap];
    [self.view addSubview:_everydayUseImageView];
    [_everydayUseImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_digitalImageView);
        make.centerY.mas_equalTo(_healthImageView);
        make.size.mas_equalTo(CGSizeMake(0, 0));
    }];
    UILabel *everydaysUseLabel = [[UILabel alloc]init];
    everydaysUseLabel.text = @"日用品";
    everydaysUseLabel.textColor = UIColorFromRGB(0xa0a0a0);
    everydaysUseLabel.font = [UIFont systemFontOfSize:11];
    [self.view addSubview:everydaysUseLabel];
    [everydaysUseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_everydayUseImageView.mas_centerY).mas_equalTo(42*kScreenWidthScale);
        make.centerX.mas_equalTo(_everydayUseImageView);
    }];
    
    self.confirmButton = [[UIButton alloc]init];
    [_confirmButton setTitle:@"确 定" forState:UIControlStateNormal];
    _confirmButton.titleLabel.textColor = [UIColor whiteColor];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _confirmButton.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    _confirmButton.layer.cornerRadius = 4;
    _confirmButton.layer.masksToBounds = YES;
    _confirmButton.userInteractionEnabled = YES;
    [_confirmButton addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_confirmButton];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(45*kScreenWidthScale);
        make.right.mas_equalTo(-45*kScreenWidthScale);
        make.bottom.mas_equalTo(-64*kScreenScale);
        make.height.mas_equalTo(44*kScreenScale);
    }];
    
    
    for (NSString *favorNum in favorNumArray) {
        //[self.view viewWithTag:[favorNum integerValue]];
        [self.favorArray addObject:[NSString stringWithFormat: @"%ld",[favorNum integerValue]]];
        UIImageView *selectedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"喜好已勾选"]];
        selectedImageView.tag = 101;
        [[self.view viewWithTag:[favorNum integerValue]] addSubview:selectedImageView];
        [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
//            make.right.mas_equalTo([self.view viewWithTag:[favorNum integerValue]].center).mas_equalTo(31);
//            make.top.mas_equalTo([self.view viewWithTag:[favorNum integerValue]].center).mas_equalTo(-31);
            make.size.mas_equalTo([self.view viewWithTag:[favorNum integerValue]]).multipliedBy(21/62.0);
        }];

    }

}

-(void)favorTap:(UIGestureRecognizer *)tap
{
    if ([[tap view]viewWithTag:101]) {
        [self.favorArray removeObject:[NSString stringWithFormat: @"%ld",[tap view].tag]];
        [[[tap view]viewWithTag:101] removeFromSuperview];
    }else{
        [self.favorArray addObject:[NSString stringWithFormat: @"%ld",[tap view].tag]];
        UIImageView *selectedImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"喜好已勾选"]];
        selectedImageView.tag = 101;
        [[tap view] addSubview:selectedImageView];
        [selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
            make.size.mas_equalTo([tap view]).multipliedBy(21/62.0);
        }];
    }
    NSLog(@"favorArray:%@",_favorArray);
    if (_favorArray.count == 0) {
        _confirmButton.userInteractionEnabled = NO;
        _confirmButton.backgroundColor = UIColorFromRGB(0xd3d3d3);
    }else{
        _confirmButton.userInteractionEnabled = YES;
        _confirmButton.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    }
}

-(void)confirmClick:(UIButton *)sender
{
    NSString *favor = [[NSString alloc]init];
    NSMutableArray *favorWordArray = [NSMutableArray array];
    for (NSString *str in _favorArray) {
        switch ([str integerValue]) {
            case 0:
                favor = @"母婴";
                break;
            case 1:
                favor = @"食品";
                break;
            case 2:
                favor = @"酒类";
                break;
            case 3:
                favor = @"彩妆护肤";
                break;
            case 4:
                favor = @"家电";
                break;
            case 5:
                favor = @"数码";
                break;
            case 6:
                favor = @"保健";
                break;
            case 7:
                favor = @"家居";
                break;
            case 8:
                favor = @"日用品";
                break;
                
            default:
                break;
        }
        [favorWordArray addObject:favor];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:favorWordArray forKey:@"favorArray"];
    [userDefaults setObject:_favorArray forKey:@"favorNumArray"];
    [userDefaults setObject:@"NO" forKey:@"isUploadedFavor"];
    [userDefaults synchronize];
    [self uploadFavor];
    [self.navigationController popViewControllerAnimated:YES];
    //NSLog(@"favorWordArray:%@",favorWordArray);
}

-(void)uploadFavor
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //唯一标示idfa
    NSString *identifierForAdvertising = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    NSArray *favorArray = [userDefaults objectForKey:@"favorArray"];
    NSString *favorStr = [[NSString alloc]init];
    for (NSString *favor in favorArray) {
        favorStr = [favorStr stringByAppendingString:[NSString stringWithFormat:@"%@,",favor]];
    }
    favorStr = [favorStr substringToIndex:favorStr.length-1];
    NSLog(@"favorStr:%@",favorStr);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    NSString *url = [NSString stringWithFormat:@"%@/%@",kUrl,kUserFavorUrl];
    NSDictionary *dic = @{@"idfa":identifierForAdvertising,@"favors":favorStr};
    NSString *paramStr = [self dictionaryToJson:dic];
    NSDictionary *paramDic = @{@"json":paramStr};
    [manager POST:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"upload resonseObject:%@",responseObject);
        [userDefaults setObject:@"YES" forKey:@"isUploadedFavor"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"uploadFavor error:%@",error);
    }];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"感兴趣商品页面"];//("PageOne"为页面名称，可自定义)
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"感兴趣商品页面"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0 animations:^{
            [_momAndBabyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(0, 0));
            }];
            [_momAndBabyImageView setNeedsLayout];
            [_momAndBabyImageView layoutIfNeeded];
            [_foodImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(0, 0));
            }];
            [_foodImageView setNeedsLayout];
            [_foodImageView layoutIfNeeded];
            [_wineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(0, 0));
            }];
            [_wineImageView setNeedsLayout];
            [_wineImageView layoutIfNeeded];
            [_cosmeticImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(0, 0));
            }];
            [_cosmeticImageView setNeedsLayout];
            [_cosmeticImageView layoutIfNeeded];
            [_homeApplianceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(0, 0));
            }];
            [_homeApplianceImageView setNeedsLayout];
            [_homeApplianceImageView layoutIfNeeded];
            [_digitalImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(0, 0));
            }];
            [_digitalImageView setNeedsLayout];
            [_digitalImageView layoutIfNeeded];
            [_healthImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(0, 0));
            }];
            [_healthImageView setNeedsLayout];
            [_healthImageView layoutIfNeeded];
            [_homeFurnishingsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(0, 0));
            }];
            [_homeFurnishingsImageView setNeedsLayout];
            [_homeFurnishingsImageView layoutIfNeeded];
            [_everydayUseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(0, 0));
            }];
            [_everydayUseImageView setNeedsLayout];
            [_everydayUseImageView layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.0714 animations:^{
            [_momAndBabyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            [_momAndBabyImageView setNeedsLayout];
            [_momAndBabyImageView layoutIfNeeded];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.0714 relativeDuration:0.0714 animations:^{
            [_momAndBabyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(41, 41));
            }];
            [_momAndBabyImageView setNeedsLayout];
            [_momAndBabyImageView layoutIfNeeded];
            [_foodImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            [_foodImageView setNeedsLayout];
            [_foodImageView layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.1428 relativeDuration:0.0714 animations:^{
            [_momAndBabyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_momAndBabyImageView setNeedsLayout];
            [_momAndBabyImageView layoutIfNeeded];
            [_foodImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(41, 41));
            }];
            [_foodImageView setNeedsLayout];
            [_foodImageView layoutIfNeeded];
            [_wineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            [_wineImageView setNeedsLayout];
            [_wineImageView layoutIfNeeded];
            
        }];
        [UIView addKeyframeWithRelativeStartTime:0.2142 relativeDuration:0.0714 animations:^{
            [_momAndBabyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(70, 70));
            }];
            [_momAndBabyImageView setNeedsLayout];
            [_momAndBabyImageView layoutIfNeeded];
            [_foodImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_foodImageView setNeedsLayout];
            [_foodImageView layoutIfNeeded];
            [_wineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(41, 41));
            }];
            [_wineImageView setNeedsLayout];
            [_wineImageView layoutIfNeeded];
            [_cosmeticImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            [_cosmeticImageView setNeedsLayout];
            [_cosmeticImageView layoutIfNeeded];
            
        }];
        [UIView addKeyframeWithRelativeStartTime:0.2856 relativeDuration:0.0714 animations:^{
            [_momAndBabyImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_momAndBabyImageView setNeedsLayout];
            [_momAndBabyImageView layoutIfNeeded];
            [_foodImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(70, 70));
            }];
            [_foodImageView setNeedsLayout];
            [_foodImageView layoutIfNeeded];
            [_wineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_wineImageView setNeedsLayout];
            [_wineImageView layoutIfNeeded];
            [_cosmeticImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(41, 41));
            }];
            [_cosmeticImageView setNeedsLayout];
            [_cosmeticImageView layoutIfNeeded];
            [_homeApplianceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            [_homeApplianceImageView setNeedsLayout];
            [_homeApplianceImageView layoutIfNeeded];
            
        }];
        [UIView addKeyframeWithRelativeStartTime:0.357 relativeDuration:0.0714 animations:^{
            [_foodImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_foodImageView setNeedsLayout];
            [_foodImageView layoutIfNeeded];
            [_wineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(70, 70));
            }];
            [_wineImageView setNeedsLayout];
            [_wineImageView layoutIfNeeded];
            [_cosmeticImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_cosmeticImageView setNeedsLayout];
            [_cosmeticImageView layoutIfNeeded];
            [_homeApplianceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(41, 41));
            }];
            [_homeApplianceImageView setNeedsLayout];
            [_homeApplianceImageView layoutIfNeeded];
            [_digitalImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            [_digitalImageView setNeedsLayout];
            [_digitalImageView layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.4284 relativeDuration:0.0714 animations:^{
            [_wineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_wineImageView setNeedsLayout];
            [_wineImageView layoutIfNeeded];
            [_cosmeticImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(70, 70));
            }];
            [_cosmeticImageView setNeedsLayout];
            [_cosmeticImageView layoutIfNeeded];
            [_homeApplianceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_homeApplianceImageView setNeedsLayout];
            [_homeApplianceImageView layoutIfNeeded];
            [_digitalImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(41, 41));
            }];
            [_digitalImageView setNeedsLayout];
            [_digitalImageView layoutIfNeeded];
            [_healthImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            [_healthImageView setNeedsLayout];
            [_healthImageView layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.4998 relativeDuration:0.0714 animations:^{
            [_cosmeticImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_cosmeticImageView setNeedsLayout];
            [_cosmeticImageView layoutIfNeeded];
            [_homeApplianceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(70, 70));
            }];
            [_homeApplianceImageView setNeedsLayout];
            [_homeApplianceImageView layoutIfNeeded];
            [_digitalImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_digitalImageView setNeedsLayout];
            [_digitalImageView layoutIfNeeded];
            [_healthImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(41, 41));
            }];
            [_healthImageView setNeedsLayout];
            [_healthImageView layoutIfNeeded];
            [_homeFurnishingsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            [_homeFurnishingsImageView setNeedsLayout];
            [_homeFurnishingsImageView layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5712 relativeDuration:0.0714 animations:^{
            [_homeApplianceImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_homeApplianceImageView setNeedsLayout];
            [_homeApplianceImageView layoutIfNeeded];
            [_digitalImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(70, 70));
            }];
            [_digitalImageView setNeedsLayout];
            [_digitalImageView layoutIfNeeded];
            [_healthImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_healthImageView setNeedsLayout];
            [_healthImageView layoutIfNeeded];
            [_homeFurnishingsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(41, 41));
            }];
            [_homeFurnishingsImageView setNeedsLayout];
            [_homeFurnishingsImageView layoutIfNeeded];
            [_everydayUseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            [_everydayUseImageView setNeedsLayout];
            [_everydayUseImageView layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.6426 relativeDuration:0.0714 animations:^{
            [_digitalImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_digitalImageView setNeedsLayout];
            [_digitalImageView layoutIfNeeded];
            [_healthImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(70, 70));
            }];
            [_healthImageView setNeedsLayout];
            [_healthImageView layoutIfNeeded];
            [_homeFurnishingsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_homeFurnishingsImageView setNeedsLayout];
            [_homeFurnishingsImageView layoutIfNeeded];
            [_everydayUseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(41, 41));
            }];
            [_everydayUseImageView setNeedsLayout];
            [_everydayUseImageView layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.714 relativeDuration:0.0714 animations:^{
            [_healthImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_healthImageView setNeedsLayout];
            [_healthImageView layoutIfNeeded];
            [_homeFurnishingsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(70, 70));
            }];
            [_homeFurnishingsImageView setNeedsLayout];
            [_homeFurnishingsImageView layoutIfNeeded];
            [_everydayUseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_everydayUseImageView setNeedsLayout];
            [_everydayUseImageView layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.7854 relativeDuration:0.0714 animations:^{
            [_homeFurnishingsImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_homeFurnishingsImageView setNeedsLayout];
            [_homeFurnishingsImageView layoutIfNeeded];
            [_everydayUseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(70, 70));
            }];
            [_everydayUseImageView setNeedsLayout];
            [_everydayUseImageView layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.8568 relativeDuration:0.0714 animations:^{
            [_everydayUseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(62, 62));
            }];
            [_everydayUseImageView setNeedsLayout];
            [_everydayUseImageView layoutIfNeeded];
        }];
        [UIView addKeyframeWithRelativeStartTime:0.9282 relativeDuration:0.0714 animations:^{
            
        }];
        
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
