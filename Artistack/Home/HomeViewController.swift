//
//  HomeViewController.swift
//  Practice_Artistack
//
//  Created by csh on 2022/07/25.
//

import UIKit
import SnapKit
import AVFoundation
import RxSwift
import Lottie
import Kingfisher


// 프로토콜
protocol HomeTableViewCellDelegate {
    func longPressedlikeButton()
    func middleButtonTapped()
    func showStackerButton()
}

class HomeViewController: UIViewController {

    // MARK: - UI Components
    var mainTableView: UITableView!
    //lazy var loadingAnimation = AnimationView(name: "LoadingAnimation")
    
    // MARK: - Variables
    let cellId = "HomeCell" // 나중에 확인
    @objc dynamic var currentIdx = 0
    var oldAndNewIndices = (0,0)  // 어디에서 쓰이는지 찾아보기
    var tmpUrl: String = String()
    
    let refreshControl = UIRefreshControl()
    let viewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    //let stackPopupControllerView = stackPopupControllerView
    // var data = [Post]() // 추후 Post에 쓰여진 data들을 기반으로 HomeView에서 출력 예정
    var projectItems: [EachProject?] = []
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        callAllProjects()
        setupView()
        initRefreshControl()
        //setupBinding()
        //setupObservers()
    }
    
    func initRefreshControl(){
        mainTableView.refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView(refreshControl:)), for: .valueChanged)
        mainTableView.refreshControl = refreshControl
    }
    
    @objc func refreshTableView(refreshControl:
    UIRefreshControl){
        print("새로고침!")
        
        DispatchQueue.main.asyncAfter(deadline: .now()){
            HomeDataManager().homeDataAllManager(completion: {
                [weak self]res in
                self?.projectItems = res
                self?.mainTableView.reloadData()
            })
            refreshControl.endRefreshing()
        }
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let cell = mainTableView.visibleCells.first as? HomeTableViewCell {
            cell.play()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let cell = mainTableView.visibleCells.first as? HomeTableViewCell {
            // HomeTableViewCell 내 pause 함수 정리해준 뒤 주석표시 삭제
            cell.pause()
        }
    }
    
    // Setup Views : especially tableView
    
    
    func callAllProjects() {
        HomeDataManager().homeDataAllManager(completion: {
            [weak self]res in
            self?.projectItems = res
            self?.mainTableView.reloadData()
        })
    }
    
    
    func setupView(){
        // Table View
        mainTableView = UITableView()
        mainTableView.backgroundColor = .black
        mainTableView.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        mainTableView.tableFooterView = UIView() // table 아래에 실행되는
        mainTableView.isPagingEnabled = true
        mainTableView.contentInsetAdjustmentBehavior = .never // safe area 무시하고 영역잡기
        mainTableView.showsVerticalScrollIndicator = false // 스크롤 안보이게
        mainTableView.separatorStyle = .none // 테이블 셀들 사이 구분 style
        //view.frame = mainTableView.bounds
        view.addSubview(mainTableView) // 맨 위에 테이블 뷰 추가
        
        //let trailingAnchor = mainTableView.trailingAnchor.constraint(equalTo: )
        mainTableView.snp.makeConstraints({ make in
            make.edges.equalToSuperview()
        })
        //DispatchQueue.global().sync{
        mainTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        //mainTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            mainTableView.delegate = self
            mainTableView.dataSource = self
            mainTableView.prefetchDataSource = self
        //}
    }
    
    // 추후 Post와 관련된 파일 생성 후 진행 예정
    // Set up Binding
    func setupBinding(){
        //Posts
    }
    
}

// MARK: - Table View Extensions
extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return projectItems.count //self.data.count // Posts 파일 관련 손대고 주석 풀기
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! HomeTableViewCell
            
            // 버튼 구현을 위한. 나중에 주석 삭제 예정
            cell.index = indexPath.row
            cell.delegate = self
            //let urlList = ["https://artistack-bucket.s3.ap-northeast-2.amazonaws.com/video/2d5cdfbc-f8c5-4576-a1a3-5d9a05a89009mp4", "https://www.pexels.com/ko-kr/video/7657365/"]
            //let urlList = ["dummyVideo", "dummyVideo2"]
            /// 일단은 로컬에 있는 비디오 돌아가는 방식으로 진행 -> 추후 변경하기로,,, 추후
            //let tmpUrl = Bundle.main.url(forResource: "dummyVideo", withExtension: "mp4")
             //= NSURL? //: NSURL //= NSURL()
            
            /// 동영상 정보 부르기 잠시 보류
            /*
            let tmpUrl: String = String()
            
            
            DispatchQueue.main.async {
                HomeDataManager().homeDataManager(projectId: 40, completion: {
                    
                    [weak self] res in
                    //let target = URL(string: res.videoUrl)
                    //let title = URLRequest(url: target!)
                    print("res.videoUrl : ", res.videoUrl)
                    self?.tmpUrl = res.videoUrl
                    print("tmpUrl : ", tmpUrl)
                    //self?.title = NSURL(string: res.videoUrl)
                })
            }
       
            print("completion 밖 tmpUrl : ", tmpUrl)
            let title = NSURL(string: tmpUrl)
             */

            
            /*
            Task {
                do {
                    //print("tmp가 가질 값 : ", projectItems[indexPath.row]!)
                    var tmp = 40//projectItems[indexPath.row]!.id
                    let data = try await HomeDataManager().homeDataInfoManager(projectId: tmp)
                    print("cell에 필요한 정보 받아온 결과 : ", data)
                    cell.musicInfoCodeLbl.text = data.codeFlow
                    cell.musicInfoBpmLbl.text = data.bpm
                    cell.TitleLbl.text = data.title
                    cell.hiddenLbl.text = data.description
                    cell.TopUserNameLbl.text = data.user.nickname
                    cell.TopProfileImageVIew.load(url: URL(string: data.user.profileImgUrl!)!)
                    cell.TopInstImageView.load(url: URL(string: data.instruments[0].imgUrl!)!)
                    cell.likeCountLbl.text = String(data.likeCount)
                    cell.stackCountLbl.text = String(data.stackCount)
                    cell.configure(title: NSURL(string: data.videoUrl), size: (Int(tableView.frame.width), Int(tableView.frame.height)))
                } catch {
                    print(error) }
            }
            */
            
            // 모든 프로젝트 리스트 조회에서 출력된 값 기반으로 cell에 대입
            cell.configure(title: NSURL(string: self.projectItems[indexPath.row]?.videoUrl ?? ""), size: (Int(tableView.frame.width), Int(tableView.frame.height)))
            cell.projectId = projectItems[indexPath.row]!.id
            cell.TitleLbl.text = projectItems[indexPath.row]?.title ?? ""
            cell.hiddenLbl.text = projectItems[indexPath.row]?.description ?? ""
            cell.musicInfoBpmLbl.text = projectItems[indexPath.row]?.bpm ?? ""
            cell.musicInfoCodeLbl.text = projectItems[indexPath.row]?.codeFlow ?? ""
            // viewCount 자리
            // prevProjectId 자리
            
            // 여기 반영 잘 안됨
            cell.lastUserNickname = projectItems[indexPath.row]!.user.nickname
            cell.lastUserImageView = projectItems[indexPath.row]!.user.profileImgUrl ?? nil
            cell.lastInstImageView = projectItems[indexPath.row]!.instruments[0].imgUrl!
            
            cell.prevStackers = projectItems[indexPath.row]?.prevStackers ?? []
            
            cell.beforeStackCnt = projectItems[indexPath.row]!.prevStackCount
            cell.afterStackCnt = projectItems[indexPath.row]!.stackCount
            cell.stackCountLbl.text = String(projectItems[indexPath.row]!.stackCount)
            cell.likeCountLbl.text = String(projectItems[indexPath.row]!.likeCount)
            cell.isLiked = projectItems[indexPath.row]!.isLiked
            if cell.isLiked == true {
                cell.likeBtn.setImage(UIImage(named: "Like_fill"), for: .normal)
                cell.liked = true
            }
            if (projectItems[indexPath.row]?.description!.count)! <= 0 { // 설명 없으면 더보기 버튼 없애기 확인해야
                cell.showMore.isHidden = true
            }
            
            // HomeTableViewCell에 있던 setProfile 함수 가져옴
            switch cell.beforeStackCnt {
                //print("[HomeViewController] cell.beforeStackCnt를 기반으로 이미지 주는 곳")
            case 0:
                cell.MiddleProfileView.isHidden = true
                cell.TopProfileView.isHidden = true
                cell.BottomLine.isHidden = true
                cell.TopLine.isHidden = true
                cell.MiddleCountLbl.isHidden = true
                
                cell.RootProfileImageVIew.setImage(with: projectItems[indexPath.row]!.user.profileImgUrl ?? nil)
                cell.RootInstImageView.load(url: URL(string: projectItems[indexPath.row]!.instruments[0].imgUrl!))
                cell.RootUserNameLbl.text = projectItems[indexPath.row]!.user.nickname
                break
                
            case 1:
                cell.TopProfileView.isHidden = true
                cell.TopLine.isHidden = true
                cell.RootUserNameLbl.isHidden = true
                cell.RootBackGroundImageView.image = UIImage.init(named: "ProfileBackgroundGrey")
                cell.MiddleCountLbl.isHidden = true
                cell.RootProfileImageVIew.alpha = 0.5
                cell.RootBackGroundImageView.alpha = 0.5
                cell.RootInstImageView.alpha = 0.5
                
                cell.RootProfileImageVIew.setImage(with: projectItems[indexPath.row]?.prevStackers[0]?.profileImgUrl ?? nil)
                cell.RootInstImageView.load(url: URL(string: (projectItems[indexPath.row]?.prevStackers[0]?.instruments[0].imgUrl!)!))
                cell.RootUserNameLbl.text = ""
                
                cell.MiddleProfileImageView.setImage(with: projectItems[indexPath.row]!.user.profileImgUrl ?? nil)
                cell.MiddleInstImageView.load(url: URL(string: projectItems[indexPath.row]!.instruments[0].imgUrl!))
                cell.MiddleUserNameLbl.text = projectItems[indexPath.row]!.user.nickname
                break
                
            case 2:
                cell.MiddleUserNameLbl.isHidden = true
                cell.MiddleBackGroundImageView.image = UIImage.init(named: "ProfileBackgroundGrey")
                cell.RootUserNameLbl.isHidden = true
                cell.RootBackGroundImageView.image = UIImage.init(named: "ProfileBackgroundGrey")
                cell.MiddleCountLbl.isHidden = true
                cell.MiddleProfileImageView.alpha = 0.5
                cell.MiddleBackGroundImageView.alpha = 0.5
                cell.MiddleInstImageView.alpha = 0.5
                cell.RootProfileImageVIew.alpha = 0.5
                cell.RootBackGroundImageView.alpha = 0.5
                cell.RootInstImageView.alpha = 0.5
                
                cell.RootProfileImageVIew.setImage(with: projectItems[indexPath.row]?.prevStackers[cell.beforeStackCnt-1]?.profileImgUrl ?? nil)
                cell.RootInstImageView.load(url: URL(string: (projectItems[indexPath.row]!.prevStackers[cell.beforeStackCnt-1]?.instruments[0].imgUrl!)!))
                cell.RootUserNameLbl.text = ""
                
                cell.MiddleProfileImageView.setImage(with: projectItems[indexPath.row]?.prevStackers[0]?.profileImgUrl ?? nil)
                cell.MiddleInstImageView.load(url: URL(string: (projectItems[indexPath.row]!.prevStackers[0]?.instruments[0].imgUrl!)!))
                cell.MiddleUserNameLbl.text = ""
                
                cell.TopProfileImageVIew.setImage(with: projectItems[indexPath.row]!.user.profileImgUrl ?? nil)
                cell.TopInstImageView.load(url: URL(string: projectItems[indexPath.row]!.instruments[0].imgUrl!))
                cell.TopUserNameLbl.text = projectItems[indexPath.row]!.user.nickname
                break
                
            case 3, 4, 5:
                cell.MiddleUserNameLbl.isHidden = true
                cell.MiddleBackGroundImageView.image = UIImage.init(named: "ProfileBackgroundGrey")
                cell.RootUserNameLbl.isHidden = true
                cell.RootBackGroundImageView.image = UIImage.init(named: "ProfileBackgroundGrey")
                cell.MiddleProfileImageView.isHidden = true
                cell.MiddleCountLbl.text = "2"
                cell.MiddleInstImageView.isHidden = true
                cell.RootProfileImageVIew.alpha = 0.5
                cell.RootBackGroundImageView.alpha = 0.5
                cell.RootInstImageView.alpha = 0.5
                cell.MiddleBackGroundImageView.alpha = 0.2

                
                cell.RootProfileImageVIew.setImage(with: projectItems[indexPath.row]?.prevStackers[cell.beforeStackCnt-1]?.profileImgUrl ?? nil)
                cell.RootInstImageView.load(url: URL(string: (projectItems[indexPath.row]!.prevStackers[cell.beforeStackCnt-1]?.instruments[0].imgUrl!)!))
                cell.RootUserNameLbl.text = ""
                
                cell.TopProfileImageVIew.setImage(with: projectItems[indexPath.row]!.user.profileImgUrl ?? nil)
                cell.TopInstImageView.setImage(with: projectItems[indexPath.row]!.instruments[0].imgUrl!)
                cell.TopUserNameLbl.text = projectItems[indexPath.row]!.user.nickname
                
            default:
                print("아직은 모든 프로젝트 조회 - prevStackCount가 0~5만 가능.")
                break
            }
            
            
            
            // 하나의 프로젝트 (= 하나의 셀) 정보 조회 API를 통한 정보 대입
            /*
            HomeDataManager().homeDataInfoManager(projectId: self.projectItems[indexPath.row]!.id, completion: {//self.projectItems[indexPath.row]?.id ?? 0, completion: {
                [weak self] res in
                //if res.description?.count == 0 {
                //    print("res.description 길이 : ", res.description?.count)
                //    cell.showMore.isHidden = true
                //}
                print("homeDataInfoManager 호출잘 되는지")
                cell.musicInfoCodeLbl.text = res.codeFlow
                cell.musicInfoBpmLbl.text = res.bpm
                cell.TitleLbl.text = res.title
                cell.hiddenLbl.text = res.description
                cell.lastUserNickname = res.user.nickname
                // load & setImage 둘 다? -> 일단 고려
                //cell.lastUserImageView.load(url: URL(string: res.user.profileImgUrl ?? " "))
                //cell.lastInstImageView.load(url: URL(string: res.instruments[0].imgUrl!)!)
                cell.lastUserImageView = res.user.profileImgUrl ?? " "
                cell.lastInstImageView = res.instruments[0].imgUrl!
                cell.likeCountLbl.text = String(res.likeCount)
                cell.stackCountLbl.text = String(res.stackCount)
                
                // 다른 화면에도 정보 전달
                //StackBtnPopupViewController().stackCountLbl.text = String(res.stackCount)
                //StackBtnPopupViewController().personImgView.load(url: URL(string: res.user.profileImgUrl!)!)
                //StackBtnPopupViewController().instrumentImgView.load(url: URL(string: res.instruments[0].imgUrl!)!)
                //StackBtnPopupViewController().nicknameLbl.text = String(res.user.nickname)
                
                //cell.configure(title: NSURL(string: res.videoUrl), size: (Int(tableView.frame.width), Int(tableView.frame.height)))
            })
            */
            //open func reloadRows(
            // 다른 파일에서 쓰일 변수 정보 대입하기
            BeforeStackViewController.projectId = self.projectItems[indexPath.row]!.id
            LikePopupViewController.likePeopleCnt = self.projectItems[indexPath.row]!.likeCount
            
            //레오거 -> 미디어 촬영에서 쓰이는 변수들
            RecordingViewController.IsStackable = self.projectItems[indexPath.row]!.isStackable
            RecordingViewController.VideoURL = self.projectItems[indexPath.row]!.videoUrl
            RecordingViewController.Title = self.projectItems[indexPath.row]!.title
            RecordingViewController.BPM = self.projectItems[indexPath.row]!.bpm
            RecordingViewController.CodeFlow = self.projectItems[indexPath.row]!.codeFlow
            RecordingViewController.ProjectID = String(self.projectItems[indexPath.row]!.id)
            RecordingViewController.ISSTACK = true
            
            // 셀 나오고나서 넘겨주기 해볼 거라 주석 달아놓음
            // print("[HomeViewController] self.projectItems[indexPath.row]!.stackCount : ", self.projectItems[indexPath.row]!.stackCount)
            // StackBtnPopupViewController.itemCnt = self.projectItems[indexPath.row]!.stackCount
            
            //let title = NSURL(string: "https://artistack-bucket.s3.ap-northeast-2.amazonaws.com/video/2d5cdfbc-f8c5-4576-a1a3-5d9a05a89009mp4")
            // size 파라미터 임의 추가
            //cell.configure(title: title, size: (Int(tableView.frame.width), Int(tableView.frame.height)))//post: data[indexPath.row]) // Posts 손대고
            //cell.delegate = self
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return tableView.frame.height
        }
    
        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            // If the cell is the first cell in the tableview, the queuePlayer automatically starts.
            // If the cell will be displayed, puase the video until the drag on the scroll view is ended
            if let cell = cell as? HomeTableViewCell{
                oldAndNewIndices.1 = indexPath.row
                currentIdx = indexPath.row
                cell.pause() //scrollviewdelegate 없애고 cell.replay 변경 가능성 있음
            }
        }
        
        func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            // Pause the video if the cell is ended displaying
            if let cell = cell as? HomeTableViewCell {
                cell.pause()
            }
        }
    
        func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//            for indexPath in indexPaths {
//                print(indexPath.row)
//            }
        }
    
    /*
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            HomeDataManager().stackInfoManager(projectId: self.projectItems[indexPath.row]!.id, sequence: "prev", completion: {
                [weak self] res in
                print("stackInfoManager 결과 한 번 보자 : ", res)
                BeforeStackViewController.beforeStackTable = res
                HomeTableViewCell.beforeStackCnt = res.count
                print("res.count : ", res.count)
                print("HomeTableViewCell.beforeStackCnt : ", HomeTableViewCell.beforeStackCnt)
                //BeforeStackViewController().stackTableView.reloadData()
                debugPrint(res)
            })
            self.mainTableView.reloadRows(at: [indexPath], with: .fade)

        }
     */
    
    
}


// MARK: - ScrollView Extension
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let cell = self.mainTableView.cellForRow(at: IndexPath(row: self.currentIdx, section: 0)) as? HomeTableViewCell
        cell?.replay()
    }
}

// MARK: - Navigation Delegate
// TODO: Customized Transition
extension HomeViewController: HomeCellNavigationDelegate {
    func navigateToProfilePage(uid: String, name: String) {
        //self.navigationController?.pushViewController(ProfileViewController(), animated: true)
    }
}


// MARK: - HomeTableViewCell 내 버튼들에 대한 기능 delegate
// 코드 구체적인 동작 : 보내준 링크 코드
extension HomeViewController: HomeTableViewCellDelegate {

    func longPressedlikeButton() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "likePopupVC")
        vc.modalPresentationStyle = .overCurrentContext 
        self.present(vc, animated: true, completion: nil)
    }
    
    func middleButtonTapped() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BeforeStackVC")
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func showStackerButton() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "StackBtnPopupVC")
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    

}
