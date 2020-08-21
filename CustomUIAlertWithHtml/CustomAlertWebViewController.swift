//
//  CustomAlertController.swift
//  CustomAlerts
//
//  Created by ShaoJen Chen on 2020/8/20.
//  Copyright © 2020 ShaoJen Chen. All rights reserved.
//

import UIKit

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
    
    @IBOutlet weak var alertTitle: UILabel!
    
    @IBOutlet weak var alertButton: UIButton!
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var checkButton: CheckedButton!
    
    var alertPayload: AlertPayload!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = Bundle.main.url(forResource: "supported_products", withExtension: "html") else { return }
        
        let request = URLRequest(url: url)
        
        self.webView.loadRequest(request)
        
        self.webView.scrollView.bounces = false
        
        self.view.backgroundColor = alertPayload.backgroundColor
        
        self.alertTitle.text = alertPayload.title
        
        self.alertTitle.textColor = alertPayload.titleColor
        
        self.alertButton.setTitle(self.alertPayload.buttonPayload.title, for: .normal)
        
        if let titleColor = self.alertPayload.buttonPayload.titleColor {
            self.alertButton.setTitleColor(titleColor, for: .normal)
        }
        
        if let backGroundColor = self.alertPayload.buttonPayload.backgroundColor {
            self.alertButton.backgroundColor = backGroundColor
        }
        
    }
    
    @IBAction func buttonTapped() {
        
        alertPayload.buttonPayload.action?(self.checkButton.checked)
        
        self.dismiss(animated: false, completion: alertPayload.completion)
        
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
        checked = !checked
        print("New value: \(checked)")
    }
}
