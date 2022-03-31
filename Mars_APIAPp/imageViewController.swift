//
//  imageViewController.swift
//  Mars_APIAPp
//
//  Created by Rania Arbash on 2022-03-31.
//

import UIKit

class imageViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    var url : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkService.Shared.getImage(url: url) { result in
            switch result{
            case .success(let imageFromURL):
                DispatchQueue.main.async {
                    self.img.image = imageFromURL
                }
                break
            case .failure(_): break
                
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
