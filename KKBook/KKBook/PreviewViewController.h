
#import "MHPagingScrollView.h"

//@interface PreviewViewController : UIViewController <MHPagingScrollViewDelegate, UIScrollViewDelegate>{
@interface PreviewViewController : UIViewController <UIScrollViewDelegate>{
    NSInteger currentIndex;
}

//@property (nonatomic, weak) IBOutlet MHPagingScrollView *pagingScrollView;
@property (nonatomic, weak) IBOutlet UIScrollView *pagingScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSMutableArray *previews;
@property (strong ,nonatomic) NSMutableArray *tempImage;

//- (IBAction)pageTurn;

@end
