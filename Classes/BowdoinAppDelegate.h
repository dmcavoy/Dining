//
//  BowdoinAppDelegate.h
//  Bowdoin College
//
//  Created by Ben Johnson on 7/17/09 - Final Release 10/26/09
//  Under the guide of Andrew Currier and the IT Education and Research Department
//  Development funded by Alumnus John Gibbons
// 
//  As this was my first iPhone application lots of code has been gleemed from Apple's
//  Code Examples. The psuedo code for much of this project was found through various
//  web surfing and iPhone Dev forums.
//
//  I will try to denote what code is not solely mine. 
//  
//  
//
#import <UIKit/UIKit.h>
#import "XMLFeedViewController.h"


@class XMLFeedViewController;

@interface BowdoinAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
    
    UIWindow *window;
	IBOutlet UINavigationController *navController;
	IBOutlet UILabel *noConnectionLabel;
	IBOutlet UILabel *noConnectionLabel2;
	IBOutlet UISegmentedControl *controlBar;
	UIAlertView *noConnectionAlert;
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet UILabel *noConnectionLabel;
@property (nonatomic, retain) IBOutlet UILabel *noConnectionLabel2;
@property (nonatomic, retain) IBOutlet UISegmentedControl *controlBar;

@property (nonatomic, retain) UIAlertView *noConnectionAlert;


- (BOOL)connectedToNetwork:(NSString *)remoteServer; 

@end

