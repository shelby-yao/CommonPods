//
//  IHShadowCell.swift
//  BusinessPods
//
//  Created by Jekin on 2019/1/24.
//

import UIKit
import SnapKit

open class JJShadowCell: UICollectionViewCell {
    public let shadowImageView: UIImageView = UIImageView.init(frame: CGRect.zero)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.insertSubview(shadowImageView, at: 0)
        let orimage = Business.bundleImage(imageName: "bg_bottomframe_")
        let resultImage = Common.clip9Image(image: orimage, insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), model: .stretch)
        shadowImageView.isUserInteractionEnabled = true
        shadowImageView.image = resultImage
        shadowImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
