//
//  AddNotesViewController.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 07/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class AddNotesViewController: BaseViewController {
    
    @IBOutlet weak var titleTextfield: VBVTextfield!{
        didSet{
            titleTextfield.insetX = 5
            titleTextfield.set(cornerRadius: .light, borderWidth: 1, borderColor: .lightGray, backgroundColor: .clear)
            titleTextfield.vbvdelegate = self
            titleTextfield.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            titleTextfield.textColor = .black
            titleTextfield.placeholder = "Enter title here"
        }
    }
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
            textView.vbvDelegate = self
            textView.placeHolderColor = UIColor.darkGray
            textView.placeHolder = "Enter the notes here"
            textView.textColor = .black
            textView.text = ""
            textView.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        }
    }
//    @IBOutlet weak var submitButton: UIButton!{
//        didSet{
//            submitButton.setTitle("Submit", for: .normal)
//            submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//            submitButton.setTitleColor(UIColor.Notes.kText, for: .normal)
//            submitButton.backgroundColor = UIColor.Notes.kElementBackground
//            submitButton.cornerRadius = .light
//        }
//    }
    
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
    
    class func instance(navigation: UINavigationController, notes: Notes){
        
        let vc = AddNotesViewController()
        vc.addNotesViewModal.notes = notes
        navigation.pushViewController(vc, animated: true)
    }
    
    class var instance: AddNotesViewController{
        
        let vc = AddNotesViewController()
        vc.addNotesViewModal.notes = nil
        return vc
    }
    
    //MARK:- Setup
    
    func setProperties(){
        self.view.backgroundColor = UIColor.Notes.kViewBG
        
        addNotesViewModal.reloadUI = {
            self.setUI()
        }
        
        addNotesViewModal.setColor()
    }
    
    func setHeader(){
        
        let isUpdate = !(addNotesViewModal.notes?.updated_time == nil)
        let rightBarButtonItem = UIBarButtonItem(title: isUpdate ? "Update" : "Save", style: UIBarButtonItem.Style.done, target: self, action: #selector(submitClicked(_:)))
        
        if isUpdate{
            self.navigationItem.title = "Add Notes"
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        else{
            self.tabBarController?.navigationItem.title = "Add Notes"
            self.tabBarController?.navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        
        initiateKeyboard(onView: scrollView)
    }
    
    func setUI(){
        
        titleTextfield.text = addNotesViewModal.notes?.title
        textView.text = addNotesViewModal.notes?.notes
        textView.set(cornerRadius: .none, borderWidth: 2, borderColor: addNotesViewModal.selectedBackgroundColor, backgroundColor: addNotesViewModal.selectedBackgroundColor.withAlphaComponent(0.6))
        collectionView.reloadData()
    }
    
    //MARK:- Action
    
    @IBAction func submitClicked(_ sender: UIButton){
        hideKeyboard()
        guard !textView.text.isEmpty || (titleTextfield.text?.isEmpty ?? true) else {
            return
        }
        
        addNotesViewModal.saveNotes()
        self.tabBarController?.selectedIndex = 0
    }
}

extension AddNotesViewController: VBVTextfieldDelegate, VBVTextViewDelegate{
    
    func textfieldDidEndEditing(_ textField: VBVTextfield) {
        addNotesViewModal.notes?.title = textField.text
    }
    
    func textViewDidEndEditing(_ textView: VBVTextView) {
        addNotesViewModal.notes?.notes = textView.text
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
        
        let data = addNotesViewModal.colorArray[indexPath.row]
        cell.containerView.backgroundColor = data.0
        cell.isSelected = data.1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        addNotesViewModal.selectedBackgroundColor = addNotesViewModal.colorArray[indexPath.row].0
    }
}
