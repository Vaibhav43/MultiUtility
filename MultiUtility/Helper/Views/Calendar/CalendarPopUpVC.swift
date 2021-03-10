//
//  ViewController.swift
//  CalendarDemo
//
//  Created by Vaibhav Agarwal on 22/11/18.
//  Copyright © 2018 Vaibhav Agarwal. All rights reserved.
//

import UIKit

class CalendarPopUpVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var previousButton: UIButton!{
        didSet{
            previousButton.setTitle("<", for: .normal)
        }
    }
    @IBOutlet weak var nextButton: UIButton!{
        didSet{
            nextButton.setTitle(">", for: .normal)
        }
    }
    
    static var calendarPopVC: CalendarPopUpVC?
    
    /// calendar variables
    lazy var months: [(String, Int)] = [("January", 31), ("February", 28), ("March", 31), ("April", 30), ("May", 31), ("June", 30), ("July", 31), ("August", 31), ("September", 30), ("October", 31), ("November", 30), ("December", 31)]
    
    
    var showFuture: Bool = true
    var showPast: Bool = true
    
    lazy var currentMonthIndex: Int = -1
    lazy var currentYear: Int = 0
    
    lazy var presentMonthIndex = 0
    lazy var presentYear = 0
    
    lazy var todaysDate = 0
    lazy var firstWeekDayOfMonth = 0
    
    lazy var selectedDate = ""
    lazy var addedDates = [String]()
    var completion: ((Date?) -> Void)?
    var tapGesture: UITapGestureRecognizer?
    
    var firstWeekDay: Int {
        
        let day = DateComponents(calendar: Calendar.current, year: currentYear, month: currentMonthIndex, day: 1).date?.firstDayOfTheMonth.weekNumber
        return day ?? 1
    }
    
    //MARK:- lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setProperties()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tapGesture = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextButton.set(cornerRadius: .rounded, borderWidth: 1.0, borderColor: .black, backgroundColor: .white)
        previousButton.set(cornerRadius: .rounded, borderWidth: 1.0, borderColor: .black, backgroundColor: .white)
    }
    
    //MARK:- instance handling
    
    class func instance(selectedDate: String, future: Bool = true, past: Bool = true, completion: ((Date?) -> Void)?){
        
        calendarPopVC = CalendarPopUpVC.init(nibName: "CalendarPopUp", bundle: nil)
        calendarPopVC?.completion = completion
        calendarPopVC?.view.frame = UIScreen.main.bounds
        calendarPopVC?.selectedDate = selectedDate
        calendarPopVC?.showFuture = future
        calendarPopVC?.showPast = past
        calendarPopVC?.calendarView.transform = CGAffineTransform(scaleX: 0, y: 0)
        if let window = AppDelegate.instance.window{
            window.addSubview((calendarPopVC?.view)!)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            calendarPopVC?.calendarView.transform = .identity
        }, completion: nil)
    }
    
    //MARK:- setup
    
    func setProperties(){
        
        //        if let date = Date.change(first: selectedDate, fFormat: .dayMonthNameDash, resultFormat: .monthName){
        //            selectedDate = date
        //        }
        
        calendarView.layer.cornerRadius = 6
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeView))
        tapGesture?.delegate = self
        self.view.addGestureRecognizer(tapGesture!)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        currentMonthIndex = Date().monthNumber-1
        currentYear = Date().year.toInt
        todaysDate = Date().dayNumber
        firstWeekDayOfMonth = firstWeekDay
        
        setDate()
        setLeapYearMonths(monthIndex: currentMonthIndex)
        
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
        showhideNextButton()
        
        collectionView.register(UINib(nibName: "DateCVCell", bundle: nil), forCellWithReuseIdentifier: "DateCVCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func showhideNextButton(){
        
        if !showFuture{
            nextButton.isHidden = (currentMonthIndex == presentMonthIndex && currentYear == presentYear)
        }
        
        if !showPast{
            previousButton.isHidden = (presentMonthIndex == currentMonthIndex && presentYear == currentYear )
        }
    }
    
    func setDate(){
        
        if currentMonthIndex < 12{
            let month = months[currentMonthIndex]
            label.text = "\(month.0) \(currentYear)"
        }
    }
    
    func setLeapYearMonths(monthIndex: Int){
        //for leap year, make february month of 29 days
        if monthIndex == 1 {
            
            if currentYear % 4 == 0 {
                months[monthIndex].1 = 29
            } else {
                months[monthIndex].1 = 28
            }
        }
    }
    
    func setMonthYear(monthIndex: Int, year: Int){
        
        currentMonthIndex=monthIndex
        currentYear = year
        showhideNextButton()
        
        setLeapYearMonths(monthIndex: monthIndex)
        firstWeekDayOfMonth = firstWeekDay
        
        collectionView.reloadData()
        setDate()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
    //MARK:- button handling
    @IBAction func nextBtn(_ sender: UIButton){
        
        currentMonthIndex += 1
        if currentMonthIndex > 11 {
            currentMonthIndex = 0
            currentYear += 1
        }
        
        setMonthYear(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    @IBAction func previousButton(_ sender: UIButton){
        currentMonthIndex -= 1
        if currentMonthIndex < 0 {
            currentMonthIndex = 11
            currentYear -= 1
        }
        
        setMonthYear(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    //MARK:- collection view functions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42//numOfDaysInMonth[currentMonthIndex] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width/7 - 5
        let height: CGFloat = 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCVCell", for: indexPath) as! DateCVCell
        cell.isUserInteractionEnabled = false
        cell.dateFilled(filled: false)
        cell.dateSelected(selected: false)
        cell.dateLabel.textColor = UIColor.lightGray
        
        var calcDate = 0
        
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            
            let numberOfDaysInLastMonth = months[currentMonthIndex].1
            calcDate = numberOfDaysInLastMonth-firstWeekDayOfMonth+indexPath.row+2
        }
        else if indexPath.row > (months[currentMonthIndex].1 + firstWeekDayOfMonth - 2){
            calcDate = indexPath.row - (months[currentMonthIndex].1 + firstWeekDayOfMonth - 2)
        }
        else {
            
            calcDate = indexPath.row-firstWeekDayOfMonth+2
            
            if !(presentMonthIndex == currentMonthIndex && presentYear == currentYear && ((calcDate > todaysDate && !showFuture) || (calcDate < todaysDate && !showPast))){
                cell.isUserInteractionEnabled = true
                cell.dateLabel.textColor = .black
                cell.dateFilled(filled: getCount(index: indexPath.row))
                cell.dateSelected(selected: selectedDate == getDate(index: indexPath.row))
            }
        }
        
        cell.dateLabel.text="\(calcDate)"
        return cell
    }
    
    func getDate(index: Int) -> String{
        
        let day = index - firstWeekDayOfMonth + 2
        var dayStr = ""
        var monthStr = ""
        var date = ""
        
        if day < 10{
            dayStr = "0\(day)"
        }
        else{
            dayStr = "\(day)"
        }
        
        if currentMonthIndex < 10{
            monthStr = "0\(currentMonthIndex+1)"
        }
        else{
            monthStr = "\(currentMonthIndex+1)"
        }
        date = "\(dayStr)-\(monthStr)-\(currentYear)"
        return date
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let date = getDate(index: indexPath.row)
        let convertedDate = Date.change(date: date, format: DateFormat.dayMonthNameDash)
        completion?(convertedDate)
        remove()
    }
    
    func getCount(index: Int) -> Bool{
        
        let date = getDate(index: index)
        return addedDates.contains(date)
    }
    
    @objc func removeView(){
        self.completion?(nil)
        remove()
    }
    
    func remove(){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.calendarView.alpha = 0.0
        }) { (done) in
            self.view.removeFromSuperview()
            CalendarPopUpVC.calendarPopVC = nil
        }
    }
}
