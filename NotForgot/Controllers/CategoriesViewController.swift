//
//  CategoriesViewController.swift
//  NotForgot
//
//  Created by Разработчик on 02.04.2021.
//

import UIKit

class CategoriesViewController: UIViewController {

    
    
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifire = "cellID"
    var categoryArray = ["Учеба","Работа","Отдых"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    

    
    func setupView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifire)
        tableView.separatorStyle = .none
        
        addTargetForButton()
    }
    
    func addTargetForButton(){
        addCategoryButton.addTarget(self, action: #selector(showAlert(sender:)), for: .touchUpInside)
    }
    
    @objc func showAlert(sender: UIButton){
        let alertController = UIAlertController(title: "Добавить категорию задачи", message: "Название должно кратко отражать суть категории", preferredStyle: .alert)
        let actionClose = UIAlertAction(title: "Закрыть", style: .cancel) { (actionClose) in
            
        }
        
        let actionSave = UIAlertAction(title: "Сохранить", style: .default) { (actionSave) in
            let text = alertController.textFields?.first
            if let temp = text?.text{
                self.tableView.performBatchUpdates({
                    self.categoryArray.append(temp)
                    self.tableView.insertRows(at: [IndexPath(row: self.categoryArray.endIndex - 1, section: 0)], with: .automatic)
                }, completion: nil)
            }
        }
        
        alertController.addTextField { (textField) in
            textField.layer.borderWidth = CGFloat(1)
            textField.layer.borderColor = UIColor.lightGray.cgColor
        }
        alertController.addAction(actionClose)
        alertController.addAction(actionSave)
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back"{
            if let vc = segue.destination as? NewTaskViewController{
                if let text = sender as? String{
                    vc.category = text
                }
            }
        }
    }
}


//MARK: - UITableViewDelegate,UITableViewDataSource

extension CategoriesViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: cellIdentifire)
        cell.textLabel?.text = categoryArray[indexPath.row]
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "back", sender: categoryArray[indexPath.row])
    }
    
}
