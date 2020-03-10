//
//  JJExchange.swift
//  CommonPods
//
//  Created by Shelby on 2019/3/28.
//

import UIKit

/// 阿拉伯数字转中文数字
open class JJExchange: NSObject {
    
    // 数字转中文
   public class func number2Chinese(num: Int) -> String {
        // 中文数字节权位
        let chineseSectionPosition = ["", "万", "亿", "万亿", "亿亿", "万亿亿", "亿亿亿"]
        
        var numInt = num
        if numInt == 0 {
            return "零"
        }
        
        // 节权位标识
        var sectionPosition = 0
        // 输出的中文字符串
        var endChineseNum = ""
        // 每个小节转换的字符串
        var sectionChineseNum = ""
        
        // 将数字从右至左, 每隔4位, 分成一小节, 再分别对每小节处理
        while numInt > 0 {
            let section = numInt % 10000
            sectionChineseNum = eachSection(num: section) //将当前小节转为中文
            if sectionPosition >= chineseSectionPosition.count {
                return "数字太大"
            }
            if section != 0 { // 当前小节不为0, 添加节权
                sectionChineseNum += chineseSectionPosition[sectionPosition]
            }
            
            //去掉已经转换的末尾四位数
            numInt = numInt / 10000
            endChineseNum = sectionChineseNum + endChineseNum
            sectionPosition += 1
        }
        
        if endChineseNum.mySubString(to: 1) == "零" {
            endChineseNum = endChineseNum.mySubString(from: 1)
        }
        
        while endChineseNum.mySubString(from: endChineseNum.count-1) == "零" {
            endChineseNum = endChineseNum.mySubString(to: endChineseNum.count-1)
        }
        return endChineseNum
        
    }
    
    // 中文转数字
   public class func chinese2Number(chinese: String) -> Int {
        
        var chineseNum = chinese
        // 保存数字
        var number = 0
        // 保存亿节权部分, 第一四位
        var yiStr = ""
        // 保存万节权部分, 第二四位
        var wanStr = ""
        // 保存""节权部分, 第三四位
        var kongStr = ""
        // 记录节权位置
        var k = 0
        // 记录该节权部分是否被处理
        var isDeal = true
        
        // 去除字符串中的"零"
        for (index, value) in chineseNum.enumerated() {
            if value == "零" {
                chineseNum = chineseNum.mySubString(to: index) + chineseNum.mySubString(from: index + 1)
            }
        }
        
        // 各部分节权处理, 将中文以小节为单位截取存入不同的字符串中
        for (index, value) in chineseNum.enumerated() {
            if value == "亿" {  // 截取亿的位置
                yiStr = chineseNum.mySubString(to: index)
                k = index + 1  // 亿后的一位
                isDeal = false
            }
            if value == "万" {
                // 截取 万 前面的字符
                wanStr = chineseNum.mySubString(fromIndex: k, toIndex: index)
                // 截取 万 后面的字符
                kongStr = chineseNum.mySubString(from: index + 1)
                isDeal = false
            }
        }
        
        if isDeal {  // 该数小于万
            kongStr = chineseNum
        }
        
        // 将中文转换为数字
        number = eachSection(chinese: yiStr) * 100000000 + eachSection(chinese: wanStr) * 10000 + eachSection(chinese: kongStr)
        
        return number
    }
}

extension JJExchange {
    
    // 一个小节中, 数字转中文
    class func eachSection(num: Int) -> String {
        var intNum = num
        let chineseNumberArr = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
        let chinesePositionArr = ["", "十", "百", "千"]
        
        // 输出的小节中文
        var chineseNum = ""
        // 每小节内部只能有一个中文"零"
        var isZero = false
        for index in 0..<4 {
            // 获取末尾值(取出个位)
            let end = intNum % 10
            // 判断该数字是否为0, 若不是0, 就直接拼接权位, 若是0, 则判断是否已经出现过中文"零"
            if end == 0 {
                if !isZero { // 上一位数不为0, 执行补0
                    isZero = true
                    chineseNum = chineseNumberArr[0] + chineseNum
                }
            } else {
                isZero = false
                chineseNum = chineseNumberArr[end] + chinesePositionArr[index] + chineseNum  // 数字 + 权位
            }
            intNum = intNum / 10; // 去除原来的个位
        }
        return chineseNum
    }
    
    // 一个小节中, 中文转数字
    class func eachSection(chinese: String) -> Int {
        var dataDic = [String: Int]()
        let chineseArr = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
        for (index, value) in chineseArr.enumerated() {
            dataDic[value] = index
        }
        // 权位
        dataDic["十"] = 10
        dataDic["百"] = 100
        dataDic["千"] = 1000
        
        // 输出的数字
        var resultInt = 0
        // 每一个数字
        var num = 0
        for (index, char) in chinese.enumerated() {
            let value = dataDic[String(char)] ?? 0
            
            // 判断是否为权位
            if value == 10 || value == 100 || value == 1000 {
                resultInt += num * value
            } else if index == chinese.count - 1 { // 判断是否为最后一位
                resultInt += value
                
            } else {  // 不是个位
                num = value
            }
        }
        return resultInt
    }
    
}
extension String {
    func mySubString(to index: Int) -> String {
        return String(self[..<self.index(self.startIndex, offsetBy: index)])
    }
    
    func mySubString(fromIndex: Int, toIndex: Int) -> String {
        
        let start = self.index(self.startIndex, offsetBy: fromIndex)
        let end = self.index(self.startIndex, offsetBy: toIndex)
        return String(self[start..<end])
    }
    func mySubString(from index: Int) -> String {
        //        fromIndex: k, toIndex: index)
        
        return String(self[self.index(self.startIndex, offsetBy: index)...])
    }
}
