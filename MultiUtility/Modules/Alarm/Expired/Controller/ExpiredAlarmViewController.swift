//
//  ExpiredAlarmViewController.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 07/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import UIKit
import CoreData

class ExpiredAlarmViewController: VBVBaseViewController {
    
    @IBOutlet weak var tableView: VBVTableView!{
        didSet{
            tableView.register(types: [AlarmListTableViewCell.self])
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var expiredAlarmViewModal = ExpiredAlarmViewModal()

    //MARK:- lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProperties()
        // Do any additional setup after loading the view.
    }

    //MARK:- Instance
    
    class func instance(navigation: UINavigationController){
        
        let vc = ExpiredAlarmViewController()
        navigation.pushViewController(vc, animated: true)
    }
    
    //MARK:- Setup
    
    func setProperties(){
        expiredAlarmViewModal.fetchResults()
        expiredAlarmViewModal.fetchedResultController.delegate = self
    }
}

extension ExpiredAlarmViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (editingStyle == .delete) {
            expiredAlarmViewModal.showDeletePopUp(index: indexPath.row)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return expiredAlarmViewModal.fetchedResultController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sections = expiredAlarmViewModal.fetchedResultController.sections else {return nil}
        return sections[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = expiredAlarmViewModal.fetchedResultController.sections else {return 0}
        return sections[section].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmListTableViewCell.identifier) as? AlarmListTableViewCell, let sections = expiredAlarmViewModal.fetchedResultController.sections, let object = sections[indexPath.section].objects?[indexPath.row] as? Reminder else {
            return UITableViewCell()
        }
        
        cell.reminder = object
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let sections = expiredAlarmViewModal.fetchedResultController.sections, let object = sections[indexPath.section].objects?[indexPath.row] as? Reminder else {
            return
        }
        addAlarm(reminder: object)
    }
    
    func addAlarm(reminder: Reminder?){
        AddAlarmViewController.instance(controller: self, context: expiredAlarmViewModal.managedContext, reminder: reminder)
    }
}

extension ExpiredAlarmViewController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch (type) {
            
        case .delete:
            
            if let indexPath = indexPath, indexPath.row != 0 {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            else{
                tableView.reloadData()
            }
            
        case .update, .move:
            tableView.reloadData()
            
        default:
            break
        }
    }
}
