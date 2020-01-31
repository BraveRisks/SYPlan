//
//  CoreMLVC.swift
//  SYPlan
//
//  Created by Ray on 2019/10/29.
//  Copyright © 2019 Sinyi Realty Inc. All rights reserved.
//
// Reference: https://www.raywenderlich.com/5653-create-ml-tutorial-getting-started#toc-anchor-007

import UIKit
import CoreML
import Vision
import ImageIO

class CoreMLVC: UIViewController {

    private var imageView: UIImageView?
    private var label: UILabel?
    
    @available(iOS 11.0, *)
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            /*
             Use the Swift class `MobileNet` Core ML generates from the model.
             To use a different Core ML classifier model, add it to the project
             and replace `MobileNet` with that model's generated Swift class.
            */
            let model = try VNCoreMLModel(for: CatsAndDogs().model)
            let request = VNCoreMLRequest(model: model) { [weak self] (req, error) in
                self?.progressClassification(for: req, error: error)
            }
            
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera,
                                                            target: self,
                                                            action: #selector(openAlbum(_:)))
        
        imageView = UIImageView()
        imageView?.contentMode = .scaleAspectFill
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView!)
        
        imageView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView?.heightAnchor.constraint(equalToConstant: 250.0).isActive = true
        
        label = UILabel()
        label?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        label?.textColor = .gray
        label?.numberOfLines = 0
        label?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label!)
        
        label?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let marginBottom: CGFloat = -40.0
        if #available(iOS 11.0, *) {
            label?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                           constant: marginBottom).isActive = true
        } else {
            label?.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,
                                           constant: marginBottom).isActive = true
        }
        
        label?.text = "請選擇一張圖片...🌚"
    }
    
    @objc private func openAlbum(_ barButton: UIBarButtonItem) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    /// 將識別結果丟給Core ML Model，進行識別
    @available(iOS 11.0, *)
    private func updateClassifications(for image: UIImage) {
        label?.text = "分類中..."
        
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// Updates the UI with the results of the classification.
    @available(iOS 11.0, *)
    private func progressClassification(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.label?.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            
            // The `results` will always be `VNClassificationObservation`s, as specified by the Core ML model in this project.
            let classifications = results as! [VNClassificationObservation]
            
            guard !classifications.isEmpty else {
                self.label?.text = "無法辨別該圖片！"
                return
            }
            
            for classification in classifications {
                print("classification = \(classification)")
            }
            
            // Display top classifications ranked by confidence in the UI.
            let topClassifications = classifications.prefix(2)
            let descriptions = topClassifications.map { classification in
                // Formats the classification for display; e.g. "(0.37125) cliff, drop, drop-off".
               return String(format: "  (%.5f) %@",
                             classification.confidence,
                             classification.identifier)
            }
            
            self.label?.text = "Classification:\n" + descriptions.joined(separator: "\n")
        }
    }
}

extension CoreMLVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        picker.dismiss(animated: true)
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView?.image = image
        
        if #available(iOS 11.0, *) {
            updateClassifications(for: image)
        }
    }
}
