//
//  IHShadowCustomView.swift
//  BusinessPods
//
//  Created by Shelby on 2019/5/8.
//

import UIKit

open class IHShadowCustomView: UIView {
public let shadowImageView: UIImageView = UIImageView.init(frame: CGRect.zero)
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupShadow()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupShadow() {
        self.insertSubview(shadowImageView, at: 0)
        let orimage = Business.bundleImage(imageName: "bg_bottomframe_")
        let resultImage = Common.clip9Image(image: orimage, insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), model: .stretch)
        shadowImageView.isUserInteractionEnabled = true
        shadowImageView.image = resultImage
        shadowImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
    }

}
