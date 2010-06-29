//
//  HourScrollViewController.m
//  Bowdoin
//
//  Created by Ben Johnson on 10/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "HourScrollViewController.h"


@implementation HourScrollViewController

@synthesize hourScrollView, thorneHourController, moultonHourController, delegate;

- (id)initWithLocation:(int)hallcode; {
	hallNumber = hallcode;
	
	HourInfoViewController *tempController = [[HourInfoViewController alloc] initWithHall:(int) 49];	
	self.thorneHourController = tempController;
	[thorneHourController setAppDelegate:self]; //sets App Delegate
	[tempController release];
	
	HourInfoViewController *anotherController = [[HourInfoViewController alloc] initWithHall:(int) 48];	
	self.moultonHourController = anotherController;
	[moultonHourController setAppDelegate:self]; //sets App Delegate
	[anotherController release];
		
	return self;
	
	}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	hourScrollView.pagingEnabled = YES;
    hourScrollView.showsHorizontalScrollIndicator = NO;
	hourScrollView.contentSize = CGSizeMake(hourScrollView.frame.size.width * 2, hourScrollView.frame.size.height);
    hourScrollView.showsVerticalScrollIndicator = YES;
    hourScrollView.scrollsToTop = NO;
	hourScrollView.delegate = self;
	hourScrollView.directionalLockEnabled = YES;
	hourScrollView.scrollEnabled = NO;
	

	// Apparently the order in which you add views to a UIScrollView impacts which view
	// will be displayed during the Flip Animation.
	// Therefore this conditional determines which view needs to appear during the switch
	// so that there is no change in the view after the flip
	
	// In addition the relative position of the HourInfoViewControllers changes based on which
	// menu they are called from
	
	if (hallNumber == 48){
		
		// add the controller's view to the scroll view
		if (nil == thorneHourController.view.superview) {
			CGRect frame = hourScrollView.frame;
			frame.origin.x = frame.size.width * 1;
			frame.origin.y = 0;
			thorneHourController.view.frame = frame;
			[hourScrollView addSubview:thorneHourController.view];
			[thorneHourController setOnRight];
		}
		
		// add the controller's view to the scroll view
		if (nil == moultonHourController.view.superview) {
			CGRect frame = hourScrollView.frame;
			frame.origin.x = frame.size.width * 0;
			frame.origin.y = 0;
			moultonHourController.view.frame = frame;
			[hourScrollView addSubview:moultonHourController.view];
			[moultonHourController setOnLeft];

		}
		
		
		
	} else {
		
		// add the controller's view to the scroll view
		if (nil == moultonHourController.view.superview) {
			CGRect frame = hourScrollView.frame;
			frame.origin.x = frame.size.width * 1;
			frame.origin.y = 0;
			moultonHourController.view.frame = frame;
			[hourScrollView addSubview:moultonHourController.view];
			[moultonHourController setOnRight];

		}
		
		// add the controller's view to the scroll view
		if (nil == thorneHourController.view.superview) {
			CGRect frame = hourScrollView.frame;
			frame.origin.x = frame.size.width * 0;
			frame.origin.y = 0;
			thorneHourController.view.frame = frame;
			[hourScrollView addSubview:thorneHourController.view];
			[thorneHourController setOnLeft];
		}
		
		
		
	}
	
	
}


- (void)setAppDelegate:(id)sender{
	self.delegate = sender;
}

// switches the view to the undisplayed dining hall
- (void)switchHourView {
	CGFloat pageWidth = hourScrollView.frame.size.width;
    int page = floor((hourScrollView.contentOffset.x - pageWidth / 2) / pageWidth + 1);
	
	if (page == 1){
		CGPoint firstPage = CGPointMake(0, 0);
		[hourScrollView setContentOffset: firstPage animated: YES];	
	} else {
		CGPoint secondPage = CGPointMake((([hourScrollView contentSize].width)/2)*1, 0);
		[hourScrollView setContentOffset: secondPage animated: YES];

	}

}

// sends a method to delegate to return back to a certain view
// based on where the user is in the hourInfopage regardless of their location they
// will flip to the menus of the current hour info page dining hall they are viewing
- (void)exitHourView {
	CGFloat pageWidth = hourScrollView.frame.size.width;
    int page = floor((hourScrollView.contentOffset.x - pageWidth / 2) / pageWidth + 1);
	
	int thorne = 0;
	int moulton = 1;
	
	if (hallNumber == 48){
		switch (page) {
			case 0: [delegate returnView:moulton]; break;
			case 1: [delegate returnView:thorne]; break;
			default: break;
		} //switch
	} else {
		switch (page) {
			case 0: [delegate returnView:thorne]; break;
			case 1: [delegate returnView:moulton]; break;
			default: break;
		} //switch
	} //else
}
	

- (void)presentModalController {
	[delegate presentModalController];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[hourScrollView release];
	[moultonHourController release];
	[thorneHourController release];
	[delegate dealloc];
	[super dealloc];
}


@end
