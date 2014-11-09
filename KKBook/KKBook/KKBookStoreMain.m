//
//  KKBookStorList.m
//  KKBooK
//
//  Created by PromptNow on 11/4/2557 BE.
//  Copyright (c) 2557 GLive. All rights reserved.
//

#import "KKBookStoreMain.h"
#import "BannerModel.h"
#import "StoreScrollingTableViewCell.h"
#import "KKBookStoreDetailVC.h"
#import "BaseNavigationController.h"

@interface KKBookStoreMain ()<StoreScrollingTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSArray *images;
@property(strong, nonatomic) NSArray *dataSource;

@end

@implementation KKBookStoreMain

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBannerView];
    [self initTable];
    [self loadStoreMainData];
    //[self dummyTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //[_myPageScrollView reloadData];
}

-(void)initBannerView{
    _myPageDataArray = [[NSMutableArray alloc] initWithCapacity : 4];
    
    for (int i=1; i<=4; i++) {
        BannerModel *banner = [[BannerModel alloc] init];
        banner.bannerImage = [NSString stringWithFormat:@"image%d", i];
        [_myPageDataArray addObject:banner];
    }
    
    CGRect frame = CGRectMake(10, 5, CHILD_WIDTH, 154);
    
    // now that we have the data, initialize the page scroll view
    //_myPageScrollView = [[[NSBundle mainBundle] loadNibNamed:HGPageScrollViewNIB owner:self options:nil] objectAtIndex:0];
    
    _myPageScrollView = [[HGPageScrollView alloc] initWithFrame:frame];
    _myPageScrollView.delegate = self;
    _myPageScrollView.dataSource = self;
    [self.view addSubview:_myPageScrollView];
    [_myPageScrollView reloadData];
}

#pragma mark -
#pragma mark HGPageScrollViewDataSource


- (NSInteger)numberOfPagesInScrollView:(HGPageScrollView *)scrollView;   // Default is 0 if not implemented
{
    return [_myPageDataArray count];
}


- (HGPageView *)pageScrollView:(HGPageScrollView *)scrollView viewForPageAtIndex:(NSInteger)index;
{
    
    BannerModel *banner = [_myPageDataArray objectAtIndex:index];
    UIImage *image = [UIImage imageNamed:banner.bannerImage];
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(_myPageScrollView.frame)-20, 154);
    HGPageImageView *imageView = [[HGPageImageView alloc]
                                  initWithFrame:frame];
    [imageView setImage:image];
    [imageView setReuseIdentifier:@"imageId"];
    
    return imageView;
}

#pragma mark -
#pragma mark HGPageScrollViewDelegate

- (void) pageScrollView:(HGPageScrollView *)scrollView didSelectPageAtIndex:(NSInteger)index
{
}

#pragma mark - UITableViewDataSource

-(void)initTable{
    
    CGRect frame = CGRectMake(10, CGRectGetMaxY(_myPageScrollView.frame) + 5, CHILD_WIDTH, CGRectGetMaxY([UIScreen mainScreen].bounds) - (CGRectGetMaxY(_myPageScrollView.frame) + 64));
    NSLog(@"bact title %@",self.navigationController.navigationBar);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_tableView];
    
    
    static NSString *CellIdentifier = @"Cell";
    [self.tableView registerClass:[StoreScrollingTableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*static NSString *CellIdentifier = @"Cell";
    NSDictionary *cellData = [self.images objectAtIndex:[indexPath section]];
    StoreScrollingTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [customCell setBackgroundColor:[UIColor grayColor]];
    [customCell setDelegate:self];
    [customCell setImageData:cellData];
    [customCell setCategoryLabelText:[cellData objectForKey:@"category"] withColor:[UIColor whiteColor]];
    [customCell setTag:[indexPath section]];
    [customCell setImageTitleTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [customCell setImageTitleLabelWitdh:90 withHeight:45];
    [customCell setCollectionViewBackgroundColor:[UIColor darkGrayColor]];
    
    return customCell;*/
    
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *cellData = [self.dataSource objectAtIndex:[indexPath section]];
    StoreScrollingTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    [customCell setBackgroundColor:[UIColor grayColor]];
    [customCell setDelegate:self];
    [customCell setCategoryData:cellData];
    [customCell setCategoryLabelText:[cellData objectForKey:@"category"] withColor:[UIColor whiteColor]];
    [customCell setTag:[indexPath section]];
    [customCell setImageTitleTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    [customCell setImageTitleLabelWitdh:90 withHeight:45];
    [customCell setCollectionViewBackgroundColor:[UIColor whiteColor]];
    
    return customCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

#pragma mark - StoreScrollingTableViewCellDelegate

-(void)scrollingTableViewCell:(StoreScrollingTableViewCell *)scrollingTableViewCell didSelectBook:(BookModel *)book{
    if ([self delegate]) {
        [[self delegate] bookStoreMain:self didBook:book];
    }
}
-(void)loadStoreMainData{
    NSURLSessionTask *task = [KKBookService storeMainService:^(NSArray *source, NSError *error) {
        if (!error) {
            self.dataSource = source;
            [self.tableView reloadData];
        }
    }];
    
//    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
//    [self.refreshControl setRefreshingWithStateOfTask:task];
}

@end
