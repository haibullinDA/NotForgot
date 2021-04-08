//
//  ShowDetailsTaskViewController.swift
//  NotForgot
//
//  Created by Разработчик on 05.04.2021.
//

import UIKit

class ShowDetailsTaskViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    var task = GetAllTasksResponce()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editButton.addTarget(self, action: #selector(editTask(sender:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setup()
    }
    func setup(){
        titleLabel.text = task.title
        categoryLabel.text = task.category.name
        descriptionTextView.text = task.description
        switch task.done {
        case 1:
            statusLabel.text = "Выполнено"
            statusLabel.textColor = .systemGreen
        case 0:
            statusLabel.text = "Не выполнено"
            statusLabel.textColor = .systemPink
        default:
            print("error")
        }
        
        deadlineLabel.text = convertDate(unix: task.deadline)
        priorityLabel.text = task.priority.name
        priorityLabel.textColor = .white
        priorityLabel.backgroundColor = UIColor(hexString: task.priority.color)
    }
   
    func convertDate(unix: Int) -> String{
        let date = NSDate(timeIntervalSince1970: TimeInterval(unix))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        return dateFormatter.string(from: date as Date)
    }

    @objc func editTask(sender: UIButton){
        performSegue(withIdentifier: "editTask", sender: self.task)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTask"{
            if let vc = segue.destination as? NewTaskViewController{
                if let task = sender as? GetAllTasksResponce{
                    vc.task = task
                }
            }
        }
    }
    
    @IBAction func unwindEditTask(segue: UIStoryboardSegue){}
}
