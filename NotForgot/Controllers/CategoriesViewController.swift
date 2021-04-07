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
    var categoryArray = [GetAllCategoriesResponce]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WorkWithServer.getAllCategoriesResponce { [weak self] categories in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.categoryArray = categories
                self.tableView.reloadData()
            }
        }
        
        setupView()
    }
    

    
    func setupView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifire)
        tableView.separatorStyle = .none
        
        dismissKeyboard()
        
        addTargetForButton()
    }
    
    func addTargetForButton(){
        addCategoryButton.addTarget(self, action: #selector(showAlert(sender:)), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeCategory(sender:)), for: .touchUpInside)
    }
    
    @objc func closeCategory(sender: UIButton){
        performSegue(withIdentifier: "back", sender: nil)
    }
    
    @objc func showAlert(sender: UIButton){
        let alertController = UIAlertController(title: "Добавить категорию задачи", message: "Название должно кратко отражать суть категории", preferredStyle: .alert)
        let actionClose = UIAlertAction(title: "Закрыть", style: .cancel) { (actionClose) in
            
        }
        
        let actionSave = UIAlertAction(title: "Сохранить", style: .default) { (actionSave) in
            let text = alertController.textFields?.first
            if let temp = text?.text{
                WorkWithServer.newCategoryRequest(name: temp) { [weak self] object in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        print("Im here")
                        self.categoryArray.append(object)
                        self.tableView.reloadData()
                    }
                }
                
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
    //MARK: - исправить as
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "back"{
            if let vc = segue.destination as? NewTaskViewController{
                if let category = sender as? GetAllCategoriesResponce{
                    vc.category = category
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire, for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "back", sender: categoryArray[indexPath.row])
    }
    
}
