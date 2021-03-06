//
//  HGPageImageView.m
//  HGPageScrollViewSample
//
//  Created by Hans Engel on 5/12/13.
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

#import "HGPageImageView.h"
#import "UIImageView+WebCache.h"

@implementation HGPageImageView

@synthesize image;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self ) {
        [self _init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self ) {
        [self _init];
    }
    return self;
}

- (void)_init {
    _identityFrame = [self frame];

    imageView = [[[UIImageView alloc] initWithFrame:[self frame]] retain];
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBanner:)];
    [imageView addGestureRecognizer:tapGesture];
    
    [self addSubview:imageView];
}

- (void)setImage:(UIImage *)_image {
    [_image retain];
    [image release];
    image = _image;

    [imageView setImage:image];
}

-(void)setImageURL:(NSURL *)imageURL{
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   // __weak UIImageView *weakImageView = imageView;
    [imageView sd_setImageWithURL:imageURL
                           placeholderImage:nil
                                    options:SDWebImageProgressiveDownload
                                   progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                       if (!activityIndicator) {
                                           [imageView addSubview:activityIndicator];
                                           activityIndicator.center = imageView.center;
                                           [activityIndicator startAnimating];
                                       }
                                   }
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      [activityIndicator removeFromSuperview];
                                      activityIndicator = nil;
                                  }];

}

-(void)tapBanner:(id)sender{
    if ([[self delegate] respondsToSelector:@selector(didTapImage:)]) {
        [[self delegate] didTapImage:imageView.tag];
    }
}

- (void)dealloc {
    [imageView release];
    [image release];
    [_imageURL release];
    [super dealloc];
}

@end
