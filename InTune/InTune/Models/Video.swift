//
//  Video.swift
//  InTune
//
//  Created by Tiffany Obi on 6/16/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation
struct Video {
  let title: String?
  let urlString: String?
}
extension Video {
  init?(_ dictionary: [String: Any]) {
   // if let title = videoInformation["artistName"] as? String,
    //            let videoURL = videoInformation["videoUrl"] as? String {
    guard let title = dictionary["artistName"] as? String,
      let urlString = dictionary["videoUrl"] as? String else {
        return nil
    }
    self.title = title
    self.urlString = urlString
  }
}
