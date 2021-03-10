//
//  NotesListViewController.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 10/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController {
    
    @IBOutlet weak var tableView: VBVTableView!{
        didSet{
            tableView.register(types: [NotesListTableViewCell.self])
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var notesListViewModel = NotesListViewModel()

    //MARK:- lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setClosure()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setHeader()
    }
    
    //MARK:- setup
    
    func setHeader(){
        self.tabBarController?.navigationItem.title = "List"
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    func setClosure(){
        
        notesListViewModel.recordsFetched = {
            self.tableView.reloadData()
        }
        
        notesListViewModel.fetchResults()
    }
}

extension NotesListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return notesListViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesListViewModel.numberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NotesListTableViewCell.identifier) as? NotesListTableViewCell else {
            return UITableViewCell()
        }
        
        if let sections = notesListViewModel.fetchedResultController.sections, let objects = sections[indexPath.section].objects, let data = objects[indexPath.row] as? Notes{
            cell.notes = data
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let sections = notesListViewModel.fetchedResultController.sections, let objects = sections[indexPath.section].objects, let data = objects[indexPath.row] as? Notes else { return }
            
        AddNotesViewController.instance(navigation: self.navigationController!, notes: data)
    }
}


extension NotesListViewController: NSFetchedResultsControllerDelegate{
    
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
