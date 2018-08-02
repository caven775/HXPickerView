//
//  HXPickerView.h
//  HXPickerView
//
//  Created by TAL on 2018/7/30.
//  Copyright © 2018年 TAL. All rights reserved.
//

#import <UIKit/UIKit.h>

///-----------------------------------------
/// 只支持component为1
///-----------------------------------------

@protocol HXPickerViewDelegate;
@protocol HXPickerViewDataSource;

@interface HXPickerView : UIPickerView

@property (nonatomic, weak, nullable) id <HXPickerViewDelegate> TDelegate;
@property (nonatomic, weak, nullable) id <HXPickerViewDataSource> TDataSource;
@property (nonatomic, strong) UIColor * separatorColor;
@property (nonatomic, assign) CGFloat separatorHeight;
@property (nonatomic, assign) UIEdgeInsets separatorInset;
@property (nonatomic, assign) NSInteger defaultSelectedRow;
@property (nonatomic, assign) BOOL scrollingAnimation;

@end


@protocol HXPickerViewDataSource <NSObject>

@required;

- (NSInteger)hx_numberOfComponentsInPickerView:(HXPickerView *)pickerView;
- (NSInteger)hx_pickerView:(HXPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;

@end


@protocol HXPickerViewDelegate <NSObject>

@optional;
- (void)hx_pickerView:(HXPickerView *)pickerView didScrollingRow:(NSInteger)row inComponent:(NSInteger)component;
- (CGFloat)hx_pickerView:(HXPickerView *)pickerView rowHeightForComponent:(NSInteger)component;
- (CGFloat)hx_pickerView:(HXPickerView *)pickerView widthForComponent:(NSInteger)component;
- (NSString *)hx_pickerView:(HXPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (NSAttributedString *)hx_pickerView:(HXPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (UIView *)hx_pickerView:(HXPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
- (void)hx_pickerView:(HXPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;

@end

@interface HXPickerView (HXAllSubViews)

- (NSArray *)hx_allSubViews;

@end




