//
//  ViewController.m
//  AwesomeStatus
//
//  Created by Pradeep Voleti on 10/09/16.
//  Copyright © 2016 Pradeep Voleti. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PostStatusViewController.h"
#import "FacebookDecorator.h"
#import "Constants.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *fbLogin;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    [FacebookDecorator setButtonProperties:self.fbLogin];
    
    self.fbLogin.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 50);
    self.fbLogin.titleEdgeInsets = UIEdgeInsetsMake(0.1, 10, 0.1, 0.1);
}

- (IBAction)loginTapped:(id)sender {

    [self login];
}

- (void)login {
    if (!([FBSDKAccessToken currentAccessToken] && [[FBSDKAccessToken currentAccessToken] hasGranted:PublishActions])) {
        
        __weak typeof(self) weakSelf = self;
        
        NSArray *array = @[PublishActions];
        
        [self loginWithPermission:array successHandler:^(NSString *name) {
            [weakSelf gotoPostVC:name];
        } failureHandler:[self handleFailure]];
    }
}

- (void)loginWithPermission:(NSArray *)array successHandler:(Handler)success failureHandler:(FailureHandler)failure {
    
    __weak typeof(self) weakSelf = self;
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithPublishPermissions:array fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (weakSelf) {
            
            if (error) {
                
                failure(FailureTypeError, error.localizedDescription);
            }
            
            if (!result.isCancelled) {
                
                if ([FBSDKAccessToken currentAccessToken] && [[FBSDKAccessToken currentAccessToken] hasGranted:PublishActions]) {
                    
                    NSString *userId = [[FBSDKAccessToken currentAccessToken] userID];
                    NSString *path = [NSString stringWithFormat:GetNameURL,userId];
                    NSDictionary *parameters = @{Fields: Name};
                    
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:path parameters:parameters]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         
                         if (result && result[Name]) {
                             
                             success(result[Name]);
                         }
                     }];
                    
                } else {
                    
                    failure(FailureTypeCancelled, ProfilePermission);
                }
                
            } else {
                
                failure(FailureTypeCancelled, PublishPermission);
            }
        }
        
    }];
}

- (void)gotoPostVC:(NSString *)name {
    PostStatusViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([PostStatusViewController class])];
    vc.name = name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (FailureHandler)handleFailure {
    
    __weak typeof(self) weakSelf = self;
    
    return ^(FailureType type, NSString *message) {
        
        if (weakSelf) {
            
            UIAlertController *alert;
            
            switch (type) {
                case FailureTypeError: {
                    
                    alert = [UIAlertController alertControllerWithTitle:Error message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:Ok style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:ok];
                    
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }
                    break;
                    
                case FailureTypeCancelled: {
                    
                    alert = [UIAlertController alertControllerWithTitle:PermissionRequired message:message preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *ok = [UIAlertAction actionWithTitle:Proceed style:UIAlertActionStyleDefault handler:[self handleProceed]];
                    [alert addAction:ok];
                    
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:Cancel style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancel];
                    
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
    };
}

- (void (^)(UIAlertAction *action))handleProceed {
    
    __weak typeof(self) weakSelf = self;
    
    return ^(UIAlertAction *action) {
        [weakSelf login];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end