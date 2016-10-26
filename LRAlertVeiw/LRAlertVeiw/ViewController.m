//
//  ViewController.m
//  LRAlertVeiw
//
//  Created by LR on 16/10/26.
//  Copyright © 2016年 LR. All rights reserved.
//

#import "ViewController.h"
#import "LRAlertView.h"

#define RESIZE(x) (x/375.f*CGRectGetWidth([UIScreen mainScreen].bounds))

#define SEPATATELINECOLOR [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1]
#define TEXTCOLOR_GRAY [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (nonatomic,strong) UIDatePicker * datePicker;

@property (nonatomic,copy) NSString * selectDateStr;

@end

@implementation ViewController
- (IBAction)showAlertAction:(id)sender {
    LRAlertView *customAlertView = [[LRAlertView alloc]init];
    customAlertView.style = LRAlertViewStyleAlert;//LRAlertViewStyleActionSheet;
    [customAlertView setButtonTitles:@[@"以后再说", @"马上升级"]];
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 120)];
    UILabel *tip=[[UILabel alloc]initWithFrame:CGRectMake(0, 10, 240, 30)];
    tip.textAlignment = NSTextAlignmentCenter;
    [tip setText:@"新版本来了"];
    [customView addSubview:tip];
    
    
    UITextView *content=[[UITextView alloc]initWithFrame:CGRectMake(10, 40, 220, 80)];
//    [content setEditable:false];
    [content setBackgroundColor:[UIColor clearColor]];
    [content setText:@"新版本的新特性的描述..."];
    [content setFont:[UIFont systemFontOfSize:12]];
    [customView addSubview:content];
    [customAlertView setContainerView:customView];
    [customAlertView setUseMotionEffects:TRUE];
    [customAlertView setOnButtonTouchUpInside:^(LRAlertView *alertView, int buttonIndex) {
        if (buttonIndex == 0) {
            [alertView close];
        } else if (buttonIndex == 1) {
            NSLog(@"开始升级...");
        }
    }];
    [customAlertView show];
}

- (IBAction)showActionSheetAction:(id)sender {
    LRAlertView *customActionSheetView = [[LRAlertView alloc]init];
    customActionSheetView.style = LRAlertViewStyleActionSheet;
    [customActionSheetView setButtonTitles:@[@"取消",@"确定"]];
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, RESIZE(255))];
    customView.backgroundColor = [UIColor whiteColor];
    {
        UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, RESIZE(40))];
        label1.text = @"请选择日期";
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont systemFontOfSize:14.0];
        label1.textColor = TEXTCOLOR_GRAY;
        label1.layer.borderColor = SEPATATELINECOLOR.CGColor;
        label1.layer.borderWidth = 1;
        [customView addSubview:label1];
        
        UIDatePicker * datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, RESIZE(40), screenWidth, RESIZE(162))];
        datePicker.datePickerMode = UIDatePickerModeDate;
        NSDateFormatter * formatter_minDate = [[NSDateFormatter alloc] init];
        [formatter_minDate setDateFormat:@"yyyy-MM-dd"];
        NSDate * minDate = [formatter_minDate dateFromString:@"1950-01-01"];
        NSDate * maxDate = [NSDate date];
        [datePicker setMinimumDate:minDate];
        [datePicker setMaximumDate:maxDate];
        //        [datePicker addTarget:self action:@selector(dataValueChanged:) forControlEvents:UIControlEventValueChanged];
        [customView addSubview:datePicker];
        _datePicker= datePicker;
    }
    customActionSheetView.containerView = customView;
    __weak typeof(self) weakSelf = self;
    //回调 点击确定取消等按钮
    
    customActionSheetView.onButtonTouchUpInside = ^(LRAlertView *actionSheetView, int buttonIndex){
        if (buttonIndex == 0) {//取消
            [actionSheetView close];
        }else {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString * str = [formatter stringFromDate:weakSelf.datePicker.date];
            weakSelf.selectDateStr = str;
            weakSelf.showLabel.text = weakSelf.selectDateStr;
        }
    };
    [customActionSheetView show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
