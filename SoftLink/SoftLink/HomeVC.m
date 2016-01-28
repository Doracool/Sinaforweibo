//
//  HomeVC.m
//  SoftLink
//
//  Created by qingyun on 16/1/18.
//  Copyright © 2016年 河南青云信息技术有限公司. All rights reserved.
//

#import "HomeVC.h"
#import "Common.h"
#import "Account.h"
#import <AFHTTPSessionManager.h>
#import "statusCell.h"
#import "NSString+StringSize.h"
#import "UINavigationController+notifation.h"
#import "StatusFooterView.h"
#import "StatusModel.h"
#import "UserModel.h"
#import "DataBaseEngine.h"
@interface HomeVC ()
@property (nonatomic, strong) NSArray *statusData;
@property (nonatomic) BOOL refreing;//正在加载中
@end

@implementation HomeVC


-(void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:kLoginSuccess object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
-(void)loadData
{
    NSString *url = [kBaseURL stringByAppendingPathComponent:@"statuses/home_timeline.json"];
    
    NSMutableDictionary *params = [[Account shareAccount] requestParams];
    
    if (!params) {
        //没有登录，不能做请求
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //从服务器获取的数据
        NSArray *result = responseObject[@"statuses"];
        //将json数据转化为model
        NSMutableArray *modelArray = [NSMutableArray array];
        
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            StatusModel *model = [[StatusModel alloc] initWithDictionary:obj];
            [modelArray addObject:model];
        }];
        
        //用模型作为数据源
        self.statusData = modelArray;
        [self.tableView reloadData];
        
        //缓存到数据库
        [DataBaseEngine saveStatuses:result];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error---%@",error);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化refreshcontrol
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadNew:) forControlEvents:UIControlEventValueChanged];
    
    [self setrefreshcontrolTitle:@"下拉加载更多"];
 
    //tableView注册footerView的xib文件
    [self.tableView registerNib:[UINib nibWithNibName:@"StatusFootView" bundle:nil] forHeaderFooterViewReuseIdentifier:@"StatusFootView"];
    
    //从数据库中查询数据
    self.statusData = [DataBaseEngine selectedStatuses];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)loadNew:(UIRefreshControl *)control
{
    //触发加载更多
    [self setrefreshcontrolTitle:@"正在加载"];
    
    //请求更新的数据
    NSString *url = [kBaseURL stringByAppendingString:@"/statuses/home_timeline.json"];
    
    NSMutableDictionary *params = [[Account shareAccount] requestParams];
    [params setObject:[self.statusData.firstObject statusID] forKey:@"since_id"];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //将新的数据放在数组的最前边
        NSArray *result = [responseObject objectForKey:@"statuses"];
        
        NSMutableArray *modelArray = [NSMutableArray array];
        
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            StatusModel *model = [[StatusModel alloc] initWithDictionary:obj];
            
            [modelArray addObject:model];
        
        }];
        
        //追加上以前的数据构成最新的数据
        [modelArray addObjectsFromArray:self.statusData];
        self.statusData = modelArray;
        [self.tableView reloadData];
        
//        NSMutableArray *array = [NSMutableArray arrayWithArray:responseObject[@"statuses"]];
//        [array addObjectsFromArray:self.statusData];
//        
//        self.statusData = array;
//        
//        //首先更新数据，然后更新UI
//        [self.tableView reloadData];
        
        [self.refreshControl endRefreshing];
        [self setrefreshcontrolTitle:@"下拉加载更多"];
        
        [self.navigationController showNotification:[NSString stringWithFormat:@"更新了 %ld 数据",[responseObject[@"statuses"] count]]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self.refreshControl endRefreshing];
        [self setrefreshcontrolTitle:@"下拉加载更多"];
    }];
}

-(void)setrefreshcontrolTitle:(NSString *)title{
       NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor orangeColor]};
    NSAttributedString *att = [[NSAttributedString alloc] initWithString:title attributes:dic];
    self.refreshControl.attributedTitle = att;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadMore
{
    //加载更多
    NSString *url = [kBaseURL stringByAppendingPathComponent:@"/statuses/home_timeline.json"];
    NSMutableDictionary *params = [[Account shareAccount] requestParams];
    if (!params) {
        return;
    }
    
    [params setObject:[self.statusData.lastObject statusID] forKey:@"max_id"];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    if (self.refreing) {
        //有正在进行的请求
        return;
    }
    self.refreing = YES;
    [session GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *statuses = responseObject[@"statuses"];
        
        NSMutableArray *modelArray = [NSMutableArray array];
        
        [statuses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            StatusModel *model = [[StatusModel alloc] initWithDictionary:obj];
            
            [modelArray addObject:model];
        }];
        
        //追加上新的数据构成新的数据源
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.statusData];
        [array addObjectsFromArray:modelArray];
        self.statusData = array;
        [self.tableView reloadData];
        
        self.refreing = NO;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.refreing = NO;
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return self.statusData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    statusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell" forIndexPath:indexPath];
    
    //绑定数据
    [cell bandingStatus:self.statusData[indexPath.section]];
//     _titleH = cell.content.frame.size.height;
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.statusData.count - 1 - indexPath.section == 3) {
        //倒数第三条
        [self loadMore];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }
    return 10.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    StatusFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"StatusFootView"];
    [footer bandingStatus:self.statusData[section]];
    return footer;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
#if 0
    NSString *text = self.statusData[indexPath.row][@"text"];
    CGFloat width = KscreenBounds.size.width -16;
    
    CGSize size = [text stringSizeWith:width Font:[UIFont systemFontOfSize:17]];
    
    return 64 + size.height + 1;
     
#else
    statusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"statusCell"];
    [cell bandingStatus:self.statusData[indexPath.section]];
    
    return [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
#endif
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
