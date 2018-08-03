//
//  THXMutablePickerView.m
//  Teacher_iOS
//
//  Created by TAL on 2018/8/2.
//  Copyright © 2018年 whqfor. All rights reserved.
//

#import "THXMutablePickerView.h"
#import "HXPickerView.h"

@interface THXMutablePickerView () <HXPickerViewDelegate, HXPickerViewDataSource>

@property (nonatomic, strong) NSMutableArray * pickerViews;
@property (nonatomic, strong) NSMutableDictionary * pickerViewsInfo;
@property (nonatomic, copy) void(^hx_didSelectedPickerRow)(HXPickerView *, id, HXPickerViewComponent *);

@end

@implementation THXMutablePickerView

+ (instancetype)viewWithFrame:(CGRect)frame pickerViewsFrame:(NSArray<NSValue *> *)frames pickerViewsData:(NSArray <NSArray *>*)data
{
    return [[THXMutablePickerView alloc] initWithFrame:frame pickerViewsFrame:frames pickerViewsData:data];
}

- (instancetype)initWithFrame:(CGRect)frame pickerViewsFrame:(NSArray<NSValue *> *)frames pickerViewsData:(NSArray <NSArray *>*)data
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initPickerViews:frames data:data];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [super initWithCoder:aDecoder];
}

- (void)initPickerViews:(NSArray <NSValue *>*)frames data:(NSArray <NSArray *>*)data
{
    if (!frames.count && !frames) { return;}
    self.clipsToBounds = YES;
    [frames enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        HXPickerView * pickerView = [[HXPickerView alloc] initWithFrame:[obj CGRectValue]];
        pickerView.TDelegate = self;
        pickerView.TDataSource = self;
        [self addSubview:pickerView];
        if (data.count > idx) {
            [self.pickerViews addObject:pickerView];
            [self.pickerViewsInfo setValue:data[idx] forKey:[self keyWithPickerView:pickerView]];
        }
    }];
    _allPickerViews = [self.pickerViews copy];
}

#pragma mark  config and callBack 

- (void)realodPickerView:(HXPickerView *)pickerView data:(NSArray *)data
{
    [self.pickerViewsInfo setValue:[data copy] forKey:[self keyWithPickerView:pickerView]];
    [pickerView reloadAllComponents];
    pickerView.defaultSelectedRow = 0;
}

- (void)configPickerViewFrames:(NSArray<NSValue *> *)frames pickerViewsData:(NSArray<NSArray *> *)data
{
    [self initPickerViews:frames data:data];
}

- (void)setConfig:(NSArray<HXPickerViewConfig *> *)config
{
    _config = config;
    [config enumerateObjectsUsingBlock:^(HXPickerViewConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == self.pickerViews.count - 1) { *stop = YES;}
        HXPickerView * pickerView = self.pickerViews[idx];
        if ((pickerView.separatorColor != obj.separatorColor) && obj.separatorColor)
        { pickerView.separatorColor = obj.separatorColor;}
        if ((pickerView.separatorHeight != obj.separatorHeight) && obj.separatorHeight)
        { pickerView.separatorHeight = obj.separatorHeight;}
        if (!UIEdgeInsetsEqualToEdgeInsets(pickerView.separatorInset, obj.separatorInsets))
        { pickerView.separatorInset = obj.separatorInsets;}
        if ((pickerView.defaultSelectedRow != obj.defaultSelectedRow) && obj.defaultSelectedRow != -1)
        { pickerView.defaultSelectedRow = obj.defaultSelectedRow;}
    }];
}

- (void)pickerViewDidSelected:(void (^)(HXPickerView *, id, HXPickerViewComponent *))didSelected
{
    self.hx_didSelectedPickerRow = didSelected;
}

#pragma mark  HXPickerViewDataSource 

- (NSInteger)hx_numberOfComponentsInPickerView:(HXPickerView *)pickerView
{
    return 1;
}

- (NSInteger)hx_pickerView:(HXPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[self dataWithPickerView:pickerView] count];
}

#pragma mark  HXPickerViewDelegate 

- (CGFloat)hx_pickerView:(HXPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return [self rowHeightForPickerView:pickerView];
}

- (UIView *)hx_pickerView:(HXPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, [self rowHeightForPickerView:pickerView])];
    HXPickerViewConfig * config = [self configForPickerView:pickerView];
    titleLabel.textColor = config ? config.titleNormalColor : [UIColor blackColor];
    titleLabel.font = config ? config.titleFont : [UIFont systemFontOfSize:18];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = [self dataWithPickerView:pickerView][row];
    return titleLabel;
}

- (void)hx_pickerView:(HXPickerView *)pickerView didScrollingRow:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel * titleLabel = (UILabel *)[pickerView viewForRow:row forComponent:0];
    HXPickerViewConfig * config = [self configForPickerView:pickerView];
    titleLabel.textColor = config ? config.titleSelectedColor : [UIColor orangeColor];
}

- (void)hx_pickerView:(HXPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.hx_didSelectedPickerRow) {
        NSArray * dataArray = [self dataWithPickerView:pickerView];
        HXPickerViewComponent * _component = [[HXPickerViewComponent alloc] init];
        _component.row = row;
        _component.component = [self.pickerViews indexOfObject:pickerView];
        self.hx_didSelectedPickerRow(pickerView, dataArray.count ? dataArray[row] : nil, _component);
    }
}

#pragma mark  Private 

- (CGFloat)rowHeightForPickerView:(HXPickerView *)pickerView
{
    HXPickerViewConfig * config = [self configForPickerView:pickerView];
    return config ? config.rowHeight : 44;
}

- (HXPickerViewConfig *)configForPickerView:(HXPickerView *)pickerView
{
    if (self.config) {
        NSInteger idx = [self.pickerViews indexOfObject:pickerView];
        if (idx < self.config.count) {
            return self.config[idx];
        }
        return nil;
    }
    return nil;
}

- (NSArray *)dataWithPickerView:(HXPickerView *)pickerView
{
    NSString * _key = [self keyWithPickerView:pickerView];
    return self.pickerViewsInfo[_key];
}

- (NSString *)keyWithPickerView:(HXPickerView *)pickerView
{
    return [NSString stringWithFormat:@"%p", pickerView];
}


#pragma mark  lazy 

- (NSMutableArray *)pickerViews
{
    if (!_pickerViews) {
        _pickerViews = [[NSMutableArray alloc] init];
    }
    return _pickerViews;
}

- (NSMutableDictionary *)pickerViewsInfo
{
    if (!_pickerViewsInfo) {
        _pickerViewsInfo = [[NSMutableDictionary alloc] init];
    }
    return _pickerViewsInfo;
}

@end

#pragma mark  HXPickerViewComponent 

@implementation HXPickerViewComponent

- (NSString *)description
{
    return [NSString stringWithFormat:@"row：%ld, component：%ld", (long)self.row, (long)self.component];
}

@end

#pragma mark  HXPickerViewConfig 

@implementation HXPickerViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _defaultSelectedRow = -1;
    }
    return self;
}

@end
