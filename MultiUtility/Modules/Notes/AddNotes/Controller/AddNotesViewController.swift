//
//  AddNotesViewController.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 07/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class AddNotesViewController: BaseViewController {
    
    @IBOutlet weak var textView: VBVTextView!{
        didSet{
            textView.placeHolder = "Enter the notes here"
            textView.showPlaceHolder = true
            textView.textColor = .black
            textView.text = ""
            textView.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            textView.set(cornerRadius: .none, borderWidth: 2, borderColor: UIColor.Notes.kBackground, backgroundColor: UIColor.Notes.kBackground.withAlphaComponent(0.6))
        }
    }
    @IBOutlet weak var submitButton: UIButton!{
        didSet{
            submitButton.setTitle("Submit", for: .normal)
            submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            submitButton.setTitleColor(UIColor.Notes.kText, for: .normal)
            submitButton.backgroundColor = UIColor.Notes.kElementBackground
            submitButton.cornerRadius = .light
        }
    }
    
    var addNotesViewModal = AddNotesViewModal()
    
    //MARK:- lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(hex: "f5f5f5")//.withAlphaComponent(0.6)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Add Notes"
        self.initiateKeyboard(buttonView: submitButton)
    }

    //MARK:- Instance
    
    class func instance(navigation: UINavigationController){
        
        let vc = AddNotesViewController()
        navigation.pushViewController(vc, animated: true)
    }
    
    //MARK:- Setup
    
    //MARK:- Action
    
    @IBAction func submitClicked(_ sender: UIButton){
        
    }
}
