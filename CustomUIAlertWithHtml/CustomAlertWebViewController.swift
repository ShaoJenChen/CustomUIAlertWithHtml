//
//  CustomAlertController.swift
//  CustomAlerts
//
//  Created by ShaoJen Chen on 2020/8/20.
//  Copyright © 2020 ShaoJen Chen. All rights reserved.
//

import UIKit
import WebKit

struct ButtonPayload {
    
    var title: String!
    
    var titleColor: UIColor?
    
    var backgroundColor: UIColor?
    
    var action: ((Bool) -> Void)?
    
}

struct AlertPayload {
    
    var title: String!
    
    var titleColor: UIColor?
    
    var backgroundColor: UIColor?
    
    var buttonPayload: ButtonPayload
    
    var completion: (() -> Void)?
    
}

class CustomAlertWebViewController: UIViewController {
    
//    @IBOutlet weak var alertTitle: UILabel!
    
    @IBOutlet weak var alertButton: UIButton!
    
    @IBOutlet weak var checkButton: CheckedButton!
    
    var alertPayload: AlertPayload!
    
    let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 270, height: 287))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = Bundle.main.url(forResource: "supported_products", withExtension: "html") else { return }
        
        let request = URLRequest(url: url)
        
        self.view.addSubview(self.webView)
        
        self.webView.load(request)
        
        self.webView.scrollView.bounces = false
        
        self.view.backgroundColor = self.alertPayload.backgroundColor
        
//        self.alertTitle.text = self.alertPayload.title
        
//        self.alertTitle.textColor = self.alertPayload.titleColor
        
        self.alertButton.setTitle(self.alertPayload.buttonPayload.title, for: .normal)
        
        if let titleColor = self.alertPayload.buttonPayload.titleColor {
            self.alertButton.setTitleColor(titleColor, for: .normal)
        }
        
        if let backGroundColor = self.alertPayload.buttonPayload.backgroundColor {
            self.alertButton.backgroundColor = backGroundColor
        }
        
    }
    
    @IBAction func buttonTapped() {
        
        self.alertPayload.buttonPayload.action?(self.checkButton.checked)
        
        self.dismiss(animated: false, completion: self.alertPayload.completion)
        
    }
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        self.checkButton.tapped()
    }
}

@IBDesignable
class CheckedButton: UIButton {
    
    // MARK: - Properties
    @IBInspectable var checked: Bool = false {
        didSet {
            // Toggle the check/uncheck images
            updateImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setup()
    }
    
    internal func setup() {
        self.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }
    
    private func updateImage() {
        let bundle = Bundle(for: CheckedButton.self)
        let image = checked ? UIImage(named: "ic_checkBox", in: bundle, compatibleWith:nil) : UIImage(named: "ic_unCheckBox", in: bundle, compatibleWith:nil)
        self.setBackgroundImage(image, for: .normal)
    }
    
    /// Called each time the button is tapped, and toggles the checked property
    @objc fileprivate func tapped() {
        checked.toggle()
        print("New value: \(checked)")
    }
}

extension UIAlertController {
    
    static func showCustomAlertWebView(payload: AlertPayload, parentViewController: UIViewController) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let customAlertWebViewController = storyboard.instantiateViewController(withIdentifier: "CustomAlertWebview") as! CustomAlertWebViewController
                
        customAlertWebViewController.alertPayload = payload
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alertController.setValue(customAlertWebViewController, forKey: "contentViewController")
        
        parentViewController.present(alertController, animated: true, completion: nil)
    }
    
}
