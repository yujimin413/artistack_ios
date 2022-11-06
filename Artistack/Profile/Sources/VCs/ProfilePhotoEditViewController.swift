//
//  ProfilePhotoEditViewController.swift
//  Artistack
//
//  Created by 유지민 on 2022/07/28.
//

import UIKit

protocol callProfilePhotoEditVC {
    func profileImageSend(data: UIImage, imgUrl: URL)
}

class ProfilePhotoEditViewController: UIViewController {
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var libraryButton: UIButton!
    
    var delegate: callProfilePhotoEditVC?
    var imgUrl: URL?
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }

    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cameraButtonDidTap(_ sender: Any) {
        picker.sourceType = .camera
        present(picker, animated: false, completion: nil)
    }

    @IBAction func libraryButtonDidTap(_ sender: Any) {
        picker.sourceType = .photoLibrary
        present(picker, animated: false, completion: nil)
    }
}

extension ProfilePhotoEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] {
            if let profileImage = image as? UIImage {
                print("success")
                if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
                    // image from camera
                    let imgName = UUID().uuidString+".jpeg"
                    let documentDirectory = NSTemporaryDirectory()
                    let localPath = documentDirectory.appending(imgName)
                    let data = profileImage.jpegData(compressionQuality: 0.3)! as NSData
                    data.write(toFile: localPath, atomically: true)
                    imgUrl = URL.init(fileURLWithPath: localPath)
                    print(imgUrl)
                }
                else if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
                    // image from library
                    imgUrl = info[UIImagePickerController.InfoKey.imageURL]  as! URL
                    print(imgUrl)
//                    let imageName=imgUrl?.lastPathComponent//파일이름
//                    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//                    let photoURL          = NSURL(fileURLWithPath: documentDirectory)
//                    let localPath         = photoURL.appendingPathComponent(imageName!)//파일경로
//                    let data=NSData(contentsOf: imgUrl as! URL)!
     
                }
                delegate?.profileImageSend(data: profileImage, imgUrl: imgUrl!)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
