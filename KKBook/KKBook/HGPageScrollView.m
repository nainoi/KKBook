//
//  HGPageScrollView.m
//  HGPageDeckSample
//
//  Created by Rotem Rubnov on 25/10/2010.
//  Copyright (C) 2010 100 grams software. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//


#import "HGPageScrollView.h"
#import <QuartzCore/QuartzCore.h>



// -----------------------------------------------------------------------------------------------------------------------------------
//Internal view class, used by to HGPageScrollView.   
#pragma mark HGTouchView

@interface HGTouchView : UIView {
}
@property (nonatomic, retain) UIView *receiver;
@end



@implementation HGTouchView

@synthesize receiver;

- (void)dealloc {
	self.receiver = nil;
    [super dealloc];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if ([self pointInside:point withEvent:event]) {
		return self.receiver;
        //NSLog(@"touched %@ receiver %@", self, [self receiver]);
	}
	return nil;
}

@end




// -----------------------------------------------------------------------------------------------------------------------------------
#pragma mark - HGPageScrollView private methods & properties

typedef enum{
    HGPageScrollViewUpdateMethodInsert, 
    HGPageScrollViewUpdateMethodDelete, 
    HGPageScrollViewUpdateMethodReload
}HGPageScrollViewUpdateMethod;


@interface HGPageScrollView()

// initializing/updating controls
//- (void) initHeaderForPageAtIndex : (NSInteger) index;
//- (void) initDeckTitlesForPageAtIndex : (NSInteger) index;

// insertion/deletion/update of pages
- (HGPageView*) loadPageAtIndex:(NSInteger)index insertIntoVisibleIndex:(NSInteger) visibleIndex;
- (void) addPageToScrollView : (HGPageView*) page atIndex : (NSInteger) index;
- (void) insertPageInScrollView:(HGPageView *)page atIndex:(NSInteger) index animated:(BOOL)animated;
- (void) removePagesFromScrollView:(NSArray*)pages animated:(BOOL)animated;
- (void) setFrameForPage:(UIView*)page atIndex:(NSInteger)index;
- (void) shiftPage : (UIView*) page withOffset : (CGFloat) offset;
- (void) setNumberOfPages : (NSInteger) number; 
- (void) updateScrolledPage : (HGPageView*) page index : (NSInteger) index;

// managing selection and scrolling
- (void) updateVisiblePages;
- (void) setAlphaForPage : (UIView*) page;
- (void) setOpacity:(CGFloat)alpha forObstructionLayerOfPage:(HGPageView *)page;
- (void) preparePage : (HGPageView *) page forMode : (HGPageScrollViewMode) mode; 
- (void) setViewMode:(HGPageScrollViewMode)mode animated:(BOOL)animated; //toggles selection/deselection

// responding to actions 
- (void) didChangePageValue : (id) sender;

@property (nonatomic, retain) NSIndexSet *indexesBeforeVisibleRange; 
@property (nonatomic, retain) NSIndexSet *indexesWithinVisibleRange; 
@property (nonatomic, retain) NSIndexSet *indexesAfterVisibleRange; 

@end



// -----------------------------------------------------------------------------------------------------------------------------------
#pragma mark - HGPageScrollView exception constants

#define kExceptionNameInvalidOperation   @"HGPageScrollView Invalid Operation"
#define kExceptionReasonInvalidOperation @"Updating HGPageScrollView data is only allowed in DECK mode, i.e. when the page scroller is visible."

#define kExceptionNameInvalidUpdate   @"HGPageScrollView DeletePagesAtIndexes Invalid Update"
#define kExceptionReasonInvalidUpdate @"The number of pages contained HGPageScrollView after the update (%d) must be equal to the number of pages contained in it before the update (%d), plus or minus the number of pages added or removed from it (%d added, %d removed)."



// -----------------------------------------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark - HGPageScrollView implementation 

@implementation HGPageScrollView

@synthesize pageDeckBackgroundView	= _pageDeckBackgroundView;
@synthesize dataSource				= _dataSource;
@synthesize delegate				= _delegate;
@synthesize viewMode				= _viewMode;

@synthesize indexesBeforeVisibleRange;
@synthesize indexesWithinVisibleRange;
@synthesize indexesAfterVisibleRange; 

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.clipsToBounds = YES;
//    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    // init internal data structures
    _visiblePages = [[NSMutableArray alloc] initWithCapacity:3];
    _reusablePages = [[NSMutableDictionary alloc] initWithCapacity:3];
    _deletedPages = [[NSMutableArray alloc] initWithCapacity:0];
    
    CGRect fram = frame;
    fram.origin.y = 0;
    fram.origin.x = 0;
    _pageDeckBackgroundView = [[UIView alloc] initWithFrame:fram];
    
    CGRect f = frame;
    f.origin.y = 0;
    f.size.width = frame.size.width - 20;
    f.origin.x = 10;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:f];
    _scrollView.decelerationRate = 1.0;//UIScrollViewDecelerationRateNormal;
    _scrollView.delaysContentTouches = NO;
    _scrollView.clipsToBounds = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    
    
    _scrollViewTouch = [[HGTouchView alloc] initWithFrame:f];
    _scrollViewTouch.receiver = _scrollView;
    
    _pageSelector = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame) - 40, f.size.width, 30)];
    
    // set gradient for background view
    CAGradientLayer *glayer = [CAGradientLayer layer];
    glayer.frame = _pageDeckBackgroundView.bounds;
    UIColor *topColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0]; //light blue-gray
    UIColor *bottomColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1.0]; //dark blue-gray
    glayer.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
    [_pageDeckBackgroundView.layer insertSublayer:glayer atIndex:0];
    
    // set tap gesture recognizer for page selection
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureFrom:)];
    [_scrollView addGestureRecognizer:recognizer];
    recognizer.delegate = self;
    [recognizer release];
    
    // setup scrollVie
    
    [self addSubview:_pageDeckBackgroundView];
    [_pageDeckBackgroundView addSubview:_scrollViewTouch];
    [_pageDeckBackgroundView addSubview:_scrollView];
    [_pageDeckBackgroundView addSubview:_pageSelector];
    
    // setup pageSelector
    [_pageSelector addTarget:self action:@selector(didChangePageValue:) forControlEvents:UIControlEventValueChanged];
    
    // default number of pages
    _numberOfPages = 1;
    
    // set initial visible indexes (page 0)
    _visibleIndexes.location = 0;
    _visibleIndexes.length = 1;
    
    // set initial view mode
    _viewMode = HGPageScrollViewModeDeck;
    
    return self;

}

- (void) awakeFromNib{ 

	[super awakeFromNib];
    
    // release IB reference (we do not want to keep a circular reference to our delegate & dataSource, or it will prevent them from properly deallocating). 
    [_delegate release];
    [_dataSource release];
	
	// init internal data structures
	_visiblePages = [[NSMutableArray alloc] initWithCapacity:3];
	_reusablePages = [[NSMutableDictionary alloc] initWithCapacity:3]; 
	_deletedPages = [[NSMutableArray alloc] initWithCapacity:0];
    
	// set gradient for background view
	CAGradientLayer *glayer = [CAGradientLayer layer];
	glayer.frame = _pageDeckBackgroundView.bounds;
	UIColor *topColor = [UIColor colorWithRed:0.57 green:0.63 blue:0.68 alpha:1.0]; //light blue-gray
	UIColor *bottomColor = [UIColor colorWithRed:0.31 green:0.41 blue:0.48 alpha:1.0]; //dark blue-gray
	glayer.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
	[_pageDeckBackgroundView.layer insertSublayer:glayer atIndex:0];
	
	// set tap gesture recognizer for page selection
	UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureFrom:)];
	[_scrollView addGestureRecognizer:recognizer];
	recognizer.delegate = self;
	[recognizer release];
	
	// setup scrollView
	_scrollView.decelerationRate = 1.0;//UIScrollViewDecelerationRateNormal;
    _scrollView.delaysContentTouches = NO;
    _scrollView.clipsToBounds = NO;
//    CGRect fram = self.frame;
//    fram.origin.y = 0;
//    
//    _pageDeckBackgroundView.frame = fram;
//    _scrollView.frame = fram;
//    _scrollViewTouch.frame =fram;
    
	//_scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	_scrollViewTouch.receiver = _scrollView;
	
	// setup pageSelector
	[_pageSelector addTarget:self action:@selector(didChangePageValue:) forControlEvents:UIControlEventValueChanged];
	
	// default number of pages 
	_numberOfPages = 1;
	
	// set initial visible indexes (page 0)
	_visibleIndexes.location = 0;
	_visibleIndexes.length = 1;
	
    // set initial view mode
    _viewMode = HGPageScrollViewModeDeck;
    
	// load the data 
	//[self reloadData];


}


- (void)dealloc 
{
	[_visiblePages release];
	_visiblePages = nil;
    [_deletedPages release];
    _deletedPages = nil;
	[_reusablePages release];
	_reusablePages = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark View Management

- (void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    //_scrollView.frame = frame;
	_scrollView.contentSize = CGSizeMake(_numberOfPages * _scrollView.bounds.size.width, _scrollView.bounds.size.height);
}


#pragma mark -
#pragma mark Info


- (NSInteger) numberOfPages; 
{
	return _numberOfPages;
}


- (HGPageView *)pageAtIndex:(NSInteger)index;            // returns nil if page is not visible or the index is out of range
{
	if (index == NSNotFound || index < _visibleIndexes.location || index > _visibleIndexes.location + _visibleIndexes.length-1) {
		return nil;
	}
	return [_visiblePages objectAtIndex:index-_visibleIndexes.location];
}



#pragma mark -
#pragma mark Page Selection


- (NSInteger)indexForSelectedPage;   
{
    return [self indexForVisiblePage : _selectedPage];
}

- (NSInteger)indexForVisiblePage : (HGPageView*) page;   
{
	NSInteger index = [_visiblePages indexOfObject:page];
	if (index != NSNotFound) {
        return _visibleIndexes.location + index;
    }
    return NSNotFound;
}



- (void) scrollToPageAtIndex : (NSInteger) index animated : (BOOL) animated; 
{
	CGPoint offset = CGPointMake(index * _scrollView.frame.size.width, 0);
	[_scrollView setContentOffset:offset animated:animated];
}


- (void) selectPageAtIndex : (NSInteger) index animated : (BOOL) animated;
{
    // ignore if there are no pages or index is invalid
    if (index == NSNotFound || _numberOfPages == 0) {
        return;
    }
    
	if (index != [self indexForSelectedPage]) {
        
        // rebuild _visibleIndexes
        BOOL isLastPage = (index == _numberOfPages-1);
        BOOL isFirstPage = (index == 0); 
        NSInteger selectedVisibleIndex; 
        if (_numberOfPages == 1) {
            _visibleIndexes.location = index;
            _visibleIndexes.length = 1;
            selectedVisibleIndex = 0;
        }
        else if (isLastPage) {
            _visibleIndexes.location = index-1;
            _visibleIndexes.length = 2;
            selectedVisibleIndex = 1;
        }
        else if(isFirstPage){
            _visibleIndexes.location = index;
            _visibleIndexes.length = 2;                
            selectedVisibleIndex = 0;
        }
        else{
            _visibleIndexes.location = index-1;
            _visibleIndexes.length = 3;           
            selectedVisibleIndex = 1;
        }
 
        // update the scrollView content offset
        _scrollView.contentOffset = CGPointMake(index * _scrollView.frame.size.width, 0);

        // reload the data for the new indexes
        [self reloadData];
        
        // update _selectedPage
        _selectedPage = [_visiblePages objectAtIndex:selectedVisibleIndex];
        
        // update the page selector (pageControl)
        [_pageSelector setCurrentPage:index];

	}
    
	[self setViewMode:HGPageScrollViewModePage animated:animated];
}


- (void) deselectPageAnimated : (BOOL) animated;
{
    // ignore if there are no pages or no _selectedPage
    if (!_selectedPage || _numberOfPages == 0) {
        return;
    }

    NSInteger visibleIndex = [_visiblePages indexOfObject:_selectedPage];

    // notify the delegate
    if ([self.delegate respondsToSelector:@selector(pageScrollView:willDeselectPageAtIndex:)]) {
        [self.delegate pageScrollView:self willDeselectPageAtIndex:visibleIndex];
    }		

    // Before moving back to DECK mode, refresh the selected page
    NSInteger selectedPageScrollIndex = [self indexForSelectedPage];
    CGRect identityFrame = _selectedPage.identityFrame;
    CGRect pageFrame = _selectedPage.frame;
    [_selectedPage removeFromSuperview];
    [_visiblePages removeObject:_selectedPage];
    _selectedPage = [self loadPageAtIndex:selectedPageScrollIndex insertIntoVisibleIndex:visibleIndex];
    _selectedPage.identityFrame = identityFrame;
    _selectedPage.frame = pageFrame;
    [self setOpacity:0.0 forObstructionLayerOfPage:_selectedPage];
    //_selectedPage.alpha = 1.0;
    [self addSubview:_selectedPage];

	[self setViewMode:HGPageScrollViewModeDeck animated:animated];
}


- (void) preparePage : (HGPageView *) page forMode : (HGPageScrollViewMode) mode 
{
    // When a page is presented in HGPageScrollViewModePage mode, it is scaled up and is moved to a different superview. 
    // As it captures the full screen, it may be cropped to fit inside its new superview's frame. 
    // So when moving it back to HGPageScrollViewModeDeck, we restore the page's proportions to prepare it to Deck mode.  
	if (mode == HGPageScrollViewModeDeck && 
        CGAffineTransformEqualToTransform(page.transform, CGAffineTransformIdentity)) {
        page.frame = page.identityFrame;
	}
    
}


- (void) setViewMode:(HGPageScrollViewMode)mode animated:(BOOL)animated;
{
	if (_viewMode == mode) {
		return;
	}
	
	_viewMode = mode;
//	
//	if (_selectedPage) {
//        [self preparePage:_selectedPage forMode:mode];
//    }
    
	NSInteger selectedIndex = [self indexForSelectedPage];


	void (^SelectBlock)(void) = (mode==HGPageScrollViewModePage)? ^{
		
       // [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

        
		// move to HGPageScrollViewModePage
		if([self.delegate respondsToSelector:@selector(pageScrollView:willSelectPageAtIndex:)]) {
			[self.delegate pageScrollView:self willSelectPageAtIndex:selectedIndex];
		}
		
		//remove unnecessary views
		//[_scrollViewTouch removeFromSuperview];
	} : ^{
		
	};
	
	void (^CompletionBlock)(BOOL) = (mode==HGPageScrollViewModePage)? ^(BOOL finished){
		if ([self.delegate respondsToSelector:@selector(pageScrollView:didSelectPageAtIndex:)]) {
			[self.delegate pageScrollView:self didSelectPageAtIndex:selectedIndex];
		}		
	} : ^(BOOL finished){
        if ([self.delegate respondsToSelector:@selector(pageScrollView:didDeselectPageAtIndex:)]) {
			[self.delegate pageScrollView:self didDeselectPageAtIndex:selectedIndex];
		}		
	};
	
	
	if(animated){
		[UIView animateWithDuration:0.3 animations:SelectBlock completion:CompletionBlock];
	}
	else {
		SelectBlock();
		CompletionBlock(YES);
	}
	
}


#pragma mark -
#pragma mark PageScroller Data



- (void) reloadData; 
{
    NSInteger numPages = 1;  
	if ([self.dataSource respondsToSelector:@selector(numberOfPagesInScrollView:)]) {
		numPages = [self.dataSource numberOfPagesInScrollView:self];
	}
	
    NSInteger selectedIndex = _selectedPage?[_visiblePages indexOfObject:_selectedPage]:NSNotFound;
        
	// reset visible pages array
	[_visiblePages removeAllObjects];
	// remove all subviews from scrollView
    [[_scrollView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }]; 
     
	[self setNumberOfPages:numPages];
    
	if (_numberOfPages > 0) {
		
		// reload visible pages
		for (int index=0; index<_visibleIndexes.length; index++) {
			HGPageView *page = [self loadPageAtIndex:_visibleIndexes.location+index insertIntoVisibleIndex:index];
            [self addPageToScrollView:page atIndex:_visibleIndexes.location+index];
		}
		
		// this will load any additional views which become visible  
		[self updateVisiblePages];
		
        // set initial alpha values for all visible pages
        [_visiblePages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self setAlphaForPage : obj];		
        }];
		
        if (selectedIndex == NSNotFound) {
            // if no page is selected, select the first page
            _selectedPage = [_visiblePages objectAtIndex:0];
        }
        else{
            // refresh the page at the selected index (it might have changed after reloading the visible pages) 
            _selectedPage = [_visiblePages objectAtIndex:selectedIndex];
        }
	}
    
    // reloading the data implicitely resets the viewMode to UIPageScrollViewModeDeck. 
    // here we restore the view mode in case this is not the first time reloadData is called (i.e. if there if a _selectedPage).   
    if (_selectedPage && _viewMode==HGPageScrollViewModePage) { 
        _viewMode = HGPageScrollViewModeDeck;
        [self setViewMode:HGPageScrollViewModePage animated:NO];
    }
}



- (HGPageView*) loadPageAtIndex : (NSInteger) index insertIntoVisibleIndex : (NSInteger) visibleIndex
{
	HGPageView *visiblePage = [self.dataSource pageScrollView:self viewForPageAtIndex:index];
	if (visiblePage.reuseIdentifier) {
		NSMutableArray *reusables = [_reusablePages objectForKey:visiblePage.reuseIdentifier];
		if (!reusables) {
			reusables = [[[NSMutableArray alloc] initWithCapacity : 4] autorelease];
		}
		if (![reusables containsObject:visiblePage]) {
			[reusables addObject:visiblePage];
		}
		[_reusablePages setObject:reusables forKey:visiblePage.reuseIdentifier];
	}
	
	// add the page to the visible pages array
	[_visiblePages insertObject:visiblePage atIndex:visibleIndex];
		
    return visiblePage;
}


// add a page to the scroll view at a given index. No adjustments are made to existing pages offsets. 
- (void) addPageToScrollView : (HGPageView*) page atIndex : (NSInteger) index
{
    // inserting a page into the scroll view is in HGPageScrollViewModeDeck by definition (the scroll is the "deck")
    [self preparePage:page forMode:HGPageScrollViewModeDeck];
    
	// configure the page frame
    [self setFrameForPage : page atIndex:index];
    	
	if(!page.maskLayer) {
        [self setLayerPropertiesForPage:page];
	}
 
    // add the page to the scroller
	[_scrollView insertSubview:page atIndex:0];

}


- (void) setLayerPropertiesForPage:(HGPageView*)page
{
    // add shadow (use shadowPath to improve rendering performance)
	page.layer.shadowColor = [[UIColor blackColor] CGColor];	
	page.layer.shadowOffset = CGSizeMake(3.0f, 8.0f);
	page.layer.shadowOpacity = 0.3f;
	page.layer.shadowRadius = 7.0;
    page.layer.masksToBounds = NO;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:page.bounds];
    page.layer.shadowPath = path.CGPath;

    page.maskLayer = [[[CALayer alloc] init] autorelease];
    CGSize size = page.identityFrame.size;
    // FIXME: Magic Numbers :S
    page.maskLayer.frame = CGRectMake(0,0, size.width, size.height); //CGRectMake(64., 92., size.width, size.height);
//    size = page.layer.bounds.size;
//    page.maskLayer.bounds = CGRectMake(0., 0., size.width, size.height);
    page.maskLayer.backgroundColor = [[UIColor blackColor] CGColor];
    page.maskLayer.opaque = NO;
    page.maskLayer.opacity = 0.0f;
    [page.layer addSublayer:page.maskLayer];
}



// inserts a page to the scroll view at a given offset by pushing existing pages forward.
- (void) insertPageInScrollView : (HGPageView *) page atIndex : (NSInteger) index animated : (BOOL) animated
{
    //hide the new page before inserting it
    //page.alpha = 0.0; 
    
    // add the new page at the correct offset
	[self addPageToScrollView:page atIndex:index]; 
    
    // shift pages at or after the new page offset forward
    [[_scrollView subviews] enumerateObjectsUsingBlock:^(id existingPage, NSUInteger idx, BOOL *stop) {

        if(existingPage != page && page.frame.origin.x <= ((UIView*)existingPage).frame.origin.x){
      
            if (animated) {
                [UIView animateWithDuration:0.4 animations:^(void) {
                    [self shiftPage : existingPage withOffset: _scrollView.frame.size.width];
                }];
            }
            else{
                [self shiftPage : existingPage withOffset: _scrollView.frame.size.width];
            }                
        }
    }];

    if (animated) {
        [UIView animateWithDuration:0.4 animations:^(void) {
            [self setAlphaForPage:page];
        }];
    }
    else{
        [self setAlphaForPage:page];
    }
 		
	

}



- (void) removePagesFromScrollView : (NSArray*) pages animated:(BOOL)animated
{
    CGFloat selectedPageOffset = NSNotFound;
    if ([pages containsObject:_selectedPage]) {
        selectedPageOffset = _selectedPage.frame.origin.x;
    }
    
    // remove the pages from the scrollView
    [pages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
	    if (animated) {
		    [UIView animateWithDuration:0.2
				     animations:^{((HGPageView *)obj).alpha = 0.0f;}
				     completion:^(BOOL finished) {
					     [obj removeFromSuperview];
					     ((HGPageView *)obj).alpha = 1.0f;
				     }];
	    } else {
		    [obj removeFromSuperview];
	    }
    }];
         
    // shift the remaining pages in the scrollView
    [[_scrollView subviews] enumerateObjectsUsingBlock:^(id remainingPage, NSUInteger idx, BOOL *stop) {
        NSIndexSet *removedPages = [pages indexesOfObjectsPassingTest:^BOOL(id removedPage, NSUInteger idx, BOOL *stop) {
            return ((UIView*)removedPage).frame.origin.x < ((UIView*)remainingPage).frame.origin.x;
        }]; 
                
        if ([removedPages count] > 0) {
            
            if (animated) {
                [UIView animateWithDuration:0.4 animations:^(void) {
                    [self shiftPage : remainingPage withOffset: -([removedPages count]*_scrollView.frame.size.width)];
                }];
            }
            else{
                [self shiftPage : remainingPage withOffset: -([removedPages count]*_scrollView.frame.size.width)];
            }                
        }
        
    }];

    // update the selected page if it has been removed 
    if(selectedPageOffset != NSNotFound){
        NSInteger index = [[_scrollView subviews] indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            CGFloat delta = fabsf(((UIView*)obj).frame.origin.x - selectedPageOffset);
            return delta < 0.1;
        }];
        HGPageView *newSelectedPage=nil;
        if (index != NSNotFound) {
            // replace selected page with the new page which is in the same offset 
            newSelectedPage = [[_scrollView subviews] objectAtIndex:index];
        }
	// This could happen when removing the last page
        if([self indexForVisiblePage:newSelectedPage] == NSNotFound) {
            // replace selected page with last visible page 
            newSelectedPage = [_visiblePages lastObject];
        }        
        NSInteger newSelectedPageIndex = [self indexForVisiblePage:newSelectedPage];
        if (newSelectedPage != _selectedPage) {
            [self updateScrolledPage:newSelectedPage index:newSelectedPageIndex];
        }
    }
}




- (void) setFrameForPage : (UIView*) page atIndex : (NSInteger) index;
{
    page.transform = CGAffineTransformMakeScale(0.99,0.95);
	//CGFloat contentOffset = index * _scrollView.frame.size.width;
	//CGFloat margin = (_scrollView.frame.size.width - page.frame.size.width)/2 ;
    CGFloat contentOffset = index * _scrollView.frame.size.width;
    CGFloat marginX = (_scrollView.frame.size.width - page.frame.size.width)/2 ;
    CGFloat marginY = (_scrollView.frame.size.height - page.frame.size.height)/2 ;
	CGRect frame = page.frame;
	frame.origin.x = contentOffset + marginX;
	frame.origin.y = marginY;
	page.frame = frame;
    
}


- (void) shiftPage : (UIView*) page withOffset : (CGFloat) offset
{
    CGRect frame = page.frame;
    frame.origin.x += offset;
    page.frame = frame; 
    
    // also refresh the alpha of the shifted page
    [self setAlphaForPage : page];	
    
}

- (void) setNumberOfPages : (NSInteger) number 
{
    _numberOfPages = number; 
    _scrollView.contentSize = CGSizeMake(_numberOfPages * _scrollView.bounds.size.width, _scrollView.bounds.size.height);            
    _pageSelector.numberOfPages = _numberOfPages;      

}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(pageScrollViewWillBeginDragging:)]) {
        [self.delegate pageScrollViewWillBeginDragging:self];
    }
}


- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([self.delegate respondsToSelector:@selector(pageScrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate pageScrollViewDidEndDragging:self willDecelerate:decelerate];
    }

    if (_isPendingScrolledPageUpdateNotification) {
        if ([self.delegate respondsToSelector:@selector(pageScrollView:didScrollToPage:atIndex:)]) {
            NSInteger selectedIndex = [_visiblePages indexOfObject:_selectedPage];
            [self.delegate pageScrollView:self didScrollToPage:_selectedPage atIndex:selectedIndex];
        }
        _isPendingScrolledPageUpdateNotification = NO;
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(pageScrollViewWillBeginDecelerating:)]) {
        [self.delegate pageScrollViewWillBeginDecelerating:self];
    }
  
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(pageScrollViewDidEndDecelerating:)]) {
        [self.delegate pageScrollViewDidEndDecelerating:self];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	// update the visible pages
	[self updateVisiblePages];
	
	// adjust alpha for all visible pages
	[_visiblePages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[self setAlphaForPage : obj];		
	}];
	
	
	CGFloat delta = scrollView.contentOffset.x - _selectedPage.frame.origin.x;
	BOOL toggleNextItem = (fabs(delta) > scrollView.frame.size.width / 2);
	if (toggleNextItem && [_visiblePages count] > 1) {
		
		NSInteger selectedIndex = [_visiblePages indexOfObject:_selectedPage];
		BOOL neighborExists = ((delta < 0 && selectedIndex > 0) || (delta > 0 && selectedIndex < [_visiblePages count]-1));
		
		if (neighborExists) {
			
			NSInteger neighborPageVisibleIndex = [_visiblePages indexOfObject:_selectedPage] + (delta > 0? 1:-1);
			HGPageView *neighborPage = [_visiblePages objectAtIndex:neighborPageVisibleIndex];
			NSInteger neighborIndex = _visibleIndexes.location + neighborPageVisibleIndex;

			[self updateScrolledPage:neighborPage index:neighborIndex];
			
		}
		
	}

}


- (void) updateScrolledPage : (HGPageView*) page index : (NSInteger) index
{
    if (!page) {
        _selectedPage = nil;
    }
    else{
        // notify delegate
        if ([self.delegate respondsToSelector:@selector(pageScrollView:willScrollToPage:atIndex:)]) {
            [self.delegate pageScrollView:self willScrollToPage:page atIndex:index];
        }
        
        // set the page selector (page control)
        [_pageSelector setCurrentPage:index];
        
        // set selected page
        _selectedPage = page;
        //	NSLog(@"selectedPage: 0x%x (index %d)", page, index );
        
        if (_scrollView.dragging) {
            _isPendingScrolledPageUpdateNotification = YES;
        }
        else{
            // notify delegate again
            if ([self.delegate respondsToSelector:@selector(pageScrollView:didScrollToPage:atIndex:)]) {
                [self.delegate pageScrollView:self didScrollToPage:page atIndex:index];
            }
            _isPendingScrolledPageUpdateNotification = NO;
        }	       
    }

}



- (void) updateVisiblePages
{
	CGFloat pageWidth = _scrollView.frame.size.width;

	//get x origin of left- and right-most pages in _scrollView's superview coordinate space (i.e. self)  
	CGFloat leftViewOriginX = _scrollView.frame.origin.x - _scrollView.contentOffset.x + (_visibleIndexes.location * pageWidth);
	CGFloat rightViewOriginX = _scrollView.frame.origin.x - _scrollView.contentOffset.x + (_visibleIndexes.location+_visibleIndexes.length-1) * pageWidth;
	
	if (leftViewOriginX > 0) {
		//new page is entering the visible range from the left
		if (_visibleIndexes.location > 0) { //is it not the first page?
			_visibleIndexes.length += 1;
			_visibleIndexes.location -= 1;
			HGPageView *page = [self loadPageAtIndex:_visibleIndexes.location insertIntoVisibleIndex:0];
            // add the page to the scroll view (to make it actually visible)
            [self addPageToScrollView:page atIndex:_visibleIndexes.location ];

		}
	}
	else if(leftViewOriginX < -pageWidth){
		//left page is exiting the visible range
		UIView *page = [_visiblePages objectAtIndex:0];
        [_visiblePages removeObject:page];
        [page removeFromSuperview]; //remove from the scroll view
		_visibleIndexes.location += 1;
		_visibleIndexes.length -= 1;
	}
	if (rightViewOriginX > self.frame.size.width) {
		//right page is exiting the visible range
		UIView *page = [_visiblePages lastObject];
        [_visiblePages removeObject:page];
        [page removeFromSuperview]; //remove from the scroll view
		_visibleIndexes.length -= 1;
	}
	else if(rightViewOriginX + pageWidth < self.frame.size.width){
		//new page is entering the visible range from the right
		if (_visibleIndexes.location + _visibleIndexes.length < _numberOfPages) { //is is not the last page?
			_visibleIndexes.length += 1;
            NSInteger index = _visibleIndexes.location+_visibleIndexes.length-1;
			HGPageView *page = [self loadPageAtIndex:index insertIntoVisibleIndex:_visibleIndexes.length-1];
            [self addPageToScrollView:page atIndex:index];

		}
	}
}


- (void) setAlphaForPage : (UIView*) page
{
	CGFloat delta = _scrollView.contentOffset.x - page.frame.origin.x;
	CGFloat step = self.frame.size.width;
	CGFloat alpha = fabs(delta/step)*2./5.;
	if(alpha > 0.2) alpha = 0.2;
	if(alpha < 0.05) alpha = 0.;
    
    if ([page isKindOfClass:[HGPageView class]]) {
        [self setOpacity:alpha forObstructionLayerOfPage:(HGPageView*)page];
    }
    else{
        CGFloat alpha = 1.0 - fabs(delta/step);
        if(alpha > 0.) alpha = 1.0;
        page.alpha = alpha;        
    }
}

- (void)setOpacity:(CGFloat)alpha forObstructionLayerOfPage:(HGPageView *)page
{
	[page.maskLayer setOpacity:alpha];
}




- (HGPageView *)dequeueReusablePageWithIdentifier:(NSString *)identifier;  // Used by the delegate to acquire an already allocated page, instead of allocating a new one
{
	HGPageView *reusablePage = nil;
	NSArray *reusables = [_reusablePages objectForKey:identifier];
	if (reusables){
		NSEnumerator *enumerator = [reusables objectEnumerator];
		while ((reusablePage = [enumerator nextObject])) {
			if(![_visiblePages containsObject:reusablePage]){
				[reusablePage prepareForReuse];
				break;
			}
		}
	}
	return reusablePage;
}


#pragma mark -
#pragma mark Handling Touches


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	if (_viewMode == HGPageScrollViewModeDeck && !_scrollView.decelerating && !_scrollView.dragging) {
		return YES;	
	}
	return NO;	
}


- (void)handleTapGestureFrom:(UITapGestureRecognizer *)recognizer 
{
    if(!_selectedPage)
        return;
    
	NSInteger selectedIndex = [self indexForSelectedPage];
    
    if ([self.delegate respondsToSelector:@selector(pageScrollView:didDeselectPageAtIndex:)]) {
        [self.delegate pageScrollView:self didDeselectPageAtIndex:selectedIndex];
    }
	
	//[self selectPageAtIndex:selectedIndex animated:YES];
		
}


#pragma mark -
#pragma mark Actions


- (void) didChangePageValue : (id) sender;
{
	NSInteger selectedIndex = [self indexForSelectedPage];
	if(_pageSelector.currentPage != selectedIndex){
		//set pageScroller
		selectedIndex = _pageSelector.currentPage;
		//_userInitiatedScroll = NO;		
		[self scrollToPageAtIndex:selectedIndex animated:YES];			
	}
}



@end
