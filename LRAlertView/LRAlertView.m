//
//  LRAlertView.m
//  ShowDemo
//
//  Created by LR on 16/9/1.
//  Copyright © 2016年 LR. All rights reserved.
//

#import "LRAlertView.h"

const static CGFloat kLRAlertViewDefaultButtonHeight       = 50;
const static CGFloat kLRAlertViewDefaultButtonSpacerHeight = 1;
const static CGFloat kLRAlertViewCornerRadius              = 0;//15;//7;
const static CGFloat kLR7MotionEffectExtent                = 10.0;

@implementation LRAlertView

CGFloat buttonHeight = 0;
CGFloat buttonSpacerHeight = 0;

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        _delegate = self;
        
        _buttonTitles = @[@"取消",@"确定"];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}

- (void)show {
    _dialogView = [self createContainerView];
    
    _dialogView.layer.shouldRasterize = YES;
    _dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
#if (defined(__IPHONE_7_0))
    if (_useMotionEffects) {
        [self applyMotionEffects];
    }
#endif
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [self addSubview:_dialogView];
    
    // iOS7 计算旋转方向
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                break;
                
            default:
                break;
        }
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
    } else {
        
    }
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    CGSize keyboardSize = CGSizeMake(0, 0);
    
    
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    
    _dialogView.layer.opacity = 0.5f;
    
    __weak typeof(self) weakSelf = self;
    if (self.style == LRAlertViewStyleAlert) {
        
        _dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
        
        _dialogView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
        
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             weakSelf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                             weakSelf.dialogView.layer.opacity = 1.0f;
                             weakSelf.dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                         }
                         completion:NULL
         ];
    }else if (self.style == LRAlertViewStyleActionSheet) {
        
        _dialogView.frame = CGRectMake(0, screenSize.height - keyboardSize.height, dialogSize.width, dialogSize.height);
//        _dialogView.frame = CGRectMake(0, screenSize.height - keyboardSize.height, self.dialogView.bounds.size.width, self.dialogView.bounds.size.height);
        
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             //                         weakSelf.dialogView.frame = CGRectMake(0, screenSize.height-weakSelf.dialogView.bounds.size.height, weakSelf.dialogView.bounds.size.width, weakSelf.dialogView.bounds.size.height);
                             weakSelf.dialogView.transform = CGAffineTransformTranslate(weakSelf.dialogView.transform, 0, -weakSelf.dialogView.bounds.size.height);//左手系 向上是-y
                             
                             weakSelf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                             weakSelf.dialogView.layer.opacity = 1.0f;
                             //                         _dialogView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                         }
                         completion:NULL
         ];
    }
    
}
- (void)close {
    CATransform3D currentTransform = _dialogView.layer.transform;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat startRotation = [[_dialogView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
        
        _dialogView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    }
    
    _dialogView.layer.opacity = 1.0f;
    __weak typeof(self) weakSelf = self;
    if (self.style == LRAlertViewStyleAlert) {
        
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             weakSelf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f];
                             _dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                             _dialogView.layer.opacity = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             for (UIView *v in [self subviews]) {
                                 [v removeFromSuperview];
                             }
                             [self removeFromSuperview];
                         }
         ];
    }else if (self.style == LRAlertViewStyleActionSheet) {
        
        [UIView animateWithDuration:0.25f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             weakSelf.dialogView.transform = CGAffineTransformIdentity;
                             //                         weakSelf.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                             //                         weakSelf.dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                             //                         weakSelf.dialogView.layer.opacity = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             //动画0.25s结束之后再移除视图
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 for (UIView *v in [self subviews]) {
                                     [v removeFromSuperview];
                                 }
                                 [weakSelf removeFromSuperview];
                             });
                         }
         ];
    }
}


// Creates the container view here: create the dialog, then add the custom content and buttons
- (UIView *)createContainerView
{
    CGSize screenSize = [self countScreenSize];
    
    if (_containerView == NULL) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 150)];
    }
    
    CGSize dialogSize = [self countDialogSize];
    
    // For the black background
    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    // This is the dialog's container; we attach the custom content and the buttons to this one
    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height)];
    
    // First, we style the dialog to match the iOS7 UIAlertView >>>
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogContainer.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       //                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       //                       (id)[[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0f] CGColor],
                       //                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       nil];
    
    CGFloat cornerRadius = kLRAlertViewCornerRadius;
    gradient.cornerRadius = cornerRadius;
    [dialogContainer.layer insertSublayer:gradient atIndex:0];
    
    dialogContainer.layer.cornerRadius = cornerRadius;
    dialogContainer.layer.borderColor = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f] CGColor];
    dialogContainer.layer.borderWidth = 1;
    dialogContainer.layer.shadowRadius = cornerRadius + 5;
    dialogContainer.layer.shadowOpacity = 0.1f;
    dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
    dialogContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    dialogContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogContainer.bounds cornerRadius:dialogContainer.layer.cornerRadius].CGPath;
    dialogContainer.layer.masksToBounds = YES;
    
    // There is a line above the button
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, dialogContainer.bounds.size.height - buttonHeight - buttonSpacerHeight, dialogContainer.bounds.size.width, buttonSpacerHeight)];
    lineView.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];//[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
    [dialogContainer addSubview:lineView];
    // ^^^
    
    // Add the custom container if there is any
    [dialogContainer addSubview:_containerView];
    
    // Add the buttons too
    [self addButtonsToView:dialogContainer];
    
    return dialogContainer;
}

- (void)addButtonsToView: (UIView *)container
{
    if (_buttonTitles==NULL) { return; }
    
    CGFloat buttonWidth = container.bounds.size.width / [_buttonTitles count];
    
    for (int i=0; i < [_buttonTitles count]; i++) {
        UILabel* lineOfBtns = [[UILabel alloc] initWithFrame:CGRectMake(i*buttonWidth, container.bounds.size.height - buttonHeight, 0.5, buttonHeight)];
        lineOfBtns.backgroundColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1];//[UIColor grayColor];
        [container addSubview:lineOfBtns];
        
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [closeButton setFrame:CGRectMake(i * buttonWidth, container.bounds.size.height - buttonHeight, buttonWidth, buttonHeight)];
        
        [closeButton addTarget:self action:@selector(customIOSActionSheetDialogButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTag:i];
        
        [closeButton setTitle:[_buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        //        [closeButton setTitleColor:[UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:186/255.0 green:120/255.0 blue:254/255.0 alpha:1] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f] forState:UIControlStateHighlighted];
        [closeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [closeButton.layer setCornerRadius:kLRAlertViewCornerRadius];
        
        [container addSubview:closeButton];
        
    }
}


- (CGSize)countDialogSize
{
    CGFloat dialogWidth = _containerView.frame.size.width;
    CGFloat dialogHeight = _containerView.frame.size.height + buttonHeight + buttonSpacerHeight;
    
    return CGSizeMake(dialogWidth, dialogHeight);
}
- (CGSize)countScreenSize
{
    if (_buttonTitles!=NULL && [_buttonTitles count] > 0) {
        buttonHeight       = kLRAlertViewDefaultButtonHeight;
        buttonSpacerHeight = kLRAlertViewDefaultButtonSpacerHeight;
    } else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    return CGSizeMake(screenWidth, screenHeight);
}

- (IBAction)customIOSActionSheetDialogButtonTouchUpInside:(id)sender {
    //代理回调
    if ((self.delegate != NULL) && ([self.delegate respondsToSelector:@selector(lrAlertViewButtonTouchUpInside:clickedButtonAtIndex:)])) {
        [self.delegate lrAlertViewButtonTouchUpInside:self clickedButtonAtIndex:[sender tag]];
    }
    
    //block回调
    if (self.onButtonTouchUpInside != NULL) {
        self.onButtonTouchUpInside(self, (int)[sender tag]);
    }
}

//遵守自身的协议 实现代理方法，实现点击按钮的默认操作：关闭
// Default button behaviour
- (void)lrAlertViewButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Clicked! %d, %d", (int)buttonIndex, (int)[alertView tag]);
    [self close];
}


#if (defined(__IPHONE_7_0))
// Add motion effects
- (void)applyMotionEffects {
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        return;
    }
    
    UIInterpolatingMotionEffect *horizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                                                                    type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalEffect.minimumRelativeValue = @(-kLR7MotionEffectExtent);
    horizontalEffect.maximumRelativeValue = @( kLR7MotionEffectExtent);
    
    UIInterpolatingMotionEffect *verticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                                                                  type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalEffect.minimumRelativeValue = @(-kLR7MotionEffectExtent);
    verticalEffect.maximumRelativeValue = @( kLR7MotionEffectExtent);
    
    UIMotionEffectGroup *motionEffectGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectGroup.motionEffects = @[horizontalEffect, verticalEffect];
    
    [_dialogView addMotionEffect:motionEffectGroup];
}
#endif

- (void)dealloc
{
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

// Rotation changed, on iOS7
- (void)changeOrientationForIOS7 {
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CGAffineTransform rotation;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 270.0 / 180.0);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 90.0 / 180.0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 180.0 / 180.0);
            break;
            
        default:
            rotation = CGAffineTransformMakeRotation(-startRotation + 0.0);
            break;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         _dialogView.transform = rotation;
                         
                     }
                     completion:nil
     ];
    
}

// Rotation changed, on iOS8
- (void)changeOrientationForIOS8: (NSNotification *)notification {
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    __weak typeof(self) weakSelf = self;
    if (self.style == LRAlertViewStyleAlert) {
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             CGSize dialogSize = [weakSelf countDialogSize];
                             CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
                             weakSelf.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                             _dialogView.frame = CGRectMake((screenWidth - dialogSize.width) / 2, (screenHeight - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                         }
                         completion:nil
         ];
    }else if (self.style == LRAlertViewStyleActionSheet) {
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             CGSize dialogSize = [weakSelf countDialogSize];
                             CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
                             weakSelf.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                             _dialogView.frame = CGRectMake(0, screenHeight - keyboardSize.height - dialogSize.height, dialogSize.width, dialogSize.height);
                         }
                         completion:nil
         ];
    }
    
    
    
}

// Handle device orientation changes
- (void)deviceOrientationDidChange: (NSNotification *)notification
{
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [self changeOrientationForIOS7];
    } else {
        [self changeOrientationForIOS8:notification];
    }
}

// Handle keyboard show/hide changes
- (void)keyboardWillShow: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation) && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }
    
//    __weak typeof(self) weakSelf = self;
    if (self.style == LRAlertViewStyleAlert) {
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             _dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - keyboardSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                         }
                         completion:nil
         ];
    }else if (self.style == LRAlertViewStyleActionSheet) {
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             _dialogView.frame = CGRectMake(0, screenSize.height - keyboardSize.height - dialogSize.height, dialogSize.width, dialogSize.height);
                         }
                         completion:nil
         ];
    }
    
}

- (void)keyboardWillHide: (NSNotification *)notification
{
    CGSize screenSize = [self countScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
//    __weak typeof(self) weakSelf = self;
    if (self.style == LRAlertViewStyleAlert) {
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             _dialogView.frame = CGRectMake((screenSize.width - dialogSize.width) / 2, (screenSize.height - dialogSize.height) / 2, dialogSize.width, dialogSize.height);
                         }
                         completion:nil
         ];
    }else if (self.style == LRAlertViewStyleActionSheet) {
        [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             _dialogView.frame = CGRectMake(0, screenSize.height - dialogSize.height, dialogSize.width, dialogSize.height);
                         }
                         completion:nil
         ];
    }
    
}


#pragma mark- 点击空白处退出
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.style == LRAlertViewStyleAlert) {
        return;//alertView不需要
    }
    //点击的位置
    CGPoint pt = [[touches anyObject] locationInView:self];
    if (pt.y > 0 && pt.y < CGRectGetMinY(self.dialogView.frame)) {
        [self endEditing:YES];
        
        [self close];
    }
}

@end
