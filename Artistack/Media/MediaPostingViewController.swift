//
//  PostMediaViewController.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 10/3/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//




import AVKit
import UIKit




class MediaPostingViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    
    let viewModel = InstImageViewModel()
    
    @IBOutlet weak var projectInfoCount: UILabel!
    @IBOutlet weak var projectTitleCount: UILabel!
    @IBOutlet weak var BPMCount: UILabel!
    @IBOutlet weak var CodeInfoCount: UILabel!
    @IBOutlet weak var ProjectInfoTextView: UITextView!
    @IBOutlet weak var CodeInfoTextField: UITextField!
    @IBOutlet weak var BPMTextField: UITextField!
    @IBOutlet weak var projectTitleTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var publicSwitch: UISwitch!
    @IBOutlet weak var stackAllowSwitch: UISwitch!
    @IBOutlet weak var postingButton: UIButton!
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    @IBOutlet weak var checkbox: UIImageView!
    
    
    
    
    //    @IBOutlet weak var captionTextView: UITextView!
    //    @IBOutlet weak var coverImgView: UIImageView!
    
    var placeholderLabel : UILabel!
    
    // MARK: - Variables
    var videoURL: URL?
    var finalURL: URL?
    var BackgroundVideoSound: URL? = nil
    var isStackable: Bool = true
    var isPublic: String = "PUBLIC"
    var Instrument: Int = 0
    var InstSelected: Bool = false
    
    static var originalVolume : Float = 0.2
    static var addedVolume : Float = 0.2
    
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        
        
        activityMonitor.scaleIndicator(factor: 2)
        activityMonitor.color = .white
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
        
        super.viewDidLoad()
        
        
        self.checkbox.isHidden = true
        self.activityMonitor.layer.zPosition = 2
        self.postingButton.layer.zPosition = 2
        //        self.postingButton.isEnabled = false
        self.ProjectInfoTextView.textContainer.lineFragmentPadding = 0
        self.ProjectInfoTextView.delegate = self
        self.CodeInfoTextField.delegate = self
        self.BPMTextField.delegate = self
        self.projectTitleTextField.delegate = self
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        publicSwitch.onTintColor = UIColor(named: "buttonColor")
        stackAllowSwitch.onTintColor = UIColor(named: "buttonColor")
        self.view.bringSubviewToFront(self.activityMonitor)
        self.activityMonitor.isHidden = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: projectTitleTextField)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextView.textDidChangeNotification,
                                               object: ProjectInfoTextView)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: BPMTextField)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange(_:)),
                                               name: UITextField.textDidChangeNotification,
                                               object: CodeInfoTextField)
        
        
        
        
        self.thumbnailImageView.image = createVideoThumbnail(from: videoURL!)
        
        
        
        //MARK: 네비게이션 바 커스텀
        //        let yourBackImage = UIImage(named: "backButton")
        //         self.navigationController?.navigationBar.tintColor = .white//.blue as you required
        //         self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
        //         self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
        self.navigationItem.leftItemsSupplementBackButton = true
        self.navigationController?.navigationBar.topItem?.title = ""
        
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.text = "게시하기"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        let title = UIBarButtonItem.init(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = title
        
        
        self.navigationController?.view.tintColor = .white
        self.collectionView.register(UINib(nibName: "InstCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell2")
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        view.bringSubviewToFront(postingButton)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        RecordingViewController.ISSTACK = false
    }
    
    // MARK: - Setup
    func setupView(){
        //        let dismissKeybordGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //        view.addGestureRecognizer(dismissKeybordGesture)
        placeholderLabel = UILabel()
        placeholderLabel.text = "연주에 대해 설명해주세요."
        placeholderLabel.font = UIFont.systemFont(ofSize: (ProjectInfoTextView.font?.pointSize)!)
        ProjectInfoTextView.addSubview(placeholderLabel)
        placeholderLabel.textColor = UIColor.init(named: "textColor")
        placeholderLabel.isHidden = !ProjectInfoTextView.text.isEmpty
        placeholderLabel.sizeToFit()
        placeholderLabel.frame.origin = CGPoint(x: 0, y: (ProjectInfoTextView.font?.pointSize)! / 2)
    }
    
    
    func fillIfStack(){
        if(RecordingViewController.ISSTACK == true){
            self.projectTitleTextField.text = RecordingViewController.Title
            self.projectTitleTextField.isEnabled = false
            self.CodeInfoTextField.text = RecordingViewController.CodeFlow
            self.BPMTextField.text = RecordingViewController.BPM
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    private func createVideoThumbnail(from url: URL) -> UIImage? {
        
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
        
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        // 한 글자 입력할 때마다 실행
        // 글자수 세기
        activatePostingButton()
        
        self.projectTitleCount.text = "\(self.projectTitleTextField.text!.count)"
        
        self.BPMCount.text = "\(self.BPMTextField.text!.count)"
        
        self.CodeInfoCount.text = "\(self.CodeInfoTextField.text!.count)"
        
        self.projectInfoCount.text = "\(self.ProjectInfoTextView.text!.count)"
        
        
        if let textField = notification.object as? UITextField {
            // nicknameTextField
            if let text = projectTitleTextField.text {
                // 초과되는 텍스트 제거
                if text.count >= 18 {
                    let index = text.index(text.startIndex, offsetBy: 17)
                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                }
                
                //            }
                else {
                    //              nicknameWarningbox.isHidden = true
                    //              setContraints()
                    //              saveButton.setImage(saveButtonAbledImage, for: .normal)
                    //              saveButton.isEnabled = true
                }
            }
            if let text = BPMTextField.text{
                if text.count >= 26 {
                    let index = text.index(text.startIndex, offsetBy: 25)
                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                }
                
            }
            
            if let text = CodeInfoTextField.text{
                if text.count >= 26 {
                    let index = text.index(text.startIndex, offsetBy: 25)
                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                }
                
            }
        }
        
        
        // introTextView
        else if let textView = notification.object as? UITextView {
            if let text = ProjectInfoTextView.text {
                // 38글자 넘어가면 자동으로 키보드 내려감
                if text.count >= 48 {
                    textView.resignFirstResponder()
                }
                else {
                    //              saveButton.setImage(saveButtonAbledImage, for: .normal)
                    //              saveButton.isEnabled = true
                }
            }
        }
        
        
        
        
        
        
    }
    
    
    func activatePostingButton(){
        if (projectTitleTextField == nil || projectTitleTextField.text!.count == 0 || InstSelected == false) {
            //            self.checkbox.isHidden = false
            postingButton.setImage(UIImage(named: "PostingUnactivatedButton"), for: .normal)
            //            postingButton.isEnabled = false
            
        }
        else{
            self.checkbox.isHidden = true
            postingButton.setImage(UIImage(named: "PostingButton"), for: .normal)
            //        postingButton.isEnabled = true
        }
        
    }
    
    
    @IBAction func PublicSwitchChanged(_ sender: Any) {
        if stackAllowSwitch.isOn == true{
            isStackable = true
        }
        else{
            isStackable = false
        }
    }
    
    
    
    @IBAction func StackSwitchChanged(_ sender: Any) {
        if publicSwitch.isOn == true{
            isPublic = "PUBLIC"
        }
        else{
            isPublic = "PRIVATE"
        }
    }
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        BPMTextField.resignFirstResponder()
        CodeInfoTextField.resignFirstResponder()
        projectTitleTextField.resignFirstResponder()
        ProjectInfoTextView.resignFirstResponder()
        return true
    }
    
    
    @IBAction func postingButtonTapped(_ sender: Any) {
        
        
        print("tapped")
        
        if(projectTitleTextField == nil || projectTitleTextField.text!.count == 0)
        {
            checkbox.isHidden = false
        }
        else if(InstSelected == false)
        {
            checkbox.isHidden = false
        }
        else
        {
            
            if(RecordingViewController.ISSTACK == true)
            {
                print("믹싱 전송/스택")
                print("볼륨확인\(MediaPostingViewController.originalVolume)")
                print("볼륨확인\(MediaPostingViewController.addedVolume)")
                mergeFilesWithUrl(videoUrl: videoURL!, videoVolume: Float(MediaPostingViewController.addedVolume),
                                  audioUrl: BackgroundVideoSound!, audioVolume: Float(MediaPostingViewController.originalVolume),
                                  completion: {(mixURL, error)-> () in let mixURL2 = mixURL;
                    
                    let videoRecorded = mixURL2;
                    self.finalURL = videoRecorded!
                    UISaveVideoAtPathToSavedPhotosAlbum(videoRecorded!.path, nil, nil, nil)
                    
                    let input = dto(title: self.projectTitleTextField.text!,
                                    description: self.ProjectInfoTextView.text,
                                    bpm: self.BPMTextField.text,
                                    codeFlow: self.CodeInfoTextField.text,
                                    instrumentIds: [self.Instrument + 1],
                                    scope: self.isPublic,
                                    isStackable: self.isStackable)
                    PostingUploadDataManager().posting(imageURL: self.finalURL, parameter: input)
                }
                )
            }
            else
            {
                self.activityMonitor.isHidden = false
                self.activityMonitor.startAnimating()
                print("그냥 전송/노스택")
                let input = dto(title: self.projectTitleTextField.text!,
                                description: self.ProjectInfoTextView.text,
                                bpm: self.BPMTextField.text,
                                codeFlow: self.CodeInfoTextField.text,
                                instrumentIds: [self.Instrument + 1],
                                scope: self.isPublic,
                                isStackable: self.isStackable)
                PostingUploadDataManager().posting(imageURL: self.videoURL, parameter: input)
                self.activityMonitor.stopAnimating()
                self.dismiss(animated: true)
                
            }
        }
    }
    
    
    
    
    @objc
    private func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
    
    
    @objc func publishPost(){
        //        // Disable the buttion to prevent duplicate posts
        ////        postBtn.isUserInteractionEnabled = false
        ////        if let url = videoURL {
        ////            let caption = captionTextView.text ?? ""
        ////            MediaViewModel.shared.postVideo(videoURL: url, caption: caption, success: { message in
        ////                print(message)
        ////                self.postBtn.isUserInteractionEnabled = true
        ////                self.dismiss(animated: true, completion: nil)
        ////            }, failure: { error in
        ////                self.showAlert(error.localizedDescription)
        //            })
        //        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func mergeFilesWithUrl(videoUrl: URL, videoVolume: Float, audioUrl: URL, audioVolume: Float, completion: @escaping (URL?, Error?) -> Void) {
        
        self.activityMonitor.isHidden = false
        self.activityMonitor.startAnimating()
        
        //비디오와 오디오 트랙을 잠시 저장해둘 곳
        let mixComposition: AVMutableComposition = AVMutableComposition()
        
        var mutableCompositionVideoTrack: [AVMutableCompositionTrack] = []
        var mutableCompositionAudioTrack: [AVMutableCompositionTrack] = []
        var mutableCompositionAudioOfVideoTrack: [AVMutableCompositionTrack] = []
        let totalVideoCompositionInstruction: AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()
        
        
        let aVideoAsset: AVAsset = AVAsset(url: videoUrl)
        let aAudioAsset: AVAsset = AVAsset(url: audioUrl)
        
        
        
        
        
        
        let videoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        
        mutableCompositionVideoTrack.append(videoTrack!) // 비디오 트랙 추가
        mutableCompositionAudioTrack.append(mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!)  // 오디오 트랙 추가
        mutableCompositionAudioOfVideoTrack.append(mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!) // 비디오의 오디오 트랙 추가
        
        
        
        
        
        
        
        guard
            let aVideoAssetTrack: AVAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.video).first
        else {print("여기가 존나 안됨")
            return }
        
        
        videoTrack?.preferredTransform = aVideoAssetTrack.preferredTransform
        
        //insertTimeRange로 각 트랙의 어떤 부분까지 넣을지 정한다.
        do {
            
            try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: aVideoAssetTrack.timeRange.duration), of: aVideoAssetTrack, at: CMTime.zero)
            
        } catch {
            print("Failed to load second track")
        }
        
        
        
        let audioMix: AVMutableAudioMix = AVMutableAudioMix()
        var audioMixParam: [AVMutableAudioMixInputParameters] = []
        
        guard
            let aVideoAudioAssetTrack: AVAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.audio).first,
            let aAudioAssetTrack: AVAssetTrack = aAudioAsset.tracks(withMediaType: AVMediaType.audio).first
        else {
            print("여기가 존나 22")
            return }
        
        
        let videoParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: aVideoAudioAssetTrack)
        videoParam.trackID = aVideoAudioAssetTrack.trackID
        let audioParam: AVMutableAudioMixInputParameters = AVMutableAudioMixInputParameters(track: aAudioAssetTrack)
        audioParam.trackID = aAudioAssetTrack.trackID
        
        
        
        videoParam.setVolume(videoVolume, at: CMTime.zero) //작동하는데 오디오소리가 조절되
        audioParam.setVolume(audioVolume, at: CMTime.zero) //작동안함
        
        
        
        audioMixParam.append(videoParam)
        audioMixParam.append(audioParam)
        
        
        
        do {
            try mutableCompositionAudioOfVideoTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: aVideoAssetTrack.timeRange.duration), of: aVideoAudioAssetTrack, at: CMTime.zero)
        } catch {
            print("Failed to load second track")
        }
        
        do {
            try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: aVideoAssetTrack.timeRange.duration), of: aAudioAssetTrack, at: CMTime.zero)
        } catch {
            print("Failed to load second track")
        }
        
        print(audioMixParam.count)
        audioMix.inputParameters = audioMixParam
        
        
        let mutableVideoComposition: AVMutableVideoComposition = AVMutableVideoComposition()
        mutableVideoComposition.instructions = [totalVideoCompositionInstruction]
        mutableVideoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        //            mutableVideoComposition.renderSize = CGSize(width: 720, height: 1280)//CGSize(1280,720)
        
        
        //비디오 경로를 설정
        let savePathUrl: NSURL = NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/newVideo.mp4")
        do { // delete old video
            try FileManager.default.removeItem(at: savePathUrl as URL)
        } catch {
            print(error.localizedDescription)
        }
        
        
        
        //비디오를 rendering하고 export
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!
        assetExport.outputFileType = AVFileType.mp4
        assetExport.outputURL = savePathUrl as URL
        assetExport.shouldOptimizeForNetworkUse = true
        assetExport.audioMix = audioMix
        
        
        assetExport.exportAsynchronously {
            DispatchQueue.main.async {
                switch assetExport.status {
                case AVAssetExportSession.Status.completed:
                    self.activityMonitor.stopAnimating()
                    print("success")
                    self.dismiss(animated: true)
                    completion(assetExport.outputURL, nil)
                case AVAssetExportSession.Status.failed:
                    print("failed \(String(describing: assetExport.error))")
                    completion(nil, assetExport.error)
                case AVAssetExportSession.Status.cancelled:
                    print("cancelled \(String(describing: assetExport.error))")
                    completion(nil, assetExport.error)
                default:
                    print("complete")
                }
            }
            
        }
    }
    
}




extension MediaPostingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return viewModel.countOfImageList
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.section) 셀의 \(indexPath.row) 번째 게시글 clicked")
        Instrument = indexPath.row
        InstSelected = true
        activatePostingButton()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as?
                InstCollectionViewCell  else {
            return UICollectionViewCell()
        }
        
        let imageInfo = viewModel.imageInfo(at: indexPath.item) // indexPath.item을 기준으로 뷰모델에서 ImageInfo 가져옴
        cell.update(info: imageInfo) // 해당 셀을 업데이트
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let interval:CGFloat = 3
        let width: CGFloat = (collectionView.bounds.width - interval * 2) / 3
        let height: CGFloat = (collectionView.bounds.height - interval * 1) / 2
        return CGSize(width: width, height: height)
        
    }
    // item간 Spacing(열간 간격)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return CGFloat(3)
    }
    
    // line간 Spacing(행간 간격)
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return CGFloat(3)
    }
}


extension UIActivityIndicatorView {
    func scaleIndicator(factor: CGFloat) {
        transform = CGAffineTransform(scaleX: factor, y: factor)
    }
}




