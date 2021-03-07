//
//  AlarmListViewController.swift
//  Alarm
//
//  Created by apple on 12/04/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import CoreData

class AlarmListViewController: UIViewController {
    
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
        alarmListViewModel.fetchResults()
        alarmListViewModel.fetchedResultController.delegate = self
    }
    
    func setHeader(){
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClicked(_:)))
        self.tabBarController?.navigationItem.rightBarButtonItem = addItem
        self.tabBarController?.navigationItem.title = "List"
    }
    
    //MARK:- Action handling
    
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
        let reminder = alarmListViewModel.fetchedResultController.fetchedObjects?[indexPath.row]
        addAlarm(reminder: reminder)
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
