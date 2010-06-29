//
//  HourScrollViewController.h
//  Bowdoin
//
//  Created by Ben Johnson on 10/10/09.
//  Copyright 2009 Bowdoin College. All rights reserved.
//
//  Responsible for controlling the layout of the Hour Info Pages

#import <UIKit/UIKit.h>
#import "HourInfoViewController.h"

@class HourInfoViewController;
@class XMLFeedViewController;

@interface HourScrollViewController : UIViewController <UIScrollViewDelegate> {
	
	IBOutlet UIScrollView *hourScrollView;
	HourInfoViewController *thorneHourController;
	HourInfoViewController *moultonHourController;
	
	XMLFeedViewController *delegate;
	
	int hallNumber;
}

@property (nonatomic, retain) IBOutlet UIScrollView *hourScrollView;
@property (nonatomic, retain) HourInfoViewController *thorneHourController;
@property (nonatomic, retain) HourInfoViewController *moultonHourController;
@property (nonatomic, retain) XMLFeedViewController *delegate;


- (id)initWithLocation:(int)hallcode;
- (void)switchHourView;
- (void)exitHourView;
- (void)setAppDelegate:(id)sender;
- (void)presentModalController;

@end

