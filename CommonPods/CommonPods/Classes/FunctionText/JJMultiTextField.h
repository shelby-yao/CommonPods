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
    SMTextFunctionTypeNoneFunction = 0,//默认不禁用
    SMTextFunctionTypePaste = 1 << 1,//禁用粘贴
    SMTextFunctionTypeSelectSignl = 1 << 2 ,//禁用选择
    SMTextFunctionTypeSelectAll = 1 << 3,//禁用全选
    SMTextFunctionTypeAllFunction = -1,//禁用所有功能
};

typedef NS_ENUM(NSInteger,JJTextContentType) {
    SMTextContentTypeDefalut = 0,//no filter
    SMTextContentTypeASCII,//数字字母
    SMTextContentTypeOnlyNum,//只有数字
    SMTextContentTypeOnlyChinese,//只有中文
    SMTextContentTypeOnlyIntAndFloat, //整形和浮点型
    SMTextContentTypeIDCard //身份证 数字 + "x"
};
@interface JJMultiTextField : UITextField<UITextFieldDelegate>
//defalut is INT_MAX
@property (nonatomic,assign) int maxNumber;
//defalut is SMTextFunctionTypeAllFunction
@property (nonatomic,assign) JJTextFunctionType forbiddenType;
@property (nonatomic,assign) JJTextContentType contentType;

///该参数只在一下两种类型下有效
//SMTextContentTypeOnlyNum,//只有数字
//SMTextContentTypeOnlyIntAndFloat //整形和浮点型
@property (nonatomic,assign) CGFloat maxValue;
//无法存在的单独字符
@property (nonatomic, copy) NSString *singleBanWord;
@property (nonatomic,assign) BOOL isBanZero;
@property (nonatomic, copy) void (^banWordCallback)(NSString *word);
//禁用字符
@property (nonatomic,strong,nullable) NSArray <NSString *>*filterCharactor;
@end

NS_ASSUME_NONNULL_END
