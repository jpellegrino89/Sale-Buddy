//
//  LoginView.m
//  Sale Buddy
//
//  Created by Joseph Pellegrino on 2/25/14.
//  Copyright (c) 2014 Ready. All rights reserved.
//

#import "LoginView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ImageEffects.h"


@interface LoginView ()

@end

@implementation LoginView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = user.id;
    self.nameLabel.text = [NSString stringWithFormat:@"Welcome, %@",user.name];
    self.nameLabel.font = [UIFont fontWithName:@"Gotham-Book" size:17];
    //loginView.frame = CGRectOffset(loginView.frame, 5, -100);
    self.welcomeLabel.alpha=0;
    self.profilePictureView.alpha=1;
    self.profilePictureView.layer.cornerRadius=self.profilePictureView.frame.size.width / 2;
    self.profilePictureView.layer.borderWidth=3.0f;
    self.profilePictureView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profilePictureView.layer.shadowOffset=CGSizeMake(0,1);
    self.profilePictureView.layer.shadowOpacity=1;
    self.profilePictureView.layer.shadowRadius=1.0;
   // self.profilePictureView.layer.cornerRadius=10.0f;
    
    CALayer* containerLayer = [CALayer layer];
    containerLayer.shadowColor = [UIColor blackColor].CGColor;
    containerLayer.shadowRadius = 2;
    containerLayer.shadowOffset = CGSizeMake(1, 1);
    containerLayer.shadowOpacity = 1;
    
    [containerLayer addSublayer:self.profilePictureView.layer];
    [self.view.layer addSublayer:containerLayer];

    
    
    self.profilePictureView.clipsToBounds = YES;
  
    [FBLoginView beginAnimations:nil context:NULL];
    //loginView.frame = CGRectOffset(loginView.frame, 5, 5);

    [FBLoginView setAnimationDuration:0.5];
    [FBLoginView commitAnimations];
    [self performSelector:@selector(initialView) withObject:self afterDelay:2.0];
    /*
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    [self presentViewController:vc animated:YES completion:nil];
    */
    
    

}
-(void)initialView{
    [self performSegueWithIdentifier:@"FBMove" sender:self];


}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.profilePictureView.alpha=1;
    self.nameLabel.text = @"Logging in is easy, just tap the button below";
    self.statusLabel.text= @"You're not logged in!";
    self.welcomeLabel.text=@"";
    self.welcomeLabel.alpha=1;
    
}



- (void)viewDidLoad
{
    //[[FBProfilePictureView layer] setCornerRadius:10];
    
    _welcomeLabel.font=[UIFont fontWithName:@"Gotham-Light" size:50];

    _saleBuddy.font=[UIFont fontWithName:@"Gotham-Book" size:40];
    _saleBuddy.font=[UIFont fontWithName:@"Avenir" size:40];
    //_saleBuddy.shadowColor=[UIColor blackColor];
    //_saleBuddy.shadowOffset=CGSizeMake(1,1);
    _saleBuddy.layer.shadowRadius = .9f;
    _saleBuddy.layer.shadowOpacity = .9;
    _saleBuddy.layer.shadowOffset=CGSizeMake(1,1);
   //_saleBuddy.layer.masksToBounds = NO;
    
    _nameLabel.layer.shadowRadius = .9f;
    _nameLabel.layer.shadowOpacity = .9;
    _nameLabel.layer.shadowOffset=CGSizeMake(1,1);
    
    
    
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email", @"user_likes"]];
    loginView.delegate = self;
    loginView.frame=CGRectMake(0, 0, 0, 0);
    
    [self.view addSubview:loginView];
 
    
    UIColor *tintColor = [UIColor colorWithWhite:0.0 alpha:0.3];

    UIImage *img = [UIImage imageNamed:@"wall.jpg"];
    
    img=[img applyBlurWithRadius:10 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
    
       self.view.backgroundColor = [UIColor colorWithPatternImage: img];

    [super viewDidLoad];
    //self.profilePictureView.layer.cornerRadius=self.profilePictureView.frame.size.width / 2;
   // self.profilePictureView.clipsToBounds = YES;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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



@end
