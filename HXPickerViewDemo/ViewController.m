//
//  ViewController.m
//  HXPickerViewDemo
//
//  Created by 林克文 on 2018/8/2.
//  Copyright © 2018年 LKW. All rights reserved.
//

#import "ViewController.h"
#import "HXPickerView.h"

@interface ViewController () <HXPickerViewDelegate, HXPickerViewDataSource>

@property (nonatomic, strong) HXPickerView * pickerView;
@property (nonatomic, strong) NSArray * dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.pickerView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.pickerView.separatorHeight = 2;
    self.pickerView.separatorColor = [UIColor redColor];
    self.pickerView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    self.pickerView.defaultSelectedRow = 3;
    self.pickerView.scrollingAnimation = YES;
}

- (NSInteger)hx_numberOfComponentsInPickerView:(HXPickerView *)pickerView
{
    return 1;
}

- (NSInteger)hx_pickerView:(HXPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

- (CGFloat)hx_pickerView:(HXPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
}

- (UIView *)hx_pickerView:(HXPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    CGFloat rowHeight = [pickerView rowSizeForComponent:0].height;
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, rowHeight)];
    titleLabel.text = self.dataArray[row];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    return titleLabel;
}

- (void)hx_pickerView:(HXPickerView *)pickerView didScrollingRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel * titleLabel = (UILabel *)[pickerView viewForRow:row forComponent:component];
    titleLabel.textColor = [UIColor orangeColor];
}

- (HXPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[HXPickerView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 300)];
        _pickerView.TDelegate = self;
        _pickerView.TDataSource = self;
    }
    return _pickerView;
}

- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = @[@"数据0", @"数据1", @"数据2", @"数据3", @"数据4", @"数据5", @"数据6", @"数据7"];
    }
    return _dataArray;
}

@end
