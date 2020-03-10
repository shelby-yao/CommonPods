//
//  TMSuperViewController.swift
//  BusinessPods
//
//  Created by Shelby on 2019/8/22.
//

import UIKit

open class JJSuperViewController: UIViewController {

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        bindUI2()
        request3()
    }
    
    @objc dynamic open func setupUI() {}
    @objc dynamic open func bindUI2() {}
    @objc dynamic open func request3() {}
    
}
