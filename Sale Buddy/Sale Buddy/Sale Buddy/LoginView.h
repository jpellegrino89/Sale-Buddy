//
//  LoginView.h
//  Sale Buddy
//
//  Created by Joseph Pellegrino on 2/25/14.
//  Copyright (c) 2014 Ready. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginView : UIViewController<FBLoginViewDelegate>{

    //IBOutlet UILabel *nameLabel;
    IBOutlet UIView *login;



}


@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *saleBuddy;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;





@end
