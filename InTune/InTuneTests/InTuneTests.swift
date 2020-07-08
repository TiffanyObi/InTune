//
//  InTuneTests.swift
//  InTuneTests
//
//  Created by Tiffany Obi on 5/26/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import XCTest
import FirebaseAuth
@testable import InTune

class InTuneTests: XCTestCase {

    func testNumArtists() {
        //        let expCount = 11
        var artistNum = 0
        let exp = XCTestExpectation(description: "artists found")
        DatabaseService.shared.getArtists { (result) in
            exp.fulfill()
            switch result {
            case .failure(let error):
                XCTFail("error is: \(error)")
            case .success(let artists):
                artistNum = artists.count
                XCTAssert(artistNum > 0)
                //                XCTAssertEqual(expCount, artistNum)
            }
        }
        wait(for: [exp], timeout: 6.0)
    }
    func testFetchArtist() {
        guard let artist = Auth.auth().currentUser else {return}
        let exp = XCTestExpectation(description: "artist found")
        DatabaseService.shared.fetchArtist(userID: artist.uid) { (result) in
            exp.fulfill()
            switch result {
            case .failure(let error):
                XCTFail("\(error)")
            case .success(let artist2):
                XCTAssertEqual(artist.uid, artist2.artistId)
            }
        }
        wait(for: [exp], timeout: 6.0)
    }
    func testVideo() {
        
        let exp = XCTestExpectation(description: "found video")
        let expVid = "https://firebasestorage.googleapis.com/v0/b/intune-4d73e.appspot.com/o/Videos%2FJF4zwB33ilQ6Z5OGMJbwjecuWs02%2F96F0D8E5-ECA4-4FA7-BC79-C66EAAB9B834?alt=media&token=88711ccc-3013-46a4-b0a7-80bc56c051a2"
        DatabaseService.shared.fetchArtist(userID: "JF4zwB33ilQ6Z5OGMJbwjecuWs02") { (result) in
            exp.fulfill()
            switch result {
            case .failure(let error):
                XCTFail("\(error)")
            case .success(let artist2):
                let artist = artist2
                DatabaseService.shared.getVideo(artist: artist) { (result) in
                    switch result {
                    case .failure(let error):
                        XCTFail("no video \(error)")
                    case .success(let videos):
                        if let firstVid = videos.first{
                            XCTAssertEqual(expVid, firstVid.urlString)
                        }
                    }
                }
            }
        }
    }

}
