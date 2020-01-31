//
//  GoogleAdDemoViewController.swift
//  SYPlan
//
//  Created by Ray on 2019/7/11.
//  Copyright © 2019 Sinyi. All rights reserved.
//

import UIKit
import Firebase

class GoogleAdDemoViewController: UIViewController {
    
    @IBOutlet weak var placeholderAdView: UIView!
    @IBOutlet weak var refreshButton: UIButton!
    
    private var adLoader: GADAdLoader!
    
    /// The native ad view that is being presented.
    private var nativeAdView: GADUnifiedNativeAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func setup() {
        view.backgroundColor = UIColor(hex: "d84157")
        
        guard let adView = Bundle.load(with: "UnifiedNativeAdView", type: GADUnifiedNativeAdView.self) else {
            assert(false, "Could not load nib file for adView")
        }
        
        nativeAdView = adView
        nativeAdView.translatesAutoresizingMaskIntoConstraints = false
        placeholderAdView.addSubview(nativeAdView)
        nativeAdView.topAnchor.constraint(equalTo: placeholderAdView.topAnchor).isActive = true
        nativeAdView.leadingAnchor.constraint(equalTo: placeholderAdView.leadingAnchor).isActive = true
        nativeAdView.trailingAnchor.constraint(equalTo: placeholderAdView.trailingAnchor).isActive = true
        nativeAdView.bottomAnchor.constraint(equalTo: placeholderAdView.bottomAnchor).isActive = true
        
        refreshButton.layer.cornerRadius = 5.0
        refreshButton.layer.borderWidth = 1.0
        refreshButton.layer.borderColor = UIColor.white.cgColor
        refreshButton.addTarget(self, action: #selector(requestAD), for: .touchUpInside)

        requestAD()
        
        // Set User Property
        Analytics.setUserProperty("384861", forName: "員工編號")
    }
    
    @objc private func requestAD() {
        let multipleAdOptions = GADMultipleAdsAdLoaderOptions()
        // 取得廣告數
        multipleAdOptions.numberOfAds = 1
        
        adLoader = GADAdLoader(adUnitID: "ca-app-pub-3940256099942544/3986624511",
                               rootViewController: self,
                               adTypes: [.unifiedNative], options: [multipleAdOptions])
        adLoader.delegate = self
        
        let request = GADRequest()
        request.keywords = ["nature", "sport"]
        
        adLoader.load(request)
    }
}

extension GoogleAdDemoViewController: GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        // Set ourselves as the native ad delegate to be notified of native ad events.
        nativeAd.delegate = self
        
        nativeAdView.nativeAd = nativeAd
        
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        nativeAdView.mediaView?.contentMode = .scaleAspectFit
        
        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        
        (nativeAdView.iconView as? UIImageView)?.layer.cornerRadius = 5.0
        (nativeAdView.iconView as? UIImageView)?.layer.masksToBounds = true
        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        
        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        
        (nativeAdView.callToActionView as? UIButton)?.layer.borderWidth = 1.0
        (nativeAdView.callToActionView as? UIButton)?.layer.borderColor = UIColor(hex: "004d99").cgColor
        (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
        nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil
        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        
        // accesstransmission.com
        print("AD advertiser \(String(describing: nativeAd.advertiser))")
        // Access transmission specializes in transmission repair and have over 43 years experience.
        print("AD body \(String(describing: nativeAd.body))")
        // Visit Site
        print("AD callToAction \(String(describing: nativeAd.callToAction))")
        // Test Ad: Transmission troubles
        print("AD headline \(String(describing: nativeAd.headline))")
        // icon
        print("AD icon \(String(describing: nativeAd.icon?.image?.size))")
        // mediaContent aspectRatio
        print("AD mediaContent aspectRatio \(String(describing: nativeAd.mediaContent.aspectRatio))")
        // mediaContent hasVideoContent
        print("AD mediaContent hasVideoContent \(String(describing: nativeAd.mediaContent.hasVideoContent))")
        print("AD store \(String(describing: nativeAd.store))")
        print("AD price \(String(describing: nativeAd.price))")
        print("AD starRating \(String(describing: nativeAd.starRating))")
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("Received unified native error: \(error.localizedDescription)")
    }
}

extension GoogleAdDemoViewController: GADUnifiedNativeAdDelegate {
    
    func nativeAdDidRecordClick(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidRecordImpression(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillPresentScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdDidDismissScreen(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
    
    func nativeAdWillLeaveApplication(_ nativeAd: GADUnifiedNativeAd) {
        print("\(#function) called")
    }
}
