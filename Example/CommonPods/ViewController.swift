//
//  ViewController.swift
//  CommonPods
//
//  Created by shelby-yao on 01/16/2019.
//  Copyright (c) 2019 shelby-yao. All rights reserved.
//

import UIKit
import CommonPods

//import CommonCrypto
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Common()
//        let view = IHTipsTextView(frame: CGRect(x: 0, y: 400, width: 300, height: 200), limitCount: 150, normalColor: .black, warmingColor: .green)
//        view.backgroundColor = .lightGray
//        self.view.addSubview(view)

        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func loadLocalFile(_ sender: Any) {

//        guard let pdfFilePath = Bundle.main.path(forResource: "git搭建", ofType: "pdf") else { return }
//        PDFReaderManage.shareInstance.openURL(SourceType.local(url: pdfFilePath), openType: OpenType.present(self))
    }
    @IBAction func loadRemoteFile(_ sender: Any) {
//        let url = "http://www.gov.cn/zhengce/pdfFile/2018_PDF.pdf"
//        PDFReaderManage.shareInstance.openURL(.netWork(url: url), openType: .present(self))
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
