//
//  FacebookDecorator.m
//  AwesomeStatus
//
//  Created by Pradeep Voleti on 11/09/16.
//  Copyright © 2016 Pradeep Voleti. All rights reserved.
//


#import "FacebookDecorator.h"

@implementation FacebookDecorator

+ (void)setButtonProperties:(UIButton *)button {
    
    button.titleLabel.textColor = [UIColor blackColor];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.borderWidth = 2;
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.shadowColor = [UIColor blackColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(2,2);
    button.layer.shadowOpacity = 0.6;
}

+ (void)setTextViewProperties:(UITextView *)textView; {
    
    textView.layer.borderWidth = 2;
    textView.layer.borderColor = [UIColor blackColor].CGColor;
}

@end
