//
//  PleaseViewController.swift
//  Artistack
//
//  Created by 임영준 on 2022/08/23.
//

import UIKit
import AVFAudio



class PleaseViewController: UIViewController {

    
    var playerView: VideoPlayerView!
    
    @IBOutlet weak var contentVIew: UIView!
    
    
    @IBOutlet weak var please: UILabel!
    @IBOutlet weak var songInfoBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeCountLbl: UILabel!
    @IBOutlet weak var stackBtn: UIButton!
    @IBOutlet weak var stackCountLbl: UILabel!
    @IBOutlet weak var TitleLbl: UILabel!
    @IBOutlet weak var showMore: UIButton!
    @IBOutlet weak var musicInfoCodeLbl: UILabel!
    @IBOutlet weak var musicInfoBpmLbl: UILabel!
    private(set) var isPlaying = false
    
    
    @IBOutlet weak var TopProfileView: UIView!
    @IBOutlet weak var MiddleProfileView: UIView!
    @IBOutlet weak var RootProfileView: UIView!
    
    
    @IBOutlet weak var TopBackGroundImageView: UIImageView!
    @IBOutlet weak var MiddleBackGroundImageView: UIImageView!
    @IBOutlet weak var RootBackGroundImageView: UIImageView!
    
    
    @IBOutlet weak var TopUserNameLbl: UILabel!
    @IBOutlet weak var MiddleUserNameLbl: UILabel!
    @IBOutlet weak var RootUserNameLbl: UILabel!
    
    
    @IBOutlet weak var TopProfileImageVIew: UIImageView!
    @IBOutlet weak var RootProfileImageVIew: UIImageView!
    @IBOutlet weak var MiddleProfileImageView: UIImageView!
    
    @IBOutlet weak var TopInstImageView: UIImageView!
    @IBOutlet weak var MiddleInstImageView: UIImageView!
    @IBOutlet weak var RootInstImageView: UIImageView!
    
    @IBOutlet weak var TopProfileButton: UIButton!
    @IBOutlet weak var MiddleProfileButton: UIButton!
    @IBOutlet weak var RootProfileButton: UIButton!
    
    @IBOutlet weak var MiddleCountLbl: UILabel!
    @IBOutlet weak var BottomLine: UIImageView!
    @IBOutlet weak var TopLine: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //게시물을 보고 있다는 것은 stack이라는 뜻
        RecordingViewController.ISSTACK = true
    
        playerView = VideoPlayerView(frame: UIScreen.main.bounds)
        contentVIew.addSubview(playerView)
//        contentVIew.sendSubviewToBack(playerView)
        playerView.play()
        setTempProfileImage()
        setProfile(stackCount: 1)
        
        TabBarController.actionButton.buttonImage = UIImage(named: "CameraButton")
        TabBarController.actionButton.buttonImageSize = CGSize(width: 48, height: 44)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        TabBarController.actionButton.buttonImage = UIImage(named: "firstRecord")
        TabBarController.actionButton.buttonImageSize = CGSize(width: 54, height: 48)
        playerView.pause()
    }
    
    
    func configure(title: NSURL?, size: (Int,Int)){ //post: Post) {
        playerView.configure(url: title, fileExtension: "mp4", size: size) //(width, Int(safeFrame.height)))//url
    }
    
    func replay(){
        if !isPlaying {
            playerView.replay()
            play()
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
            isPlaying=true
        }
    }
    
    
    private func setTempProfileImage(){
        self.TopProfileImageVIew.addDiamondMask()
        self.MiddleProfileImageView.addDiamondMask()
        self.RootProfileImageVIew.addDiamondMask()
    }
    
    
    private func setProfile(stackCount: Int){
        
        switch stackCount
        {
        case 1:
            self.MiddleProfileView.isHidden = true
            self.TopProfileView.isHidden = true
            self.BottomLine.isHidden = true
            self.TopLine.isHidden = true
            self.MiddleCountLbl.isHidden = true
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
            break
            
        default:
            print("1~6 정수값만 가능")
            break
        }
        
        
    }

    
    
    
}
