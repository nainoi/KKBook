//
//  ViewController.m
//  CurlWebView
//
//  Created by Disakul Waidee on 7/10/56 BE.
//  Copyright (c) 2556 Digix. All rights reserved.
//

#import "InteractiveReader.h"

#import "FileHelper.h"

#import <QuartzCore/QuartzCore.h>

@interface InteractiveReader ()

@end

@implementation InteractiveReader

-(id)initWithBook:(BookEntity *)book
{
    self = [super initWithNibName:@"InteractiveReader" bundle:nil];
    if (self) {
        self.book = book;
        self.currenCh = 0;
        //self.currentSec = sec;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self createContentPages];
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                        forKey: UIPageViewControllerOptionSpineLocationKey];
    
    self.pageController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                           options: options];
    
    _pageController.dataSource = self;

    [[_pageController view] setFrame:[[self view] bounds]];
    
    ContentViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageController setViewControllers:viewControllers
                             direction:UIPageViewControllerNavigationDirectionForward
                              animated:NO
                            completion:nil];
    
    [self addChildViewController:_pageController];
    [[self view] addSubview:[_pageController view]];
    [_pageController didMoveToParentViewController:self];
    
//    [self.navigationController.navigationBar setTintColor:[UIColor
//                                                           colorWithRed:78.0/255.0
//                                                           green:156.0/255.0
//                                                           blue:206.0/255.0
//                                                           alpha:1.0]];
    
    
//    MMLogoView * logo = [[MMLogoView alloc] initWithFrame:CGRectMake(0, 0, 29, 31)];
//    [self.navigationItem setTitleView:logo];
//    [self.navigationController.view.layer setCornerRadius:10.0f];
    
    //[self setupLeftMenuButton];
    //[self setupRightMenuButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

/*
-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}

-(void)setupRightMenuButton{
    MMDrawerBarButtonItem * rightDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(rightDrawerButtonPress:)];
    [self.navigationItem setRightBarButtonItem:rightDrawerButton animated:YES];
}
*/

- (void) createContentPages
{
    //NSMutableArray *pageStrings = [[NSMutableArray alloc] init];
    
    NSString *path = [[FileHelper booksPath] stringByAppendingPathComponent:_book.folder];
    
    //Json reader
//    NSString *jsonPath = [path stringByAppendingPathComponent:@"en.json"];
//    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
//    NSError *e = nil;
//    NSArray *jsonArray = [[NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e]objectForKey:@"ch"];
//    
//    if (!jsonArray) {
//        NSLog(@"Error parsing JSON: %@", e);
//    } else {
//        for(NSDictionary *item in jsonArray) {
//            NSLog(@"Item: %@", item);
//        }
//    }
    
    //path = [path stringByAppendingPathComponent:@"ch01"];
    
    self.pageContent = [self listFileAtPath:path];
}

-(NSArray *)listFileAtPath:(NSString *)path
{
    //-----> LIST ALL FILES <-----//
    NSLog(@"LISTING ALL FILES FOUND");
    
    NSMutableArray *data = [[NSMutableArray alloc] init];
    NSArray *directoryContent = [[NSFileManager  defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    if (directoryContent.count == 1) {
        path = [path stringByAppendingPathComponent:directoryContent[0]];
    }
    
    NSArray *directoryContent2 = [[NSFileManager  defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    for (NSString *file in directoryContent2)
    {
       // NSString *file = [directoryContent objectAtIndex:count];
        if ([[file pathExtension] isEqualToString:@"html"]) {
            [data addObject:[path stringByAppendingPathComponent:file]];
        }
        //NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return data;
}

- (ContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index.
    if (([self.pageContent count] == 0) ||
        (index >= [self.pageContent count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    ContentViewController *dataViewController = [[ContentViewController alloc] initWithNibName:@"ContentViewController"bundle:nil];
    dataViewController.dataObject = [self.pageContent objectAtIndex:index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(ContentViewController *)viewController
{
    return [self.pageContent indexOfObject:viewController.dataObject];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(ContentViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageContent count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}


-(void)gotoPage:(NSInteger)ch sec:(NSInteger)sec page:(NSInteger)page{
    _currentSec = sec;
    _currenCh = ch;
    
    [self createContentPages];
    ContentViewController *targetPageViewController = [self viewControllerAtIndex:page];
    if (targetPageViewController) {
        //put it(or them if in landscape view) in an array
        NSArray *viewControllers = [NSArray arrayWithObjects:targetPageViewController, nil];
        //add page view
        [self.pageController setViewControllers:viewControllers  direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
    }
}

/*
#pragma mark - Button Handlers
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)rightDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
}

-(void)doubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideLeft completion:nil];
}

-(void)twoFingerDoubleTap:(UITapGestureRecognizer*)gesture{
    [self.mm_drawerController bouncePreviewForDrawerSide:MMDrawerSideRight completion:nil];
}
*/

@end
