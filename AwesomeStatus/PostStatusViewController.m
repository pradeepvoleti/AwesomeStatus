//
//  PostStatusViewController.m
//  AwesomeStatus
//
//  Created by Pradeep Voleti on 10/09/16.
//  Copyright © 2016 Pradeep Voleti. All rights reserved.
//

#import "PostStatusViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FacebookDecorator.h"
#import "Constants.h"

@interface PostStatusViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *fbImage;
@property (weak, nonatomic) IBOutlet UILabel *fbUsername;
@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
@property (weak, nonatomic) IBOutlet UIButton *updateStatus;
@property (weak, nonatomic) IBOutlet UIButton *disconnectFb;
@end

@implementation PostStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [FacebookDecorator setButtonProperties:self.updateStatus];
    [FacebookDecorator setButtonProperties:self.disconnectFb];
    [FacebookDecorator setTextViewProperties:self.statusTextView];
    self.fbUsername.text = self.name;
}

- (NSString *)getPath {
    
    NSString *userId = [[FBSDKAccessToken currentAccessToken] userID];
    NSString *path = [NSString stringWithFormat:PostFeedURL,userId];
    return path;
}

- (void)postStatus:(NSString *)message {
    
    NSString *path = [self getPath];
    NSString *token = [[FBSDKAccessToken currentAccessToken] tokenString];
    NSDictionary *parameters = @{AccessToken: token, Message: message};
    
    __weak typeof(self) weakSelf = self;
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]initWithGraphPath:path parameters:parameters HTTPMethod:@"POST"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        UIAlertController *alert;
        
        if (error) {
            
            alert = [UIAlertController alertControllerWithTitle:Error message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:Ok style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:ok];
            
        } else {
            
            weakSelf.statusTextView.text = Blank;
            alert = [UIAlertController alertControllerWithTitle:StatusUpdated message:Blank preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:Ok style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:ok];
        }
        [weakSelf presentViewController:alert animated:YES completion:nil];
    }];
}

- (IBAction)updateStatusTapped:(id)sender {
    
    if (![self.statusTextView.text isEqualToString:Blank]) {
        
        [self postStatus:self.statusTextView.text];
        
    } else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:EnterSomeText message:Blank preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:Ok style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (IBAction)logoutTapped:(id)sender {
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
