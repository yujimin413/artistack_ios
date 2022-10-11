//
//  RecordingViewController.swift
//  VideoRecordingPractice
//
//  Created by 태우 on 2020/03/24.
//  Copyright © 2020 taewoo. All rights reserved.
//

import AVFoundation
import UIKit
import AVKit
import RxCocoa
import RxSwift
import CoreMotion
import Then
import SnapKit




// TODO: 녜한테 받아서 해야할 것
// 지금 보고 있는 video url, title 받기



class RecordingViewController: UIViewController {
    
    // MARK:- Properties
    
    
    
    @IBOutlet weak var CountdownTimeLabel: UILabel!
    @IBOutlet weak var recordLengthLabel: UILabel!
    @IBOutlet weak var recordTimerLabel: UILabel!
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var playerExitButton: UIButton!
    @IBOutlet weak var recordingTimeView: UIView!
    @IBOutlet weak var BGMTitleLabel: UILabel!
    @IBOutlet weak var ArtistackonLabel: UILabel!
    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var volumeCtrlButton: UIButton!
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    static var playerView: MediaPlayerView?
    
    
    
    //MARK: 여기야 녜!!!!!!!!!!!!!
    static var IsStackable: Bool?
    static var VideoURL: String?
    static var Title: String?
    static var sontTitle: String?
    static var BPM: String?
    static var CodeFlow: String?
    static var ProjectID: String?
    //MARK: @@@@@@@@@@@@@@@@@@@@@@
    
    
    
    
    
    static var ISSTACK:Bool?
    
    
    //    static var AudioPlayer = AVAudioPlayer()
    static var AudioPlayer = AVPlayer()
    var AudioPlayer2 = AVAudioPlayer()
    
    
    //    var BackgroundVideoSound : URL = URL(string: "https://artistack-bucket.s3.ap-northeast-2.amazonaws.com/video/5dd5e300-71b7-460d-9dcf-01c3e46cc11a.mp4")!
    //    var BackgroundURLString : String = "https://artistack-bucket.s3.ap-northeast-2.amazonaws.com/video/5dd5e300-71b7-460d-9dcf-01c3e46cc11a.mp4"
    
    //
    //    var BackgroundVideoSound : URL = URL(string: RecordingViewController.VideoURL!)!
    //    var BackgroundURLString : String = RecordingViewController.VideoURL!
    
    
    var BackgroundVideoSound : URL!
    var BackgroundURLString : String!
    
    var fileDestinationUrl: URL?
    var timer: Timer?
    var timer2:Timer?
    var timeLeft = 0
    var timerTapCount = 0
    
    
    
    
    var disposeBag = DisposeBag()
    
    
    let captureSession = AVCaptureSession()
    var videoDevice: AVCaptureDevice!
    var videoInput: AVCaptureDeviceInput!
    var audioInput: AVCaptureDeviceInput!
    
    var videoOutput: AVCaptureMovieFileOutput!
    lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession).then {
        $0.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        $0.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        $0.videoGravity = .resizeAspectFill
    }
    
    
    var outputURL: URL?
    var mixURL2: URL?
    
    
    var secondsOfTimer = 0
    var recordTime = 0
    
    // MARK:- LifeCycle Methods
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setISSTACK()
        if !captureSession.isRunning {
            captureSession.startRunning()
            BGMTitleLabel.text = RecordingViewController.Title
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    func setISSTACK(){
        if(RecordingViewController.ISSTACK==true){
            RecordingViewController.ISSTACK=true
        }
        else{
            RecordingViewController.ISSTACK=false
        }
    }
    
    
    func setBGMIFSTACK(){
        if(RecordingViewController.ISSTACK == true ){
            BackgroundVideoSound = URL(string: RecordingViewController.VideoURL!)!
            BackgroundURLString = RecordingViewController.VideoURL!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBGMIFSTACK()
        setBGM()
        layout()
        setRecordLength()
        bind()
        videoDevice = bestDevice(in: .back)
        setupSession()
    }
    
    
    
    private func layout() {
        self.view.layer.addSublayer(previewLayer)
        self.view.addSubview(topContainer)
        self.recordingTimeView.isHidden = true
        CountdownTimeLabel.isHidden = true
        
        //스택이 아닐 때 UI세팅
        if(RecordingViewController.ISSTACK == false){
            self.ArtistackonLabel.isHidden = true
            self.BGMTitleLabel.isHidden = true
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK:- Rx Binding
    
    private func bind() {
        
        
        recordButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                
                
                if(RecordingViewController.ISSTACK == false){
                    print("노스택촬영")
                    if self.videoOutput.isRecording {
                        self.stopRecording()
                        print("노스택촬영멈춤")
                        self.audioinit()
                        self.recordButton.setImage( UIImage(named: "RecordButton"), for: .normal)
                    }
                    
                    else {
                        print("노스택촬영시작")
                        let seconds = 0.0
                        self.recordButton.isEnabled = false
                        self.timerButton.isHidden = true
                        self.swapButton.isHidden = true
                        self.BGMTitleLabel.isHidden = true
                        self.ArtistackonLabel.isHidden = true
                        self.timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onTimerFires), userInfo: nil, repeats: true)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.timeLeft)){
                            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                self.startRecording()
                            }
                            self.recordButton.setImage( UIImage(named: "StopButton"), for: .normal)
                            self.recordingTimeView.isHidden = false
                        }
                    }
                }
                
                else{ //스택촬영일때
                    print("스택촬영")
                    print(self.timerTapCount)
                    // 촬영중일때
                    if self.videoOutput.isRecording  {
                        self.stopRecording()
                        self.audioinit()
                        self.recordButton.setImage( UIImage(named: "RecordButton"), for: .normal)
                    }
                    
                    //촬영중이 아닐때 버튼 탭 = 촬영시작
                    else {
                        let seconds = 0.25
                        self.recordButton.isEnabled = false
                        self.timerButton.isHidden = true
                        self.swapButton.isHidden = true
                        self.BGMTitleLabel.isHidden = true
                        self.ArtistackonLabel.isHidden = true
                        self.timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.onTimerFires), userInfo: nil, repeats: true)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(self.timeLeft)){
                            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                                self.startRecording()
                            }
                            RecordingViewController.AudioPlayer.volume = 0.5
                            RecordingViewController.AudioPlayer.play()
                            self.recordButton.setImage( UIImage(named: "StopButton"), for: .normal)
                            self.recordingTimeView.isHidden = false
                        }
                        
                    }
                }
                
            })
            .disposed(by: self.disposeBag)
        
        
        
        swapButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                self.swapCameraType()
            })
            .disposed(by: self.disposeBag)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    private func setupSession() {
        do {
            captureSession.beginConfiguration()
            videoInput = try AVCaptureDeviceInput(device: videoDevice!)
            if captureSession.canAddInput(videoInput) {
                captureSession.addInput(videoInput)
            }
            
            let audioDevice = AVCaptureDevice.default(for: AVMediaType.audio)!
            audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if captureSession.canAddInput(audioInput) {
                captureSession.addInput(audioInput)
            }
            
            videoOutput = AVCaptureMovieFileOutput()
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            }
            
            captureSession.commitConfiguration()
        }
        catch let error as NSError {
            NSLog("\(error), \(error.localizedDescription)")
        }
    }
    
    
    
    
    private func bestDevice(in position: AVCaptureDevice.Position) -> AVCaptureDevice {
        var deviceTypes: [AVCaptureDevice.DeviceType]!
        
        if #available(iOS 11.1, *) {
            deviceTypes = [.builtInTrueDepthCamera, .builtInDualCamera, .builtInWideAngleCamera]
        } else {
            deviceTypes = [.builtInDualCamera, .builtInWideAngleCamera]
        }
        
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: deviceTypes,
            mediaType: .video,
            position: .unspecified
        )
        
        let devices = discoverySession.devices
        guard !devices.isEmpty else { fatalError("Missing capture devices.")}
        return devices.first(where: { device in device.position == position })!
    }
    
    
    
    private func swapCameraType() {
        guard let input = captureSession.inputs.first(where: { input in
            guard let input = input as? AVCaptureDeviceInput else { return false }
            return input.device.hasMediaType(.video)
        }) as? AVCaptureDeviceInput else { return }
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        // Create new capture device
        var newDevice: AVCaptureDevice?
        if input.device.position == .back {
            newDevice = bestDevice(in: .front)
        } else {
            newDevice = bestDevice(in: .back)
        }
        
        do {
            videoInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch let error {
            NSLog("\(error), \(error.localizedDescription)")
            return
        }
        
        // Swap capture device inputs
        captureSession.removeInput(input)
        captureSession.addInput(videoInput!)
    }
    
    
    // MARK: Recording Methods
    private func startRecording() {
        outputURL = tempURL()
        videoOutput.movieFragmentInterval = CMTime.invalid
        videoOutput.startRecording(to: outputURL!, recordingDelegate: self)
        self.startTimer()
    }
    
    private func stopRecording() {
        if videoOutput.isRecording {
            self.stopTimer()
            videoOutput.stopRecording()
        }
    }
    
    
    private func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    
    
    // MARK: 시간
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let `self` = self else { return }
            
            self.secondsOfTimer += 1
            
            self.recordTimerLabel.text = Double(self.secondsOfTimer).format(units: [.minute, .second])
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        self.secondsOfTimer = 0
        self.recordTimerLabel.text = "00:00"
    }
    
    
    func getDataFrom(url: String) -> Data? {
        var data: Data?
        if let url = URL(string: url) {
            do {
                data = try Data(contentsOf: url)
            } catch {
                print("Failed to get data from url. error = \(error.localizedDescription)")
            }
        }
        return data
    }
    
    
    @objc func onTimerFires()
    {
        CountdownTimeLabel.isHidden = false
        recordButton.isEnabled = false
        timeLeft -= 1
        CountdownTimeLabel.text = "\(timeLeft)"
        if timeLeft <= 0 {
            timer2?.invalidate()
            timer2 = nil
            CountdownTimeLabel.isHidden = true
            recordButton.isEnabled = true
        }
    }
    
    
    
    private func presentPlayerView(){
        if let url = outputURL {
            RecordingViewController.playerView = MediaPlayerView(frame: previewLayer.frame, videoURL: url)
            view.addSubview(RecordingViewController.playerView!)
            view.bringSubviewToFront(playerExitButton)
            view.bringSubviewToFront(completeButton)
            view.bringSubviewToFront(retakeButton)
            view.bringSubviewToFront(replayButton)
            view.bringSubviewToFront(volumeCtrlButton)
            RecordingViewController.playerView?.play()
            RecordingViewController.AudioPlayer.play()
        }
    }
    
    
    
    @objc func dismissController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func volumeCtrlButtonTapped(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Media", bundle: nil)
        let popupVC = storyBoard.instantiateViewController(identifier: "VolumeVC")
        popupVC.modalPresentationStyle = .overCurrentContext    //  투명도가 있으면 투명도에 맞춰서 나오게 해주는 코드(뒤에있는 배경이 보일 수 있게)
        self.present(popupVC, animated: false, completion: nil)
    }
    
    
    @IBAction func exitButtonTapped(_ sender: Any) {
        RecordingViewController.AudioPlayer.pause()
        dismissController()
    }
    
    @IBAction func playerExitButtonTapped(_ sender: Any) {
        RecordingViewController.AudioPlayer .pause()
        dismissController()
    }
    
    
    @IBAction func retakeButtonTapped(_ sender: Any) {
        
        self.timerButton.isHidden = false
        self.swapButton.isHidden = false
        self.BGMTitleLabel.isHidden = false
        self.ArtistackonLabel.isHidden = false
        self.recordingTimeView.isHidden = true
        
        RecordingViewController.playerView?.pause()
        RecordingViewController.playerView?.removeFromSuperview()
        audioinit()
        
        
        view.sendSubviewToBack(playerExitButton)
        view.sendSubviewToBack(completeButton)
        view.sendSubviewToBack(retakeButton)
        view.sendSubviewToBack(replayButton)
        view.sendSubviewToBack(volumeCtrlButton)
    }
    
    @IBAction func replayButtonTapped(_ sender: Any) {
        RecordingViewController.playerView?.replay()
        RecordingViewController.AudioPlayer.pause()
        RecordingViewController.AudioPlayer.play()
        
    }
    
    func setBGM(){
        if(RecordingViewController.ISSTACK == true){
            
            
            RecordingViewController.AudioPlayer = AVPlayer(url: BackgroundVideoSound)
            
            //        do {
            //            try RecordingViewController.AudioPlayer = AVAudioPlayer(data: getDataFrom(url: BackgroundURLString)!)
            //            } catch {
            //                print(error)
            //            }
        }
    }
    
    
    
    
    
    
    @IBAction func timerButtonTapped(_ sender: Any) {
        timerTapCount += 1
        switch timerTapCount{
        case 1:
            timerButton.setImage(UIImage(named: "Timer3"), for: .normal)
            timeLeft = 4
            break
        case 2:
            timerButton.setImage(UIImage(named: "Timer5"), for: .normal)
            timeLeft = 6
            break
        case 3:
            timerButton.setImage(UIImage(named: "Timer10"), for: .normal)
            timeLeft = 11
            break
        case 4:
            timerButton.setImage(UIImage(named: "TimerButton"), for: .normal)
            timeLeft = 0
            timerTapCount = 0
            break
        default:
            timeLeft = 0
            break
        }
        
        
        
        
    }
    
    @IBAction func navigateToPosting(_ sender: Any) {
        let vc = UIStoryboard(name: "Media", bundle: nil).instantiateViewController(identifier: "MediaPostingVC") as! MediaPostingViewController
        vc.videoURL = outputURL
        vc.BackgroundVideoSound = BackgroundVideoSound
        RecordingViewController.playerView?.pause()
        RecordingViewController.AudioPlayer.pause()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func audioinit(){
        if(RecordingViewController.ISSTACK == true){
            RecordingViewController.AudioPlayer.pause()
            RecordingViewController.AudioPlayer = AVPlayer(url: BackgroundVideoSound)}
        //        RecordingViewController.AudioPlayer.currentTime = 0
    }
    
    
    
    private func setRecordLength(){
        if(RecordingViewController.ISSTACK == true){
            let asset = AVAsset(url: self.BackgroundVideoSound)
            let duration = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            recordTime = Int(durationTime)
            let minutes = Int((durationTime.truncatingRemainder(dividingBy: 3600)) / 60)
            let seconds = Int(durationTime.truncatingRemainder(dividingBy: 60))
            let videoDuration = String(format: "%02i:%02i", minutes, seconds)
            self.recordLengthLabel.text = videoDuration
        }
        else{
            let videoDuration = String(format: "%02i:%02i", 1, 0)
            self.recordLengthLabel.text = videoDuration
            
        }
    }
}











extension RecordingViewController: AVCaptureFileOutputRecordingDelegate {
    
    // 레코딩이 시작되면 호출
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        
    }
    
    // 레코딩이 끝나면 호출
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
        presentPlayerView()
        
        if (error != nil) {
            print("Error recording movie: \(error!.localizedDescription)")
        }
    }
}




extension Double {
    func format(units: NSCalendar.Unit) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = units
        formatter.zeroFormattingBehavior = [ .pad ]
        
        return formatter.string(from: self)!
    }
}



