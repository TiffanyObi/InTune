//
//  Video.swift
//  InTune
//
//  Created by Tiffany Obi on 6/16/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation
struct Video {
  let artistName: String?
  let videoUrl: String?
    let postId: String
}
extension Video {
  init?(_ dictionary: [String: Any]) {
   // if let title = videoInformation["artistName"] as? String,
    //            let videoURL = videoInformation["videoUrl"] as? String {
    guard let artistName = dictionary["artistName"] as? String,
      let videoUrl = dictionary["videoUrl"] as? String,
    let postId = dictionary["postId"] as? String else {
        return nil
    }
    self.artistName = artistName
    self.videoUrl = videoUrl
    self.postId = postId
  }
}
