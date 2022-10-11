//
//  HomeTableViewCell.swift
//  Practice_Artistack
//
//  Created by csh on 2022/07/26.
//

import UIKit
import AVFAudio

protocol HomeCellNavigationDelegate: class { //손봐서 바꿀 것들 바꿔야
    // Navigate to Profile page
    func navigateToProfilePage(uid: String, name: String)
}

class HomeTableViewCell: UITableViewCell {

    // MARK: - UI Components
    var playerView: VideoPlayerView!
    //var musicInfoView: MusicInfoViewController!
    @IBOutlet weak var songInfoBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var stackBtn: UIButton!
    @IBOutlet weak var stackCountLbl: UILabel!
    @IBOutlet weak var musicInfoView: UIView!
    var index: Int = 0
    var delegate: HomeTableViewCellDelegate?
    
    @IBOutlet weak var TopProfileView: UIView!
    @IBOutlet weak var MiddleProfileView: UIView!
    @IBOutlet weak var RootProfileView: UIView!
    
    @IBOutlet weak var TopBackGroundImageView: UIImageView!
    @IBOutlet weak var MiddleBackGroundImageView: UIImageView!
    @IBOutlet weak var RootBackGroundImageView: UIImageView!
    
    @IBOutlet weak var TopUserNameLbl: UILabel!
    @IBOutlet weak var MiddleUserNameLbl: UILabel!
    @IBOutlet weak var RootUserNameLbl: UILabel!
    
    @IBOutlet var TopProfileImageVIew: UIImageView!
    @IBOutlet var MiddleProfileImageView: UIImageView!
    @IBOutlet var RootProfileImageVIew: UIImageView!
    
    @IBOutlet var TopInstImageView: UIImageView!
    @IBOutlet var MiddleInstImageView: UIImageView!
    @IBOutlet var RootInstImageView: UIImageView!
    
    
    @IBOutlet weak var TopProfileButton: UIButton!
    @IBOutlet weak var MiddleProfileButton: UIButton!
    //미들 버튼 하나 더 만들거나 분기해서 사용할 것
    @IBOutlet weak var RootProfileButton: UIButton!
    
    @IBOutlet weak var MiddleCountLbl: UILabel!
    @IBOutlet weak var BottomLine: UIImageView!
    @IBOutlet weak var TopLine: UIImageView!
    
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var showMore: UIButton!
    @IBOutlet weak var hiddenLbl: UILabel!
    @IBOutlet weak var titleLblBottom: NSLayoutConstraint!
    
    // 가변적인 변수들 추가 선언
    @IBOutlet weak var musicInfoCodeLbl: UILabel!
    @IBOutlet weak var musicInfoBpmLbl: UILabel!
    // StackBtnPopupViewController에 Constraint를 위한 변수들
    // 있는 변수로 가능한지 확인해보고 안되면 변경 예정
    
    // MARK: - Variables
    private(set) var isPlaying = false
    private(set) var infoCheck = false
    private(set) var stackCheck = false
    private(set) var moreCheck = false
    
    var projectId: Int = Int()
    var isLiked = false
    var liked = false
    var bottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    var StackBtnController: StackBtnPopupViewController!
    var beforeStackCnt: Int = 0
    var afterStackCnt: Int = 0
    //var lastUserImageView: UIImageView = UIImageView()
    //var lastInstImageView: UIImageView = UIImageView()
    var lastUserImageView: String?
    var lastInstImageView: String = String()
    var lastUserNickname: String = String()
    var prevStackers: [StackerInfo?] = []
    //var post: Post? //Post 파일 만든 뒤 주석 풀기
    //week var delegate: HomeCellNavigationDelegate? //navigation 관련 손대고 주석 풀기
    
    // MARK: - LifeCycles
    override func prepareForReuse() { // video URL등을 nil로 초기화
        super.prepareForReuse()
        playerView.cancelAllLoadingRequest() // playerView 관련 손대고 주석 풀기
        resetViewsForReuse()
    }
    
    // 할 필요 없어 보이니 일단 제외 : 이미지 round 하게 만들어주는 작업. 추후 필요할 수도
    /*
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        self.layoutMargins = UIEdgeInsets.zero
        self.separatorInset = UIEdgeInsets.zero
        // 가장 먼저 데이터 연결을 해볼까
        
        //hiddenContent.frame = CGRect(x: 0, y: 0, width: self.hiddenContent.frame.width, height: 0)
        //hiddenTextView.frame = CGRect(x: 0, y: 0, width: self.hiddenTextView.frame.width, height: self.hiddenTextView.frame.height)
        //hiddenLbl.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        playerView = VideoPlayerView(frame: UIScreen.main.bounds) //나중에 기능 체크 후 주석 풀기
        setTempProfileImage()
        //setProfile(stackCount: HomeTableViewCell.beforeStackCnt) -> HomeVC에서
        contentView.addSubview(playerView)
        contentView.sendSubviewToBack(playerView)
        contentView.sendSubviewToBack(musicInfoView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(long))
        tapGesture.numberOfTapsRequired = 1
        likeBtn.addGestureRecognizer(tapGesture)
        likeBtn.addGestureRecognizer(longGesture)
        //contactServer()
        // 한 번 탭 시 영상 멈추는 거 할까요? 일단 없애는 걸로
        //let pauseGesture = UITapGestureRecognizer(target: self, action: #selector(handlePause))
        //self.contentView.addGestureRecognizer(pauseGesture)
        
        // 두 번 탭 시 좋아요 할까요? 일단 없애는 걸로
        //let likeDoubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLikeGesture(sender:)))
        //likeDoubleTapGesture.numberOfTapsRequired = 2
        //self.contentView.addGestureRecognizer(likeDoubleTapGesture)
        
        //pauseGesture.require(toFail: likeDoubleTapGesture)
    }
    
    // Post 게시물 만들고나서 주석 풀기
    
    func configure(title: NSURL?, size: (Int,Int)){ //post: Post) {
        /*
        self.post = post
        // name 관련해서 여기에서 받을지 고민
        likeCountLbl.text = post.likeCount.shorten()
        stackCountLbl.text = post.stackCount.shorten()
        */
        //let window = UIApplication.shared.windows[0]
        //let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        //let width = Int(safeFrame.width)
        playerView.configure(url: title, fileExtension: "mp4", size: size) //(width, Int(safeFrame.height)))//url: post.videoUrl, fileExtension: post.videoFileExtension, size:(post.videoWidth, post.videoHeight))
        
    }
    
    func replay(){
        if !isPlaying {
            playerView.replay()
            isPlaying = true
            //play()
        }
    }
    
    func play() {
        if !isPlaying {
            playerView.play()
            isPlaying = true
        }
    }
    
    func pause(){
        if isPlaying {
            playerView.pause()
            isPlaying = false
        }
    }
    
    // 클릭했을 때 일시 정지 이미지 및 시작 이미지 뜨게 하는 함수. 작동 여부 결정해야.
    /*
    @objc func handlePause() {
        if isPlaying {
            // Pause video and show pause sign
            UIView.animate(withDuration: 0.075, delay: 0, options: .curveEaseIn, animations: { [weak self] in
                guard let self = self else {return}
                self.pauseImgView.alpha = 0.35
                self.pauseImgView.transform = CGAffineTransform.init(scaleX: 0.45, y: 0.45)
            }, completion: { [weak self] _ in
                self?.pause()
            })
        } else {
            // Start video and remove pause sign
            UIView.animate(withDuration: 0.075, delay: 0, options: .curveEaseIn, animations: { [weak self] in
                guard let self = self else { return }
                self.pauseImgView.alpha = 0
            }, completion: { [weak self] _ in
                self?.play()
                self?.pauseImgView.transform = .identity
            })
        }
    }
     */
    
    func resetViewsForReuse() {
        likeBtn.setImage(UIImage(named: "Like"), for: .normal)
        //pauseImgView.alpha = 0
    }
    
    /*func contactServer(){
        HomeDataManager().homeDataManager(projectId: 40, completion: {
            [weak self] res in
            //self?.
            self?.musicInfoCodeLbl.text = res.codeFlow
            self?.musicInfoBpmLbl.text = res.bpm
            self?.TitleLbl.text = res.title
            self?.hiddenLbl.text = res.description
            self?.RootUserNameLbl.text = res.user.nickname
            //self?.RootProfileImageVIew = UIImageView(image: UIImage(contentsOfFile: res.user.profileImgUrl!))
            //self?.RootInstImageView = UIImageView(image: UIImage(contentsOfFile: res.instruments.imgUrl!))
            self?.likeCountLbl.text = String(res.likeCount)
            self?.stackCountLbl.text = String(res.stackCount)
            print("completion 완료")
        })
        print("contactServer 함수 완료")
    }*/
    
    // MARK: - Actions
    
    // Content show more
    @IBAction func showMoreInfo(_ sender: Any) {
        self.showMore.isHidden = false
        bottomConstraint.constant = 30
        if !moreCheck, self.hiddenLbl.text?.count != 0 {
            // 애니 동작이 잘 안됨
            print("hiddenLbl.count : ", self.hiddenLbl.text?.count)
            UIView.transition(with: hiddenLbl, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.hiddenLbl.isHidden = false
                self.showMore.isHidden = true
                
            })
            
            UIView.animate(withDuration: 3, delay:0, options: .curveLinear, animations: {
                //self.hiddenLbl.isHidden = false
                //self.hiddenContent.isHidden = false
                //self.hiddenContent.frame = CGRect(x: 0, y: 0, width: self.hiddenContent.frame.width, height: self.hiddenTextView.frame.height)
                //self.hiddenLbl.frame = CGRect(x: 0, y: 0, width: self.hiddenLbl.frame.width, height: self.hiddenLbl.frame.height)
                //self.showMore.isHidden = true
                print(self.hiddenLbl.frame.height)
                self.titleLblBottom.constant += (self.hiddenLbl.frame.height * 2)
            }, completion: { finished in
                print("Animation completed")
            })

            
        }
    
    }

    /*
    // Like Video Actions
    @IBAction func like(_ sender: UIButton) { //UITapGestureRecognizer
        LikePopupViewController.projectId = projectId
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(likeLongPressed(gesture:)))
        self.likeBtn.addGestureRecognizer(longPress)
        
        let tapPress = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        self.likeBtn.addGestureRecognizer(tapPress)
    
    }
    
    @objc func likeTapped(sender: UITapGestureRecognizer){
        if !liked {
            likeVideo()
        } else {
            liked = false
            likeBtn.setImage(UIImage(named: "Like"), for: .normal)
            HomeDataManager().postUnlikeManager(projectId: projectId)
            var beforeLikeCnt = Int(likeCountLbl.text!)
            var newLikeCnt = beforeLikeCnt!-1
            likeCountLbl.text = String(newLikeCnt)
            LikePopupViewController.likePeopleCnt -= 1
        }
    }
    
    @objc func likeVideo() {
        if !liked {
            liked = true
            likeBtn.setImage(UIImage(named: "Like_fill"), for: .normal)
            HomeDataManager().postLikeManager(projectId: projectId)
            var beforeLikeCnt = Int(likeCountLbl.text!)
            var newLikeCnt = beforeLikeCnt!+1
            likeCountLbl.text = String(newLikeCnt)
            LikePopupViewController.likePeopleCnt += 1
        }
    }
    
    @objc func likeLongPressed(gesture: UILongPressGestureRecognizer){
        if gesture.state == UIGestureRecognizer.State.began {
            print("Long Press")
            self.delegate?.longPressedlikeButton()
        }
        
    }
    */
    
    @objc func tap() {
        if !liked {
            likeVideo()
        } else {
            liked = false
            likeBtn.setImage(UIImage(named: "Like"), for: .normal)
            HomeDataManager().postUnlikeManager(projectId: projectId)
            var beforeLikeCnt = Int(likeCountLbl.text!)
            var newLikeCnt = beforeLikeCnt!-1
            likeCountLbl.text = String(newLikeCnt)
        }
    }
    
    @objc func long(_ recognizer: UILongPressGestureRecognizer) {
        LikePopupViewController.likePeopleCnt = Int(likeCountLbl.text!)!
        LikePopupViewController.projectId = projectId
        if recognizer.state == UIGestureRecognizer.State.began {
            print("Long Press")
            self.delegate?.longPressedlikeButton()
        }
    }
    
    @objc func likeVideo() {
        if !liked {
            liked = true
            likeBtn.setImage(UIImage(named: "Like_fill"), for: .normal)
            HomeDataManager().postLikeManager(projectId: projectId)
            var beforeLikeCnt = Int(likeCountLbl.text!)
            var newLikeCnt = beforeLikeCnt!+1
            likeCountLbl.text = String(newLikeCnt)
            LikePopupViewController.likePeopleCnt += 1
        }
    }
    
    
    /*
    @IBAction func likeLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        print("hi")
        
        self.delegate?.longPressedlikeButton()
     
        

        
//        self.present(vc, animated: true, completion: nil)

        
        //구별필요함
    }*/
    
    
    
    
    // UITabGestureRecognizer 구현 완료되었을 때 주석 해제
    /*
    // Heart Animation with random angle
    @objc func handleLikeGesture(sender: UITabGestureRecognizer) {
        let location = sender.location(in: self)
        let heartView = UIImageView(image: UIImage(named: "Like_fill"))
        let width : CGFloat = 110
        heartView.contentMode = .scaleAspectFit
        heartView.frame = CGRect(x: location.x - width / 2, y: location.y - width / 2, width: width, height: width)
        heartView.transform = CGAffineTransform(rotationAngle: CGFloat.random(in: -CGFloat.pi * 0.2...CGFloat.pi * 0.2))
        self.contentView.addSubview(heartView)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: {
            heartView.transform = heartView.transform.scaledBy(x: 0.85, y: 0.85)
        }, completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: [.curveEaseInOut], animations: {
                heartView.transform = heartView.transform.scaledBy(x: 2.3, y: 2.3)
                heartView.alpha = 0
            }, completion: { _ in
                heartView.removeFromSuperview()
            })
        })
        likeVideo()
    }
    */
    
    @IBAction func selectedInfoBtn(_ sender: Any) {
        if !infoCheck {
            infoMusic()
            //musicInfoShow()
        } else {
            infoCheck = false
            songInfoBtn.setImage(UIImage(named: "SongInfo"), for: .normal)
            contentView.sendSubviewToBack(musicInfoView)

        }
         
    }
    
    @objc func infoMusic() {
        if !infoCheck {
            infoCheck = true
            /*
            HomeDataManager().homeDataManager(projectId: 40, completion: {
                [weak self] res in
                //self?.
                self?.musicInfoCodeLbl.text = res.codeFlow
                self?.musicInfoBpmLbl.text = res.bpm
            })
             */
            songInfoBtn.setImage(UIImage(named: "SongInfo_fill"), for: .normal)
            contentView.bringSubviewToFront(musicInfoView)

        }
    
    }
    
    /*
    @objc func musicInfoShow(){
        let storyboard = UIStoryboard.init(name: "MusicInfoViewController", bundle: nil)
        let popupVC = storyboard.instantiateViewController(identifier: "MusicInfoVC")
        popupVC.modalPresentationStyle = .overCurrentContext
        self.present(popupVC, animated: false, completion: nil)
    }
     */
    
    
    @IBAction func stack(_ sender: Any) {
        StackBtnPopupViewController.projectId = projectId
        //StackBtnPopupViewController().personImgView.setImage(with: lastUserImageView ?? nil)
        StackBtnPopupViewController.rootProfileImage = lastUserImageView
        StackBtnPopupViewController.rootInstImage = lastInstImageView
        StackBtnPopupViewController.rootNickname = lastUserNickname
        StackBtnPopupViewController.itemCnt = afterStackCnt
        stackMusic()
        /*if !stackCheck {
            stackMusic()
        } else {
            stackCheck = false
            stackBtn.setImage(UIImage(named: "Stack"), for: .normal)
        }*/
    }
    
    @objc func stackMusic() {
        //if !stackCheck {
            //stackCheck = true
            //stackBtn.setImage(UIImage(named: "Stack_fill"), for: .normal)
        //StackBtnController.bottomConstraint = RootProfileView.frame.origin.y
        //StackBtnController.positionY = RootProfileView.frame.origin.y
        self.delegate?.showStackerButton()
        //}
    }
    
    
    
    private func setTempProfileImage(){
        self.TopProfileImageVIew.addDiamondMask()
        self.MiddleProfileImageView.addDiamondMask()
        self.RootProfileImageVIew.addDiamondMask()
    }
    
    /*
    func setProfile(stackCount: Int){
        
//        print("lastUserImageView String : ", lastUserImageView)
//        print("lastInstImageView String : ", lastInstImageView)
        print("[HomeTableViewCell] beforeStackCnt가 몇인데 그래서 ? :", stackCount)
        
        switch stackCount+1
        {
        case 1:
            self.MiddleProfileView.isHidden = true
            self.TopProfileView.isHidden = true
            self.BottomLine.isHidden = true
            self.TopLine.isHidden = true
            self.MiddleCountLbl.isHidden = true
            
            self.RootProfileImageVIew?.load(url: URL(string: lastUserImageView))
            self.RootInstImageView?.load(url: URL(string: lastInstImageView))
            self.RootUserNameLbl?.text = lastUserNickname
            break
            
        case 2:
            self.TopProfileView.isHidden = true
            self.TopLine.isHidden = true
            self.RootUserNameLbl.isHidden = true
            self.RootBackGroundImageView.image = UIImage.init(named: "ProfileBackgroundGrey")
            self.MiddleCountLbl.isHidden = true
            self.RootProfileImageVIew.alpha = 0.5
            self.RootBackGroundImageView.alpha = 0.5
            self.RootInstImageView.alpha = 0.5
            
            self.MiddleProfileImageView.load(url: URL(string: lastUserImageView))
            self.MiddleInstImageView.load(url: URL(string: lastUserImageView))
            self.RootProfileImageVIew.load(url: URL(string: prevStackers[0]?.profileImgUrl ?? " "))
            self.RootInstImageView.load(url: URL(string: prevStackers[0]?.instruments[0].imgUrl ?? " "))
            break
            
        case 3:
            self.MiddleUserNameLbl.isHidden = true
            self.MiddleBackGroundImageView.image = UIImage.init(named: "ProfileBackgroundGrey")
            self.RootUserNameLbl.isHidden = true
            self.RootBackGroundImageView.image = UIImage.init(named: "ProfileBackgroundGrey")
            self.MiddleCountLbl.isHidden = true
            self.MiddleProfileImageView.alpha = 0.5
            self.MiddleBackGroundImageView.alpha = 0.5
            self.MiddleInstImageView.alpha = 0.5
            self.RootProfileImageVIew.alpha = 0.5
            self.RootBackGroundImageView.alpha = 0.5
            self.RootInstImageView.alpha = 0.5
            
            self.TopProfileImageVIew.load(url: URL(string: lastUserImageView))
            self.TopInstImageView.load(url: URL(string: lastUserImageView))
            self.MiddleProfileImageView.load(url: URL(string: prevStackers[0]?.profileImgUrl ?? " "))
            self.MiddleInstImageView.load(url: URL(string: prevStackers[0]?.instruments[0].imgUrl ?? " "))
            self.RootProfileImageVIew.load(url: URL(string: prevStackers[1]?.profileImgUrl ?? " "))
            self.RootInstImageView.load(url: URL(string: prevStackers[1]?.instruments[0].imgUrl ?? " "))
            
            break
        
        case 4:
            self.MiddleUserNameLbl.isHidden = true
            self.MiddleBackGroundImageView.image = UIImage.init(named: "ProfileBackgroundGrey")
            self.RootUserNameLbl.isHidden = true
            self.RootBackGroundImageView.image = UIImage.init(named: "ProfileBackgroundGrey")
            self.MiddleProfileImageView.isHidden = true
            self.MiddleCountLbl.text = "2"
            self.MiddleInstImageView.isHidden = true
            self.RootProfileImageVIew.alpha = 0.5
            self.RootBackGroundImageView.alpha = 0.5
            self.RootInstImageView.alpha = 0.5
            
            self.TopProfileImageVIew.load(url: URL(string: lastUserImageView))
            self.TopInstImageView.load(url: URL(string: lastUserImageView))
            self.RootProfileImageVIew.load(url: URL(string: prevStackers[beforeStackCnt-1]?.profileImgUrl ?? " "))
            self.RootInstImageView.load(url: URL(string: prevStackers[beforeStackCnt-1]?.instruments[0].imgUrl ?? " "))
            break
            
        case 5:
            self.MiddleUserNameLbl.isHidden = true
            self.MiddleBackGroundImageView.image = UIImage.init(named: "ProfileBackgroundGrey")
            self.RootUserNameLbl.isHidden = true
            self.RootBackGroundImageView.image = UIImage.init(named: "ProfileBackgroundGrey")
            self.MiddleProfileImageView.isHidden = true
            self.MiddleCountLbl.text = "3"
            self.MiddleInstImageView.isHidden = true
            self.RootProfileImageVIew.alpha = 0.5
            self.RootBackGroundImageView.alpha = 0.5
            self.RootInstImageView.alpha = 0.5

            self.TopProfileImageVIew.load(url: URL(string: lastUserImageView))
            self.TopInstImageView.load(url: URL(string: lastUserImageView))
            self.RootProfileImageVIew.load(url: URL(string: prevStackers[beforeStackCnt-1]?.profileImgUrl ?? " "))
            self.RootInstImageView.load(url: URL(string: prevStackers[beforeStackCnt-1]?.instruments[0].imgUrl ?? " "))
            break
        case 6:
            self.MiddleUserNameLbl.isHidden = true
            self.MiddleBackGroundImageView.image = UIImage.init(named: "ProfileBackgroundGrey")
            self.RootUserNameLbl.isHidden = true
            self.RootBackGroundImageView.image = UIImage.init(named: "ProfileBackgroundGrey")
            self.MiddleProfileImageView.isHidden = true
            self.MiddleCountLbl.text = "4"
            self.MiddleInstImageView.isHidden = true
            self.RootProfileImageVIew.alpha = 0.5
            self.RootBackGroundImageView.alpha = 0.5
            self.RootInstImageView.alpha = 0.5
            
            self.TopProfileImageVIew.load(url: URL(string: lastUserImageView))
            self.TopInstImageView.load(url: URL(string: lastUserImageView))
            self.RootProfileImageVIew.load(url: URL(string: prevStackers[beforeStackCnt-1]?.profileImgUrl ?? " "))
            self.RootInstImageView.load(url: URL(string: prevStackers[beforeStackCnt-1]?.instruments[0].imgUrl ?? " "))
            break
            
        default:
            print("1~6 정수값만 가능")
            break
        }
        
    }
    */
    
    @IBAction func MiddleButtonTapped(_ sender: Any) {
        if beforeStackCnt >= 3 {
            self.delegate?.middleButtonTapped()
        }
    }
    
    
    // 추후 손봐야. 닉네임만 필요함
    // post 만들었을 때 하기
    /*
    @objc func navigateToProfilePage(){
        guard let post = post else { return }
        delegate?.navigateToProfilePage(uid: post.autherName, name: post.autherID)
    }
    */
}

