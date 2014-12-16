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
#import "UIAlertView+AFNetworking.h"
#import "InternetChecking.h"

#define BANNER_HEIGHT [Utility isPad] ? 308 : 154

@interface KKBookStoreMain ()<StoreScrollingTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>{
    unsigned long maxBanner;
    unsigned long currentBanner;
}

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSArray *images;
@property(strong, nonatomic) NSArray *dataSource;

@end

@implementation KKBookStoreMain

- (void)viewDidLoad {
    [super viewDidLoad];
    maxBanner = 0;
    currentBanner = 0;
    if ([InternetChecking isConnectedToInternet]) {
        [self initBannerView];
        [self initTable];
        [self loadBanner];
        [self loadStoreMainData];
        [self initTimer];
    }else{
        [BaseViewController showAlertNotConnectInternet];
    }
    
    //[self dummyTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initTimer];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initTimer];
    //[_myPageScrollView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopAndDeleteTimer];
}

-(void)loadBanner{
    //[self showProgressLoading];
    NSURLSessionTask *task = [KKBookService requestBannerService:^(NSArray *source, NSError *error) {
        //[self dismissProgress];
        if (!error) {
            _myPageDataArray = [[NSMutableArray alloc] initWithArray:source];
            currentBanner = 0;
            maxBanner = _myPageDataArray.count;
            [_myPageScrollView reloadData];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
}

-(void)initBannerView{
    _myPageDataArray = [[NSMutableArray alloc] initWithCapacity : 4];
    
    for (int i=1; i<=4; i++) {
        BannerModel *banner = [[BannerModel alloc] init];
        banner.bannerImage = [NSString stringWithFormat:@"image%d", i];
        [_myPageDataArray addObject:banner];
    }
    currentBanner = 0;
    maxBanner = _myPageDataArray.count;
    CGRect frame = CGRectMake(10, 5, CHILD_WIDTH, BANNER_HEIGHT);
    
    // now that we have the data, initialize the page scroll view
    //_myPageScrollView = [[[NSBundle mainBundle] loadNibNamed:HGPageScrollViewNIB owner:self options:nil] objectAtIndex:0];
    
    _myPageScrollView = [[HGPageScrollView alloc] initWithFrame:frame];
    _myPageScrollView.delegate = self;
    _myPageScrollView.dataSource = self;
    [self.view addSubview:_myPageScrollView];
    //[_myPageScrollView reloadData];
}
-(void)addNavigationItem{
    UIBarButtonItem *allBtn = [[UIBarButtonItem alloc] initWithTitle:@"ALL" style:UIBarButtonItemStylePlain target:self action:@selector(showAllBook)];
    super.navigationItem.rightBarButtonItem = allBtn;
}

#pragma mark -
#pragma mark HGPageScrollViewDataSource


- (NSInteger)numberOfPagesInScrollView:(HGPageScrollView *)scrollView;   // Default is 0 if not implemented
{
    return [_myPageDataArray count];
}


- (HGPageView *)pageScrollView:(HGPageScrollView *)scrollView viewForPageAtIndex:(NSInteger)index;
{
    
//    BannerModel *banner = [_myPageDataArray objectAtIndex:index];
//    UIImage *image = [UIImage imageNamed:banner.bannerImage];
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(_myPageScrollView.frame)-20, BANNER_HEIGHT);
    HGPageImageView *imageView = [[HGPageImageView alloc]
                                  initWithFrame:frame];
    //[imageView setImage:image];
    [imageView setImageURL:[NSURL URLWithString:[_myPageDataArray objectAtIndex:index]]];
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
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
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
    static NSString *CellIdentifier = @"Cell";
    NSDictionary *cellData = [self.dataSource objectAtIndex:[indexPath section]];
    if ((NSNull*)cellData != [NSNull null]){
        StoreScrollingTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [customCell setBackgroundColor:[UIColor clearColor]];
        [customCell setDelegate:self];
        [customCell setCategoryData:cellData];
        [customCell setCategoryLabelText:[cellData objectForKey:@"category"] withColor:[UIColor KKBookMediumSeagreenColor]];
        [customCell setTag:[indexPath section]];
        [customCell setImageTitleTextColor:[UIColor whiteColor] withBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        [customCell setImageTitleLabelWitdh:90 withHeight:45];
        [customCell setCollectionViewBackgroundColor:[UIColor clearColor]];
        
        return customCell;
    }else{
        return nil;
    }
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [Utility isPad] ? 220 : 220;
}

#pragma mark - StoreScrollingTableViewCellDelegate

-(void)scrollingTableViewCell:(StoreScrollingTableViewCell *)scrollingTableViewCell didSelectBook:(BookModel *)book{
    if ([self delegate]) {
        [self viewWillDisappear:NO];
        [[self delegate] bookStoreMain:self didBook:book];
    }
}

-(void)loadStoreMainData{
    [self showProgressLoading];
    NSURLSessionTask *task = [KKBookService storeMainService:^(NSArray *source, NSError *error) {
        [self dismissProgress];
        if (!error) {
            self.dataSource = source;
            [self.tableView reloadData];
        }
    }];
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:task delegate:nil];
//    [self.refreshControl setRefreshingWithStateOfTask:task];
}

-(void)showAllBook{
    if ([self delegate]) {
        [[self delegate] bookStoreMain:self didListBook:nil];
    }
}

#pragma mark - Slide banner

-(void)initTimer{
    if (!_timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                      target:self
                                                    selector:@selector(slide:)
                                                    userInfo:nil repeats:YES];
    }
}

-(void)stopAndDeleteTimer{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(void)slide:(NSTimer*)timer{

    unsigned long nextpage = currentBanner+1;
    if(nextpage > maxBanner-1){
        nextpage = 0;
    }
    currentBanner = nextpage;
    // update the scroll view to the appropriate page
    @try {
        [_myPageScrollView scrollToPageAtIndex:currentBanner animated:YES];
    }
    @catch (NSException *exception) {
        currentBanner = 0;
    }
    @finally {
        //
    }
    
}

@end