//
//  IHTimingButton.swift
//  InternetHospital
//
//  Created by Jekin on 2019/1/16.
//  Copyright © 2019 ZhuJiangChilink. All rights reserved.
//

import UIKit


public class JJTimingButton: UIButton {
    public var countDownTime: UInt8 = 10
    private var countDownTimer: DispatchSourceTimer?
    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if self.countDownTimer == nil||newWindow != nil {
            return
        }
//        self.countDownTimer?.cancel()
//        self.countDownTimer = nil
    }
    
    //发送中
    public func sending() {
        self.isEnabled = false
        self.isUserInteractionEnabled = false
        self.setTitle("发送中...", for: UIControl.State.normal)
    }
    //发送失败
    public func sendFail() {
        self.isEnabled = false
        self.isUserInteractionEnabled = false
        self.setTitle("发送失败", for: UIControl.State.normal)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            self.isEnabled = true
            self.isUserInteractionEnabled = true
            self.setTitle("重新发送", for: UIControl.State.normal)
        }
    }
    //开始计时
    
    public func startTime() {
        if self.countDownTimer != nil {
            self.countDownTimer!.cancel()
        }
        var time = self.countDownTime
        self.isEnabled = false
        self.isUserInteractionEnabled = false
        self.setTitle("已发送", for: UIControl.State.normal)
        countDownTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        countDownTimer!.schedule(deadline: DispatchTime.now(), repeating: .milliseconds(1000))
        countDownTimer!.setEventHandler( handler: {
            time -= 1
            if time <= 0 {
                self.countDownTimer!.cancel()
                DispatchQueue.main.async {
                    self.isEnabled = true
                    self.isUserInteractionEnabled = true
                    self.setTitle("重新发送", for: UIControl.State.normal)
                }
            } else {
                let seconds = time % 60
                DispatchQueue.main.async {
                    self.setTitle("\(seconds)s", for: UIControl.State.normal)
                }
               
            }
            
        })
        countDownTimer!.resume()
    }
    
    public func startTime(sec: Int) {
        self.countDownTime = UInt8(sec)
        self.startTime()
    }
    

}
