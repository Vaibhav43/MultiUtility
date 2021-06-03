//
//  AlarmListViewController.swift
//  Alarm
//
//  Created by apple on 12/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import CoreData

class AlarmListViewController: VBVBaseViewController {
    
    @IBOutlet weak var noRecordLabel: UILabel!{
        didSet{
            noRecordLabel.textAlignment = .center
            noRecordLabel.numberOfLines = 0
            noRecordLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            noRecordLabel.textColor = UIColor.Alarm.ktheme
            noRecordLabel.text = "Please click on + to add."
            noRecordLabel.isHidden = true
        }
    }
    @IBOutlet weak var tableView: VBVTableView!{
        didSet{
            tableView.register(types: [AlarmListTableViewCell.self])
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var alarmListViewModel = AlarmListViewModel()
    
    //MARK:- lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setHeader()
    }
    
    //MARK:- Setup
    
    func setProperties(){
        alarmListViewModel.recordsFetched = { [weak self] in
            self?.noRecordLabel.isHidden = !(self?.alarmListViewModel.fetchedResultController.sections?.isEmpty ?? false)
        }
        
        alarmListViewModel.fetchResults()
        alarmListViewModel.fetchedResultController.delegate = self
    }
    
    func setHeader(){
        
        var rightItemsArray = [UIBarButtonItem]()
        
        if alarmListViewModel.expired_count > 0{
            let expiredItem = UIBarButtonItem(title: "Expired", style: .plain, target: self, action: #selector(expiredClicked(_:)))
            rightItemsArray.append(expiredItem)
        }
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClicked(_:)))
        rightItemsArray.append(addItem)
        
        if tabBarController == nil{
            self.navigationItem.rightBarButtonItems = rightItemsArray
            self.navigationItem.title = "Alarm List"
        }
        else{
            self.tabBarController?.navigationItem.rightBarButtonItems = rightItemsArray
            self.tabBarController?.navigationItem.title = "Alarm List"
        }
    }
    
    //MARK:- Action handling
    
    @IBAction func expiredClicked(_ sender: UIButton){
        ExpiredAlarmViewController.instance(navigation: self.navigationController!)
    }
    
    @IBAction func addClicked(_ sender: UIButton){
        addAlarm(reminder: nil)
    }
    
    func addAlarm(reminder: Reminder?){
        AddAlarmViewController.instance(controller: self, context: alarmListViewModel.managedContext, reminder: reminder)
    }
}

extension AlarmListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            self.alarmListViewModel.showDeletePopUp(index: indexPath.row)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return alarmListViewModel.fetchedResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sections = alarmListViewModel.fetchedResultController.sections else {return nil}
        return sections[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = alarmListViewModel.fetchedResultController.sections else {return 0}
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmListTableViewCell.identifier) as? AlarmListTableViewCell, let sections = alarmListViewModel.fetchedResultController.sections, let object = sections[indexPath.section].objects?[indexPath.row] as? Reminder else {
            return UITableViewCell()
        }
        
        cell.reminder = object
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let sections = alarmListViewModel.fetchedResultController.sections, let object = sections[indexPath.section].objects?[indexPath.row] as? Reminder else {
            return
        }
        addAlarm(reminder: object)
    }
}

extension AlarmListViewController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
        
        case .insert:
            
            if let indexPath = newIndexPath, indexPath.section != 0, indexPath.row != 0 {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            else{
                tableView.reloadData()
            }
            
        case .delete:
            
            if let indexPath = indexPath, indexPath.row != 0 {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            else{
                tableView.reloadData()
            }
            
        case .update, .move:
            
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            
        default:
            break
        }
    }
}
