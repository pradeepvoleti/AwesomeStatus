//
//  Constants.h
//  AwesomeStatus
//
//  Created by Pradeep Voleti on 11/09/16.
//  Copyright © 2016 Pradeep Voleti. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, FailureType) {
    FailureTypeError = 0,
    FailureTypeCancelled
};

typedef void (^Handler)(NSString *name);
typedef void (^FailureHandler)(FailureType type, NSString *message);

extern NSString *const GetNameURL;
extern NSString *const PostFeedURL;

extern NSString *const Error;
extern NSString *const PublishActions;
extern NSString *const Name;
extern NSString *const ProfilePermission;
extern NSString *const PublishPermission;
extern NSString *const PermissionRequired;
extern NSString *const Proceed;
extern NSString *const Ok;
extern NSString *const Cancel;
extern NSString *const Fields;
extern NSString *const AccessToken;
extern NSString *const Message;
extern NSString *const StatusUpdated;
extern NSString *const EnterSomeText;
extern NSString *const Blank;

@interface Constants : NSObject

@end
