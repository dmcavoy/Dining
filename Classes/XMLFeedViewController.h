//
//  XMLFeedViewController.h
//  Bowdoin
//
//  Created by Ben Johnson on 7/17/09.
//  Copyright 2009 __Bowdoin__. All rights reserved.
//
//  The XMLFeedViewController was initially designed to be the 
//  controller for an XML feeds but was adapted to support a UIWindowView
//  The misnomer XMLFeed is a relic. This is essentially a View Controller
//  setting up the UI environment.
//  
//  This controller has few intelligent functions. It merely responds and reacts to information
//  and events. The brains of the program is implemented in ContentAreaViewController.m

#import <UIKit/UIKit.h>

@class ContentAreaViewController;
@class GrillAreaViewController;
@class HourScrollViewController;
@class MailComposerViewController;



@interface XMLFeedViewController : UIViewController <UIScrollViewDelegate> {
	IBOutlet UILabel *diningHallLabel;
	IBOutlet UIButton *leftButton;
	IBOutlet UIButton *rightButton;
	IBOutlet UIButton *infoButton;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIToolbar *toolBar;
	IBOutlet UIBarButtonItem *todayButton;
	IBOutlet UIBarButtonItem *tomorrowButton;
	int selectedSegment;
	ContentAreaViewController *thorneController;
	ContentAreaViewController *moultonController;
	UISegmentedControl *segmentedControlBar;
	IBOutlet UISegmentedControl *daySegmentedControl;

	
	//Secondary View Definitions
	HourScrollViewController *hourController;
//	IBOutlet UIView *secondaryView;
	
	//Modal controller Definitions
	GrillAreaViewController *grillMenuController;
		
	// booleans for setting whether menus are needed
	BOOL *eveningMenuBoolean;
	BOOL *loadNeeded;
	
	

	 	
}

@property (nonatomic, retain) IBOutlet UILabel *diningHallLabel;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) ContentAreaViewController *thorneController;
@property (nonatomic, retain) ContentAreaViewController *moultonController;
@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, retain) UIButton *rightButton;
//@property (nonatomic, retain) UIBarButtonItem *todayButton;
//@property (nonatomic, retain) UIBarButtonItem *tomorrowButton;
//@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, retain) UISegmentedControl *segmentedControlBar;
@property (nonatomic, retain) UISegmentedControl *daySegmentedControl;

@property (nonatomic, retain) IBOutlet UIButton *infoButton;

// Secondary View Properties
@property (nonatomic, retain) HourScrollViewController *hourController;
//@property (nonatomic, retain) UIView *secondaryView;

//Modal Controller
@property (nonatomic, retain) GrillAreaViewController *grillMenuController;

//Evening Menu
@property (nonatomic) BOOL *eveningMenuBoolean;
@property (nonatomic) BOOL *loadNeeded;




- (void)setSelectedSegment:(int)index;
- (IBAction)showHours:(id)sender; //Action for hoursInfoView
- (void)returnView:(int)diningHallToDisplay;
- (void)refreshScrollView:(NSString*)newMeal;
- (void)loadScrollView;
- (BOOL)checkIfCurrentDataExists;
- (void)presentModalController;



@end
