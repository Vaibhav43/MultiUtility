//
//  AddNotesViewController.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 07/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class AddNotesViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.text = ""
            textView.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            textView.set(cornerRadius: .mild, borderWidth: 1, borderColor: UIColor.Notes.background, backgroundColor: UIColor.Notes.background)
        }
    }
    @IBOutlet weak var submitButton: UIButton!{
        didSet{
            submitButton.setTitle("Submit", for: .normal)
            submitButton.backgroundColor = UIColor.Notes.ktheme
            submitButton.cornerRadius = .light
        }
    }
    
    var addNotesViewModal = AddNotesViewModal()
    
    //MARK:- lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Notes.background
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
