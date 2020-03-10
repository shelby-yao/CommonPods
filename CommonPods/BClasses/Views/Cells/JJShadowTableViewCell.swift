//
//  JJRecipeListCell.swift
//  RecipeModule
//
//  Created by Shelby on 2019/4/23.
//

import UIKit

open class JJShadowTableViewCell: UITableViewCell {
public let shadowImageView: UIImageView = UIImageView.init(frame: CGRect.zero)
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupShadow()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupShadow() {
        self.contentView.insertSubview(shadowImageView, at: 0)
        let orimage = Business.bundleImage(imageName: "bg_bottomframe_")
        let resultImage = Common.clip9Image(image: orimage, insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), model: .stretch)
        shadowImageView.isUserInteractionEnabled = true
        shadowImageView.image = resultImage
        shadowImageView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview().offset(UIEdgeInsetsMake(15, 15, 0, 15))
            make.top.equalToSuperview().offset(15)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
        }
    }
    

}
