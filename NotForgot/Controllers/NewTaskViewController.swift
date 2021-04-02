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
    let priorityArray = ["Срочно,важно","Срочно,не важно","Не срочно,важно","Не срочно,не важно"]
    var category = String()
    
    let textField = UITextField()
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    var closePicker = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text = category
        print("\(self.category)")
    }
    
    func setupView(){
        setupTitles()
        closeButton.addTarget(self, action: #selector(closeScreen(sender:)), for: .touchUpInside)
        createDatePicker()
        category = "Hello"
        
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
    
    
    func createPickerView(){
        self.closePicker = UIButton(frame: CGRect(x: CGFloat(5), y: self.tableView.frame.maxY + 10, width: 80, height: 20))
        self.closePicker.setTitle("Done", for: .normal)
        self.closePicker.setTitleColor(.systemBlue, for: .normal)
        self.closePicker.addTarget(self, action: #selector(closePicker(sender:)), for: .touchUpInside)
        self.closePicker.isEnabled = true
        self.closePicker.isHidden = false
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.pickerView.frame = CGRect(x: CGFloat(0), y: self.closePicker.frame.maxY, width: UIScreen.main.bounds.width, height: self.view.frame.height/5)
        self.pickerView.isHidden = false
        self.view.addSubview(closePicker)
        self.view.addSubview(self.pickerView)

    }
    
    @objc func closePicker(sender: UIButton){
        self.closePicker.isEnabled = false
        self.closePicker.isHidden = true
        self.pickerView.isHidden = true
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
    
    @IBAction func unwindSegueBack(segue: UIStoryboardSegue){}
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension NewTaskViewController: UITableViewDelegate,UITableViewDataSource{
    

    
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
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifire)
            cell.textLabel?.text = stringArray[indexPath.row]
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.accessoryType = .disclosureIndicator
            cell.detailTextLabel?.text = category
            cell.detailTextLabel?.textColor = .lightGray
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifire)
            cell.textLabel?.text = stringArray[indexPath.row]
            cell.layer.borderWidth = 0.5
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            performSegue(withIdentifier: "selectCategory", sender: nil)
        }
        if indexPath.row == 2 {
            createPickerView()
        }
    }
    
}


extension NewTaskViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorityArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(60)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return priorityArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.detailTextLabel?.text = priorityArray[row]
    }
}

