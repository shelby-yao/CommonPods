//
//  SMMultiTextField.m
//  testTextfield
//
//  Created by Jekin on 2018/11/16.
//  Copyright © 2018 Jekin. All rights reserved.
//

#import "JJMultiTextField.h"

@implementation JJMultiTextField {
    NSInteger _length;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (!self.singleBanWord && !self.isBanZero) {return;}
    
    if (self.isBanZero) {
        NSInteger num = textField.text.integerValue;
        if (num == 0) {
            textField.text = @"";
            if (self.banWordCallback) {
                self.banWordCallback(@"0");
            }
            return;
        }
    }

    if ([textField.text isEqualToString:self.singleBanWord]) {
        textField.text = @"";
        if (self.banWordCallback) {
            self.banWordCallback(self.singleBanWord);
        }
        return;
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.forbiddenType = JJTextFunctionTypeAllFunction;
    self.maxNumber = INT_MAX;
    [self addTarget:self action:@selector(textDidEditChange:) forControlEvents:UIControlEventEditingChanged];
    self.delegate = self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.maxValue = CGFLOAT_MAX;
        self.forbiddenType = JJTextFunctionTypeAllFunction;
        self.maxNumber = INT_MAX;
        [self addTarget:self action:@selector(textDidEditChange:) forControlEvents:UIControlEventEditingChanged];
        self.delegate = self;
    }
    return self;
}


- (void)textDidEditChange:(UITextField *)textField {
    NSString *toBeString = textField.text;
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//    UITextInputMode *inputMode = [UITextInputMode activeInputModes].firstObject;
    if (!position){//没有高亮选择
        if (toBeString.length > self.maxNumber && textField.markedTextRange == nil){
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.maxNumber];
            if (rangeIndex.length == 1){
                textField.text = [self resultString:[toBeString substringToIndex:self.maxNumber]];
            }
            else{
                textField.text = [self resultString:[toBeString substringWithRange:NSMakeRange(0, _length)]];
            }
        } else {
            textField.text = [self resultString:toBeString];
            _length = toBeString.length;
        }
    }else {//有高亮选择
        if (self.contentType == JJTextContentTypeOnlyNum) {
            textField.text = @"";
        }else if (self.contentType == JJTextContentTypeASCII){
            textField.text = [self filterOtherKeepASCWithString:toBeString];
        }
    }
}


- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.forbiddenType == JJTextFunctionTypeNoneFunction)return [super canPerformAction:action withSender:sender];
    if (self.forbiddenType == JJTextFunctionTypeAllFunction)return NO;
    if(action == @selector(paste:)){
        return (self.forbiddenType & JJTextFunctionTypePaste) == 0;
    }
    if (action == @selector(selectAll:)) {
        return (self.forbiddenType &JJTextFunctionTypeSelectAll) == 0;
    }
    if (action == @selector(select:)) {
        return (self.forbiddenType & JJTextFunctionTypeSelectSignl) == 0;
    }
    return [super canPerformAction:action withSender:sender];
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0)return YES;
    if ([self.filterCharactor containsObject:string])return NO;
    if (self.contentType == JJTextContentTypeDefalut)return YES;
    if (self.contentType == JJTextContentTypeOnlyNum) return [self validateNumber:string];
    if (self.contentType == JJTextContentTypeOnlyIntAndFloat) return  [self validateIntOrFloat:string];
    if (self.contentType == JJTextContentTypeIDCard)return [self validateID:string];
    if (self.contentType == JJTextContentTypeOnlyChinese) {
        //不可输入数字/以及特殊字符
        return ![self validateChinese:string]&&![self validateNumber:string];
    }
    return YES;
}


- (NSString *)resultString:(NSString *)string {
    switch (self.contentType) {

        case JJTextContentTypeASCII://(过滤中文)
            return [self filterOtherKeepASCWithString:string];
            break;
        case JJTextContentTypeDefalut:
            return string;
            break;
        case JJTextContentTypeOnlyNum:
            return [self filterOtherKeepNumberWithString:string];
            break;
        case JJTextContentTypeOnlyChinese:
            return [self filterOtherKeepChineseWithString:string];
            break;
        
        default:
            return string;
            break;
    }
    return string;
}
//过滤中文(只显示ASCII)
- (NSString *)filterOtherKeepASCWithString:(NSString *)string {
    return [self filterCharactor:string withRegex:@"[\u4e00-\u9fa5]"];
}

//过滤非数字字符(只显示数字)
- (NSString *)filterOtherKeepNumberWithString:(NSString *)string {
    return [self filterCharactor:string withRegex:@"[a-zA-Z\u4e00-\u9fa5]"];
}





//过滤非汉字字符(只显示中文)
- (NSString *)filterOtherKeepChineseWithString:(NSString *)string {
    return [self filterCharactor:string withRegex:@"[^\u4e00-\u9fa5]"];
}

//过滤指定字符
- (NSString *)filterCharactor:(NSString *)string withRegex:(NSString *)regexStr{
    NSString *searchText = string;
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

- (BOOL)validateIntOrFloat:(NSString *)string {
    if (self.text.length == 0 && [string isEqualToString:@"."]){
        self.text = @"0";
    }
    NSString *tempString = [NSString stringWithFormat:@"%@%@",self.text,string];
    if (tempString.floatValue > self.maxValue) {
        return NO;
    }
    NSString *targetString = [self.text stringByAppendingString:string];
    if ([self validateNumber:string] || [string isEqualToString:@"."]) {
        //检测“.”的个数
        NSString *temp = [NSString string];
        NSString *decimalsStr = [NSString string];
        NSInteger pointNum = 0;
        
        for(int i = 0; i < [targetString length];i++) {
            temp = [targetString substringWithRange:NSMakeRange(i, 1)];
            if ([temp isEqualToString:@"."]) {
                //切割小数点之后的字符串
                decimalsStr = [targetString substringFromIndex:i+1];
                pointNum ++;
            }
        }
        //如果输入了两个小数点或者小数点后面多于两位，禁止输入
        if (pointNum <= 1 && decimalsStr.length <= 2) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
    
}

- (BOOL)validateID:(NSString*)string {
    if (self.text.length == 18) {return NO;}
    BOOL isValid = YES;
    NSUInteger len = string.length;
    NSString *tempString = [NSString stringWithFormat:@"%@%@",self.text,string];
    if (tempString.floatValue > self.maxValue) {
        return NO;
    }
    
    if (len > 0) {
        if (self.text.length == 17) {
            NSString *numberRegex = @"\\d*([X]|[x]{0,1})";
            NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
            isValid = [numberPredicate evaluateWithObject:string];
        } else {
            NSString *numberRegex = @"^[0-9]*$";
            NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
            isValid = [numberPredicate evaluateWithObject:string];
        }
    }
    return isValid;
}

- (BOOL)validateNumber:(NSString*)string {
    BOOL isValid = YES;
    NSUInteger len = string.length;
    NSString *tempString = [NSString stringWithFormat:@"%@%@",self.text,string];
    if (tempString.floatValue > self.maxValue) {
        return NO;
    }
    if (len > 0) {
        NSString *numberRegex = @"^[0-9]*$";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}

- (BOOL)validateChinese:(NSString *)string {
    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *numberRegex = @"((?=[\\x00-\\xff]|。|、|“|”+)[^A-Za-z0-9])";
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
        isValid = [numberPredicate evaluateWithObject:string];
    }
    return isValid;
}
@end
