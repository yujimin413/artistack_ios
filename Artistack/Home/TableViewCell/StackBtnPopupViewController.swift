//
//  StackBtnPopupViewController.swift
//  Practice_Artistack
//
//  Created by csh on 2022/08/01.
//

import UIKit
import Kingfisher

class StackBtnPopupViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var stackPopupCollectionView: UICollectionView!
    @IBOutlet weak var emptyStackerView: UIView!
    
    @IBOutlet weak var stackClickedBtn: UIButton!
    @IBOutlet weak var personImgView: UIImageView!
    @IBOutlet weak var instrumentImgView: UIImageView!
    @IBOutlet weak var nicknameLbl: UILabel!
    @IBOutlet weak var rootProfileView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackCountLbl: UILabel!
    
    static var projectId: Int = Int()
    static var itemCnt: Int = Int()
    var collectionTable: [EachStack?] = []
    //var positionY = CGFloat()
    static var rootProfileImage: String?
    static var rootInstImage: String = String()
    static var rootNickname: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillCollectionTable()
        backgroundView.alpha = 0.8
        print("[StackBtnPopupController] StackBtnPopupViewController.itemCnt : ", StackBtnPopupViewController.itemCnt)
        stackCountLbl.text = String(StackBtnPopupViewController.itemCnt)

        if StackBtnPopupViewController.itemCnt > 0 {
            emptyStackerView.isHidden = true
            stackPopupCollectionView.isHidden = false
            //rootProfileView.frame.origin.y = positionY
            setupCollectionView()
        } else {
            emptyStackerView.isHidden = false
            stackPopupCollectionView.isHidden = true }
        
        print("[StackBtnPopupViewController] rootProfileImage : ", StackBtnPopupViewController.rootProfileImage)
        self.personImgView.setImage(with: StackBtnPopupViewController.rootProfileImage)
        self.instrumentImgView.setImage(with: StackBtnPopupViewController.rootInstImage)
        self.nicknameLbl.text = StackBtnPopupViewController.rootNickname
        self.personImgView.addDiamondMask()
    }

    func fillCollectionTable(){
        HomeDataManager().stackInfoManager(projectId: StackBtnPopupViewController.projectId, sequence: "next", query: "false", completion:{
            [weak self] res in
            print("stackInfoManager [next]의 출력 결과 : ", res)
            self?.collectionTable = res
            self?.stackPopupCollectionView.reloadData()
        })
    }
                                           
    
    func setupCollectionView() {
        stackPopupCollectionView.delegate = self
        stackPopupCollectionView.dataSource = self
        stackPopupCollectionView.showsHorizontalScrollIndicator = false
        stackPopupCollectionView.layer.backgroundColor = UIColor.clear.cgColor
        stackPopupCollectionView.backgroundColor = .clear
        
        let storyNib = UINib(nibName: "StackerCollectionViewCell", bundle: nil)
        stackPopupCollectionView.register(storyNib, forCellWithReuseIdentifier: "StackerCollectionViewCell")
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top:0, left:0, bottom:0, right: 1)
        //flowLayout.minimumLineSpacing = 12
    
        stackPopupCollectionView.collectionViewLayout = flowLayout
        stackPopupCollectionView.reloadData() // 재부팅
        
    }
    
    
    @IBAction func stackBtnClick(_ sender: Any) {
        self.dismiss(animated: false)
    }
}

extension StackBtnPopupViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionTable.count   // 추후 변경
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StackerCollectionViewCell", for: indexPath) as? StackerCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = UIColor.clear
        
        //print("indexPath.item : ", indexPath.item)
        //print("indexPath.row : ", indexPath.row)
        
        //cell.stackerInstrImg.load(url: URL(string: (collectionTable[indexPath.row]?.instruments[0].imgUrl)!)!)
        //cell.stackerImageView.load(url: URL(string: (collectionTable[indexPath.row]?.profileImgUrl)!)!)
        cell.stackerInstrImg.setImage(with: (collectionTable[indexPath.row]?.instruments[0].imgUrl)!)
        cell.stackerImageView.setImage(with: (collectionTable[indexPath.row]?.profileImgUrl ?? nil))
        
        /*
        HomeDataManager().stackInfoManager(projectId: 40, sequence: "next", completion: {
            [weak self] res in
            //for row in res {
            print("res[indexPath.item] : ", res[indexPath.item])
            print("CollectionView Cell indexPath.item : ", indexPath.item)
            cell.stackerImageView.load(url: URL(string: (res[indexPath.item]?.profileImgUrl)!)!)
            cell.stackerInstrImg.load(url: URL(string: (res[indexPath.item]?.instruments[0].imgUrl)!)!)
                //print("row : ", row)
            //}
            //print("stackInfoManager completion 내 res : ", res)
        })*/
        return cell
    }
    
    // CollectionViewCell 은 반드시 셀의 너비와 높이 설정해야
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 71)
    }
    
    
    
}
