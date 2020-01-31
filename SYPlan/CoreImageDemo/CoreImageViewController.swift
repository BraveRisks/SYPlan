//
//  CoreImageViewController.swift
//  SYPlan
//
//  Created by Ray on 2019/3/21.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import UIKit
import CoreImage
import PDFGenerator

class CoreImageViewController: UIViewController {
    private var tiffImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        //generatorPDF()
        //generatorPDFWithPassword()
        //useCoreImage()
        //generatorGrayScaleImage()
    }
    
    private func setup() {
        view.backgroundColor = .white
        
        let button = UIButton(type: .system)
        button.setTitle("Upload PDF", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 7.0
        button.addTarget(self, action: #selector(upload(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15.0).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15.0).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -68.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        tiffImageView = UIImageView(frame: .zero)
        tiffImageView.contentMode = .scaleAspectFit
        tiffImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tiffImageView)
        
        tiffImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10.0).isActive = true
        tiffImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0).isActive = true
        tiffImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0).isActive = true
        tiffImageView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -10.0).isActive = true
        
        let image = UIImage(named: "largeImage1")
        tiffImageView.image = image
    }
    
    @objc private func upload(_ btn: UIButton) {
        let image = UIImage(named: "largeImage1")
        guard let img = image, let cgImage = img.cgImage else { return }
        
        // Reference 👉🏻 http://www.printernational.org/iso-paper-sizes.php
        // 1648 * 2336 200dpi
        let sizeA4 = CGSize(width: 1648.0, height: 2336.0)
        let scale = UIScreen.main.scale
        
        // 取得圖片原始大小
        let width = img.size.width * scale
        let height = img.size.height * scale
        print("Input Image Size 👉🏻 \(width) \(height)")
        
        // 計算縮放倍率
        var scaleFactor: CGFloat = 1.0
        if width > sizeA4.width && height < sizeA4.height {
            scaleFactor = sizeA4.width / width
        } else if width < sizeA4.width && height > sizeA4.height {
            scaleFactor = sizeA4.height / height
        } else if width > sizeA4.width && height > sizeA4.height {
            scaleFactor = min(sizeA4.width / width, sizeA4.height / height)
        }
        print("Input scaleFactor 👉🏻 \(scaleFactor)")
        
        DispatchQueue.global(qos: .userInitiated).async {
            // 縮放後圖片大小
            let scaleW = width * scaleFactor
            let scaleH = height * scaleFactor
            print("Output Image Size 👉🏻 \(scaleW) \(scaleH)")
            
            // 將圖片水平垂直置中
            var offsetX: CGFloat = 0.0
            var offsetY: CGFloat = 0.0
            if sizeA4.width > scaleW { offsetX = (sizeA4.width - scaleW) / 2 }
            if sizeA4.height > scaleH { offsetY = (sizeA4.height - scaleH) / 2 }
            let bounds = CGRect(
                origin: CGPoint(x: offsetX, y: offsetY),
                size: CGSize(width: scaleW, height: scaleH)
            )
            
            // 產生圖片
            UIGraphicsBeginImageContextWithOptions(sizeA4, false, scale)
            
            let context = UIGraphicsGetCurrentContext()
            UIColor.orange.setFill()
            context?.fill(CGRect(origin: .zero, size: sizeA4))
            context?.draw(cgImage, in: bounds, byTiling: false)
            var image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            
            image = UIImage(cgImage: image.cgImage!, scale: scale, orientation: .downMirrored)
            /*print("Output Image Size 👉🏻 \(result.size)")
            print("Output convert start time 👉🏻 \(Date().milliStamp)")
            if let data = result.jpegData(compressionQuality: 1.0) {
                print("Output Image Data 👉🏻 \(data.count / 1024)KB")
                print("Output convert end time 👉🏻 \(Date().milliStamp)")
            }*/
            print("Output Image Size 2 👉🏻 \(image.size)")
            DispatchQueue.main.async { self.tiffImageView.image = image }
        }
        
        /*let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            UIColor(hue: CGFloat(arc4random_uniform(100)) / 100,
                    saturation: 1, brightness: 1, alpha: 1).setFill()
            context.fill(context.format.bounds)
        }*/
    }
    
    private func generatorPDF() {
        var images: [UIImage] = []
        for i in stride(from: 17, to: 23, by: 1) {
            images.append(UIImage(named: "photo_\(i)")!)
        }

        let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending("iOS-demo.pdf"))
        print("Generator PDF URL --> \(dst)")
        
        PDFManager.shared.create(from: images, dst: dst, password: "rayboy26") {
            print("Generator PDF Finish")
        }
    }
    
    private func generatorPDFWithPassword() {
        var images: [UIImage] = []
        for i in stride(from: 17, to: 23, by: 1) {
            images.append(UIImage(named: "photo_\(i)")!)
        }
        
        let dst = URL(fileURLWithPath: NSTemporaryDirectory().appending("iOS-demo.pdf"))
        print("Generator PDF URL --> \(dst)")
        
        if let data = PDFManager.shared.create(from: images, password: "rayboy26") {
            do {
                // outputs as Data
                try data.write(to: dst, options: .atomic)
            } catch let err {
                print("Generator PDF Error --> \(err)")
            }
        }
    }
    
    private func useCoreImage() {
        let uiimage = UIImage(named: "photo_1")
        tiffImageView.image = uiimage
        
        guard #available(iOS 10.0, *) else { return }
        
        let openGLContext = EAGLContext(api: .openGLES2)
        let cicontext = CIContext(eaglContext: openGLContext!)
        
        let ciimage = uiimage?.ciImage
        let cgimage = uiimage?.cgImage
        print("saveTIFF ciImage --> \(String(describing: ciimage))")
        print("saveTIFF cgImage --> \(String(describing: cgimage))")
        
        if let image = ciimage {
            guard let data = cicontext.tiffRepresentation(of: image, format: CIFormat.RGBAh, colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!, options: [:]) else { return }
            tiffImageView.image = UIImage(data: data)
            saveTIFF(with: data)
        } else if let cgimage = cgimage {
            let ciimage = CIImage(cgImage: cgimage)
            guard let data = cicontext.tiffRepresentation(of: ciimage, format: CIFormat.RGBAh, colorSpace: cgimage.colorSpace!, options: [:]) else { return }
            tiffImageView.image = UIImage(data: data)
            saveTIFF(with: data)
        } else {
            print("saveTIFF convert fail")
        }
    }
    
    private func saveTIFF(with data: Data) {
        let fileManager = FileManager.default
        let folderName = ProcessInfo.processInfo.globallyUniqueString
        let folderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(folderName, isDirectory: true)
        print("saveTIFF URL --> \(folderURL)")
        do {
            try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
            let fileURL = folderURL.appendingPathComponent("image.TIF")
            print("saveTIFF URL with id --> \(fileURL)")
            // 將圖片存至disk
            try data.write(to: fileURL, options: .atomicWrite)
        } catch let error {
            print("saveTIFF error --> \(error)")
        }
    }
    
    private func generatorGrayScaleImage() {
        tiffImageView.contentMode = .scaleAspectFit
        // largeImage1(橫式)、largeImage2(直式)
        // largeImage3(直式)
        let image = UIImage(named: "largeImage3")
        
        guard let img = image, let cgImage = img.cgImage else { return }
        
        let ciImage = CIImage(cgImage: cgImage)
        
        // Reference 👉🏻 http://www.printernational.org/iso-paper-sizes.php
        let sizeA4 = CGSize(width: 595.0, height: 842.0)
        
        // 計算縮放倍率
        // 取得圖片原始大小
        let width  = img.size.width * UIScreen.main.scale
        
        var scaleFactor: CGFloat = 1.0
        if width > sizeA4.width {
            scaleFactor = sizeA4.width / width
        }
        
        DispatchQueue.global().async {
            // Reference 👉🏻 https://developer.apple.com/library/archive/documentation/GraphicsImaging/Reference/CoreImageFilterReference/index.html#//apple_ref/doc/filter/ci/CIColorClamp
            guard let grayscale = ImageFilterManager.shared.grayscale(in: ciImage) else { return }
            guard let scale = ImageFilterManager.shared.scale(in: grayscale, scale: scaleFactor) else { return }
            guard let result = ImageFilterManager.shared.create(in: scale) else { return }
            
            print("Output Image Size 👉🏻 \(result.size)")
            print("Output convert start time 👉🏻 \(Date().milliStamp)")
            if let data = result.jpegData(compressionQuality: 1.0) {
                print("Output Image Data 👉🏻 \(data.count / 1024)KB")
                print("Output convert end time 👉🏻 \(Date().milliStamp)")
            }
            
            DispatchQueue.main.async { self.tiffImageView.image = result }
        }
    }
}
