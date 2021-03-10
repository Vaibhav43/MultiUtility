//
//  AddNotesViewController.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 07/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class AddNotesViewController: BaseViewController {
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.textColor = .black
            textView.text = ""
            textView.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            textView.set(cornerRadius: .mild, borderWidth: 1, borderColor: UIColor.clear, backgroundColor: UIColor.Notes.kBackground.withAlphaComponent(0.6))
            textView.addShadow(radius: 5, opacity: 0.5)
        }
    }
    @IBOutlet weak var submitButton: UIButton!{
        didSet{
            submitButton.setTitle("Submit", for: .normal)
            submitButton.setTitleColor(UIColor.Notes.kText, for: .normal)
            submitButton.backgroundColor = UIColor.Notes.kElementBackground
            submitButton.cornerRadius = .light
        }
    }
    
    var addNotesViewModal = AddNotesViewModal()
    
    //MARK:- lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Add Notes"
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
