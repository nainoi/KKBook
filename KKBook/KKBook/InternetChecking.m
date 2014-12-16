//
//  InternetChecking.m
//  MoMag
//
//  Created by Disakul Waidee on 8/1/10.
//  Copyright 2010 Digix Technology. All rights reserved.
//

#import "InternetChecking.h"

#define HOST @"www.google.com"

@interface InternetChecking(PrivateMethod)

// Check internet active
- (void)reachabilityChanged:(NSNotification *)note;
- (void)updateStatus;

@end

@implementation InternetChecking

static InternetChecking *sharedInstance = nil;
static dispatch_once_t onceToken;

@synthesize networkStatus,hostReach,isActived;

-(id)init{
	self = [super init];
	if(self){
		//Use the Reachability class to determine if the internet can be reached.
		hostReach =  [Reachability reachabilityWithHostName:HOST];
		//Set Reachability class to notifiy app when the network status changes.
		[hostReach startNotifier];
		// Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
		// method "reachabilityChanged" will be called. 
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
		[self updateStatus];
	}
	return self;
}

+ (BOOL)isConnectedToInternet {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (status == ReachableViaWiFi|| status == ReachableViaWWAN)
        return YES;
    else
        return NO;
}

/**************         Check internet active ********************/

-(void)updateStatus{
	
	networkStatus = [hostReach currentReachabilityStatus];
	if((networkStatus != ReachableViaWiFi) && (networkStatus != ReachableViaWWAN))
	{
		isActived = NO;
	}else {
		isActived= YES;
		
		NSLog(@"Internet is available");
	}
}

-(void)reachabilityChanged:(NSNotification *)note{
	[self updateStatus];
}

#pragma mark -
#pragma mark class instance methods

#pragma mark -
#pragma mark Singleton methods

+ (InternetChecking*)sharedInstance
{
    dispatch_once(&onceToken, ^{
        sharedInstance = [[InternetChecking alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}



@end
