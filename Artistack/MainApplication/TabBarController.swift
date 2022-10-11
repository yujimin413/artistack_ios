//
//  TabBarController.swift
//  Artistack
//
//  Created by 임영준 on 2022/07/20.
//

import UIKit
import CoreMotion
import JJFloatingActionButton



class TabBarController: UITabBarController, UITabBarControllerDelegate {

     let MediaButton = UIButton()
    static let actionButton = JJFloatingActionButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        addFloatingButton()
        tabBar.barTintColor = UIColor(named: "backgroundColor")
        tabBar.isTranslucent = false
    }
    
    
    override func viewDidLayoutSubviews() {
        TabBarController.actionButton.layer.zPosition = 2
        view.bringSubviewToFront(TabBarController.actionButton)
    }
    
    
    func addFloatingButton(){
        TabBarController.actionButton.buttonImage = UIImage(named: "CameraButton")
        TabBarController.actionButton.buttonColor = .clear
        TabBarController.actionButton.buttonImageSize = CGSize(width: 48, height: 44)

        TabBarController.actionButton.addTarget(self, action: #selector(self.addButtonAction(sender:)), for: UIControl.Event.touchUpInside)
            
        
        self.view.addSubview(TabBarController.actionButton)
        TabBarController.actionButton.translatesAutoresizingMaskIntoConstraints = false
            
        NSLayoutConstraint(item: TabBarController.actionButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        TabBarController.actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 5).isActive = true
//            actionButton.layer.zPosition = 999
        }
    

    
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 {
            TabBarController.actionButton.buttonImage = UIImage(named: "firstRecord")
            TabBarController.actionButton.buttonImageSize = CGSize(width: 54, height: 48)
            

        }
        else if item.tag == 0{
            TabBarController.actionButton.buttonImage = UIImage(named: "CameraButton")
            TabBarController.actionButton.buttonImageSize = CGSize(width: 48, height: 44)

        }
    }
    
    

    @objc func addButtonAction(sender: UIButton){
        self.selectedIndex = 700
        
        //IsStackable이 False면 alert메시지를 띄우고 촬영이 안되게끔? OK
        
        TabBarController.actionButton.showAnimation {
            self.checkIfBGMisNil()
            let storyboard = UIStoryboard(name: "Media", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CameraVC") as! RecordingViewController
            let nav = UINavigationController(rootViewController: vc)
            nav.modalTransitionStyle = .crossDissolve //기본은 coverVertical
            nav.modalPresentationStyle = .fullScreen // 풀스크린 만들기 그럼 dismiss 만들어야함
            nav.setNavigationBarHidden(true, animated: false)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    
    func checkIfBGMisNil(){
        guard (RecordingViewController.VideoURL != nil)
        else{
            RecordingViewController.IsStackable = false
            return
        }
    
    
}


}
