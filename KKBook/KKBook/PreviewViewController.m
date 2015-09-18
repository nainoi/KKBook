
#import "PreviewViewController.h"
#import "PageView.h"
#import "ImageScrollView.h"

@implementation PreviewViewController
{
	//NSUInteger _numPages;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

	//_numPages = _previews.count;

	//self.pagingScrollView.previewInsets = UIEdgeInsetsMake(0.0, 80.0, 0.0, 80.0);
	//[self.pagingScrollView reloadPages];

//	self.pageControl.currentPage = 0;
//	self.pageControl.numberOfPages = _numPages;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self initOfImageArray];
}

//- (void)didReceiveMemoryWarning
//{
//	[self.pagingScrollView didReceiveMemoryWarning];
//}

/*#pragma mark - Actions

- (IBAction)pageTurn
{
	[self.pagingScrollView selectPageAtIndex:self.pageControl.currentPage animated:YES];
}

#pragma mark - View Controller Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self.pagingScrollView beforeRotation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[self.pagingScrollView afterRotation];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)theScrollView
{
	self.pageControl.currentPage = [self.pagingScrollView indexOfSelectedPage];
	[self.pagingScrollView scrollViewDidScroll];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)theScrollView
{
	if ([self.pagingScrollView indexOfSelectedPage] == _numPages - 1)
	{
		_numPages++;
		[self.pagingScrollView reloadPages];
		self.pageControl.numberOfPages = _numPages;

}*/

/*#pragma mark - MHPagingScrollViewDelegate

- (NSUInteger)numberOfPagesInPagingScrollView:(MHPagingScrollView *)pagingScrollView
{
	return _numPages;
}

- (UIView *)pagingScrollView:(MHPagingScrollView *)thePagingScrollView pageForIndex:(NSUInteger)index
{
	PageView *pageView = (PageView *)[thePagingScrollView dequeueReusablePage];
	if (pageView == nil)
		pageView = [[PageView alloc] init];

	[pageView setImageURL:[NSURL URLWithString:_previews[index]]];
	return pageView;
    
    ImageScrollView *imageScroll = (ImageScrollView*)[thePagingScrollView dequeueReusablePage];
    if (!imageScroll) {
        imageScroll = [[ImageScrollView alloc] init];
    }
    [imageScroll displayImageURL:[NSURL URLWithString:_previews[index]]];
    return imageScroll;
}*/

#pragma mark - scrollview delegate

-(void)initOfImageArray{
    
    NSMutableArray *arrayOfImage = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [self numberOfPage]; i++) {
        [arrayOfImage addObject:[NSNull null]];
    }
    self.tempImage = arrayOfImage;
    //_pagingScrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44);
    _pagingScrollView.delegate = self;
    _pagingScrollView.pagingEnabled = YES;
    _pagingScrollView.alwaysBounceHorizontal = NO;
    _pagingScrollView.alwaysBounceVertical = NO;
    _pagingScrollView.showsHorizontalScrollIndicator = NO;
    _pagingScrollView.showsVerticalScrollIndicator = NO;
    _pagingScrollView.bounces = NO;
    _pagingScrollView.delaysContentTouches = NO;
    _pagingScrollView.backgroundColor = [UIColor clearColor];
    
    //[self defaultScrollContentSize];
    
    //[self.view addSubview:_scrollImage];
    
    //[self.view bringSubviewToFront:_pageControl];
    //
    [self pageControl].currentPage = 0;
    [self pageControl].numberOfPages = [self numberOfPage];
    [self.pagingScrollView setContentSize:CGSizeMake(_pagingScrollView.frame.size.width*[self numberOfPage], 0)];
    _pageControl.hidden = NO;
    
    /*if ([self numberOfPage] <= 1) {
     [self pageControl].hidden = YES;
     }else{
     [self pageControl].hidden = NO;
     }*/
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}


-(NSInteger)numberOfPage{
    return [_previews count];
}

- (void)loadScrollViewWithPage:(NSInteger)page {
    if (page < 0) return;
    if (page >= [self numberOfPage]) return;
    
    // replace the placeholder if necessary
    ImageScrollView *imageView = [self.tempImage objectAtIndex:page];
    if ((NSNull *)imageView == [NSNull null]) {
        //NSString *path = [[NSBundle mainBundle] resourcePath];
        //UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:_arrOfImages[page]]]];
        //UIImage *img = [UIImage imageNamed:[_arrOfImages objectAtIndex:page]];
        
        imageView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.pagingScrollView.frame.size.width, _pagingScrollView.frame.size.height)];
        //[imageView displayImage:_previews[page]];
        [imageView displayImageURL:[NSURL URLWithString:_previews[page]]];
        imageView.tag = page+1;
        [self.tempImage replaceObjectAtIndex:page withObject:imageView];
        //img = nil;
        
    }
    // add the controller's view to the scroll view
    if (nil == imageView.superview) {
        
        CGRect frame = imageView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        imageView.frame = frame;
        [self.pagingScrollView addSubview:imageView];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _pagingScrollView.frame.size.width;
    int page = floor((_pagingScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    currentIndex = page;
    
    
    [self pageControl].currentPage = page;
    
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}


#pragma mark - page control

- (IBAction)pageControlDidChange:(id)sender {
    NSInteger page = ((UIPageControl*)sender).currentPage;
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    currentIndex = page;
    
    // update the scroll view to the appropriate page
    CGRect frame = _pagingScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [_pagingScrollView scrollRectToVisible:frame animated:YES];
}

@end
