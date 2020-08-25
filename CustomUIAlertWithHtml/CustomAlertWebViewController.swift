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
    
    var webView: WKWebView!
        
    var indicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = Bundle.main.url(forResource: "supported_products", withExtension: "html") else { return }
                
        let webViewCofig = WKWebViewConfiguration()
        
        webViewCofig.dataDetectorTypes = []
        
        self.webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 270, height: 287), configuration: webViewCofig)
        
        self.webView.navigationDelegate = self
        
        self.webView.loadFileURL(url, allowingReadAccessTo: url)
        
        self.webView.scrollView.bounces = false
        
        self.view.addSubview(self.webView)
        
        self.indicator = UIActivityIndicatorView(style: .gray)
        
        self.indicator?.startAnimating()
        
        self.webView.addSubview(self.indicator!)
        
        self.indicator!.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.indicator!.centerXAnchor.constraint(equalTo: self.webView.centerXAnchor),
            self.indicator!.centerYAnchor.constraint(equalTo: self.webView.centerYAnchor)
        ])
        
        self.view.backgroundColor = self.alertPayload.backgroundColor
        
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

extension CustomAlertWebViewController: WKNavigationDelegate {
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        self.indicator?.stopAnimating()
    }
    
}
