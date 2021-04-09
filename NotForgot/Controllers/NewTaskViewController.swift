//
//  NewTaskViewController.swift
//  NotForgot
//
//  Created by Разработчик on 01.04.2021.
//

import UIKit
import Loaf

class NewTaskViewController: UIViewController {

   
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellIdentifire = "cellID"
    let stringArray = ["Срок выполнения задачи","Категория задачи","Приоритет"]
    var priorityArray = [GetAllPrioritiesResponce]()
    var category = GetAllCategoriesResponce()
    var priority = GetAllPrioritiesResponce()
    var date = Int()
    
    var task = GetAllTasksResponce()
    var segue = String()
    var segueCategory = String()
    
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
        updateView()
    }
    
    func server(){
        WorkWithServer.getAllPrioritiesRequest { [weak self] priorities in
            guard let self = self else{ return }
            DispatchQueue.main.async {
                self.priorityArray = priorities
            }
        }
    }
    
    func setupView(){
        server()
        
        setupTitles()
        
        closeButton.addTarget(self, action: #selector(closeScreen(sender:)), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(actionSaveTask(sender:)), for: .touchUpInside)
        createDatePicker()
        
        dismissKeyboard()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifire)
        tableView.separatorStyle = .none
    }
    
    func updateView(){
        switch segue {
        case "newTask":
            if category.name == String(){
                self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text = "Category"
            }else{
                self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text = category.name
            }
        case "editTask":
            titleTextView.text = task.title
            descriptionTextView.text = task.description
            textField.text = convertDate(unix: task.deadline)
            self.tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.detailTextLabel?.text = task.priority.name
            self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text = task.category.name
        default:
            Loaf("Ошибка", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
        }
        if segueCategory == "back"{
            self.tableView.cellForRow(at: IndexPath(row: 1, section: 0))?.detailTextLabel?.text = category.name
        }
        if segueCategory == "back" && (priority.name.isEmpty == false) {
            self.tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.detailTextLabel?.text = priority.name
        }
    }
    
    func convertDate(unix: Int) -> String{
        let date = NSDate(timeIntervalSince1970: TimeInterval(unix))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date as Date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSave"{
            if let vc = segue.destination as? ShowDetailsTaskViewController{
                vc.categoryLabel.text = category.name
                vc.deadlineLabel.text = textField.text
                vc.descriptionTextView.text = descriptionTextView.text
                vc.priorityLabel.text = priority.name
                vc.priorityLabel.backgroundColor = UIColor(hexString: priority.color)
                vc.titleLabel.text = titleTextView.text
            }
        }
    }
    
    //MARK: - @objc methods
    @objc func donePressed(sender: UIBarButtonItem){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.textField.text = dateFormatter.string(from: datePicker.date)
        date = Int(self.datePicker.date.timeIntervalSince1970)
        self.view.endEditing(true)
    }
    
    @objc func closePicker(sender: UIButton){
        self.closePicker.isEnabled = false
        self.closePicker.isHidden = true
        self.pickerView.isHidden = true
    }
    
    @objc func actionSaveTask(sender: UIButton){
        guard let title = self.titleTextView.text else {
            return
        }
        guard let description = self.descriptionTextView.text else {
            return
        }
        switch segue {
        case "newTask":
            self.saveTask(title: title, description: description, done: 0, deadline: date, category_id: category.id, priority_id: priority.id)
        case "editTask":
            self.editTask(title: title, description: description, done: 0, deadline: date, category_id: category.id, priority_id: priority.id)
        default:
            Loaf("Ошибка", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
        }
        
    }
    
    @objc func closeScreen(sender: UIButton){
        switch segue {
        
        case "newTask":
            let alertController = UIAlertController(title: "Сохранить задачу?", message: nil, preferredStyle: .alert)
            let actionClose = UIAlertAction(title: "Нет", style: .cancel) { (actionClose) in
                self.performSegue(withIdentifier: "toMainScreen", sender: nil)
            }
            let actionSave = UIAlertAction(title: "Сохранить", style: .default) { (actionSave) in
                guard let title = self.titleTextView.text else {
                    return
                }
                guard let description = self.descriptionTextView.text else {
                    return
                }
                self.saveTask(title: title, description: description, done: 0, deadline: self.date, category_id: self.category.id, priority_id: self.priority.id)
            }
            alertController.addAction(actionClose)
            alertController.addAction(actionSave)
            present(alertController, animated: true, completion: nil)
        
        case "editTask":
            let alertController = UIAlertController(title: "Сохранить задачу?", message: nil, preferredStyle: .alert)
            let actionClose = UIAlertAction(title: "Нет", style: .cancel) { (actionClose) in
                self.performSegue(withIdentifier: "editSave", sender: nil)
            }
            let actionSave = UIAlertAction(title: "Сохранить", style: .default) { (actionSave) in
                guard let title = self.titleTextView.text else {
                    return
                }
                guard let description = self.descriptionTextView.text else {
                    return
                }
                self.editTask(title: title, description: description, done: 0, deadline: self.date, category_id: self.category.id, priority_id: self.priority.id)
            }
            alertController.addAction(actionClose)
            alertController.addAction(actionSave)
            present(alertController, animated: true, completion: nil)
        
        default:
            Loaf("Ошибка", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
        }
    }
    
    func editTask(title: String,description: String,done: Int,deadline: Int,category_id: Int,priority_id:Int){
        if self.priority.name.isEmpty || self.category.name.isEmpty || self.titleTextView.text.isEmpty || self.descriptionTextView.text.isEmpty{
            let alertController = UIAlertController(title: "Предупреждение", message: "Не все поля заполнены", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }else{
            WorkWithServer.taskUpdating(id: self.task.id, title: title, description: description, done: done, deadline: deadline, category_id: category_id, priority_id: priority_id) { [weak self] flag in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if flag{
                        Loaf("Дело обновлено", state: .success, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
                        self.performSegue(withIdentifier: "editSave", sender: nil)
                    }else{
                        Loaf("Ошибка обновления, повторите попытку", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
                    }
                }
            }
        }
    }
    
    func saveTask(title: String,description: String,done: Int,deadline: Int,category_id: Int,priority_id:Int){
        if self.priority.name.isEmpty || self.category.name.isEmpty || self.titleTextView.text.isEmpty || self.descriptionTextView.text.isEmpty{
            let alertController = UIAlertController(title: "Предупреждение", message: "Не все поля заполнены", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(action)
            self.present(alertController, animated: true, completion: nil)
        }else{
            WorkWithServer.newTaskRequest(title: title, description: description, done: done, deadline: deadline, category_id: category_id, priority_id: priority_id) { [weak self] flag in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if flag{
                        Loaf("Дело сохранено", state: .success, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
                        self.performSegue(withIdentifier: "toMainScreen", sender: nil)
                    }else{
                        Loaf("Ошибка сохранения, повторите попытку", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
                    }
                }
            }
        }
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
            cell.detailTextLabel?.text = category.name
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
        return priorityArray[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.detailTextLabel?.text = priorityArray[row].name
        self.priority = priorityArray[row]
    }
}


