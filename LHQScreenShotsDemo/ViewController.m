//
//  ViewController.m
//  LHQScreenShotsDemo
//
//  Created by hq.Lin on 2020/5/2.
//  Copyright © 2020 hq.Lin. All rights reserved.
//

/**
 https://blog.csdn.net/weixin_34348805/article/details/92461029
 
 */

#import "ViewController.h"
#import "UITableView+Screenshot.h"
#import "UIImage+Extension.h"

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Screen Shots";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    /*
     
     UITableViewStyleGrouped样式，
     只有一组分区时
     会发生
     [self.tableView headerViewForSection:0]; 的值为nil 或者
     [self.tableView footerViewForSection:0]; 的值为nil
     暂时不知道为何？
     
      现在换成 UITableViewStylePlain样式，修改区头尾悬停效果。
     */
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX ? 84 : 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-(kDevice_Is_iPhoneX ? 84 : 64)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20);
    self.tableView.tableHeaderView = view;
    self.tableView.tableFooterView = view;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    [self.view addSubview:self.tableView];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"share" style:UIBarButtonItemStyleDone target:self action:@selector(shareAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)shareAction
{
    CGPoint contentOffset = self.tableView.contentOffset;
    CGRect originFrame = self.tableView.frame;
    // 偏移量置为zero 是因为， 滑动一定距离第一个区头部消失后 第一个区头部获取不到
    // 然后 却没有什么用 使用scrollToRowAtIndexPath 发现有个滚动效果体验不是很好。
//    self.tableView.contentOffset = CGPointZero;
//    self.tableView.scrollsToTop = YES;
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    self.tableView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.contentSize.height);
    // TableView 内容图
    __block UIImage *tableViewImage;
    tableViewImage = [self.tableView tableViewContentSizeSnapshot];
    // 导航栏图
    UIImage *navImage = [self.tableView screenShotWithShotView:self.navigationController.navigationBar];
    // 拼接
    UIImage *image = [UIImage verticalImageFromArray:@[navImage, tableViewImage]];

    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    self.tableView.frame = originFrame;
    self.tableView.contentOffset = contentOffset;
}

//指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功，可到相册查看" ;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"截图成功，已保存至相册" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:sureAction];

    [self presentViewController:alert animated:YES completion:nil];

    
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 5;
    }
    
    if (section == 1) {
        return 8;
    }
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld-%ld",indexPath.section,indexPath.row];
    return cell;;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    /**
     Header/Footer也要像UITableViewCell一样指定Identifier，否则你用headerViewForSection:方法来获取Head/Footer的结果只能为nil
     */
    
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
//    headerView.backgroundColor = [UIColor redColor];
//    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] init];
   UILabel *v = [UILabel new];
    v.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    v.backgroundColor = [UIColor redColor];
    v.text = [NSString stringWithFormat:@"头部-%ld",section];
    [headerView addSubview:v];

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footer"];
//    UITableViewHeaderFooterView *footerView = [[UITableViewHeaderFooterView alloc] init];
//    footerView.backgroundColor = [UIColor orangeColor];
    UILabel *v = [UILabel new];
    v.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    v.backgroundColor = [UIColor orangeColor];
    v.text = [NSString stringWithFormat:@"尾部-%ld",section];
    [footerView addSubview:v];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if (scrollView == self.tableView)
//    {
//        UITableView *tableview = (UITableView *)scrollView;
//        CGFloat sectionHeaderHeight = 30;
//        CGFloat sectionFooterHeight = 30;
//        CGFloat offsetY = tableview.contentOffset.y;
//        if (offsetY >= 0 && offsetY <= sectionHeaderHeight)
//        {
//            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -sectionFooterHeight, 0);
//
//        }else if (offsetY >= sectionHeaderHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight)
//        {
//            tableview.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, -sectionFooterHeight, 0);
//        }else if (offsetY >= tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight && offsetY <= tableview.contentSize.height - tableview.frame.size.height)
//        {
//            tableview.contentInset = UIEdgeInsetsMake(-offsetY, 0, -(tableview.contentSize.height - tableview.frame.size.height - sectionFooterHeight), 0);
//        }
//    }
//}



@end
