//
//  ModelClasses.swift
//  Mars_APIAPp
//
//  Created by Rania Arbash on 2022-03-24.
//

import Foundation
// MVC
class Photo : Codable{
    var id : Int = 0
    var img_src: String = ""
    var camera : Camera = Camera()
}

class PhotoCollection : Codable{
    var photos : [Photo] = [Photo]()
}

class Camera : Codable {
    var name: String = ""
    var rover_id : Int = 0
}
