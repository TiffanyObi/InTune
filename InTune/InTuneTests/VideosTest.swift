//
//  VideosTest.swift
//  InTuneTests
//
//  Created by Christian Hurtado on 6/11/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import XCTest
@testable import InTune
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class VideosTest: XCTestCase {

    func testCreateVideoDocumentForArtists() {
        let artistId = "73UyY4iR6GgqUw9wnrcq4KCXUXC3"
        let videoDict: [String: Any] = ["createDate": Date(),
                                        "artistId": artistId
        ]
        let exp = XCTestExpectation(description: "video document created")
        
        let documentRef = Firestore.firestore().collection("artists").document(artistId).collection("videos").document()
        Firestore.firestore().collection("artists").document(artistId).collection("videos").document(documentRef.documentID).setData(videoDict) { error in
            
            exp.fulfill()
            if let error = error {
                XCTFail("failed to create video document with error \(error.localizedDescription)")
            }
            XCTAssertTrue(true)
        }
        
        wait(for: [exp], timeout: 4.0)
    }

}
