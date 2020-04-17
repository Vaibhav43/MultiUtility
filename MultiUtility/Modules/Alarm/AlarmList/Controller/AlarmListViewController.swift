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
        
        alarmListViewModel.reloadTable = { [weak self] in
            self?.tableView.reloadData()
        }
        
//                alarmListViewModel.alarmList.data.addAndNotify(observer: self) { [weak self] (alarmList) in
//                    self?.tableView.reloadData()
//                }
        
//                alarmListViewModel.fetchData()
        alarmListViewModel.fetchResults()
    }
    
    func setHeader(){
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addClicked(_:)))
        self.tabBarController?.navigationItem.rightBarButtonItem = addItem
        self.tabBarController?.navigationItem.title = "List"
    }
    
    //MARK:- Action handling
    
    @IBAction func addClicked(_ sender: UIButton){
        AddAlarmViewController.instance(controller: self)
    }
}

extension AlarmListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            self.alarmListViewModel.alarmList.data.value[indexPath.row].delete()
            self.alarmListViewModel.alarmList.data.value.remove(at: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return alarmListViewModel.fetchedResultController.fetchedObjects?.count ?? 0//alarmListViewModel.alarmList.data.value.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AlarmListTableViewCell.identifier) as? AlarmListTableViewCell, let objects = alarmListViewModel.fetchedResultController.fetchedObjects else {
            return UITableViewCell()
        }
        
        //        let alarm = alarmListViewModel.alarmList.data.value[indexPath.row]
        cell.reminder = objects[indexPath.row] //alarm
        return cell
    }
}


extension AlarmListViewController: AlarmAddedDelegate{
    
    func alarmAdded(_ alarm: Reminder){
        self.alarmListViewModel.alarmList.data.value.append(alarm)
    }
}
