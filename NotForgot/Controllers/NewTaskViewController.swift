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
    let stringArray = ["Срок выполнения задачи","Категория задачи","Приоритет"]
    
    let textField = UITextField()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func setupView(){
        setupTitles()
        closeButton.addTarget(self, action: #selector(closeScreen(sender:)), for: .touchUpInside)
        createDatePicker()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifire)
        tableView.separatorStyle = .none
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
    
    func createToolbar() -> UIToolbar{
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed(sender:)))
        
        toolBar.setItems([doneButton], animated: true)
        
        return toolBar
    }
    
    func createDatePicker(){
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        textField.inputView = datePicker
        textField.inputAccessoryView = createToolbar()
    }
    
    @objc func donePressed(sender: UIBarButtonItem){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.textField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
}

//MARK: -
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
            let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifire)
            cell.textLabel?.text = stringArray[indexPath.row]
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.lightGray.cgColor
            textField.frame = CGRect(x: cell.frame.width-20, y: cell.frame.minY + 5, width: cell.frame.width/3, height: cell.contentView.frame.height)
            textField.textColor = .lightGray
            cell.contentView.addSubview(textField)
            return cell
        case 1:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifire)
            cell.textLabel?.text = stringArray[indexPath.row]
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.accessoryType = .disclosureIndicator
            return cell
        case 2:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifire)
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

    }
    
    
}
