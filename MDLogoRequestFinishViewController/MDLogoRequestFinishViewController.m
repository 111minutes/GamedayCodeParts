//
//  MDLogoRequestFinishViewController.m
//  matchday
//
//  Created by Andrey Sokur on 15.03.17.
//  Copyright © 2017 111 Minutes. All rights reserved.
//

#import "MDLogoRequestFinishViewController.h"
#import "AppDelegate.h"
#import "MDUserAPIManager.h"


@interface MDLogoRequestFinishViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIButton *enableButton;

@end


@implementation MDLogoRequestFinishViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerForRemoteNotifications) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self setupViews];
}

- (void)setupViews
{
    self.navigationItem.hidesBackButton = YES;
    
    [self.enableButton setHidden:[self.appDelegate isRegisteredForRemoteNotifications]];
    if ([self.appDelegate isRegisteredForRemoteNotifications]) {
        self.bodyLabel.text = NSLocalizedString(@"Keep your notifications on, so we will inform you as soon as the database is updated.", nil);
    } else {
        self.bodyLabel.text = NSLocalizedString(@"Don’t forget to turn on notifications so you will get notified as soon as the database is updated.", nil);
    }
}

- (void)registerForRemoteNotifications
{
    if (![self.appDelegate isRegisteredForRemoteNotifications]) {
        [self.appDelegate registerForRemoteNotifications];
    }
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *) [[UIApplication sharedApplication] delegate];
}


#pragma mark - Actions


- (IBAction)okPressed:(UIButton *)sender
{
    [self.navigationController.viewControllers.firstObject dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)enablePressed:(UIButton *)sender
{
    if (UIApplicationOpenSettingsURLString != NULL){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

@end
