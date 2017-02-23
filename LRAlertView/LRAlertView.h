//
//  LRAlertView.h
//  ShowDemo
//
//  Created by LR on 16/9/1.
//  Copyright © 2016年 LR. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, LRAlertViewStyle){
    /**
     *  0: Alert
     */
    LRAlertViewStyleAlert = 0,
    /**
     *  1: ActionSheet
     */
    LRAlertViewStyleActionSheet = 1
    
};

@protocol LRAlertViewDelegate <NSObject>

- (void)lrAlertViewButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface LRAlertView : UIView <LRAlertViewDelegate>

@property (nonatomic, retain) UIView *dialogView;
@property (nonatomic, retain) UIView *containerView;

@property (nonatomic, weak) id<LRAlertViewDelegate> delegate;
@property (nonatomic, strong) NSArray *buttonTitles;
@property (nonatomic, assign) BOOL useMotionEffects;
@property (nonatomic, assign) LRAlertViewStyle style;

@property (copy) void (^onButtonTouchUpInside)(LRAlertView *alertView, int buttonIndex);


- (void)show;
- (void)close;
@end
