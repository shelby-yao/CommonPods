//
//  JJTableViewCell.swift
//  BusinessPods
//
//  Created by Shelby on 2019/10/25.
//

import UIKit

open class JJTableViewCell: UITableViewCell {
    public let line = UILabel()
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        line.backgroundColor = UIColor(fromHexValue: 0xfafafa)
        contentView.addSubview(line)
        line.snp.makeConstraints { (m) in
            m.bottom.equalToSuperview()
            m.height.equalTo(1.0 / UIScreen.screenScale())
            m.left.equalTo(15)
            m.right.equalToSuperview()
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
