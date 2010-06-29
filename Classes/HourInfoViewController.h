//
//  HourInfoViewController.h
//  Bowdoin
//
//  Created by Ben Johnson on 8/14/09.
//  Copyright 2009 Bowdoin College. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentAreaViewController.h"
#import "XMLFeedViewController.h"


@class ContentAreaViewController;
@class HourScrollViewController;
@class GrillAreaViewController;


@interface HourInfoViewController : UIViewController {
	
	
	// Labels used for hour information
	IBOutlet UILabel *hallLabel;
	IBOutlet UILabel *grillLabel;
	IBOutlet UILabel *dateLabel;
	IBOutlet UILabel *mealOne;
	IBOutlet UILabel *mealTwo;
	IBOutlet UILabel *mealThree;
	IBOutlet UILabel *mealFour;
	IBOutlet UILabel *hoursOne;
	IBOutlet UILabel *hoursTwo;
	IBOutlet UILabel *hoursThree;
	IBOutlet UILabel *hoursFour;
	IBOutlet UILabel *grillHours;
	IBOutlet UILabel *cafeHoursOne;
	IBOutlet UILabel *cafeHoursTwo;
	IBOutlet UILabel *hotOne;
	IBOutlet UILabel *hotTwo;
	IBOutlet UILabel *hotThree;
	IBOutlet UILabel *creditsLabel;
	// might be able to get rid of below ContentAreaViewController
	ContentAreaViewController *tempDayController;
	
	// Buttons used for Navigation
	IBOutlet UIButton *leftHallButton;
	IBOutlet UIButton *rightHallButton;
	IBOutlet UIButton *doneButton;
	IBOutlet UIButton *emailButton;
	IBOutlet UIButton *callGrillButton;
	
	int hourInfoAlert;
	int hallCode;
	
	HourScrollViewController *delegate;
	HourInfoViewController *nextController;
	GrillAreaViewController *grillMenuController;

}

	@property (nonatomic, retain) UILabel *hallLabel;
	@property (nonatomic, retain) UILabel *grillLabel;
	@property (nonatomic, retain) UILabel *dateLabel;
	@property (nonatomic, retain) UILabel *mealOne;
	@property (nonatomic, retain) UILabel *mealTwo;
	@property (nonatomic, retain) UILabel *mealThree;
	@property (nonatomic, retain) UILabel *mealFour;
	@property (nonatomic, retain) UILabel *hoursOne;
	@property (nonatomic, retain) UILabel *hoursTwo;
	@property (nonatomic, retain) UILabel *hoursThree;
	@property (nonatomic, retain) UILabel *hoursFour;
	@property (nonatomic, retain) UILabel *grillHours;
	@property (nonatomic, retain) UILabel *cafeHoursOne;
	@property (nonatomic, retain) UILabel *cafeHoursTwo;
	@property (nonatomic, retain) UILabel *hotOne;
	@property (nonatomic, retain) UILabel *hotTwo;
	@property (nonatomic, retain) UILabel *hotThree;
	@property (nonatomic, retain) UILabel *creditsLabel;
	@property (nonatomic, retain) ContentAreaViewController *tempDayController;
	@property (nonatomic, retain) HourInfoViewController *nextController;
	@property (nonatomic, retain) GrillAreaViewController *grillMenuController;

	@property (nonatomic, retain) UIButton *leftHallButton;
	@property (nonatomic, retain) UIButton *rightHallButton;	
	@property (nonatomic, retain) UIButton *doneButton;
	@property (nonatomic, retain) UIButton *emailButton;
	@property (nonatomic, retain) UIButton *callGrillButton;



	// App Delegate
	@property (nonatomic, retain) HourScrollViewController *delegate;




- (id)initWithHall:(int)hall;
- (IBAction)returnView:(id)sender;
- (IBAction)changeDiningHall;
- (IBAction)sendEmail;
- (IBAction)callTheGrill;
- (IBAction)displayGrillPDF;
- (void)setDiningLabels;
- (void)setAppDelegate:(id)sender;
- (void)setOnLeft;
- (void)setOnRight;
- (int)currentHallCode;




@end
