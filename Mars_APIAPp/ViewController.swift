//
//  ViewController.swift
//  Mars_APIAPp
//
//  Created by Rania Arbash on 2022-03-24.
//

import UIKit

class ViewController: UIViewController,
                      UIPickerViewDataSource,
                      UIPickerViewDelegate ,
                      networkingDelegateProtocole
{
   
    
    @IBOutlet weak var numberOfPhotosLabel: UILabel!
    var result : PhotoCollection = PhotoCollection()
    @IBOutlet weak var rovers_picker: UIPickerView!
    
    @IBOutlet weak var itemsID_picker: UIPickerView!
    @IBOutlet weak var date_picker: UIDatePicker!
    @IBOutlet weak var image: UIImageView!
    var currentPhotoCollection: PhotoCollection?
    var rovers = ["Curiosity", "Opportunity", "Spirit"]
    
    func getNewData(roverName: String, date:String)  {
        NetworkService.Shared.getImagesDataFromURL(roverName: roverName, earthdate: date) { resutl in
            switch resutl {
            case .success(let photoCollection) :
                DispatchQueue.main.async {
                    self.currentPhotoCollection = photoCollection
                    self.result = photoCollection
                    self.itemsID_picker.reloadAllComponents()
                    self.numberOfPhotosLabel.text = "Num Of Photos: " + String( self.result.photos.count)
                }
                break
            case .failure(_):
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkService.Shared.delegate = self
        date_picker.addTarget(self, action: #selector(datePickerValueChanged(picker:)), for: .valueChanged)
        getNewData(roverName: "Opportunity",date: "2015-06-03")
        
    }
    
    @IBAction func saveNewImage(_ sender: Any) {
        
        let alert = UIAlertController.init(title: "Are You Sure", message: "Do you want to save this iamge?", preferredStyle: .alert)
        
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            let imageIndex = self.itemsID_picker.selectedRow(inComponent: 0)
            let currentImage = self.currentPhotoCollection?.photos[imageIndex]
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "yyyy-MM-dd"
            let stringDate = dataFormatter.string(from: self.date_picker.date)
            let roverName = self.rovers[self.rovers_picker.selectedRow(inComponent: 0)]
            
            CoreDataService.Shared.insertPhotoIntoStorage(id: currentImage!.id, roverName: roverName, date: stringDate, url: currentImage!.img_src)
            
            
        }))
        
        
        present(alert, animated: true)
        
        
        
        
    }
    @objc func datePickerValueChanged(picker: UIDatePicker)  {
        let dataFormatter = DateFormatter()
        dataFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dataFormatter.string(from: date_picker.date)
        
        getNewData(roverName: rovers[rovers_picker.selectedRow(inComponent: 0)] ,date: stringDate)

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
            // yyyy-MM-DD

            
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "yyyy-MM-dd"
            let stringDate = dataFormatter.string(from: date_picker.date)
            
            getNewData(roverName: rovers[row],date: stringDate)

        }
        else {
            NetworkService.Shared.getImage(url: result.photos[row].img_src)
            //{ result in
//                switch result {
//                case .success(let imageFromURL):
//                    DispatchQueue.main.async {
//                        self.image.image = imageFromURL
//                    }
//                    break
//
//                case .failure(_):
//                    break
//                }
            //}
        }
    }
    
    
    func imageDownloadedCorrectly(image: UIImage) {
        DispatchQueue.main.async {
                               self.image.image = image
                            }
    }
    
    func imageDidNotDownloadedCorrectly() {
        
    }
}

