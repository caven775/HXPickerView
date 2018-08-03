//
//  THXMutablePickerView.h
//  Teacher_iOS
//
//  Created by TAL on 2018/8/2.
//  Copyright © 2018年 whqfor. All rights reserved.
//

#import <UIKit/UIKit.h>

///-----------------------------------------
/// 创建一个或者多个pickerView
///-----------------------------------------

@class HXPickerView;
@class HXPickerViewConfig;
@class HXPickerViewComponent;

@interface THXMutablePickerView : UIView

/**
 初始化

 @param frame contentView的frame
 @param frames contentView中每个pickerView的frame
 @param data contentView中每个pickerView的数据源
 @return THXMutablePickerView
 */
+ (instancetype)viewWithFrame:(CGRect)frame
             pickerViewsFrame:(NSArray <NSValue *>*)frames
              pickerViewsData:(NSArray <NSArray *>*)data;

/**
 初始化

 @param frame contentView的frame
 @param frames contentView中每个pickerView的frame
 @param data contentView中每个pickerView的数据源
 @return THXMutablePickerView
 */
- (instancetype)initWithFrame:(CGRect)frame
             pickerViewsFrame:(NSArray <NSValue *>*)frames
              pickerViewsData:(NSArray <NSArray *>*)data;

/**
 配置每个pickerView的样式
 不配置为默认值
 注意：
 当从xib加载时，必须在方法 configPickerViewFrames:pickerViewsData: 之后设置
 */
@property (nonatomic, strong) NSArray <HXPickerViewConfig *>* config;

/**
 所有的pickView
 */
@property (nonatomic, strong, readonly) NSArray <HXPickerView *>* allPickerViews;

/**
 配置contentView
 注意：当从xib加载时，该方法必须实现

 @param frames 每个pickerView的frame
 @param data 每个pickerView的数据源
 */
- (void)configPickerViewFrames:(NSArray <NSValue *>*)frames
               pickerViewsData:(NSArray <NSArray *>*)data;

/**
 刷新pickerView

 @param pickerView targetpickerView
 @param data 数据源
 */
- (void)realodPickerView:(HXPickerView *)pickerView
                    data:(NSArray *)data;

/**
 选择回调

 @param didSelected 回调
 */
- (void)pickerViewDidSelected:(void(^)(HXPickerView * pickerView, id selectedItem, HXPickerViewComponent * component))didSelected;

@end



@interface HXPickerViewComponent : NSObject

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger component;

@end


@interface HXPickerViewConfig : NSObject

/**
 行高
 */
@property (nonatomic, assign) CGFloat rowHeight;

/**
 初始选中的row
 */
@property (nonatomic, assign) NSInteger defaultSelectedRow;

/**
 字体大小
 */
@property (nonatomic, strong) UIFont * titleFont;

/**
 分割线的粗细
 */
@property (nonatomic, assign) CGFloat separatorHeight;

/**
 分割线的颜色
 */
@property (nonatomic, strong) UIColor * separatorColor;

/**
 正常字体颜色
 */
@property (nonatomic, strong) UIColor * titleNormalColor;

/**
 选中时的字体颜色
 */
@property (nonatomic, strong) UIColor * titleSelectedColor;

/**
 分割线的Insets
 */
@property (nonatomic, assign) UIEdgeInsets separatorInsets;

@end
