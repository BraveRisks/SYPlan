//
//  ResizeImageDemoVC.swift
//  SYPlan
//
//  Created by Ray on 2020/2/3.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit

class CropImageDemoVC: UIViewController {
    
    @IBOutlet weak var xTextField: UITextField!
    @IBOutlet weak var yTextField: UITextField!
    @IBOutlet weak var wTextField: UITextField!
    @IBOutlet weak var hTextField: UITextField!
    
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var originImageView: UIImageView!
    @IBOutlet weak var cropLabel: UILabel!
    @IBOutlet weak var cropImageView: UIImageView!
    @IBOutlet weak var cropButton: UIButton!
    
    private let scale = UIScreen.main.scale
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setup() {
        if #available(iOS 13, *) {
            overrideUserInterfaceStyle = .light
        }
        
        [xTextField, yTextField, wTextField, hTextField].forEach { (textField) in
            textField?.delegate = self
        }
        
        originLabel.backgroundColor = UIColor(hex: "ffffff", alpha: 0.65)
        cropLabel.backgroundColor = UIColor(hex: "ffffff", alpha: 0.65)
        originImageView.contentMode = .scaleAspectFit
        
        if let url = Bundle.main.url(forResource: "mobile01_20180727_4", withExtension: ".jpg"),
            let data = try? Data(contentsOf: url, options: .mappedIfSafe),
            let image = UIImage(data: data, scale: scale) {
            originImageView.image = image
            
            originLabel.text = "尺寸：\(image.size.width * scale) x \(image.size.height * scale)"
        }
        
        cropImageView.contentMode = .scaleAspectFit
        
        cropButton.layer.cornerRadius = 7.0
        cropButton.addTarget(self, action: #selector(clicked(_:)), for: .touchUpInside)
    }
    
    @objc private func clicked(_ button: UIButton) {
        let x = CGFloat(Int(xTextField.text ?? "0") ?? 0)
        let y = CGFloat(Int(yTextField.text ?? "0") ?? 0)
        let w = CGFloat(Int(wTextField.text ?? "0") ?? 0)
        let h = CGFloat(Int(hTextField.text ?? "0") ?? 0)
        
        let image = originImageView.image!
        let cropImage = image.crop(with: CGRect(x: x, y: y, width: w, height: h))
        cropImageView.image = cropImage
        
        let cropW = Int(cropImage.size.width * scale)
        let cropH = Int(cropImage.size.height * scale)
        cropLabel.text = "尺寸：\(cropW) x \(cropH)"
    }
}

extension CropImageDemoVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isFirstResponder { textField.resignFirstResponder() }
        
        return true
    }
}
