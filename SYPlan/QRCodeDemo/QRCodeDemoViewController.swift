//
//  QRCodeDemoViewController.swift
//  SYPlan
//
//  Created by Ray on 2019/7/23.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import AVFoundation
import UIKit

class QRCodeDemoViewController: UIViewController {

    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    /// 支援掃描的類型，value = [.qr]
    private let supportedBarCodes: [AVMetadataObject.ObjectType] = [.qr]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }
    
    private func setup() {
        navigationItem.title = "QRCode 掃描"
        view.backgroundColor = .white
        
        // 檢查是否有攝影裝置
        guard let viedeoDeivce = AVCaptureDevice.default(for: .video) else {
            failed(message: "您的設備未有設攝影鏡頭")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: viedeoDeivce)
        } catch let error {
            print("videoInput error 👉🏻 \(error.localizedDescription)")
            return
        }
        
        captureSession = AVCaptureSession()
        
        // 檢查是否可加入Input
        guard captureSession.canAddInput(videoInput) else {
            failed(message: "您的設備不支持掃描項目中的條碼類型")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        // 檢查是否可加入Output
        guard captureSession.canAddOutput(metadataOutput) else {
            failed(message: "您的設備不支持掃描項目中的條碼類型")
            return
        }
        
        captureSession.addInput(videoInput)
        captureSession.addOutput(metadataOutput)
        
        // 律定掃描邊框尺寸
        let style = ScanBorderView.Style.normal
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = supportedBarCodes
        
        // 律定掃描區域範圍，注意x, y, w, h 與設定區域`相反`
        // reference：https://qiita.com/tomosooon/items/9cb7bf161a9f76f3199b
        // reference：https://swiswiswift.com/barcode/
        let width = view.frame.width
        var height = view.frame.height
        
        // 減去StatusBar and NavigationBar
        if let vc = navigationController {
            height -= (vc.navigationBar.frame.height + UIApplication.shared.statusBarFrame.height)
        }
        
        // 減去Tabbar
        if let vc = tabBarController {
            height -= vc.tabBar.frame.height
        }
        
        // 掃描邊框的尺寸
        let size = style.size
        
        // 計算掃描邊框`寬度`對於整個螢幕`寬度`的比例
        let ratioW = size.width / width
        
        // 計算掃描邊框`高度`對於整個螢幕`高度`的比例
        let ratioH = size.height / height
        
        // 預設掃描區域範圍為：0.0, 0.0, 1.0, 1.0，故需要做比例上的計算
        let x = 1 - ratioH - ((height - size.height) / 2 / height)
        let y = 1 - ratioW - ((width - size.width) / 2 / width)
        let w = ratioH
        let h = ratioW
        metadataOutput.rectOfInterest = CGRect(x: x, y: y, width: w, height: h)
        //print("!! metadataOutput rectOfInterest \(metadataOutput.rectOfInterest)")
        //print("!! metadataOutput startX \(metadataOutput.rectOfInterest.minY * width)")
        //print("!! metadataOutput startY \(metadataOutput.rectOfInterest.minX * height)")
        //print("!! metadataOutput endX \(metadataOutput.rectOfInterest.maxY * width)")
        //print("!! metadataOutput endY \(metadataOutput.rectOfInterest.maxX * height)")
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // 加入掃描邊框
        let scanView = ScanBorderView(frame: .zero)
        scanView.style = style
        scanView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scanView)
        if #available(iOS 11.0, *) {
            scanView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            scanView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            scanView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            scanView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        } else {
            scanView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
            scanView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            scanView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            scanView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
    
    private func failed(message: String) {
        let ac = UIAlertController(title: "不支援掃描", message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "關閉", style: .cancel) { [unowned self] (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        ac.addAction(close)
        present(ac, animated: true)
        captureSession = nil
    }
    
    private func outputValue(with text: String) {
        let ac = UIAlertController(title: "掃描結果：\(text)", message: nil, preferredStyle: .alert)
        let close = UIAlertAction(title: "關閉", style: .default) { (action) in
            self.captureSession.startRunning()
        }
        ac.addAction(close)
        present(ac, animated: true)
    }
}

extension QRCodeDemoViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        captureSession.stopRunning()
        
        // 是否有資訊物件
        guard let metadataObject = metadataObjects.first else { return }
        
        // 是否可轉換為機器可讀object
        guard let object = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
        
        // 檢查object型別是否為`QRCode`，並且有value
        guard object.type == .qr, let value = object.stringValue else { return }
        
        // 顯示掃描結果
        outputValue(with: value)
    }
}
