//
//  GrillAreaViewController.h
//  Bowdoin
//
//  Created by Ben Johnson on 8/3/09.
//  Copyright 2009 __Bowdoin College___ All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GrillAreaViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *aWebView;
	IBOutlet UIBarButtonItem *doneButton;
	IBOutlet UIBarButtonItem *callGrillButton;
	IBOutlet UIActivityIndicatorView *activityIndicator;

	
	
	
}

@property (nonatomic, retain) IBOutlet UIWebView *aWebView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *callGrillButton;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;

-(IBAction)dismissModalController;
-(IBAction)callTheGrill;

@end
