//
//  FirstViewController.m
//  Sale Buddy
//
//  Created by Joseph Pellegrino on 10/19/13.
//  Copyright (c) 2013 Ready. All rights reserved.
//

#import "FirstViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+ImageEffects.h"

@interface FirstViewController ()

@property (copy, nonatomic) NSString* profileID;
@property (strong, nonatomic) NSString *objectID;



@end

@implementation FirstViewController
@synthesize finalPrice;

-(IBAction) switchValueChanged{
    if ([further isOn]) {
        NSLog(@"Switch ON");
        [self thirtyDiscount:nil];}
    else {
        
        [self calculatePrice:nil];
        [furtherDiscountLabel setText: [NSString stringWithFormat:@""]];
        [additionalDiscount resignFirstResponder];
        
    }
}
// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = user.id;
    self.nameLabel.text = user.name;
    self.nameLabel.font = [UIFont fontWithName:@"Gotham-Light" size:17];
    loginView.frame = CGRectOffset(loginView.frame, 5, -100);
    [self.view sendSubviewToBack:loginView];
}
- (IBAction)place:(id)sender {
    // Initialize the place picker
    FBPlacePickerViewController *placePickerController = [[FBPlacePickerViewController alloc] init];
    // Set the place picker title
    placePickerController.title = @"Pick Place";
    // Hard code current location to Menlo Park, CA
    placePickerController.locationCoordinate = CLLocationCoordinate2DMake(37.453827, -122.182187);
    // Configure the additional search parameters
    placePickerController.radiusInMeters = 1000;
    placePickerController.resultsLimit = 50;
    placePickerController.searchText = @"restaurant";
    
    // TODO: Set up the place picker delegate to handle
    // picker callbacks, ex: Done/Cancel button
    
    // Load the place data
    [placePickerController loadData];
    // Show the place picker modally
    [placePickerController presentModallyFromViewController:self animated:YES handler:nil];
}
- (void)imageTaped:(UIGestureRecognizer *)gestureRecognizer
    {
        if(FBSession.activeSession.state == FBSessionStateOpen){
        
        //self.profilePictureView.alpha = 0.0f;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to Log Out of Facebook?"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"NO"
                                              otherButtonTitles:@"YES", nil];
        [alert show];
        }
        
        else {
            
            // If there's one, just open the session silently, without showing the user the login UI
            [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                               allowLoginUI:NO
                                          completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                              // Handler for session state changes
                                              // This method will be called EACH time the session state changes,
                                              // also for intermediate states and NOT just when the session open
                                              
                                          }];
        }


}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"Clicked button index 0");
        [FBSession.activeSession closeAndClearTokenInformation];
        // Add the action here
    } else {
        NSLog(@"Clicked button index other than 0");
        // Add another action here
    }
}

- (IBAction)FBLogout:(id)sender {
     [FBSession.activeSession closeAndClearTokenInformation];
    fbview.hidden=NO;


}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.statusLabel.text= @"You're not logged in!";
    fbview.hidden=NO;

}

-(IBAction)backgroundTouched:(id)sender
{
	[originalPrice resignFirstResponder];
    [percentageOff resignFirstResponder];
    [additionalDiscount resignFirstResponder];
    //[additionalDiscount resignFirstResponder];
}

- (void)viewDidLoad

{
    if(FBSession.activeSession.state == FBSessionStateOpen){
       // [self.view sendSubviewToBack:fbview];
    }
    fbview.hidden=YES;

    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-30);
    verticalMotionEffect.maximumRelativeValue = @(30);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-30);
    horizontalMotionEffect.maximumRelativeValue = @(30);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [topImage addMotionEffect:group];
    
    
    UIImage *img = [UIImage imageNamed:@"wall.jpg"];
    
    UIColor *tintColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    img=[img applyBlurWithRadius:10 tintColor:tintColor saturationDeltaFactor:1.8 maskImage:nil];
    topImage.backgroundColor = [UIColor colorWithPatternImage: img];
    
    profileTop.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"profile"]];
    
   // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

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
   // originalPriceLabel.font = [UIFont fontWithName:@"Gotham-Light" size:17];
    
    percentageOffLabel.text=@"Percentage Off";
  //  percentageOffLabel.font = [UIFont fontWithName:@"Gotham-Light" size:17];
    
    
   // finalPrice.font = [UIFont fontWithName:@"Gotham-Medium" size:30];

   // originalPrice.font=[UIFont fontWithName:@"Gotham-Book" size:23];
   // percentageOff.font=[UIFont fontWithName:@"Gotham-Book" size:23];
    
    originalPrice.keyboardType=UIKeyboardTypeDecimalPad;
    percentageOff.keyboardType=UIKeyboardTypeDecimalPad;
    
    //Calculate Button
    [calculateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    calculateButton.layer.borderWidth = 1.0;
    calculateButton.layer.masksToBounds = YES;
    calculateButton.layer.cornerRadius = 5.0;
    [calculateButton.titleLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:16]];
    calculateButton.layer.borderColor=[[UIColor whiteColor] CGColor];
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
    */
    // Initialize the profile picture
    self.profilePictureView = [[FBProfilePictureView alloc] init];
    // Set the size
    self.profilePictureView.frame = CGRectMake(20.0, 30.0, 50.0, 50.0);
    // Show the profile picture for a user
   // self.profilePictureView.profileID = @"user.id";
    // Add the profile picture view to the main view
    [self.view addSubview:self.profilePictureView];
    self.profilePictureView.layer.cornerRadius=self.profilePictureView.frame.size.width / 2;
    self.profilePictureView.clipsToBounds = YES;
    self.profilePictureView.userInteractionEnabled=YES;
    self.profilePictureView.layer.borderWidth=1.0f;
    self.profilePictureView.layer.borderColor = [UIColor whiteColor].CGColor;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTaped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.profilePictureView addGestureRecognizer:singleTap];
    [self.profilePictureView setUserInteractionEnabled:YES];

    //PICTURE VIEW END
    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


-(void)furtherDiscount{
    /*
     
     o=[[originalPrice text] floatValue];
     p=[[percentageOff text] floatValue];
     r=o * (p/100);
     
     f
     
     
     [ammountDeducted setText:[NSString stringWithFormat:@"%.2f", o * (p/100)]];
     [salePrice setText: [NSString stringWithFormat:@"%.2f", o-r]];
     
     */
    
    sP=o-r;
    
    NSString *myMessage = [NSString stringWithFormat:@"The current Price is $%.2f",sP];
    
    furtherDiscount= [[UIAlertView alloc] initWithTitle:@"Further Discount" message:myMessage delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"30%",nil];
    furtherDiscount.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [furtherDiscount textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDecimalPad;
    alertTextField.placeholder = @"%";
    [furtherDiscount show];
    float percentageValue = [[alertTextField text] floatValue];
    
    
    float discountedPrice=sP*(percentageValue/100);
    //float finalDP=sP-discountedPrice;
    
    
    discountedResult = [[UIAlertView alloc] initWithTitle:@"Final Discount" message:[NSString stringWithFormat:@"The discounted Price is %.2f", discountedPrice]
                                                 delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    
    
    
}

-(IBAction)thirtyDiscount:(id)sender {
    
    
    
    [originalPrice resignFirstResponder];
    [percentageOff resignFirstResponder];
    [additionalDiscount resignFirstResponder];
    float aD=[[additionalDiscount text] floatValue];
    sP=o-r;
    float thirtyo=sP;
    //float thirtyp=30.00;
    float thirtyp=aD;
    float thirtyr=thirtyo * (thirtyp/100);
    
    
    [ammountDeducted setText:[NSString stringWithFormat:@"%.2f", thirtyo * (thirtyp/100)]];
    [finalPrice setText: [NSString stringWithFormat:@"$""%.2f", thirtyo-thirtyr]];
    [furtherDiscountLabel setText: [NSString stringWithFormat:@"+""%@""%%", additionalDiscount.text]];
    
    
    if(o==0){
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Calculation Error" message: @"You do not have a price to discount!" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        
        [someError show];
        [self.view addSubview:calculateButton];
        further.on=NO;
        
        
    }
    
    
    if(o>1){
        //Calculate Price Custom Button
        UIButton *calculatePrice2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //[calculatePrice setTitle:@"Calculate" forState:UIControlStateNormal];
        calculatePrice2.frame = CGRectMake(106, 163, 101, 39); // position in the parent view and set the size of the button
        //UIImage *buttonImage = [UIImage imageNamed:@"ClearNormal.png"];
        //[calculatePrice setBackgroundImage:buttonImage forState:UIControlStateNormal];
        //[calculatePrice setImage:[UIImage imageNamed:@"ClearNormal.png"] forState:UIControlStateNormal];
        // add targets and actions
        [calculatePrice2 addTarget:self action:@selector(calculatePrice) forControlEvents:UIControlEventTouchUpInside];
        // add to a view
        [calculatePrice2 setTitle:@"Back" forState:UIControlStateNormal];
        
        [calculateButton removeFromSuperview];
        //[self.view addSubview:calculatePrice2];
    }
    if (further.on)
    {
        
        
    }
    else
    {
        [finalPrice setText: [NSString stringWithFormat:@"%.2f", o-r]];
        
        
    }
    
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



- (IBAction)calculatePrice:(id)sender

{
    further.on=NO;
    
    //Caculate original * percentage off
    o=[[originalPrice text] floatValue];
    p=[[percentageOff text] floatValue];
    r=o * (p/100);
    
    [ammountDeducted setText:[NSString stringWithFormat:@"%.2f", o * (p/100)]];
    [finalPrice setText: [NSString stringWithFormat:@"$""%.2f", o-r]];
    [percentageOff resignFirstResponder];
    [originalPrice resignFirstResponder];
    [additionalDiscount resignFirstResponder];
    
    if(r==0){
        [finalPrice setText: @"Free!"];
    }
    if(o==0&&p==0){
        UIAlertView *CandPerror = [[UIAlertView alloc] initWithTitle: @"Calculation Error" message: @"You must specify the Original Price and the Percentage Off" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        
        [CandPerror show];

        
    }
    else if(o==0){
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Calculation Error" message: @"You must specify the Original Price" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        
        [someError show];
        
    }
    else if(p==0){
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle: @"Calculation Error" message: @"You must specify the Percentage off" delegate: self cancelButtonTitle: @"Ok" otherButtonTitles: nil];
        
        [someError show];
        
    }
    //Calculate Price Custom Button
       // [calculateButton addTarget:self action:@selector(calculatePrice) forControlEvents:UIControlEventTouchUpInside];
    // add to a view
   // [calculatePrice2 removeFromSuperview];
    //[self.view addSubview:calculatePrice];
    
    //apply Button
    UIButton *apply=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    apply.frame = CGRectMake(240, 300, 65, 30);
    [apply setTitle:@"Apply" forState:UIControlStateNormal];
    [apply addTarget:self action:@selector(thirtyDiscount:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //[self.view addSubview:apply];
    //[self.view addSubview:additionalDiscount];
    
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*Post to Facebook Graph API*/

- (IBAction)postObject:(id)sender
{
    
    // We will post an object on behalf of the user
    // These are the permissions we need:
    NSArray *permissionsNeeded = @[@"publish_actions"];
    
    // Request the permissions the user currently has
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error){
                                  NSDictionary *currentPermissions= [(NSArray *)[result data] objectAtIndex:0];
                                  NSLog([NSString stringWithFormat:@"current permissions %@", currentPermissions]);
                                  NSMutableArray *requestPermissions = [[NSMutableArray alloc] initWithArray:@[]];
                                  
                                  // Check if all the permissions we need are present in the user's current permissions
                                  // If they are not present add them to the permissions to be requested
                                  for (NSString *permission in permissionsNeeded){
                                      if (![currentPermissions objectForKey:permission]){
                                          [requestPermissions addObject:permission];
                                      }
                                  }
                                  
                                  // If we have permissions to request
                                  if ([requestPermissions count] > 0){
                                      // Ask for the missing permissions
                                      [FBSession.activeSession requestNewPublishPermissions:requestPermissions
                                                                            defaultAudience:FBSessionDefaultAudienceFriends
                                                                          completionHandler:^(FBSession *session, NSError *error) {
                                                                              if (!error) {
                                                                                  // Permission granted
                                                                                  NSLog([NSString stringWithFormat:@"new permissions %@", [FBSession.activeSession permissions]]);
                                                                                  // We can request the user information
                                                                                  [self makeRequestToPostObject];
                                                                              } else {
                                                                                  // An error occurred, we need to handle the error
                                                                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                                                                  NSLog([NSString stringWithFormat:@"error %@", error.description]);
                                                                              }
                                                                          }];
                                  } else {
                                      // Permissions are present
                                      // We can request the user information
                                      [self makeRequestToPostObject];
                                  }
                                  
                              } else {
                                  // An error occurred, we need to handle the error
                                  // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                                  NSLog([NSString stringWithFormat:@"error %@", error.description]);
                              }
                          }];
}

- (void)makeRequestToPostObject
{
    // Retrieve a picture from the device's photo library
    /*
     NOTE: SDK Image size limits are 480x480px minimum resolution to 12MB maximum file size.
     In this app we're not making sure that our image is within those limits but you should.
     Error code for images that go below or above the size limits is 102.
     */
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

// When the user is done picking the image
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    // Get the UIImage
    NSArray* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Dismiss the image picker off the screen
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // stage the image
    [FBRequestConnection startForUploadStagingResourceWithImage:image completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        __block NSString *alertText;
        __block NSString *alertTitle;
        if(!error) {
            NSLog(@"Successfuly staged image with staged URI: %@", [result objectForKey:@"uri"]);
            
            // Package image inside a dictionary, inside an array like we'll need it for the object
            NSArray *image = @[@{@"url": [result objectForKey:@"uri"], @"user_generated" : @"true" }];
            
            // Create an object
            NSMutableDictionary<FBOpenGraphObject> *restaurant = [FBGraphObject openGraphObjectForPost];
            
            // specify that this Open Graph object will be posted to Facebook
            restaurant.provisionedForPost = YES;
            
            // Add the standard object properties
            restaurant[@"og"] = @{ @"title":@"mytitle", @"type":@"restaurant.restaurant", @"description":@"my description", @"image":image };
            
            // Add the properties restaurant inherits from place
            restaurant[@"place"] = @{ @"location" : @{ @"longitude": @"-58.381667", @"latitude":@"-34.603333"} };
            
            // Add the properties particular to the type restaurant.restaurant
            restaurant[@"restaurant"] = @{@"category": @[@"Mexican"],
                                          @"contact_info": @{@"street_address": @"123 Some st",
                                                             @"locality": @"Menlo Park",
                                                             @"region": @"CA",
                                                             @"phone_number": @"555-555-555",
                                                             @"website": @"http://www.example.com"}};
            
            // Make the Graph API request to post the object
            FBRequest *request = [FBRequest requestForPostWithGraphPath:@"me/objects/restaurant.restaurant"
                                                            graphObject:@{@"object":restaurant}];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    // Success! Include your code to handle the results here
                    NSLog([NSString stringWithFormat:@"result: %@", result]);
                    _objectID = [result objectForKey:@"id"];
                    alertTitle = @"Object successfully created";
                    alertText = [NSString stringWithFormat:@"An object with id %@ has been created", _objectID];
                    [[[UIAlertView alloc] initWithTitle:alertTitle
                                                message:alertText
                                               delegate:self
                                      cancelButtonTitle:@"OK!"
                                      otherButtonTitles:nil] show];
                } else {
                    // An error occurred, we need to handle the error
                    // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
                    NSLog([NSString stringWithFormat:@"error %@", error.description]);
                }
            }];
            
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog([NSString stringWithFormat:@"error %@", error.description]);
        }
    }];
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
    /*(if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController * fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [fbSheetOBJ setInitialText:@"Post from my iOS application"];
        [fbSheetOBJ addURL:[NSURL URLWithString:@"http://www.weblineindia.com"]];
        [fbSheetOBJ addImage:[UIImage imageNamed:@"my_image_to_share.png"]];
        
        [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
    }
    */
    // Check if the Facebook app is installed and we can present the share dialog
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:@"https://itunes.apple.com/us/app/sale-buddy/id525314025?mt=8"];
    params.name = @"Check out this Deal I found!";
    params.caption = @"Caption";
    params.picture = [NSURL URLWithString:@"http://i.imgur.com/g3Qc1HN.png"];
    params.description = [NSString stringWithFormat:@"Check out this great deal I found! %@",finalPrice.text];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                         name:params.name
                                      caption:params.caption
                                  description:params.description
                                      picture:params.picture
                                  clientState:nil
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        // Present the share dialog
    } else {
        
        // Present the feed dialog
        // Put together the dialog parameters
        NSString *string1=[NSString stringWithFormat:@"Check out this great deal I found! %@",finalPrice.text];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Sharing Tutorial", @"name",
                                       @"Build great social apps and get more installs.", @"caption",
                                       @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                       @"https://developers.facebook.com/docs/ios/share/", @"link",
                                       @"http://i.imgur.com/g3Qc1HN.png", @"place",
                                       nil];
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog([NSString stringWithFormat:@"Error publishing story: %@", error.description]);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];    }
    
}
// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

-(void)bannerViewDidLoad:(ADBannerView *)abanner{
    if(self.bannerVisible){
        [UIView beginAnimations:@"animatedAdBannerOn" context:NULL];
        _banner.frame =CGRectOffset(_banner.frame, 0, 50.0);
        [UIView commitAnimations];
        self.bannerVisible=YES;
        _banner.frame =CGRectZero;
        
        
        
        
        
    }
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL urlWasHandled = [FBAppCall handleOpenURL:url
                                sourceApplication:sourceApplication
                                  fallbackHandler:^(FBAppCall *call) {
                                      NSLog(@"Unhandled deep link: %@", url);
                                      // Here goes the code to handle the links
                                      // Use the links to show a relevant view of your app to the user
                                  }];
    
    return urlWasHandled;
}

-(void)bannerView:(ADBannerView *)aBanner didFailToReceiveAdWithError:(NSError *)error{
    if(self.bannerVisible){
        [UIView beginAnimations:@"animatedAdBannerOff" context:NULL];
        _banner.frame =CGRectOffset(_banner.frame, 0, -320.0);
        [UIView commitAnimations];
        self.bannerVisible=NO;
    }
}


@end
