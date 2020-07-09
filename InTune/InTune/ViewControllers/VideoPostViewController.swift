//
//  ExtraController2.swift
//  InTune
//
//  Created by Tiffany Obi on 5/27/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class VideoPostViewController: UIViewController {
    
    @IBOutlet private var videoView: DesignableImageView!
    @IBOutlet private var addVidButton: UIButton!
    
    private lazy var imagePickerController: UIImagePickerController = {
        let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
        let pickerController = UIImagePickerController()
        pickerController.videoMaximumDuration = 30.0
        pickerController.allowsEditing = true
        pickerController.isEditing = true
        pickerController.mediaTypes = mediaTypes ?? ["kUTTypeImage"]
        pickerController.delegate = self
        return pickerController
    }()
    let db = DatabaseService.shared
    private var vidURL: URL?
    private var artist: Artist?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addVidButton.shadowLayer(addVidButton)
    }
    
    @IBAction func addPostButtonPressed(_ sender: UIButton) {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    @IBAction func postButtonPressed(_ sender: UIButton) {
        //thumbnail updates to Profile vc cell
        guard let url = vidURL else { return }
        let urlString = url.absoluteString
        // we have the video url
        // 1. convert url to Data
        guard let videoData = try? Data(contentsOf: url) else {
            return
        }
        let vid = Video(title: "", urlString: urlString)
        db.createVideoPosts(post: vid) { (result) in
            switch result {
            case .failure(let error):
                print("could not post media: \(error.localizedDescription)")
            case .success:
                // 2. update Data to Firebase Storage
                StorageService().uploadVideoData(videoData) { (result) in
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
extension VideoPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String else {
            return
        }
        switch mediaType {
        case "public.image":
            print("image picked")
        case "public.movie":
            print("video picked")
            dismiss(animated: true, completion: nil)
            if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
                let image = mediaURL.videoPreviewThumbnail(),
                let imageData = image.jpegData(compressionQuality: 1.0)
            {
                vidURL = mediaURL
                videoView.image = image
            }
        default:
            print("default")
        }
    }
}
extension Data {
    public func convertToURL() -> URL? {
        let tempURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("video").appendingPathExtension("mp4")
        do {
            try self.write(to: tempURL, options: [.atomic])
            return tempURL
        } catch {
            print("failed to write aka save to video data to temporary file error: \(error)")
        }
        return nil
    }
}
extension URL{
    public func videoPreviewThumbnail() -> UIImage? {
        let asset = AVAsset(url: self)
        let assetGenerator = AVAssetImageGenerator(asset: asset)
        assetGenerator.appliesPreferredTrackTransform = true
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        var image: UIImage?
        do {
            let cgImage = try assetGenerator.copyCGImage(at: timestamp, actualTime: nil)
            image = UIImage(cgImage: cgImage)
        } catch {
        }
        return image
    }
}
