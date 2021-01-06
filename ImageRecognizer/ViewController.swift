//
//  ViewController.swift
//  ImageRecognizer
//
//  Created by Field Employee on 12/31/20.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var resnetModel = Resnet50()
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        if let image = imageView.image{
            classifyPicture(image:image)
        }
    }
    
    @IBAction func albumTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker,animated: true, completion:nil)
    }
    
    @IBAction func photoTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker,animated:true,completion:nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            imageView.image = image
            classifyPicture(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func classifyPicture(image:UIImage){
        if let model = try?VNCoreMLModel(for: resnetModel.model){
            let request = VNCoreMLRequest(model:model){(request, error) in
                if let results = request.results as?[VNClassificationObservation]{
                    for result in results{
                        print(result.identifier + "," + String(result.confidence))
                    }
                }
            }
            if let imageData = image.jpegData(compressionQuality:1.0){
                let handler = VNImageRequestHandler(data:imageData,options:[:])
                try? handler.perform([request])
            }
        }
    }
    
    


}

