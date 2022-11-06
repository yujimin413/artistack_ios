//
//  ProfileViewController.swift
//  Artistack
//
//  Created by csh on 2022/07/18.
//

import UIKit
import Alamofire
import AVFAudio

// 내프로필 -> 프로필편집화면 으로 프로필 정보 전달
protocol ProfileCollectionViewCellDelegate {
    func profileEditButtonDidTap(index: Int, imgStr: String, img: UIImage, name: UILabel, bio: UILabel)
}

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    var idArray =  [Int]()
    var playerView: VideoPlayerView!
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var no_posts: UIImageView!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    
    
    
    
    var userPosts: [content]? {
        didSet {
            self.profileCollectionView.reloadData()
            if (profileCollectionView.numberOfItems(inSection: 2) == 0) {
                no_posts.isHidden = false
            }
            else {
                no_posts.isHidden = true
            }
            
        }
        
    }
    
    
 
    let stickyIndexPath = IndexPath(row: 0, section: 1)
    
    // MARK - Lifecycle
    override func viewDidLoad() {
    
        super.viewDidLoad()
        setupCollectionView()
        setFlowLayout()
        setIndicator()
        initRefreshControl()

        
        // 게시글 개수 0일 경우 이미지 뷰 띄우기
//        if (profileCollectionView.numberOfItems(inSection: 2) == 0) {
//            no_posts.isHidden = false
//        }
//
//        if (userPosts?.count == 0) {
//            no_posts.isHidden = false
//        }
        
        
        
    // MARK: 네비게이션 바 셋팅
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationController?.navigationBar.topItem?.title = ""
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.text = "프로필"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let title = UIBarButtonItem.init(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = title
        self.navigationController?.view.tintColor = .white
        
        
        let settingButton = UIButton()
        settingButton.setImage(UIImage(named: "setting"), for: .normal)
        settingButton.addTarget(self, action: #selector(settingButtonPressed(_:)), for: .touchUpInside)
        
        let setting = UIBarButtonItem.init(customView: settingButton)
        self.navigationItem.rightBarButtonItem = setting
    }
    
    
    func initRefreshControl(){
        profileCollectionView.refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView(refreshControl:)), for: .valueChanged)
        profileCollectionView.refreshControl = refreshControl
    }
    
    @objc func refreshTableView(refreshControl:
    UIRefreshControl){
        print("새로고침!")
        
        DispatchQueue.main.asyncAfter(deadline: .now()){
            self.profileCollectionView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        // setupData() 개명했어욤
        myProjectListReload()

        RecordingViewController.ISSTACK = false
        // 게시글 개수 0일 경우 이미지 뷰 띄우기
        if (profileCollectionView.numberOfItems(inSection: 2) == 0) {
            no_posts.isHidden = false
        }
        else {
            no_posts.isHidden = true
        }
    }
    
    // MARK: - Actions
    // 내프로필화면에서 선택한 게시글로 이동
    func collectionView(_ collectionView: UICollectionView,
      didSelectItemAt indexPath: IndexPath) {
        
        let section = indexPath.section
        if section == 2 {
            
            print("배열")
            print(idArray)
            var id = indexPath.row
            print("인덱스")
            print(id)
            
            print("게시물 터치됨")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PleaseVC") as! PleaseViewController
            
            //이거 고마운놈
            vc.loadViewIfNeeded()
//            vc.please.text = "fuckfuckk"

        DispatchQueue.main.async {
            print("디버깅중")
            GetProject(projectId: self.idArray[id]) { data in
                    debugPrint(data)
                    vc.TitleLbl.text = data.title
                    vc.likeCountLbl.text = String(data.likeCount)
                    vc.stackCountLbl.text = String(data.stackCount)
                    vc.musicInfoCodeLbl.text = data.codeFlow
                    vc.musicInfoBpmLbl.text = data.bpm
                    vc.configure(title: NSURL(string: data.videoUrl), size: (Int(vc.contentVIew.frame.width), Int(vc.contentVIew.frame.width)))
                    vc.playerView.play()
                    vc.RootUserNameLbl.text = data.user.nickname
                    vc.RootInstImageView.load(url: URL(string: data.instruments[0].imgUrl)!)
                guard let url = URL(string: data.user.profileImgUrl)
                else{
                    ("url 비엇음")
                    return
                }
                    vc.RootProfileImageVIew.load(url: url)
                
                RecordingViewController.Title = data.title
                RecordingViewController.IsStackable = data.isStackable
                RecordingViewController.VideoURL = data.videoUrl
                RecordingViewController.BPM = data.bpm
                RecordingViewController.CodeFlow = data.codeFlow
                RecordingViewController.ProjectID = String(describing: data.prevProjectId)
                }
            // 뒤로가기 버튼 커스텀
            }
            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
            backBarButtonItem.tintColor = .white
            self.navigationItem.backBarButtonItem = backBarButtonItem
            self.navigationController?.navigationBar.backgroundColor = .clear
            
            
            // 해당 게시글 뷰컨트롤러로 이동
//                myPostVC.txt = "\(indexPath.section) 셀의 \(indexPath.row) 번째 게시글 clicked"
//            vc.test.text = "hi"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
            


      }
    
    @objc
    func didLongPressCell (gestureRecognizer: UILongPressGestureRecognizer) {
        
        if gestureRecognizer.state != .began { return }
        
        let position = gestureRecognizer.location(in: profileCollectionView)
        
        if let indexPath = profileCollectionView?.indexPathForItem(at: position) {
            print("DEBUG: ", indexPath.item)
            
            guard let userPosts = self.userPosts else { return }
            let cellData = userPosts[indexPath.item]
            if let projectId = cellData.id {
                // 삭제 API 호출
                
                let alert = UIAlertController(title: "알림", message: "해당 게시글을 정말 삭제하시겠습니까?", preferredStyle: .alert)
                let ok = UIAlertAction(title: "네", style: .destructive) {
                    (action) in
                    print("게시글 삭제 api 호출")
                    MyprojectDataManager().deleteMyPost(self, projectId)
                    self.myProjectListReload()
                }
        //                MyprojectDataManager().deleteMyPost(self, projectId)
        //                setupData()
                let cancel = UIAlertAction(title: "아니오", style: .cancel) {
                    (action) in
                    print("게시글 삭제 안 함")
                }

                alert.addAction(ok)
                alert.addAction(cancel)
                
                present(alert, animated: true)

            }
            
        }
        

    }
    
    
    func setIndicator(){
        activityMonitor.scaleIndicator(factor: 2)
        activityMonitor.color = .white
        activityMonitor.isHidden = true
        view.bringSubviewToFront(activityMonitor)
        activityMonitor.layer.zPosition = 2
    }
    
    
    // MARK: - Helpers
    private func setupCollectionView() {
        // delegate 연결
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        
        // cell 등록
        // 프로필
        profileCollectionView.register(
            UINib(nibName: "ProfileCollectionViewCell",
                bundle: nil),
            forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        
        // 내 연주
        profileCollectionView.register(
            UINib(nibName: "CollectionReusableView",
                bundle: nil),
            forCellWithReuseIdentifier: CollectionReusableView.identifier)
        
        // 게시글
        profileCollectionView.register(
            UINib(nibName: "PostCollectionViewCell",
                bundle: nil),
            forCellWithReuseIdentifier: PostCollectionViewCell.identifier)
        
        let gesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(didLongPressCell(gestureRecognizer:)))
        gesture.minimumPressDuration = 0.66
        gesture.delegate = self
        gesture.delaysTouchesBegan = true
        profileCollectionView.addGestureRecognizer(gesture)
    }
        
    private func myProjectListReload() {
        self.activityMonitor.isHidden = false
        self.activityMonitor.startAnimating()
        MyprojectDataManager().getMyProject(self){
            data in
            guard let dataArray = data.content else { return }
            self.idArray.removeAll()
//            print(dataArray.count)
            
            if dataArray.count > 0 {
            for i in 0...dataArray.count - 1 {
//                print(dataArray[i].id!)
                self.idArray.append(dataArray[i].id!)
//                print(self.idArray)
            }
            }
            self.activityMonitor.stopAnimating()
            self.activityMonitor.isHidden = true
        }
    }
    
    func myProfileReload(_ collectionViewCell: ProfileCollectionViewCell) {
        collectionViewCell.getProfileInfo(self)
//        MyprojectDataManager().getMyProject(self)
    }
                
    func setFlowLayout() {
        let columnLayout = CustomCollectionViewFlowLayout(stickyIndexPath: stickyIndexPath)
        self.profileCollectionView.collectionViewLayout = columnLayout
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // 섹션의 개수
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    // 셀의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            return userPosts?.count ?? 0
        }
    }
    
    // 셀 생성
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProfileCollectionViewCell.identifier,
                for: indexPath) as? ProfileCollectionViewCell else {
                    fatalError("셀 타입 캐스팅 실패...")
            }
            cell.index = indexPath.row
            cell.delegate = self
            //            cell.getProfileInfo(self)
                        self.myProfileReload(cell)
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionReusableView.identifier,
                for: indexPath) as? CollectionReusableView else {
                    fatalError("셀 타입 캐스팅 실패...")
            }
            cell.setupData(userPosts?.count ?? 0)
            return cell
            
        default:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PostCollectionViewCell.identifier,
                    for: indexPath) as? PostCollectionViewCell else {
                        fatalError("셀 타입 캐스팅 실패...")
                    }
//            print("각 게시글 셀에 데이터 전달(썸네일, 좋아요 수 등,,")
            let itemIndex = indexPath.item
            if let cellData = self.userPosts {
                // 데이터가 있는 경우 셀에 데이터 전달
                cell.setupData(cellData[itemIndex].id, cellData[itemIndex].videoUrl, cellData[itemIndex].viewCount, cellData[itemIndex].likeCount, cellData[itemIndex].stackCount)
//                profileCollectionView.reloadData()
                
    //            print("프로필 - 프로젝트 리스트 조회")
                
                    // 왜 계속 호출???
//                setupData()
//                    MyprojectDataManager().getMyProject(self)
            }

            return cell
        }
    }
    
}

// for collectionView size 조절
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
        switch section {
        case 0:
//            print("collectionviewheight")
//            print(collectionView.frame.height)
            return CGSize(
                width: collectionView.frame.width,
//                height: 127)
                height: collectionView.frame.height * 127 / 670)

        case 1:
            return CGSize(
                width: collectionView.frame.width,
//                height: 43)
                height: collectionView.frame.height * 43 / 673)

        default:
//            let side = CGFloat((collectionView.frame.width / 3) - (4/3) )
            return CGSize(
//                width: 110,
//                height: 180)
                width: collectionView.frame.width * 110 / 390,
                height: collectionView.frame.height * 180 / 670)
        }
    }
    
    // 열 간격
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat(0)
        case 1:
            return CGFloat(0)
        default:
            return CGFloat(1)
//            return CGFloat(1)
        }
    }

    // 행 간격
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat(0)
        case 1:
            return CGFloat(0)
        default:
            return CGFloat(10)
//            return CGFloat(10)
        }
    }
    
    // contentInset 상하좌우
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let interval = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        switch section {
        case 0:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        case 1:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            return interval
        }
    }
    
    
    
    @objc private func settingButtonPressed(_ sender: Any) {
        
        print("tapped")
                  self.navigationController?.popViewController(animated: true)

                    let myPostVC = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as? SettingViewController
                        // 뒤로가기 버튼 커스텀
                        let backBarButtonItem = UIBarButtonItem(title: "설정", style: .plain, target: self, action: nil)
                        backBarButtonItem.tintColor = .white
                        self.navigationItem.backBarButtonItem = backBarButtonItem
        
                        // 해당 게시글 뷰컨트롤러로 이동
                        self.navigationController?.pushViewController(myPostVC!, animated: true)
              }
}

extension ProfileViewController: ProfileCollectionViewCellDelegate {
    func profileEditButtonDidTap(index: Int, imgStr: String, img: UIImage, name: UILabel, bio: UILabel) {
        // 네비게이션바 커스텀
        let backBarButtonItem = UIBarButtonItem(title: "프로필 수정", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .white
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        let profileEditViewController = UIStoryboard(name: "ProfileEdit", bundle: nil).instantiateViewController(withIdentifier: "ProfileEditVC") as! ProfileEditViewController
        
        // 기존 프로필사진, 닉네임, 소개글 정보 넘기기
        profileEditViewController.profileImgStr = imgStr
        profileEditViewController.profileImg = img
        profileEditViewController.nicknameTxt = name.text!
        profileEditViewController.bioTxt = bio.text!
        
//        self.present(profileEditViewController, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(profileEditViewController, animated: true)
//        self.present(profileEditViewController, animated: true)
    }
    
}

// MARK: - API 통신 메소드

extension ProfileViewController {
    func suuccessFeedAPI(_ result: MyprojectDataModel) {
//        self.userFeedData = result
        
        self.userPosts = result.data?.content
    }
}


