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

@interface KKBookStoreMain ()<StoreScrollingTableViewCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSArray *images;

@end

@implementation KKBookStoreMain

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBannerView];
    [self dummyTable];
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

-(void)dummyTable{
    
    CGRect frame = CGRectMake(10, CGRectGetMaxY(_myPageScrollView.frame) + 5, CHILD_WIDTH, CGRectGetMaxY([UIScreen mainScreen].bounds) - CGRectGetMaxY(_myPageScrollView.frame) - 10);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:_tableView];
    
    
    static NSString *CellIdentifier = @"Cell";
    [self.tableView registerClass:[StoreScrollingTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.images = @[
                    @{ @"category": @"Category A",
                       @"images":
                           @[
                               @{ @"name":@"sample_1.jpeg", @"title":@"A-0"},
                               @{ @"name":@"sample_2.jpeg", @"title":@"A-1"},
                               @{ @"name":@"sample_3.jpeg", @"title":@"A-2"},
                               @{ @"name":@"sample_4.jpeg", @"title":@"A-3"},
                               @{ @"name":@"sample_5.jpeg", @"title":@"A-4"},
                               @{ @"name":@"sample_6.jpeg", @"title":@"A-5"}
                               
                               ]
                       },
                    @{ @"category": @"Category B",
                       @"images":
                           @[
                               @{ @"name":@"sample_3.jpeg", @"title":@"B-0"},
                               @{ @"name":@"sample_1.jpeg", @"title":@"B-1"},
                               @{ @"name":@"sample_2.jpeg", @"title":@"B-2"},
                               @{ @"name":@"sample_5.jpeg", @"title":@"B-3"},
                               @{ @"name":@"sample_6.jpeg", @"title":@"B-4"},
                               @{ @"name":@"sample_4.jpeg", @"title":@"B-5"}
                               ]
                       },
                    @{ @"category": @"Category C",
                       @"images":
                           @[
                               @{ @"name":@"sample_6.jpeg", @"title":@"C-0"},
                               @{ @"name":@"sample_2.jpeg", @"title":@"C-1"},
                               @{ @"name":@"sample_3.jpeg", @"title":@"C-2"},
                               @{ @"name":@"sample_1.jpeg", @"title":@"C-3"},
                               @{ @"name":@"sample_5.jpeg", @"title":@"C-4"},
                               @{ @"name":@"sample_4.jpeg", @"title":@"C-5"}
                               ]
                       },
                    @{ @"category": @"Category D",
                       @"images":
                           @[
                               @{ @"name":@"sample_3.jpeg", @"title":@"D-0"},
                               @{ @"name":@"sample_1.jpeg", @"title":@"D-1"},
                               @{ @"name":@"sample_2.jpeg", @"title":@"D-2"},
                               @{ @"name":@"sample_5.jpeg", @"title":@"D-3"},
                               @{ @"name":@"sample_6.jpeg", @"title":@"D-4"},
                               @{ @"name":@"sample_4.jpeg", @"title":@"D-5"}
                               ]
                       }
                    ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.images count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
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
    
    return customCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 220;
}

#pragma mark - StoreScrollingTableViewCellDelegate

- (void)scrollingTableViewCell:(StoreScrollingTableViewCell *)scrollingTableViewCell didSelectImageAtIndexPath:(NSIndexPath*)indexPathOfImage atCategoryRowIndex:(NSInteger)categoryRowIndex
{
    
    NSDictionary *images = [self.images objectAtIndex:categoryRowIndex];
    NSArray *imageCollection = [images objectForKey:@"images"];
    NSString *imageTitle = [[imageCollection objectAtIndex:[indexPathOfImage row]]objectForKey:@"title"];
    NSString *categoryTitle = [[self.images objectAtIndex:categoryRowIndex] objectForKey:@"category"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat: @"Image %@",imageTitle]
                                                    message:[NSString stringWithFormat: @"in %@",categoryTitle]
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

@end
