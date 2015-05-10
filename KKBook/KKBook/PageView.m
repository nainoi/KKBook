
#import "PageView.h"
#import "UIImageView+WebCache.h"

@implementation PageView

- (id)init
{
	if ((self = [super init]))
	{
		self.opaque = YES;

		self.backgroundColor = [UIColor clearColor];
        self.contentMode = UIViewContentModeScaleAspectFit;
	}
	return self;
}

-(void)setImageURL:(NSURL*)url{
    __block UIActivityIndicatorView *activityIndicator;
    __weak UIImageView *weakImageView = self;
    [self sd_setImageWithURL:url
                 placeholderImage:nil
                          options:SDWebImageProgressiveDownload
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             if (!activityIndicator) {
                                 [weakImageView addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                                 activityIndicator.center = weakImageView.center;
                                 [activityIndicator startAnimating];
                             }
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            [activityIndicator removeFromSuperview];
                            activityIndicator = nil;
                        }];
    //_zoomView = [[UIImageView alloc] initWithImage:image];

}

@end
