//
//  ServiceTermViewController.m
//  BaseProject
//
//  Created by 刘子琨 on 16/1/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "ServiceTermViewController.h"

@interface ServiceTermViewController ()
//@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ServiceTermViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"服务条款";
    
    [self setNavigationBar];
    
    

//    [self.textView scrollRangeToVisible:NSMakeRange(0, 1)];
////    [self.textView scrollRectToVisible:CGRectMake(0, 0, self.textView.frame.size.width, self.textView.frame.size.height) animated:YES];

    //目前由于UITextView初始化时需设置containter，声明成属性时存在文字不在第一行的问题，改为直接声明变量
    UITextView * textView = [[UITextView alloc] init];
    textView.editable = NO;
    textView.text = @"1 特别提示\n1.1云检(以下简称本软件)按照本协议的规定提供基于商品CA认证的相关服务，服务使用人（以下称用户）应当同意本协议的全部条款并按照页面上的提示下载，并安装使用。用户在下载安装过程中点击同意按钮即表示用户完全接受本协议项下的全部条款。\n1.2本软件提供商为浙江云检科技有限公司(以下简称本公司)。\n\n2 服务内容\n2.1本软件服务的具体内容主要是指通过本软件扫描本公司提供的商检码、涂层标签、NFC芯片，可以直接读取商品的相关信息，以及产品的检验状态。本公司保留变更、中断或终止部分或全部服务的权利。\n\n3 使用规则\n3.1用户在'申请使用本软件服务时，无须注册，下载安装后即可使用。\n3.2用户在使用本软件服务过程中，必须遵循以下原则：\n(a)	遵守中国有关的法律和法规；\n(b)	不得为任何非法目的而使用本软件；\n(c)	遵守所有与本软件有关的协议、规定和程序；\n3.3本软件在对商品上的认证认证码、涂层标签、NFC芯片进行扫描认证时，必须遵循以下原则：\n(a)	扫描信息显示“经检验检疫放行”表示产品抽检合格；\n(b)	扫描信息显示'检验中'表示产品还未通过检验，请勿购买或使用；\n(c)	扫描信息显示“不合格”表示产品检验 不合格，请勿购买或使用；\n(d)	扫描信息显示“紧急召回”表示产品被紧急召回，请勿购买或使用，并及时联系厂家要求退货或更换；\n\n4 内容所有权\n4.1本软件提供的服务内容可能包括：文字、图片等。所有这些内容受版权、商标和其它财产所有权受法律的保护。\n4.2用户只有在获得本公司的授权之后才能使用这些内容，而不能擅自复制、再造这些 内容、或创造与内容有关的派生产品。\n\n5 免责声明\n5.1用户明确同意其使用本软件服务所存在的风险将完全由其自己承担；因其使用本软件服务而产生的一切后果也由其自己承担，本公司对用户不承担任何责任。\n5.2本软件用于扫描非本公司提供的商检码、涂层标签、NFC芯片，而无法识别的，本公司对用户不承担任何责任。\n5.3对于因不可抗力或本公司不能控制的原因造成的查询服务中断或其它缺陷，本公司不承担任何责任，但将尽力减少因此而给用户造成的损失和影响。\n\n6 服务变更、中断或终止\n6.1如因软件维护或升级的需要而需暂停服务，本公司将尽可能事先进行通告。\n6.2如发生下列任何一种情形，本公司有权随时中断或终止向用户提供本协议项下的服务而无需通知用户：\n(a)	本软件被非法使用;\n(b)	用户违反本协议中规定的使用规则。\n\n7 违约赔偿\n7.1用户在享有本软件提供的服务的同时，同意保障和维护本公司的利益，如因用户违反有关法律、法规或本协议项下的任何条款而给本公司造成损失，用户同意承担由此造成的损害赔偿责任。\n\n8 协议修改\n8.1本公司将有权随时修改本协议的有关条款，一旦本协议的内容发生变动，本公司将会通过适当方式向用户提示修改内容。\n8.2如果不同意本公司对本协议相关条款所做的修改，用户有权停止使用本软件服务。如果用户继续使用本软件服务，则视为用户接受本公司对本协议相关条款所做的修改。\n\n9 法律管辖\n9.1本协议的订立、执行和解释及争议的解决均应适用中国法律。\n9.2如双方就本协议内容或其执行发生任何争议，双方应尽量友好协商解决；协商不成时，任何一方均可向本公司所在地的人民法院提起诉讼。\n\n10 通知和送达\n10.1本协议项下所有的通知均通过在本软件页面公告方式进行；该通知于发送之日视为已送达软件用户。\n\n11 其他规定\n11.1本协议构成双方对本协议之约定事项的完整协议，除本协议规定的之外，未赋予本协议各方其他权利。\n11.2如本协议中的任何条款无论因何种原因完全或部分无效或不具有执行力，本协议的其余条款仍应有效并且有约束力。";
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"服务条款"];//("PageOne"为页面名称，可自定义)
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"服务条款"];
}


-(void)setNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(21);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor colorWithRed:52/255.0 green:181/255.0 blue:254/255.0 alpha:1.0];
    label.text = @"服务条款";
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
    [button addTarget:self action:@selector(backToPreferenceViewController) forControlEvents:UIControlEventTouchUpInside];
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

-(void)backToPreferenceViewController
{
    [self.navigationController popViewControllerAnimated:YES];
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
