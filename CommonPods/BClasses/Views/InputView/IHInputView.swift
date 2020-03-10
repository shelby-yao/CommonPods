//
//  IHTextInputView.swift
//  BusinessPods
//
//  Created by Shelby on 2019/5/6.
//

import UIKit

open class IHInputView: UIView {
public let titleLabel = UILabel()
public let line = UILabel()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupUI() {
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.text = "姓名"
        titleLabel.font = .systemFont(ofSize: 15)
        titleLabel.textColor = .black
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.snp.makeConstraints { (m) in
            m.top.equalTo(20)
            m.left.equalTo(15)
            m.bottom.equalTo(-20)
            m.height.equalTo(15)
        }
        line.backgroundColor = .black
        addSubview(line)
        line.snp.makeConstraints { (m) in
            m.bottom.equalToSuperview()
            m.height.equalTo(1.0)
            m.right.equalTo(-1)
            m.left.equalTo(15)
        }
    }
    
    open func setupTitle(txt: String) {
//        let temp = NSMutableAttributedString(string: txt, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.kT000814])
//        self.titleLabel.attributedText = temp
    }
    
    open func setupStarTitle(txt: String) {
        self.titleLabel.attributedText = self.attr(str: txt)
    }
    
    private func attr(str: String) -> NSAttributedString? {
//        let attr = NSMutableAttributedString()
//        var temp = NSMutableAttributedString(string: "*", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.kf87f8d])
//        attr.append(temp)
//        temp = NSMutableAttributedString(string: str, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.kT000814])
//        attr.append(temp)
//        return attr
        return nil
    }
}
