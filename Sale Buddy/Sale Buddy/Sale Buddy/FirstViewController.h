//
//  FirstViewController.h
//  Sale Buddy
//
//  Created by Joseph Pellegrino on 10/19/13.
//  Copyright (c) 2013 Ready. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import <iAd/iAd.h>


@interface FirstViewController : UIViewController<FBLoginViewDelegate>{
    //UIView *transBack;
    
    IBOutlet UILabel *originalPriceLabel;
    IBOutlet UILabel *percentageOffLabel;
    IBOutlet UILabel *finalPrice;
    IBOutlet UIButton *calculateButton;
    IBOutlet UIButton *tweetButton;
    IBOutlet UIButton *postButton;
    IBOutlet UITextField *originalPrice;
    IBOutlet UITextField *percentageOff;
    IBOutlet UIView *login;
    UISwitch *further;
    IBOutlet UILabel *ammountDeducted;
    IBOutlet UITextField *additionalDiscount;
    IBOutlet UILabel *furtherDiscountLabel;
    IBOutlet UIView *profileTop;


    
    NSInteger original,sale,tempCalc,result;
    int originalValue;
    float p,r,o,sP,thirtyPercent,percentageValue,thirtyo,thirtyp,thirtyr;
    UIAlertView *furtherDiscount;
    UIAlertView *discountedResult;

    
}

- (IBAction)btnFacebookSharing_Clicked:(id)sender;
- (IBAction)btnTwitterSharing_Clicked:(id)sender;

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, assign) BOOL bannerVisible;
@property (nonatomic, retain) IBOutlet ADBannerView *banner;
@property (nonatomic, retain) IBOutlet UISwitch *further;
@property (nonatomic, retain) IBOutlet UILabel *finalPrice;






@end
