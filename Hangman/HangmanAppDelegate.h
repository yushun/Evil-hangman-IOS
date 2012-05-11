//
//  HangmanAppDelegate.h
//  Hangman
//
//  Created by yushun he on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface HangmanAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MainViewController *mainViewController;

@end
