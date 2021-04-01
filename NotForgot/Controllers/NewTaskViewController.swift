//
//  NewTaskViewController.swift
//  NotForgot
//
//  Created by Разработчик on 01.04.2021.
//

import UIKit

class NewTaskViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifire = "cellID"
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var buttonCloseInPicker: UIButton!
    @IBOutlet weak var buttonOkInPicker: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTitles()
        closeButton.addTarget(self, action: #selector(closeScreen(sender:)), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifire)
        tableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    @objc func closeScreen(sender: UIButton){
            performSegue(withIdentifier: "toMainScreen", sender: nil)
    }
    
    func setupTitles(){
        titleTextView.layer.borderWidth = 0.5
        titleTextView.layer.borderColor = UIColor.lightGray.cgColor
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: descriptionTextView.frame.height - 1, width: descriptionTextView.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.addSublayer(bottomLine)
    }
    let stringArray = ["Срок выполнения задачи","Категория задачи","Приоритет"]
}


extension NewTaskViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifire)
            cell.textLabel?.text = stringArray[indexPath.row]
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.detailTextLabel?.text = "Sep 17, 2018"
            cell.detailTextLabel?.textColor = .lightGray
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath)
            cell.textLabel?.text = stringArray[indexPath.row]
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.accessoryType = .disclosureIndicator
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath)
            cell.textLabel?.text = stringArray[indexPath.row]
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.datePickerView.isHidden = true
            self.buttonCloseInPicker.isEnabled = true
            self.buttonOkInPicker.isEnabled = true
            self.buttonCloseInPicker.addTarget(self, action: #selector(closePicker(sender:)), for: .touchUpInside)
            //self.buttonOkInPicker.addTarget(self, action: #selector(okPicker(sender:)), for: .touchUpInside)
        }
    }
    
    func pickerSetup(){
        self.datePickerView.isHidden = false
        self.buttonCloseInPicker.isEnabled = false
        self.buttonOkInPicker.isEnabled = false
        
    }
    
    func addTatgetInPicker(){
        
    }
    
    @objc func closePicker(sender: UIButton){
        pickerSetup()
    }
    /*
    @objc func okPicker(sender: Any?){
        pickerSetup()
        if let indexPath = sender as? IndexPath{
            tableView.cellForRow(at: indexPath)?.detailTextLabel?.text = String(self.datePicker.
            
        }
        
    }*/
}
