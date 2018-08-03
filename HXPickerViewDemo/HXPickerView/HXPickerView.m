//
//  HXPickerView.m
//  HXPickerView
//
//  Created by TAL on 2018/7/30.
//  Copyright © 2018年 TAL. All rights reserved.
//

#import "HXPickerView.h"

static NSString * const contentOffsetPath = @"contentOffset";

@interface HXPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) NSInteger currentSelectedRow;
@property (nonatomic, strong) NSMutableArray * scrollViews;
@property (nonatomic, assign) NSInteger hx_numberOfRowsInComponent;
@property (nonatomic, strong) NSMutableArray <UIView *>* separatorLineViews;

@end

@implementation HXPickerView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    return self;
}

- (void)config
{
    self.delegate = self;
    self.dataSource = self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    for (UIView * subView in [self hx_allSubViews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            UIScrollView * subScrollView = (UIScrollView *)subView;
            [subScrollView addObserver:self forKeyPath:contentOffsetPath
                               options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                               context:nil];
            self.startPoint = subScrollView.contentOffset;
            [self.scrollViews addObject:subScrollView];
        }
        if (subView.frame.size.height <= 1 &&
            (self.separatorColor != nil || self.separatorHeight > 0 )) {
            [self _setSeparatorLineView:subView];
        }
        if (subView.frame.size.height <= 1) { [self.separatorLineViews addObject:subView];}
    }
    self.defaultSelectedRow = 0;
}

#pragma mark  setter 

- (void)setDefaultSelectedRow:(NSInteger)defaultSelectedRow
{
    _defaultSelectedRow = defaultSelectedRow;
    [self selectRow:_defaultSelectedRow inComponent:0 animated:self.scrollingAnimation?:NO];
    [self hx_pickerView:self didScrollingRow:_defaultSelectedRow inComponent:0];
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    _separatorColor = separatorColor;
    [self.separatorLineViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = separatorColor;
    }];
}

- (void)setSeparatorInset:(UIEdgeInsets)separatorInset
{
    _separatorInset = separatorInset;
    [self.separatorLineViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = obj.frame;
        frame.origin.x = separatorInset.left;
        frame.size.width = self.bounds.size.width - frame.origin.x - separatorInset.right;
        obj.frame = frame;
    }];
}

- (void)setSeparatorHeight:(CGFloat)separatorHeight
{
    _separatorHeight = separatorHeight;
    [self.separatorLineViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = obj.frame;
        frame.size.height = separatorHeight;
        obj.frame = frame;
    }];
}

- (void)_setSeparatorLineView:(UIView *)view
{
    CGRect frame = view.frame;
    view.backgroundColor = self.separatorColor;
    frame.origin.x = self.separatorInset.left;
    frame.size.height = self.separatorHeight;
    frame.size.width = self.bounds.size.width - frame.origin.x - self.separatorInset.right;
    view.frame = frame;
}

#pragma mark  observer 

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:contentOffsetPath] && [object isKindOfClass:[UIScrollView class]]) {
        CGFloat rowHeight = [self rowSizeForComponent:0].height;
        CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
        CGPoint oldContentOffset = [change[NSKeyValueChangeOldKey] CGPointValue];
        CGFloat scrollingRow = fabs(self.startPoint.y - contentOffset.y) / rowHeight;
        CGFloat _y = contentOffset.y - oldContentOffset.y;
        if (_y > 0) {
            NSInteger row = ceil(scrollingRow);
            if (row >= self.hx_numberOfRowsInComponent) { row = self.hx_numberOfRowsInComponent - 1;}
            if (contentOffset.y <= self.startPoint.y) { row = 0;}
            [self hx_pickerView:self didScrollingRow:row inComponent:0];
            NSLog(@"上");
        } else if (_y < 0) {
            NSInteger row = floor(scrollingRow);
            [self hx_pickerView:self didScrollingRow:row inComponent:0];
            NSLog(@"下");
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark  UIPickerViewDataSource 

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self hx_numberOfComponentsInPickerView:self];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self hx_pickerView:self numberOfRowsInComponent:component];
}


#pragma mark  UIPickerViewDelegate 

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return [self hx_pickerView:self rowHeightForComponent:component];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [self hx_pickerView:self widthForComponent:component];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self pickerView:self titleForRow:row forComponent:component];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self hx_pickerView:self attributedTitleForRow:row forComponent:component];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    return [self hx_pickerView:self viewForRow:row forComponent:component reusingView:view];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self hx_pickerView:self didSelectRow:row inComponent:component];
}


#pragma mark  HXPickerViewDataSource 

- (NSInteger)hx_numberOfComponentsInPickerView:(HXPickerView *)pickerView
{
    if ([self.TDataSource respondsToSelector:_cmd]) {
        return [self.TDataSource hx_numberOfComponentsInPickerView:pickerView];
    }
    return 1;
}

- (NSInteger)hx_pickerView:(HXPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([self.TDataSource respondsToSelector:_cmd]) {
        self.hx_numberOfRowsInComponent = [self.TDataSource hx_pickerView:pickerView numberOfRowsInComponent:component];
        return self.hx_numberOfRowsInComponent;
    }
    return 1;
}


#pragma mark  HXPickerViewDelegate 

- (void)hx_pickerView:(HXPickerView *)pickerView didScrollingRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([self.TDelegate respondsToSelector:_cmd]) {
        [self.TDelegate hx_pickerView:pickerView didScrollingRow:row inComponent:component];
    }
}

- (CGFloat)hx_pickerView:(HXPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if ([self.TDelegate respondsToSelector:_cmd]) {
        return [self.TDelegate hx_pickerView:pickerView rowHeightForComponent:component];
    }
    return 44;
}

- (CGFloat)hx_pickerView:(HXPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if ([self.TDelegate respondsToSelector:_cmd]) {
        return [self.TDelegate hx_pickerView:pickerView widthForComponent:component];
    }
    return 0;
}

- (NSString *)hx_pickerView:(HXPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.TDelegate respondsToSelector:_cmd]) {
        return [self.TDelegate hx_pickerView:pickerView titleForRow:row forComponent:component];
    }
    return nil;
}

- (NSAttributedString *)hx_pickerView:(HXPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.TDelegate respondsToSelector:_cmd]) {
        return [self.TDelegate hx_pickerView:pickerView attributedTitleForRow:row forComponent:component];
    }
    return nil;
}

- (UIView *)hx_pickerView:(HXPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if ([self.TDelegate respondsToSelector:_cmd]) {
        return [self.TDelegate hx_pickerView:pickerView viewForRow:row forComponent:component reusingView:view];
    }
    return nil;
}

- (void)hx_pickerView:(HXPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.currentSelectedRow = row;
    [self hx_pickerView:pickerView didScrollingRow:row inComponent:component];
    if ([self.TDelegate respondsToSelector:_cmd]) {
        [self.TDelegate hx_pickerView:pickerView didSelectRow:row inComponent:component];
    }
}


#pragma mark  lazy 

- (NSMutableArray *)scrollViews
{
    if (!_scrollViews) {
        _scrollViews = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _scrollViews;
}

- (NSMutableArray *)separatorLineViews
{
    if (!_separatorLineViews) {
        _separatorLineViews = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return _separatorLineViews;
}


#pragma mark  dealloc 

- (void)dealloc
{
    for (UIScrollView * scrollView in self.scrollViews) {
        [scrollView removeObserver:self forKeyPath:contentOffsetPath];
    }
}


@end


@implementation HXPickerView (HXAllSubViews)

- (NSArray *)hx_allSubViews
{
    NSMutableArray * views = [[NSMutableArray alloc] initWithCapacity:0];
    [self hx_ergodicSubView:self views:views];
    return views;
}

- (NSMutableArray *)hx_viewsWithSubView:(UIView *)view views:(NSMutableArray *)views
{
    if (view == nil) {
        return views;
    } else if (!view.subviews.count) {
        [views addObject:view];
    } else {
        [views addObject:view];
        [self hx_ergodicSubView:view views:views];
    }
    return views;
}

- (void)hx_ergodicSubView:(UIView *)view views:(NSMutableArray *)views
{
    for (UIView * subView in view.subviews) {
        [self hx_viewsWithSubView:subView views:views];
    }
}


@end

