//
//  CameraView.swift
//  YummyHealthy
//
//  Created by Mark Le on 11/22/23.
//

import SwiftUI
import VisionKit

struct CameraView: View {
    @EnvironmentObject var vm: DataController 
    
    
    var body: some View {
        switch vm.dataScannerAccessStatus {
        case .scannerAvailable:
            mainView
        case .cameraNotAvailable:
            Text("Your device doesn't have a camera")
        case .scannerNotAvailable:
            Text("Your device doesn't have support for scanning barcode with this app")
        case .cameraAccessNotGranted:
            Text("Please provide access to the camera in settings")
        case .notDetermined:
            Text("Requesting camera access")
        }
    }
    
    private var mainView: some View {
        DataScannerView(
            recognizedItems: $vm.recognizedItems,
            recognizedDataType: .barcode(),
            recognizesMultipleItems: false)
        .background { Color.gray.opacity(0.3) }
        .onReceive(NotificationCenter.default.publisher(for: .scannedBarcodeNotification), perform: { notification in
            Task {
                guard let object = notification.object as? RecognizedItem else {return}
                if case let .barcode(barcode) = object {
                    vm.barcode = barcode.payloadStringValue ?? "Unknown"
                    await vm.loadData()
                    vm.cameraSheet = false
                }
            }
        })
        
    }
}
#Preview {
    CameraView()
        .environmentObject(DataController.preview)
}
