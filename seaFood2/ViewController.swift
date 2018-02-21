//
//  ViewController.swift
//  seaFood2
//
//  Created by Karan Sagar on 21/02/18.
//  Copyright © 2018 Karan Sagar. All rights reserved.
//

import UIKit
import VisualRecognitionV3

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //1s. API Key
    let apiKey = "148c16fead276ded630045e52134d939562864f1"
    let version = "2018-02-21"
    
    
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var classificationResult:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
     }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // send the image that we pick to ibm blue mix
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            
            let visualRecognition = VisualRecognition(apiKey: apiKey, version: version)
            
            let imageData = UIImageJPEGRepresentation(image, 0.01)
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("tempImage.jpg")
            try? imageData?.write(to: fileURL, options: [])
            
            
            visualRecognition.classify(imageFile: fileURL, success: { (classifiedImages) in
                
                let classes = classifiedImages.images.first!.classifiers.first!.classes
                
                self.classificationResult = []
                
                for index in 0..<classes.count {
                    self.classificationResult.append(classes[index].classification)
                }
                print(self.classificationResult)
                
                if self.classificationResult.contains("hotdog") {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "HotDog!"

                    }
                }
                    
                    
                else {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Not HotDog !"

                    }
                }
            })
            
            
        } else {
            print("there was error picking the image")
        }
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
    }
    
}

