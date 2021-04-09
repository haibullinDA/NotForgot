//
//  MainScreenViewController.swift
//  NotForgot
//
//  Created by Разработчик on 31.03.2021.
//

import UIKit
import Alamofire
import Loaf

class MainScreenViewController: UIViewController {
    
   
  
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var createNewTaskButton: UICustomButton!
    @IBOutlet weak var plusTaskButton: UIButton!
    @IBOutlet weak var viewTopBorder: UIView!
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!

    let cellIdentifire = "cell"
    var tasks = [GetAllTasksResponce]()
    var tasks2 = [[GetAllTasksResponce]]()
    var numberOfSection = [String]()
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.server()
        checkTable()
    }
    
    func server(){
        WorkWithServer.getAllTasksResponce { [weak self] tasks in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tasks = tasks
                self.createTaskForTable()
                self.checkTable()
            }
        }
    }
    
    func createTaskForTable(){
        let numberSection = calculateNumberOfSection()
        for i in 0..<numberSection{
            self.tasks2.append([GetAllTasksResponce]())
            for task in self.tasks{
                if task.category.name == self.numberOfSection[i]{
                    self.tasks2[i].append(task)
                }
            }
        }
    }
    
    func checkTable(){
        if self.tasks.isEmpty == false {
            self.showTableView()
        }else{
            self.hiddenTableView()
        }
    }
    
    func hiddenTableView(){
        self.plusTaskButton.isEnabled = false
        self.plusTaskButton.isHidden = true
        self.tableView.isHidden = true
        self.createNewTaskButton.isEnabled = true
        self.createNewTaskButton.isHidden = false
        self.welcomeLabel.isHidden = false
        self.placeholderImageView.isHidden = false
    }
    
    func showTableView(){
        self.plusTaskButton.isEnabled = true
        self.plusTaskButton.isHidden = false
        self.tableView.isHidden = false
        self.createNewTaskButton.isEnabled = false
        self.createNewTaskButton.isHidden = true
        self.welcomeLabel.isHidden = true
        self.placeholderImageView.isHidden = true
        self.tableView.reloadData()
    }
    
    func setup(){
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTable(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.isHidden = true
        tableView.register(UINib(nibName: "UICustomTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifire)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        plusTaskButton.isEnabled = false
        plusTaskButton.isHidden = true
        
        createNewTaskButton.addTarget(self, action: #selector(createTask(sender:)), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(exitMain(sender:)), for: .touchUpInside)
        plusTaskButton.addTarget(self, action: #selector(createTask(sender:)), for: .touchUpInside)
        
        loadImage()
    }
    
    @objc func refreshTable(sender: UIRefreshControl){
        if self.tasks.isEmpty{
            self.hiddenTableView()
            self.refreshControl.endRefreshing()
        }else{
            self.server()
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc func exitMain(sender: UIButton){
        UserDefaults.standard.removeObject(forKey: WorkWithServer.key)
        performSegue(withIdentifier: "exit", sender: nil)
    }
    
    @objc func createTask(sender: UICustomButton){
        let segue = "newTask"
        performSegue(withIdentifier: segue, sender: segue)
    }
    
    private func loadImage(){
        guard let imageURL = URL(string: "https://loremflickr.com/g/640/480/holiday") else{
            return
        }
        placeholderImageView.load(url: imageURL)
    }
 
    func calculateNumberOfSection() -> Int{
        if numberOfSection.isEmpty == false{
            numberOfSection.removeAll()
        }
        for task in self.tasks {
            var counter = 0
            for number in self.numberOfSection{
                if task.category.name == number{
                    counter += 1
                }
            }
            if counter == 0{
                self.numberOfSection.append(task.category.name)
            }
        }
        return numberOfSection.count
    }
    
    func calculateNumberOfRowInSection() -> [Int]{
        var arrayOfRowInSection = [Int]()
        for _ in numberOfSection{
            arrayOfRowInSection.append(0)
        }
        for task in self.tasks{
            for section in 0..<self.numberOfSection.count{
                if task.category.name == self.numberOfSection[section]{
                    arrayOfRowInSection[section] += 1
                }
            }
        }
        return arrayOfRowInSection
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "detailsTask":
            if let vc = segue.destination as? ShowDetailsTaskViewController{
                if let task = sender as? GetAllTasksResponce{
                    vc.task = task
                }
            }
        case "newTask":
            if let vc = segue.destination as? NewTaskViewController{
                if let text = sender as? String{
                    vc.segue = text
                }
            }
        default: break
        }
    }
    
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue){}
    @IBAction func unwindSegueBackFromShowDetailsTask(segue: UIStoryboardSegue){}
}

//MARK: - UITableViewDelegate,UITableViewDataSource
extension MainScreenViewController: UITableViewDelegate,UITableViewDataSource{
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        
        view.backgroundColor = UICustomTableViewCell().backgroundColor
        let titlelabel = UILabel(frame: CGRect(x: view.frame.minX + 30, y: view.frame.minY, width: view.frame.width/2, height: view.frame.height))
        titlelabel.text = self.numberOfSection[section]
        titlelabel.font = UIFont(name: "Nunito-Bold", size: CGFloat(35))
        titlelabel.textColor = .black
        view.addSubview(titlelabel)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.calculateNumberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = self.calculateNumberOfRowInSection()
        return array[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UICustomTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath) as! UICustomTableViewCell
        
        cell.body.backgroundColor = UIColor(hexString: self.tasks2[indexPath.section][indexPath.row].priority.color)
        cell.titleLabel.text = self.tasks2[indexPath.section][indexPath.row].title
        cell.subtitleLabel.text = self.tasks2[indexPath.section][indexPath.row].description

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            WorkWithServer.removeTask(id: self.tasks2[indexPath.section][indexPath.row].id) { [weak self] flag in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if flag{
                        Loaf("Задача удалена", state: .success, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
                    }else{
                        Loaf("Ошибка удаления", state: .error, location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self).show()
                    }
                }
            }
            self.server()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detailsTask", sender: self.tasks2[indexPath.section][indexPath.row])
    }

}
