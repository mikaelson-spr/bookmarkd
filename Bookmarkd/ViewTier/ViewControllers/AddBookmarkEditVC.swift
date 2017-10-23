//
//  AddBookmarkEditVC.swift
//  Bookmarkd
//
//  Created by Mikael Son on 10/4/17.
//  Copyright © 2017 SPR. All rights reserved.
//

import UIKit

public protocol AddBookmarkEditVCDelegate: class {
    func updateContext(with context: String)
}

class AddBookmarkEditVC: UIViewController, UITextViewDelegate {

    var context: String = ""
    var delegate: AddBookmarkEditVCDelegate?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonInit()
    }

    // MARK: - Helper Functions
    
    private func commonInit() {
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.borderColor = UIColor.lightGray.cgColor
        self.containerView.layer.borderWidth = 1
        self.editTextView.textColor = UIColor.darkGray
        self.editTextView.tintColor = UIColor(red: 105/255, green: 182/255, blue: 116/255, alpha: 1)
        self.editTextView.delegate = self
        
        if self.context == "Empty" {
            self.editTextView.text = ""
        } else {
            self.editTextView.text = self.context
        }
    }

    // MARK: - UITextViewDelegate Function
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.delegate?.updateContext(with: textView.text)
        return true
    }
}
