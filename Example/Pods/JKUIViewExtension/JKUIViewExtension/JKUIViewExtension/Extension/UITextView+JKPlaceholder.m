//  UITextView+Placeholder.m
//  TextViewPlaceHolderDemo
//
//  Created by zhangjie on 2017/8/16.
//  Copyright © 2017年 zhangjie. All rights reserved.
//

#import <objc/runtime.h>
#import "UITextView+JKPlaceholder.h"

@implementation UITextView (JKPlaceholder)

#pragma mark - Swizzle Dealloc

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
}

- (void)swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UILabel *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
    if (label) {
        for (NSString *key in self.class.observingKeys) {
            @try {
                [self removeObserver:self forKeyPath:key];
            }
            @catch (NSException *exception) {
            }
        }
    }
    [self swizzledDealloc];
}


#pragma mark - Class Methods
#pragma mark  defaultPlaceholderColor

+ (UIColor *)defaultPlaceholderColor {
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor blackColor];
    });
    return color;
}


#pragma mark -  observingKeys

+ (NSArray *)observingKeys {
    return @[@"attributedText",
             @"bounds",
             @"font",
             @"frame",
             @"text",
             @"textAlignment",
             @"textContainerInset"];
}


#pragma mark - Properties
#pragma mark placeholderLabel

- (UILabel *)placeholderLabel {
    UILabel *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
    if (!label) {
        NSAttributedString *originalText = self.attributedText;
        self.text = @" ";
        self.attributedText = originalText;
        label = [[UILabel alloc] init];
        label.textColor = [self.class defaultPlaceholderColor];
        label.numberOfLines = 0;
        label.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, @selector(placeholderLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        self.needsUpdateFont = YES;
        [self updatePlaceholderLabel];
        self.needsUpdateFont = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updatePlaceholderLabel)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];

        for (NSString *key in self.class.observingKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return label;
}


#pragma mark  placeholder

- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
    [self updatePlaceholderLabel];
}

- (NSAttributedString *)attributedPlaceholder {
    return self.placeholderLabel.attributedText;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.placeholderLabel.attributedText = attributedPlaceholder;
    [self updatePlaceholderLabel];
}

#pragma mark  placeholderColor

- (UIColor *)placeholderColor {
    return self.placeholderLabel.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderLabel.textColor = placeholderColor;
}


#pragma mark  needsUpdateFont

- (BOOL)needsUpdateFont {
    return [objc_getAssociatedObject(self, @selector(needsUpdateFont)) boolValue];
}

- (void)setNeedsUpdateFont:(BOOL)needsUpdate {
    objc_setAssociatedObject(self, @selector(needsUpdateFont), @(needsUpdate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self updatePlaceholderLabel];
}
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"font"]) {
        self.needsUpdateFont = (change[NSKeyValueChangeNewKey] != nil);
    }
    [self updatePlaceholderLabel];
}


#pragma mark - Update

- (void)updatePlaceholderLabel {
    if (self.text.length) {
        [self.placeholderLabel removeFromSuperview];
        return;
    }
    [self insertSubview:self.placeholderLabel atIndex:0];
    if (self.needsUpdateFont) {
        self.placeholderLabel.font = self.font;
        self.needsUpdateFont = NO;
    }
    self.placeholderLabel.textAlignment = self.textAlignment;
    CGFloat lineFragmentPadding;
    UIEdgeInsets textContainerInset;
    lineFragmentPadding = self.textContainer.lineFragmentPadding;
    textContainerInset = self.textContainerInset;
    CGFloat x = lineFragmentPadding + textContainerInset.left;
    CGFloat y = textContainerInset.top;
    CGFloat width = CGRectGetWidth(self.bounds) - x - lineFragmentPadding - textContainerInset.right;
    CGFloat height = [self.placeholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
    self.placeholderLabel.frame = CGRectMake(x, y, width, height);
}

@end
