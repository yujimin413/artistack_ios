//
//  PostCollectionViewCell.swift
//  Artistack
//
//  Created by 유지민 on 2022/07/21.
//

import UIKit
import SnapKit
import Kingfisher
import AVKit


class PostCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCollectionViewCell"

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var playCounts: UILabel!
    @IBOutlet weak var stackCounts: UILabel!
    @IBOutlet weak var likeCounts: UILabel!
    
    var postId : Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        postImageView.layer.cornerRadius = 10   // 모서리 둥글게
    }
    
//    "id": 3,
//    "videoUrl": "https://artistack-bucket.s3.ap-northeast-2.amazonaws.com/video/dbf547f8-f417-41fa-bad7-0f194e3a3d39.mp4",
//    "viewCount": 0 // 조회수
//    "likeCount": 0,
//    "stackCount": 0
    
    public func setupData(_ postId: Int?, _ videoUrlStr: String?, _ viewCount: Int?, _ likeCount: Int?, _ stackCount: Int?) {
        // 각 게시글 셀의 데이터 (썸네일 이미지, 조회수, 좋아요수, 스택수)
        
        // 썸네일 이미지
        guard let videoUrlStr = videoUrlStr else { return }
        if let videoUrl = URL(string: videoUrlStr) {
            
            self.postImageView.image = createVideoThumbnail(from: videoUrl)
//            self.postImageView.kf.setImage(with: AVAssetImageDataProvider(assetURL: videoUrl, seconds: 1))
        }
//        if let videoUrl = URL(string: videoUrlStr) {
//            let thumbnailImg = createVideoThumbnail(from: videoUrl)
//            postImageView.kf.setImage(with: thumbnailImg)
//        }
        
        // 프로젝트아이디
        guard let postId = postId else { return }
        self.postId = postId

        
        // 조회수
        guard let viewCount = viewCount else { return }
        self.playCounts.text = "\(viewCount)"

        
        // 좋아요수
        guard let likeCount = likeCount else { return }
        self.likeCounts.text = "\(likeCount)"
        
        // 스택수
        guard let stackCount = stackCount else { return }
        self.stackCounts.text = "\(stackCount)"
            
    }
//    self.thumbnailImageView.image = createVideoThumbnail(from: videoURL!)

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
    
    
}



 
