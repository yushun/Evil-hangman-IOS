//
//  FlipsideViewController.h
//  Hangman
//
//  Created by yushun he on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController {

}
@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) IBOutlet UILabel *numOfLetters;
@property (nonatomic, retain) IBOutlet UISlider *numOfTrysSlider;
@property (nonatomic, retain) IBOutlet UILabel *numOfTrys;
@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)changeSlider;
- (IBAction)changeNumOfTrysSlider;
- (IBAction)done:(id)sender;

@end


@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end
