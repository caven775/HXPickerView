//
//  TestViewController.m
//  HXPickerViewDemo
//
//  Created by TAL on 2018/8/3.
//  Copyright © 2018年 LKW. All rights reserved.
//

#import "TestViewController.h"
#import "THXMutablePickerView.h"

@interface TestViewController ()

@property (nonatomic, strong) THXMutablePickerView * pickerView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    HXPickerViewConfig * config1 = [[HXPickerViewConfig alloc] init];
    config1.rowHeight = 66;
    config1.titleSelectedColor = [UIColor redColor];
    config1.titleNormalColor = [UIColor blueColor];
    config1.defaultSelectedRow = 2;
    config1.titleFont = [UIFont systemFontOfSize:14];
    config1.separatorHeight = 2;
    config1.separatorColor = [UIColor redColor];
    config1.separatorInsets = UIEdgeInsetsMake(0, 20, 0, 20);
    
    CGFloat width = self.view.bounds.size.width;
    CGRect frame1 = {{0, 0}, {width / 2 - 10, 400}};
    CGRect frame2 = {{width / 2, 0}, {width / 2 - 10, 400}};
    
    NSArray * arrayLeft = @[@"左 数据1", @"左 数据2", @"左 数据3", @"左 数据4"];
    NSArray * arrayRight = @[@"右 数据1", @"右 数据2", @"右 数据3", @"右 数据4"];
    self.pickerView = [[THXMutablePickerView alloc] initWithFrame:CGRectMake(0, 100, width, 400)
                                                          pickerViewsFrame:@[[NSValue valueWithCGRect:frame1], [NSValue valueWithCGRect:frame2]]
                                                           pickerViewsData:@[arrayLeft, arrayRight]];
    
    self.pickerView.config = @[config1];
    
    [self.view addSubview:self.pickerView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    HXPickerView * p = self.pickerView.allPickerViews[1];
    [self.pickerView realodPickerView:p data:@[@"新数据1", @"新数据2", @"新数据3", @"新数据4"]];
}

@end
