//
//  LYDecimalKeyBoard.m
//  Aipai
//
//  Created by zhangjie on 2018/3/22.
//  Copyright © 2018年 www.aipai.com. All rights reserved.
//

#import "LYDecimalKeyBoard.h"
#import <UIKit/UIKit.h>
@interface UIImage (XXX)
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;
@end
@implementation UIImage (XXX)

+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [color setFill];
    CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end



@interface LYDecimalKeyboardItem : UIButton
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
@end
@implementation LYDecimalKeyboardItem
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state{
    [self setBackgroundImage:[UIImage imageWithColor:backgroundColor size:CGSizeMake(1, 1)]
                    forState:state];
}

@end


@interface LYDecimalKeyBoard()<UIInputViewAudioFeedback>{
    NSTimer *_deleteTimer;
}
@property (nonatomic,weak)UIView<UIKeyInput> *firstResponder;

@end

@implementation LYDecimalKeyBoard {
    BOOL _hideDot;
}
- (void)dealloc {
    [self cleanTimer];
}

- (instancetype)initWithHideDot:(BOOL)hideDot {
    _hideDot = hideDot;
    return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*0.32*2)]){
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat width = CGRectGetWidth(self.bounds) / 4.f - .5f;
    CGFloat height = CGRectGetHeight(self.bounds) / 4.f - .5f;
    [self viewWithTag:49].frame = CGRectMake(0, .5, width, height);
    [self viewWithTag:50].frame = CGRectMake(width + .5f, .5f, width, height);
    [self viewWithTag:51].frame = CGRectMake((width + .5f) * 2, .5f, width, height);
    [self viewWithTag:52].frame = CGRectMake(0, height + 1.f, width, height);
    [self viewWithTag:53].frame = CGRectMake(width + .5f, height + 1.f, width, height);
    [self viewWithTag:54].frame = CGRectMake((width + .5f) * 2, height + 1.f, width, height);
    [self viewWithTag:55].frame = CGRectMake(0, .5f + (height + .5f) * 2, width, height);
    [self viewWithTag:56].frame = CGRectMake(width + .5f, .5f + (height + .5f) * 2, width, height);
    [self viewWithTag:57].frame = CGRectMake((width + .5f) * 2, .5f + (height + .5f) * 2, width, height);
    [self viewWithTag:48].frame = CGRectMake(width + .5f, .5f + (height + .5f) * 3, width, height);
    [self viewWithTag:46].frame = CGRectMake(0, .5f + (height + .5f) * 3, width, height);
    [self viewWithTag:-1].frame = CGRectMake((width + .5f) * 2, .5f + (height + .5f) * 3, width, height);
    [self viewWithTag:127].frame = CGRectMake((width + .5f) * 3, .5f, width, height * 2 + .5f);
    [self viewWithTag:-2].frame = CGRectMake((width + .5f) * 3, 1.f + height * 2, width, height * 2 + 1.f);
}
#pragma mark ACTION
- (void)buttonTouchUpInside:(LYDecimalKeyboardItem *)sender
{
    if (!self.firstResponder || ![self.firstResponder isFirstResponder]) {
        self.firstResponder = (UIView<UIKeyInput>*)[[UIApplication sharedApplication].keyWindow valueForKey:@"_firstResponder"];
        if (!self.firstResponder) return;
        if (![self.firstResponder conformsToProtocol:@protocol(UIKeyInput)]) return;
    }
    
    [self playClickAudio];
    [self handleInputWithKeyboardItemTag:sender.tag];
}
#pragma mark PRITVATEMETHOD

- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.tintColor = self.tintColor?:[UIColor colorWithRed:23/255.0 green:113/255.0 blue:251/255.0 alpha:1.0];
    NSBundle *mainBundle = [NSBundle bundleForClass:self.class];
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"keyboard" ofType:@"bundle"]];
    if (resourcesBundle == nil) {
        resourcesBundle = mainBundle;
    }
    for (int i = 0; i < 14; ++i) {
        LYDecimalKeyboardItem *item = [LYDecimalKeyboardItem buttonWithType:UIButtonTypeCustom];
        if (i == 10) {
            item.tag = 46;
            [item setTitle:@"." forState:UIControlStateNormal];
            item.hidden = _hideDot;
        }
        else if (i == 11) {
            item.tag = 127;
            //删除
            

            UIImage *img = [UIImage imageNamed:@"ly_coustom_delete_icon" inBundle:resourcesBundle compatibleWithTraitCollection:nil];
            
            [item setImage:img forState:UIControlStateNormal];
            UILongPressGestureRecognizer *g = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(deleteItemLongPress:)];
            [item addGestureRecognizer:g];
        }
        else if (i == 12) {
            item.tag = -1;
            UIImage *img = [UIImage imageNamed:@"ly_coustom_keyboard_icon" inBundle:resourcesBundle compatibleWithTraitCollection:nil];
            [item setImage:img forState:UIControlStateNormal];
        }
        else if (i == 13) {
            item.tag = -2;
            item.titleLabel.font = [UIFont systemFontOfSize:20];
            [item setTitle:@"确定" forState:UIControlStateNormal];
        }
        else {
            item.tag = 48 + i;
            [item setTitle:[NSString stringWithFormat:@"%d", i]
                  forState:UIControlStateNormal];
        }
        
        if (item.tag != -2) {
            [item setBackgroundColor:[UIColor colorWithRed:244 / 255.f
                                                     green:243 / 255.f
                                                      blue:244 / 255.f
                                                     alpha:1] forState:UIControlStateNormal];
            [item setBackgroundColor:[UIColor colorWithRed:230 / 255.f
                                                     green:230 / 255.f
                                                      blue:230 / 255.f
                                                     alpha:1] forState:UIControlStateHighlighted];
            [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [item.titleLabel setFont:[UIFont systemFontOfSize:27]];
        }
        else {
            CGFloat h[1], s[1], b[1], a[1];
            [self.tintColor getHue:h
                        saturation:s
                        brightness:b
                             alpha:a];
            UIColor *highlightColor = [UIColor colorWithHue:h[0]
                                                 saturation:s[0]
                                                 brightness:b[0] - .1f
                                                      alpha:a[0]];            
            [item setBackgroundColor:self.tintColor forState:UIControlStateNormal];
            [item setBackgroundColor:highlightColor forState:UIControlStateHighlighted];
            [item setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [item addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
    }
}
- (void)cleanTimer{
    [_deleteTimer invalidate];
    _deleteTimer = nil;
}
- (void)playClickAudio{
    [[UIDevice currentDevice] playInputClick];
}
- (void)clickedDot{
    [self insert:@"."];
}
- (void)clickedDelete
{
    if (self.isPw6Code) {
        [self.firstResponder deleteBackward];
        return;
    }
    if ([self.firstResponder hasText]) {
        [self.firstResponder deleteBackward];
    }
}

- (void)clickedDismiss
{
    [self.firstResponder resignFirstResponder];
}

- (void)clickedSure
{
    [self.firstResponder resignFirstResponder];
    !self.done ?: self.done();
}

- (void)clickedDecimal:(int)decimal
{
    [self insert:[NSString stringWithFormat:@"%d", decimal]];
}
- (void)insert:(NSString *)text
{
    if ([self.firstResponder isKindOfClass:[UITextField class]]) {
        id<UITextFieldDelegate> delegate = [(UITextField *)self.firstResponder delegate];
        if ([delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            NSRange range = [self selectedRangeInInputView:(id<UITextInput>)self.firstResponder];
            if ([delegate textField:(UITextField *)self.firstResponder shouldChangeCharactersInRange:range replacementString:text]) {
                [self.firstResponder insertText:text];
            }
        }
    }
    else if ([self.firstResponder isKindOfClass:[UITextView class]]) {
        id<UITextViewDelegate> delegate = [(UITextView *)self.firstResponder delegate];
        if ([delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
            NSRange range = [self selectedRangeInInputView:(id<UITextInput>)self.firstResponder];
            if ([delegate textView:(UITextView *)self.firstResponder shouldChangeTextInRange:range replacementText:text]) {
                [self.firstResponder insertText:text];
            }
        }
    }
    else {
        [self.firstResponder insertText:text];
    }
}
- (NSRange)selectedRangeInInputView:(id<UITextInput>)inputView{
    UITextPosition* beginning = inputView.beginningOfDocument;
    
    UITextRange* selectedRange = inputView.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [inputView offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [inputView offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}
- (void)handleInputWithKeyboardItemTag:(NSUInteger)tag{
    switch (tag) {
            case 46:
            [self clickedDot];
            break;
            
            case 127:
            [self clickedDelete];
            break;
            
            case -1:
            [self clickedDismiss];
            break;
            
            case -2:
            [self clickedSure];
            break;
            case 48:
            case 49:
            case 50:
            case 51:
            case 52:
            case 53:
            case 54:
            case 55:
            case 56:
            case 57:
            [self clickedDecimal:(int)tag - 48];
            break;
            
        default:
            break;
    }
}
- (void)deleteItemLongPress:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        _deleteTimer = [NSTimer scheduledTimerWithTimeInterval:.1
                                                       target:self
                                                     selector:@selector(repeatLongPressDelete)
                                                     userInfo:nil
                                                      repeats:YES];
    }
    else if (longPress.state == UIGestureRecognizerStateEnded
             || longPress.state == UIGestureRecognizerStateCancelled
             || longPress.state == UIGestureRecognizerStateFailed) {
        [self cleanTimer];
    }
}
- (void)repeatLongPressDelete{
    [(UIControl *)[self viewWithTag:127] sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UIInputViewAudioFeedback

- (BOOL)enableInputClicksWhenVisible{
    return YES;
}

#pragma mark set/get
- (void)setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
}
@end
