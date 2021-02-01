//
//  GoogleMapDemoVC.swift
//  SYPlan
//
//  Created by Ray on 2020/8/28.
//  Copyright © 2020 Sinyi Realty Inc. All rights reserved.
//

import UIKit
import GoogleMaps

// Reference: https://developers.google.com/maps/documentation/ios-sdk/start
class GoogleMapDemoVC: UIViewController {

    private var map: GMSMapView?
    
    var position: (lat: Double, lng: Double) = (25.032659, 121.565957)
    
    /// 繪製View
    private lazy var drawView: DrawView = {
        let view = DrawView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addMarker()
        //addDrawView()
    }
    
    private func setup() {
        let camera = GMSCameraPosition(latitude: position.lat, longitude: position.lng, zoom: 15.0)
        map = GMSMapView(frame: .zero, camera: camera)
        
        // 顯示交通狀態
        //map?.isTrafficEnabled = true
        
        // 顯示目前位置
        map?.isMyLocationEnabled = true
        
        // 地圖類型
        // normal
        // satellite
        // hybrid
        // terrain
        // none
        map?.mapType = .normal
        
        // 地圖樣式
        map?.mapStyle = try? .init(jsonString: "")
        
        // 顯示指北針
        map?.settings.compassButton = true
        
        // 顯示我的位置按鈕
        //map?.settings.myLocationButton = true
        
        // 顯示樓層選擇器
        map?.settings.indoorPicker = true
        
        // 禁止滾動
        //map?.settings.scrollGestures = false
        
        // 禁止旋轉
        //map?.settings.rotateGestures = false
        
        // 禁止傾斜
        //map?.settings.tiltGestures = false
        
        // 禁止縮放
        //map?.settings.zoomGestures = false
        
        map?.delegate = self
        map?.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(map!)
        
        map?.topAnchorEqual(to: view.topAnchor)
            .isActive = true
        map?.leadingAnchorEqual(to: view.leadingAnchor)
            .isActive = true
        map?.trailingAnchorEqual(to: view.trailingAnchor)
            .isActive = true
        map?.bottomAnchorEqual(to: view.bottomAnchor)
            .isActive = true
    }
    
    private func addMarker() {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 25.054446, longitude: 121.524143)
        marker.title = "晶華酒店"
        marker.snippet = "Regent Taipei"
        marker.icon = GMSMarker.markerImage(with: .orange)
        marker.opacity = 0.7
        
        // 自訂更新資訊窗
        marker.tracksInfoWindowChanges = true
        marker.map = map
    }
    
    private func removeMarkers() {
        map?.clear()
    }
    
    private func addDrawView() {
        view.addSubview(drawView)
        
        drawView.topAnchorEqual(to: view.topAnchor)
                .isActive = true
        drawView.leadingAnchorEqual(to: view.leadingAnchor)
                .isActive = true
        drawView.trailingAnchorEqual(to: view.trailingAnchor)
                .isActive = true
        drawView.bottomAnchorEqual(to: view.bottomAnchor)
                .isActive = true
    }
    
    public func animateTo(position: (lat: Double, lng: Double)?) {
        guard let p = position else { return }
        
        map?.animate(to: GMSCameraPosition(latitude: p.lat, longitude: p.lng, zoom: 15.0))
    }
}

extension GoogleMapDemoVC: GMSMapViewDelegate {
    
    // 地圖開始渲染，會觸發多次
    func mapViewDidStartTileRendering(_ mapView: GMSMapView) {
        print("nn mapViewDidStartTileRendering")
    }
    
    // 地圖移動位置，會觸發多次
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("nn didChangePosition")
    }
    
    // 地圖停止移動
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        print("nn idleAtPosition")
        
        let c = mapView.projection.coordinate(for: CGPoint(x: 272.0, y: 187.5))
        let p = mapView.projection.point(for: c)
        print("nn idleAtPosition coordinate to point = \(p)")
        print("nn idleAtPosition point to coordinate = \(c)")
    }
    
    // 地圖結束渲染，會觸發多次
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        print("nn mapViewDidFinishTileRendering")
    }
    
    // 地圖已完成，會觸發多次
    func mapViewSnapshotReady(_ mapView: GMSMapView) {
        print("nn mapViewSnapshotReady")
    }
    
    // 手指拖曳地圖
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("nn willMoveGesture")
    }
    
    // 手指開始拖曳圖標
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("nn didBeginDragging")
    }
    
    // 手指拖曳圖標
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("nn didDragMarker")
    }
    
    // 手指結束拖曳圖標
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("nn didEndDragging")
    }
    
    func mapView(_ mapView: GMSMapView, didTap overlay: GMSOverlay) {
        print("nn didTapOverlay")
    }
    
    // 手指點擊圖標
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("nn didTapMarker")
        return false
    }
    
    // 手指點擊圖標「資訊窗」
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("nn didTapInfoWindowOf")
    }
    
    // 圖標資訊窗關閉
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        print("nn didCloseInfoWindowOf")
    }
    
    // 手指長壓圖標「資訊窗」
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("nn didLongPressInfoWindowOf")
    }
    
    // 手指點擊地圖任意地方
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        // mapView.projection該方法，需在地圖完成後才可以調用，否則計算出來的數值會錯誤
        let p = mapView.projection.point(for: coordinate)
        let c = mapView.projection.coordinate(for: p)
        print("nn coordinate to point = \(p)")
        print("nn point to coordinate = \(c)")
        print("nn didTapAtCoordinate = \(coordinate)")
    }
    
    // 手指長壓地圖任意地方
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        print("nn didLongPressAtCoordinate")
    }
    
    // 手指點擊「我的位置」圖標
    func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
        print("nn didTapMyLocation")
    }
    
    // 手指點擊地圖上，系統的圖標
    func mapView(_ mapView: GMSMapView,
                 didTapPOIWithPlaceID placeID: String,
                 name: String,
                 location: CLLocationCoordinate2D) {
        print("nn didTapPOIWithPlaceID = \(location)")
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return nil
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        return nil
    }
}

extension GoogleMapDemoVC: DrawViewDelegate {
    
    func onDrawBegan(_ drawView: DrawView) {
        map?.clear()
    }
    
    func onDrawing(_ drawView: DrawView) {
        
    }
    
    func onDrawEnd(_ drawView: DrawView, points: Array<CGPoint>) {
        // Create a rectangular path
        let path = GMSMutablePath()
        for p in points {
            guard let location = map?.projection.coordinate(for: p) else { continue }
            
            path.add(location)
        }
        
        // Create the polygon, and assign it to the map.
        let polygon = GMSPolygon(path: path)
        polygon.fillColor = UIColor.systemRed.withAlphaComponent(0.2)
        polygon.strokeColor = UIColor.systemRed
        polygon.strokeWidth = 4
        polygon.map = map
        
        drawView.canDraw = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(320)) {
            drawView.isHidden = true
        }
    }
}
