//
//  FirstViewController.m
//  Sale Buddy
//
//  Created by Joseph Pellegrino on 10/19/13.
//  Copyright (c) 2013 Ready. All rights reserved.
//

#import "FirstViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import "UIImage+ImageEffects.h"

@interface FirstViewController ()

@property (copy, nonatomic) NSString* profileID;


@end

@implementation FirstViewController

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = user.id;
    self.nameLabel.text = user.name;
    self.nameLabel.font = [UIFont fontWithName:@"Gotham-Light" size:17];
    loginView.frame = CGRectOffset(loginView.frame, 5, -100);
    
    
    
}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.statusLabel.text= @"You're not logged in!";
}

-(IBAction)backgroundTouched:(id)sender
{
	[originalPrice resignFirstResponder];
    [percentageOff resignFirstResponder];
    //[additionalDiscount resignFirstResponder];
}

- (void)viewDidLoad

{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

    login.backgroundColor = [UIColor clearColor];
    UIToolbar *blurbar = [[UIToolbar alloc] initWithFrame:login.frame];
    blurbar.barStyle = UIBarStyleDefault;
    [login.superview insertSubview:blurbar belowSubview:login];
    [blurbar setAlpha:0];
   
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [blurbar setAlpha:1.0];
    [UIView commitAnimations];
    
     FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email", @"user_likes"]];
    loginView.delegate = self;

    originalPriceLabel.text=@"Original Price";
    originalPriceLabel.font = [UIFont fontWithName:@"Gotham-Light" size:17];
    
    percentageOffLabel.text=@"Percentage Off";
    percentageOffLabel.font = [UIFont fontWithName:@"Gotham-Light" size:17];
    
    
    finalPrice.font = [UIFont fontWithName:@"Gotham-Medium" size:30];

    originalPrice.font=[UIFont fontWithName:@"Gotham-Book" size:23];
    percentageOff.font=[UIFont fontWithName:@"Gotham-Book" size:23];
    
    originalPrice.keyboardType=UIKeyboardTypeDecimalPad;
    percentageOff.keyboardType=UIKeyboardTypeDecimalPad;
    
    //Calculate Button
    [calculateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    calculateButton.layer.borderWidth = 1.0;
    calculateButton.layer.masksToBounds = YES;
    calculateButton.layer.cornerRadius = 5.0;
    [calculateButton.titleLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:16]];
    calculateButton.layer.borderColor=[[UIColor blueColor] CGColor];
    [calculateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

    
    


    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)+20), 34);

    [self.view addSubview:loginView];
    
    //Gesture Recognizer
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];


    /*
    //FB LOGIN START
    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame,
                                   (self.view.center.x - (loginView.frame.size.width / 2)),
                                   5);
    loginView.publishPermissions = @[@"publish_actions"];
    loginView.defaultAudience = FBSessionDefaultAudienceFriends;
    
    [self.view addSubview:loginView];
    [loginView sizeToFit];
    //FB LOGIN END
    
    // Initialize the profile picture
    self.profilePictureView = [[FBProfilePictureView alloc] init];
    // Set the size
    self.profilePictureView.frame = CGRectMake(0.0, 0.0, 75.0, 75.0);
    // Show the profile picture for a user
   // self.profilePictureView.profileID = @"user.id";
    // Add the profile picture view to the main view
    [self.view addSubview:self.profilePictureView];
    //PICTURE VIEW END
    */
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnTwitterSharing_Clicked:(id)sender {
    NSString *textToShare = @"your text";
   // UIImage *imageToShare = [UIImage imageNamed:@"yourImage.png"];
    NSArray *itemsToShare = @[textToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,UIActivityTypePostToFacebook,UIActivityTypePostToTwitter]; //or whichever you don't need
    [self presentViewController:activityVC animated:YES completion:nil];

}
-(IBAction)btnFacebookSharing_Clicked:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController * fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [fbSheetOBJ setInitialText:@"Post from my iOS application"];
        [fbSheetOBJ addURL:[NSURL URLWithString:@"http://www.weblineindia.com"]];
        [fbSheetOBJ addImage:[UIImage imageNamed:@"my_image_to_share.png"]];
        
        [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
    }
}
@end
