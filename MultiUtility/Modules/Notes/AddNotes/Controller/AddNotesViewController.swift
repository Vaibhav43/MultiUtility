//
//  AddNotesViewController.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 07/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class AddNotesViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var collectionView: VBVCollectionView!{
        didSet{
            collectionView.backgroundColor = .clear
            collectionView.register(types: [ColorCollectionViewCell.self])
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    @IBOutlet weak var textView: VBVTextView!{
        didSet{
            textView.placeHolderColor = UIColor.darkGray
            textView.placeHolder = "Enter the notes here"
            textView.textColor = .black
            textView.text = ""
            textView.font = UIFont.systemFont(ofSize: 14, weight: .medium)
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
        setProperties()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setHeader()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //MARK:- Instance
    
    class func instance(navigation: UINavigationController){
        
        let vc = AddNotesViewController()
        navigation.pushViewController(vc, animated: true)
    }
    
    //MARK:- Setup
    
    func setProperties(){
        self.view.backgroundColor = UIColor.Notes.kViewBG
        setUI()
        
        addNotesViewModal.reloadUI = {
            self.setUI()
        }
    }
    
    func setHeader(){
        self.tabBarController?.navigationItem.title = "Add Notes"
    }
    
    func setUI(){
        
        textView.set(cornerRadius: .none, borderWidth: 2, borderColor: addNotesViewModal.selectedBackgroundColor, backgroundColor: addNotesViewModal.selectedBackgroundColor.withAlphaComponent(0.6))
    }
    
    //MARK:- Action
    
    @IBAction func submitClicked(_ sender: UIButton){
        
        guard !textView.text.isEmpty else {
            return
        }
        
        
    }
}

extension AddNotesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addNotesViewModal.colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as? ColorCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.containerView.backgroundColor = addNotesViewModal.colorArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        addNotesViewModal.selectedBackgroundColor = addNotesViewModal.colorArray[indexPath.row]
        
    }
}
