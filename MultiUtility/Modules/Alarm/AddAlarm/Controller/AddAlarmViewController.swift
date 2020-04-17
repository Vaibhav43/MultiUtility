//
//  AddAlarmViewController.swift
//  Alarm
//
//  Created by Vaibhav Agarwal on 14/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class AddAlarmViewController: VBVViewController {
    
    @IBOutlet weak var tableView: VBVTableView!{
        didSet{
            tableView.register(types: [AlarmNameTableViewCell.self])
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var addAlarmViewModel = AddAlarmViewModel()
    
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
    
    //MARK:- instance
    
    class func instance(controller: UIViewController){
        AddAlarmViewController.initFromNib.present()
    }
    
    //MARK:- setup
    
    func setHeader(){
        
        self.navigationItem.title = "Add Alarm"
        
        let saveItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveClicked))
        self.navigationItem.rightBarButtonItem = saveItem
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backPressed))
        self.navigationItem.leftBarButtonItem = cancelItem
    }
    
    func setProperties(){
        addAlarmViewModel.initialize()
        addAlarmViewModel.reloadTable = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    //MARK:- Actions
    
    @objc func saveClicked(){
        addAlarmViewModel.saveAlarm()
        backPressed()
    }
}

extension AddAlarmViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addAlarmViewModel.cellArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return textfieldCell(indexPath: indexPath)
    }
    
    func textfieldCell(indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmNameTableViewCell.identifier) as! AlarmNameTableViewCell
        let data = addAlarmViewModel.cellArray[indexPath.row]
        cell.setData(heading: data.0, placeHolder: data.1)
        cell.textField.vbvdelegate = self
        setValues(fromCell: true, indexPath: indexPath, text: nil, textfield: cell.textField)
        return cell
    }
}

extension AddAlarmViewController: VBVTextfieldDelegate{
    
    func textfieldShouldBeginEditing(_ textField: VBVTextfield) -> Bool {
        guard let indexPath = IndexPath.of(textField, objectView: tableView) else {return true}
        
        if indexPath.row == 2{
            self.addAlarmViewModel.showPicker()
            return false
        }
        else if indexPath.row == 3{
            self.addAlarmViewModel.showDate()
            return false
        }
        
        return true
    }
    
    func textfieldDidEndEditing(_ textField: VBVTextfield) {
        guard let text = textField.text, !text.isEmpty, let indexPath = IndexPath.of(textField, objectView: tableView) else {return}
        setValues(fromCell: false, indexPath: indexPath, text: text, textfield: textField)
    }
    
    func setValues(fromCell: Bool, indexPath: IndexPath, text: String?, textfield: VBVTextfield){
        
        switch indexPath.row {
            
        case 0:
            (fromCell) ? (textfield.text = addAlarmViewModel.alarm.title) : (addAlarmViewModel.alarm.title = text)
            
        case 1:
            (fromCell) ? (textfield.text = addAlarmViewModel.alarm.message) : (addAlarmViewModel.alarm.message = text)
            
        case 2:
            (textfield.text = addAlarmViewModel.alarm.task)
            
        case 3:
            (textfield.text = addAlarmViewModel.alarm.reminder_time?.toString(format: .dateTimeDotA))
            
        default:
            break
        }
    }
}
