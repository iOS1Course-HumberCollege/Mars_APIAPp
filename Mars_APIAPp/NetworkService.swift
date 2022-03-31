//
//  NetworkService.swift
//  Mars_APIAPp
//
//  Created by Rania Arbash on 2022-03-24.
//

import Foundation
import UIKit

protocol networkingDelegateProtocole {
    func imageDownloadedCorrectly(image : UIImage)
    func imageDidNotDownloadedCorrectly()
}
class NetworkService {
    
    var delegate : networkingDelegateProtocole?
    static var Shared = NetworkService()
    var api_key = "wArFt3VHK2bJ853DS1uac88LIsGSaFyF4lfgIrkB"
   
    func getImagesDataFromURL(roverName: String ,earthdate : String,
    completionHandler : @escaping (Result <PhotoCollection, Error>)->Void )  {
        
        let url = "https://api.nasa.gov/mars-photos/api/v1/rovers/\(roverName)/photos?earth_date=\(earthdate)&api_key=\(api_key)"
        
        let urlObj = URL(string: url)!
           
        let task = URLSession.shared.dataTask(with: urlObj)
            { data, response, error in
                   guard error == nil else {
                       completionHandler(.failure(error!))
                       return
                   }
                   guard let httpRespons = response as? HTTPURLResponse, (200...299).contains(httpRespons.statusCode) else {
                       print ("Incorrect response ")
                                              return
                   }
                   
        if let jsonData = data {
                           print(jsonData)
            let decoder =  JSONDecoder()
                       do {
            let result = try decoder.decode(PhotoCollection.self, from: jsonData)
                           completionHandler(.success(result))
                       }
                       catch {
                           print (error)
                       }
                   }
               }
               task.resume()
    }
    

    func getImage(url: String , completionHandler : @escaping (Result <UIImage, Error>)->Void){
        let urlObj = URL(string: url)!
        let task = URLSession.shared.dataTask(with: urlObj)
            { data, response, error in
                   guard error == nil else {
                       completionHandler(.failure(error!))
                       return
                   }
                   guard let httpRespons = response as? HTTPURLResponse, (200...299).contains(httpRespons.statusCode) else {
                       print ("Incorrect response ")
                       return
                }
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    completionHandler(.success(image!))
                   }
               }
               task.resume()

    }

    
    
    func getImage(url: String ){
        let urlObj = URL(string: url)!
        let task = URLSession.shared.dataTask(with: urlObj)
        { [self] data, response, error in
                   guard error == nil else {
                       self.delegate?.imageDidNotDownloadedCorrectly()
                       return
                   }
                   guard let httpRespons = response as? HTTPURLResponse, (200...299).contains(httpRespons.statusCode) else {
                       print ("Incorrect response ")
                       return
                }
                if let imageData = data {
                    let image = UIImage(data: imageData)
                    self.delegate?.imageDownloadedCorrectly(image: image!)
                }
               }
               task.resume()
        
    }
    

}
