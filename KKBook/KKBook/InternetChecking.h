//
//  InternetChecking.h
//  MoMag
//
//  Created by Disakul Waidee on 8/1/10.
//  Copyright 2010 Digix Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"


@interface InternetChecking : NSObject {

	Reachability* hostReach;
	// Internet active
	BOOL         isActived;
	NetworkStatus networkStatus;
}
@property (nonatomic,readonly) NetworkStatus networkStatus;
@property (nonatomic,strong,readonly) Reachability* hostReach;
@property (nonatomic,readonly) BOOL          isActived;

+ (InternetChecking*)sharedInstance;

+ (BOOL)isConnectedToInternet;

@end
