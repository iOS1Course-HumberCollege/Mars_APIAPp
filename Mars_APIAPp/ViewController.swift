//
//  ViewController.swift
//  Mars_APIAPp
//
//  Created by Rania Arbash on 2022-03-24.
//

import UIKit

class ViewController: UIViewController,
                      UIPickerViewDataSource,
                      UIPickerViewDelegate {
    
    var result : PhotoCollection = PhotoCollection()
    @IBOutlet weak var rovers_picker: UIPickerView!
    
    @IBOutlet weak var itemsID_picker: UIPickerView!
    @IBOutlet weak var date_picker: UIDatePicker!
    @IBOutlet weak var image: UIImageView!

    var rovers = ["Curiosity", "Opportunity", " Spirit"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkService.Shared.getImagesDataFromURL(roverName: "Opportunity", earthdate: "2015-06-03") { resutl in
            switch resutl {
            case .success(let photoCollection) :
                DispatchQueue.main.async {
                    self.result = photoCollection
                    self.itemsID_picker.reloadAllComponents()
                }
               
                break
            case .failure(let error):
                break
            }
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rows = 0
        if pickerView.tag == 1 {
            rows = rovers.count
        }else {
            rows = result.photos.count
        }
        return rows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = ""
        
        if pickerView.tag == 1 {
            title = rovers[row]
        }
        else {
            title = String(result.photos[row].id)
        }
        return title
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            
        }
        else {
            NetworkService.Shared.getImage(url: result.photos[row].img_src) { result in
                switch result {
                case .success(let imageFromURL):
                    DispatchQueue.main.async {
                        self.image.image = imageFromURL
                    }
                    break
                
                case .failure(_):
                    break
                }
            }
        }
    }
}

