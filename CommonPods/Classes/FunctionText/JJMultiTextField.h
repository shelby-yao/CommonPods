//
//  SMMultiTextField.h
//  testTextfield
//
//  Created by Jekin on 2018/11/16.
//  Copyright © 2018 Jekin. All rights reserved.
//


#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,JJTextFunctionType){
    JJTextFunctionTypeNoneFunction = 0,//默认不禁用
    JJTextFunctionTypePaste = 1 << 1,//禁用粘贴
    JJTextFunctionTypeSelectSignl = 1 << 2 ,//禁用选择
    JJTextFunctionTypeSelectAll = 1 << 3,//禁用全选
    JJTextFunctionTypeAllFunction = -1,//禁用所有功能
};

typedef NS_ENUM(NSInteger,JJTextContentType) {
    JJTextContentTypeDefalut = 0,//no filter
    JJTextContentTypeASCII,//数字字母
    JJTextContentTypeOnlyNum,//只有数字
    JJTextContentTypeOnlyChinese,//只有中文
    JJTextContentTypeOnlyIntAndFloat, //整形和浮点型
    JJTextContentTypeIDCard //身份证 数字 + "x"
};
@interface JJMultiTextField : UITextField<UITextFieldDelegate>
//defalut is INT_MAX
@property (nonatomic,assign) int maxNumber;
//defalut is JJTextFunctionTypeAllFunction
@property (nonatomic,assign) JJTextFunctionType forbiddenType;
@property (nonatomic,assign) JJTextContentType contentType;

///该参数只在一下两种类型下有效
//JJTextContentTypeOnlyNum,//只有数字
//JJTextContentTypeOnlyIntAndFloat //整形和浮点型
@property (nonatomic,assign) CGFloat maxValue;
//无法存在的单独字符
@property (nonatomic, copy) NSString *singleBanWord;
@property (nonatomic,assign) BOOL isBanZero;
@property (nonatomic, copy) void (^banWordCallback)(NSString *word);
//禁用字符
@property (nonatomic,strong,nullable) NSArray <NSString *>*filterCharactor;
@end

NS_ASSUME_NONNULL_END
