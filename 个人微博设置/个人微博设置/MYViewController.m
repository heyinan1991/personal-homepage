//
//  MYViewController.m
//  个人微博设置
//
//  Created by xuchuangnan on 15/8/14.
//  Copyright (c) 2015年 xuchuangnan. All rights reserved.
//

#import "MYViewController.h"
#import "UIImage+Image.h"

#define kHeaderViewH 200
#define kTabBarViewH 44

#define kHeaderViewMinH 64

@interface MYViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewH;
/**
 *  记录初始scrollView的conffset的Y值
 */
@property(nonatomic,assign) CGFloat oricalOffSetY;

@property(nonatomic, weak) UILabel *nameLabel;

@end

@implementation MYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // scrollView的初始位置的contentoffSet的Y值
    self.oricalOffSetY = - (kHeaderViewH + kTabBarViewH);
    
    // 设置额外滚动区域
    self.tableView.contentInset = UIEdgeInsetsMake(kHeaderViewH + kTabBarViewH, 0, 0, 0);
    
    // ios默认会给导航控制器里所有scrollView斗会添加额外的滚动区域64
    // 设置不需要这块滚动该区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setUpNav];
}
#pragma mark - 设置导航条内容
- (void)setUpNav
{
    
    // 设置导航条透明
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    // 设置背景阴影
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    // 设置导航条标题
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.textColor = [UIColor colorWithWhite:0 alpha:0];
    nameLabel.text = @"我的主页";
    // label自适应文字
    [nameLabel sizeToFit];
    self.nameLabel = nameLabel;
    self.navigationItem.titleView = self.nameLabel;
}

#pragma mark - 数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}
#pragma mark - 代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 记录目前的scrollView的contentOffSet的Y值,就能计算出来滚动了多少,就可以计算出头视图的Y值要移动多少,这里是直接改变它的高度给一种视觉感受,老师这样说的,装逼
    CGFloat offsetY = scrollView.contentOffset.y;
    // 计算目前的偏移量的差
    CGFloat delat  = offsetY - _oricalOffSetY;
    // 计算目前头视图的高应该是多少
    CGFloat headerH = kHeaderViewH - delat;
 
    // 当头部视图当然高为64时就不能在往上缩进
    if (headerH<kHeaderViewMinH) {
        headerH = kHeaderViewMinH;
    }
       // 将计算出来的值给头视图 的高
    self.headerViewH.constant =headerH;
    
    // 设置alpha让导航控制条的背景慢慢显示出来
    // 根据比例计算alpha的值
    CGFloat alpha = delat / (kHeaderViewH - kHeaderViewMinH);
    if (alpha > 1) {
        alpha = 0.99;
    }
    self.nameLabel.textColor = [UIColor colorWithWhite:0 alpha:alpha];
    // 设置导航条的背景
    UIColor *navC = [UIColor colorWithWhite:1 alpha:alpha];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:navC] forBarMetrics:UIBarMetricsDefault];
    
}

@end
