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
    
    var collectionView = UICollectionView()
    
    func initCollectionView(){
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.collectionView.backgroundColor = .black
        self.view.addSubview(self.collectionView)
    }
    
    func createConstraintForCollectionView(){
        NSLayoutConstraint(item: self.collectionView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self.viewTopBorder,
                           attribute: .topMargin,
                           multiplier: 1,
                           constant: 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        plusTaskButton.isEnabled = false
        plusTaskButton.isHidden = true
        createNewTaskButton.addTarget(self, action: #selector(createTask(sender:)), for: .touchUpInside)
        loadImage()
    }
    
    @objc func createTask(sender: UICustomButton){
        
    }
    
    private func loadImage(){
        guard let imageURL = URL(string: "https://loremflickr.com/g/640/480/holiday") else{
            return
        }
        placeholderImageView.load(url: imageURL)
    }
 

}

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

extension MainScreenViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}
