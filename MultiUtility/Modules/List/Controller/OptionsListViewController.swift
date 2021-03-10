//
//  OptionsListViewController.swift
//  MultiUtility
//
//  Created by Vaibhav Agarwal on 07/03/21.
//  Copyright © 2021 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class OptionsListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    
    var optionsListViewModal = OptionsListViewModal()

    //MARK:- lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "All Options"
    }

    //MARK:- instance
    
    //MARK:- Setup
}

extension OptionsListViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsListViewModal.optionsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = optionsListViewModal.optionsArray[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "optionsCell")
        cell.textLabel?.text = data.rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = optionsListViewModal.optionsArray[indexPath.row]
        
        switch data {
        
        case .alarm:
            AlarmTabViewController.instance(navigation: self.navigationController!)
            
        case .notes:
            NotesTabViewController.instance(navigation: self.navigationController!)
        }
    }
}
