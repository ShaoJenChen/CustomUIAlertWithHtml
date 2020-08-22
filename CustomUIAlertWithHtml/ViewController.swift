//
//  ViewController.swift
//  CustomUIAlertWithHtml
//
//  Created by ShaoJen Chen on 2020/8/21.
//  Copyright © 2020 ShaoJen Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func WebViewAlertTap() {
        
        let ok_button = ButtonPayload(title: "OK",
                                      titleColor: .systemBlue,
                                      backgroundColor: .white,
                                      action: { (isChecked) in
                                        print("isChecked \(isChecked)")
                                        
        })
        
        
        let alertPayload = AlertPayload(title: nil,
                                        titleColor: nil,
                                        backgroundColor: .white,
                                        buttonPayload: ok_button,
                                        completion: {
                                            print("completion")
        })
        
        UIAlertController.showCustomAlertWebView(payload: alertPayload, parentViewController: self)
    }
    
}
