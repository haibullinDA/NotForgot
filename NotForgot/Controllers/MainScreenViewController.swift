//
//  MainScreenViewController.swift
//  NotForgot
//
//  Created by Разработчик on 31.03.2021.
//

import UIKit

class MainScreenViewController: UIViewController {
    
   
  
    @IBOutlet weak var placeholderImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var createNewTaskButton: UICustomButton!
    @IBOutlet weak var plusTaskButton: UIButton!
    @IBOutlet weak var viewTopBorder: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    let cellIdentifire = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        setup()
    }
    
    func setup(){
        plusTaskButton.isEnabled = false
        plusTaskButton.isHidden = true
        createNewTaskButton.addTarget(self, action: #selector(createTask(sender:)), for: .touchUpInside)
        loadImage()
    }
    
    @objc func createTask(sender: UICustomButton){
        performSegue(withIdentifier: "newTask", sender: nil)
    }
    
    //Load image
    private func loadImage(){
        guard let imageURL = URL(string: "https://loremflickr.com/g/640/480/holiday") else{
            return
        }
        placeholderImageView.load(url: imageURL)
    }
 
    @IBAction func unwindSegueToMainScreen(segue: UIStoryboardSegue){}
    @IBAction func unwindSegueBackFromShowDetailsTask(segue: UIStoryboardSegue){}
}


//MARK: - UIImageView LoadURL
extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global(qos: .utility).async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}
//MARK: - UITableViewDelegate,UITableViewDataSource
extension MainScreenViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifire) as! UICustomTableViewCell
        return cell
    }
    
    
}
