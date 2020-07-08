# InTune: Connect with Artist

Winning 6-week Capstone Project: Won the 'Best In Class App' award, awarded by staff from the Capital One team. 

## About

InTune is an app where artists can show off their skills and make a living. InTune connects artists and enthusiasts, creating a virtual community and a networking system.

Artists and enthusiasts need to create an account and give us some basic information about themselves and their interests. Artists can post videos, like other artists as well as collaborate with other artists. All users can like their favorite artists. Artists can chat with other artists. Enthusiasts can chat with artists. Everyone can post gigs, to find artists for their private events.

## Features

**Liked Artist Tab**

<img src="DemoExamples/LA.png" width="300">

**Gigs Tab**

<img src="DemoExamples/GT.png" width="300">
<img src="DemoExamples/PG.png" width="300">
<img src="DemoExamples/GD.png" width="300">

## Demo

**Find artists using tags**

![gif](DemoExamples/TagsExplore.gif)

**Starting a chat with an artist**

![gif](DemoExamples/Chat.gif)

**Posting Videos**

![intune-videogif-p1](https://user-images.githubusercontent.com/55755297/86839904-06bad880-c070-11ea-9291-5f1b0ffed1a5.gif)
![intune-videogif-p2](https://user-images.githubusercontent.com/55755297/86839910-091d3280-c070-11ea-818a-fa2185e3a33c.gif)
![intune-videogif-p3](https://user-images.githubusercontent.com/55755297/86839916-0cb0b980-c070-11ea-8c77-b39b55d6471a.gif)
![intune-videogif-p4](https://user-images.githubusercontent.com/55755297/86841107-84cbaf00-c071-11ea-90bf-f558a4b752dd.gif)


## Code Snippet 

**Creating a thread**

```swift
public func createThread(artist: Artist, completion: @escaping (Result<Bool, Error>)->()) {
    guard let artistId = Auth.auth().currentUser?.uid else {return}
    db.collection(DatabaseService.artistsCollection).document(artistId).collection(DatabaseService.threadCollection).document(artist.artistId).setData(["name" : artist.name, "artistId": artist.artistId, "photoURL": artist.photoURL ?? "no photo url", "city": artist.city]) { (error) in
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(true))
        }
    }
}    
```

## Technologies

This project includes cocoapods such as MessageKit and Kingfisher to facilitate the production of the app. MessageKit was used to create conversations between our users for the chat features. Kingfisher was used to access images faster on the product. Firebase was used to organize and store user data.


## Contributors 

| <a href="https://github.com/maitreebain" target="_blank">**InTune**</a> | <a href="https://github.com/TiffanyObi" target="_blank">**InTune**</a> | <a href="https://github.com/ChristianHurtado29" target="_blank">**InTune**</a> | <a href="https://github.com/oscarvictoria" target="_blank">**InTune**</a> |
| :---: |:---:| :---: |:---:|
| [![InTune](https://avatars2.githubusercontent.com/u/55721710?s=250&u=0eebcc3a8a764dfe250d0b89fce345a2ca46eb6d&v=4&s=200)](https://github.com/maitreebain) |  [![InTune](https://avatars2.githubusercontent.com/u/55755297?s=400&u=364f4a7c46054d81adf10cc9b63e5215b5a83515&v=4&s=200)](https://github.com/TiffanyObi)    | [![InTune](https://avatars2.githubusercontent.com/u/55717913?s=250&u=6a26ab824fe75a6038add490238e47dc972ec603&v=4&s=200)](https://github.com/ChristianHurtado29) | [![InTune](https://avatars3.githubusercontent.com/u/55722232?s=260&u=742a8f0f4cab152c96093d98305b09c92eddf8bc&v=4&s=200)](https://github.com/oscarvictoria)  | 
| <a href="https://github.com/maitreebain" target="_blank">`https://github.com/maitreebain`</a> | <a href="https://github.com/TiffanyObi" target="_blank">`https://github.com/TiffanyObi`</a> | <a href="https://github.com/ChristianHurtado29" target="_blank">`https://github.com/ChristianHurtado29`</a> |  <a href="https://github.com/oscarvictoria" target="_blank">`https://github.com/oscarvictoria`</a> |

## Support

