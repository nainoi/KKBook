//
//  KKBookMainVC.m
//  KKBooK
//
//  Created by PromptNow Ltd. on 30/10/14.
//  Copyright (c) 2014 GLive. All rights reserved.
//

#import "KKBookMainVC.h"
#import "KKBookStoreVC.h"
#import "KKBookLeftSidebar.h"
#import "KKBookLibraryVC.h"
#import "KKBookStoreMain.h"
#import "KKBookStoreDetailVC.h"
#import "ReaderViewController.h"

#import "DataManager.h"
#import "BookEntity.h"
#import "FileHelper.h"

@interface KKBookMainVC ()<KKBookLeftSidebarDelegate, KKBookStoreMainDelegate, ReaderViewControllerDelegate, KKBookLibraryDelegate>{
    KKBookStoreMain *storeVC;
    KKBookLibraryVC *libraryVC;
    ReaderViewController *readerViewController;
}

@property (nonatomic, strong) NSMutableIndexSet *optionIndices;
@property (nonatomic, strong) KKBookLeftSidebar *leftSideBar;

@end

@implementation KKBookMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //init
    self.optionIndices = [NSMutableIndexSet indexSetWithIndex:0];
    storeVC = [[KKBookStoreMain alloc] init];
    storeVC.delegate = self;
    libraryVC = [[KKBookLibraryVC alloc] init];
    libraryVC.delegate = self;
    [self setNavigationBar];
    [self setMainMenuItem];
    [self initMainViewController];
    [self toggleViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initMainViewController{
    self.mainController = [[UIViewController alloc] init];
    CGRect frame = self.view.bounds;
    frame.origin.y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    frame.size.height = CGRectGetHeight(frame) - CGRectGetMaxY(self.navigationController.navigationBar.frame);
    _mainController.view.frame = frame;
    //_mainController.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainController.view];
    _pageType = STORE;
    storeVC.view.frame = frame;
    self.title = @"KKBook";
    [_mainController.view addSubview:storeVC.view];
}

#pragma mark - top view

-(void)toggleViewController{
    CGRect frame = _mainController.view.bounds;
    frame.origin.y = 0;
    switch (_pageType) {
        case STORE:
            if (_mainController.view.superview == storeVC.view) {
                return;
            }else{
                [libraryVC.view removeFromSuperview];
            }
            storeVC.view.frame = frame;
            self.title = @"KKBook";
            [_mainController.view addSubview:storeVC.view];
            break;
            
        case LIBRARY:
            if (_mainController.view.superview == libraryVC.view) {
                return;
            }else{
                [storeVC.view removeFromSuperview];
            }
            libraryVC.view.frame = frame;
            self.title = @"Library";
            [_mainController.view addSubview:libraryVC.view];
            break;
            
        default:
            break;
    }
}

#pragma mark - left menu

-(void)setMainMenuItem{
    UIImage *mainMenuImage = [UIImage imageNamed:@"ic_menu.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.reversesTitleShadowWhenHighlighted = YES;
    [button setImage:mainMenuImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0, 0.0, 40.0, 30.0);
    [button addTarget:self action:@selector(tapLeftMainMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *mainMenu = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = mainMenu;
}

-(void)tapLeftMainMenu{
    if (!_leftSideBar) {
        NSArray *images = @[
                            [UIImage imageNamed:@"gear"],
                            [UIImage imageNamed:@"globe"],
                            [UIImage imageNamed:@"profile"],
                            [UIImage imageNamed:@"star"],
                            ];
        NSArray *colors = @[
                            [UIColor colorWithRed:240/255.f green:159/255.f blue:254/255.f alpha:1],
                            [UIColor colorWithRed:255/255.f green:137/255.f blue:167/255.f alpha:1],
                            [UIColor colorWithRed:126/255.f green:242/255.f blue:195/255.f alpha:1],
                            [UIColor colorWithRed:119/255.f green:152/255.f blue:255/255.f alpha:1],
                            ];
        
        KKBookLeftSidebar *callout = [[KKBookLeftSidebar alloc] initWithImages:images selectedIndices:self.optionIndices borderColors:colors];
        callout.isSingleSelect = YES;
        _leftSideBar = callout;
        callout.delegate = self;

    }
       //    callout.showFromRight = YES;
    [_leftSideBar show];

}

#pragma mark - RNFrostedSidebarDelegate

- (void)sidebar:(KKBookLeftSidebar *)sidebar didTapItemAtIndex:(NSUInteger)index {
    NSLog(@"Tapped item at index %lu",(unsigned long)index);
    if (index == 0) {
        _pageType = STORE;
    }else if (index == 1){
        _pageType = LIBRARY;
    }
    if (index == 2) {
        
    }
    [self toggleViewController];
    [sidebar dismissAnimated:YES completion:nil];
}

- (void)sidebar:(KKBookLeftSidebar *)sidebar didEnable:(BOOL)itemEnabled itemAtIndex:(NSUInteger)index {
    //if (itemEnabled) {
    
        [self.optionIndices addIndex:index];
    //}
}

#pragma mark - KKBookStore delegate

-(void)bookStoreMain:(KKBookStoreMain *)storeMain didBook:(BookModel *)book{
    KKBookStoreDetailVC *bookDetailVC = [[KKBookStoreDetailVC alloc] initWithBook:book];
    bookDetailVC.didDownload = ^(BookModel *bookModel){
        [[DataManager shareInstance] insertBookWithBookModel:bookModel onComplete:^(NSArray *books){
            [libraryVC setMyBook:[[NSMutableArray alloc] initWithArray:books]];
            [self sidebar:_leftSideBar didTapItemAtIndex:1];
        }];
    };
    [self.navigationController pushViewController:bookDetailVC animated:YES];
}

-(void)bookStoreMain:(KKBookStoreMain *)storeMain didListBook:(BookModel *)book{
    
}

#pragma mark - KKBookLibrary delegate

-(void)didSelectBook:(KKBookLibraryVC *)bookLibrary withBookEntity:(BookEntity *)bookEntity{
    [self pdfReaderWithBookEntity:bookEntity];
}

#pragma mark - PDF Reader

-(void)pdfReaderWithBookEntity:(BookEntity*)bookEntity{
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    NSString *filePath = nil;
    NSFileManager * filemanager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *pdfs = [filemanager enumeratorAtPath:[[FileHelper booksPath]stringByAppendingString:bookEntity.folder]];
    NSString *pdfFile = [[[[FileHelper booksPath]stringByAppendingPathComponent:bookEntity.folder] stringByAppendingPathComponent:bookEntity.folder]stringByAppendingPathExtension:@"pdf"];
    if ([FileHelper fileExists:pdfFile isDir:NO]) {
        filePath = pdfFile;
    }else{
        NSString *documentsSubpath;
        while (documentsSubpath = [pdfs nextObject])
        {
            if (![documentsSubpath.pathExtension isEqual:@"pdf"]) {
                continue;
            }
            
            NSLog(@"found %@", documentsSubpath);
            filePath = documentsSubpath;
        }
    }
    
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
    if (document != nil) // Must have a valid ReaderDocument object in order to proceed
    {
        readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
        readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        //[self.navigationController pushViewController:readerViewController animated:YES];
        
        // present in a modal view controller
        
        readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [self presentViewController:readerViewController animated:YES completion:NULL];
    }

}

-(void)dismissReaderViewController:(ReaderViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:^{}];
}

@end
