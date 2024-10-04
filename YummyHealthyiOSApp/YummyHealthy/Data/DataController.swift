//
//  CameraViewModel.swift
//  YummyHealthy
//
//  Created by Mark Le on 11/22/23.
//

import AVKit
import Foundation
import SwiftUI
import VisionKit

enum ScanType: String {
    case barcode, text
}

enum DataScannerAccessStatusType {
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvailable
    case scannerAvailable
    case scannerNotAvailable
}

struct ProductData: Codable {
    let code: String
    let product: Product
}

struct Product: Codable {
    let product_name: String
    let nutriments: Nutriment
}

struct Nutriment: Codable {
    let energyPerServing: Int?
    
    enum CodingKeys: String, CodingKey {
        case energyPerServing = "energy-kcal_serving"
    }
    
}


@MainActor
final class DataController: ObservableObject {
    
    static var preview = DataController()
    
    @Published var dataScannerAccessStatus: DataScannerAccessStatusType = .notDetermined
    @Published var recognizedItems: [RecognizedItem] = []
    @Published var scanType: ScanType = .barcode
    @Published var cameraSheet = false
    @Published var barcode = "200"
    @Published var caloriesPerServing = 100.0
    @Published var caloriesPer100g = 120.0
    @Published var description = "Abc"
    
    
    @Published var product = Product(product_name: "Abc", nutriments: Nutriment(energyPerServing: 100))
    @Published var error: Error?
    
    @Published var username: String = ""
    @Published var password: String = ""
    let keychainKey = "userToken"
    
    @Published var isLoggedIn: Bool = false

    
    
    var recognizedDataType: DataScannerViewController.RecognizedDataType = .barcode()
    
    private var isScannerAvailable: Bool {
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }
    
    func requestDataScannerAccessStatus() async {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            dataScannerAccessStatus = .cameraNotAvailable
            return
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
            
        case .restricted, .denied:
            dataScannerAccessStatus = .cameraAccessNotGranted
            
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted {
                dataScannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
            } else {
                dataScannerAccessStatus = .cameraAccessNotGranted
            }
        
        default: break
            
        }
    }
    
    func loadData() async {

        guard let url = URL(string: "https://world.openfoodfacts.org/api/v0/product/\(barcode).json") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let decodedData = try JSONDecoder().decode(ProductData.self, from: data)
            product = decodedData.product
            description = product.product_name
            caloriesPerServing = Double(product.nutriments.energyPerServing ?? 0)
            //aloriesPer100g = Double(product)
            print("\(barcode)")
            
        } catch {
            self.error = error
        }

    }
    

    
        
}


