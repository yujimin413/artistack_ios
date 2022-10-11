//
//  BeforeStackViewController.swift
//  Practice_Artistack
//
//  Created by 임영준 on 2022/07/30.
//

import UIKit

class BeforeStackViewController: UIViewController {

    @IBOutlet weak var stackTableView: UITableView!
    @IBOutlet weak var dismissButton: UIButton!
    
    //var stackCnt = 4
    static var projectId: Int = Int()
    static var beforeStackTable: [EachStack?] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        callBeforeStack()
        print("callBeforeStack 함수 결과 beforeStackTable 확인 : ", BeforeStackViewController.beforeStackTable)
        setupTableView()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func callBeforeStack(){
        HomeDataManager().stackInfoManager(projectId: BeforeStackViewController.projectId, sequence: "prev", query: "true", completion: {
            [weak self] res in
            print("stackInfoManager 결과 한 번 보자 : ", res)
            BeforeStackViewController.beforeStackTable = res
            self?.stackTableView.reloadData()
            //BeforeStackViewController().stackTableView.reloadData()
        })
    }

    func setupTableView(){
        stackTableView.layer.backgroundColor = UIColor.clear.cgColor
        stackTableView.backgroundColor = .clear
        stackTableView.translatesAutoresizingMaskIntoConstraints = false // auto layout 가능하게
        //self.stackTableView.rowHeight = UITableView.automaticDimension
        //self.tableView.estimatedRowHeight = 85
        //stackTableView.sizeToFit()
        //setupTableSize()
        
        /*
        HomeDataManager().stackInfoManager(projectId: projectId, sequence: "prev", completion: {
            [weak self] res in
            self?.beforeStackTable = res
            self?.stackTableView.reloadData()
        })
         */
        
        stackTableView.register(UINib(nibName: "BeforeStackTableViewCell", bundle: nil), forCellReuseIdentifier: "beforeCell")
        stackTableView.showsVerticalScrollIndicator = false
        stackTableView.delegate = self
        stackTableView.dataSource = self
        //self.stackTableView.sizeToFit()
    }
    
    /*
    func setupTableSize(){
        if stackCnt
    }
    */
 
    @IBAction func dismissButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}



extension BeforeStackViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BeforeStackViewController.beforeStackTable.count // 추후 self.dataSource.count 로 변경
    }
        

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beforeCell", for: indexPath) as! BeforeStackTableViewCell
        if indexPath.row == 0 {
            cell.line.isHidden = true
        } else {
            cell.line.isHidden = false
        }
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = UIColor.clear

        //cell.profileImage.load(url: URL(string: (beforeStackTable[indexPath.row]?.profileImgUrl)!)!)
        cell.profileImage.setImage(with: BeforeStackViewController.beforeStackTable[indexPath.row]?.profileImgUrl ?? nil)
        cell.nicknameLbl.text = BeforeStackViewController.beforeStackTable[indexPath.row]?.nickname
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 // size 이게 맞아요
    }
    /*
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "OneProjectVC")
        vc.modalPresentationStyle = .pageSheet
        self.present(vc, animated: true, completion: {
            //let projectViewController = OneProjectViewController.self
            //projectViewController.likeCountLbl.text = "22"
            //projectViewController.stackCountLbl.text = "37"
        })
        //self.present(, animated: true)
    }
}

