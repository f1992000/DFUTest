//
//  ViewController.swift
//  DFUtest
//
//  Created by  DARFON on 2019/12/12.
//  Copyright © 2019  DARFON. All rights reserved.
//

import UIKit
import CoreBluetooth
import iOSDFULibrary
import ZIPFoundation

var MacCentralManager: CBCentralManager!
var TargetPeripheral: CBPeripheral!
var TargetCharacteristic: CBCharacteristic!
var TxCharacteristic: CBCharacteristic?
var TargetService: CBService!
var connectServiceUUID = CBUUID(string: "FE59")
var getDataServices = CBUUID(string: "EF680200-9B35-4933-9B10-52FFA9740042")
var connectDeviceName = "DfuTarg"

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        MacCentralManager = CBCentralManager(delegate: self, queue: nil)
    }

    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //检查蓝牙设备是否有在更新
        if central.state == CBManagerState.poweredOn {
            print("did update:\(central.state)")
            // 蓝牙设备确实有反应了开始搜索
            central.scanForPeripherals(withServices: nil, options: nil)
            print("Start Scanning")
        } else {
            //蓝牙设备没有更新的话，报告原因
            print("BLE on this Mac is not ready")
            switch central.state {
            case .unknown:
                print("蓝牙central.state is .unknown")
            case .resetting:
                print("蓝牙central.state is .resetting")
            case .unsupported:
                print("蓝牙central.state is .unsupported")
            case .unauthorized:
                print("蓝牙central.state is .unauthorized")
            case .poweredOff:
                print("蓝牙central.state is .poweredOff")
            case .poweredOn:
                print("蓝牙central.state is .poweredOn")
            @unknown default:
                print("UnKnowError")
            }
        }
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("BLE Device identified: \(peripheral)")
        if peripheral.name == connectDeviceName{
            print(peripheral)
            TargetPeripheral = peripheral
            TargetPeripheral.delegate = self  // 初始化peripheral的delegate
            MacCentralManager.stopScan()
            MacCentralManager.connect(TargetPeripheral) //连接
            print("\(peripheral) is connected") // 调试用
        }

    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connection Confirmed!")
//        TargetPeripheral.discoverServices([getDataServices])
//        TargetPeripheral.discoverServices(nil)
        startDFU()
        print("Target Service Confirmed!")
    }
//--------------------------------------------------------------------------
    func startDFU(){
//        guard var url = URL(fileURLWithPath: NSTemporaryDirectory()) else {
//            print("No file found")
//            return
//        }
        if let url = Bundle.main.url(forResource: "DFUZIP", withExtension: "bundle"), let bundle = Bundle(url: url), let path = bundle.path(forResource: "DFU", ofType: "zip") {
             let url2 = UIImage(contentsOfFile: path)
            let url3 = "\(url)DFU.zip"
            print(url3)
        }
        let url3 = "file:///private/var/containers/Bundle/Application/99F7FCE9-022A-4031-A373-F43FC07D2110/DFUtest.app/DFUZIP.bundle/DFU.zip"
        let selectedFirmware = DFUFirmware(urlToZipFile:URL(fileURLWithPath: url3))

//        let initiator = DFUServiceInitiator().with(firmware: selectedFirmware!)
        // Optional:
        // initiator.forceDfu = true/false // default false
        // initiator.packetReceiptNotificationParameter = N // default is 12
//        initiator.logger = self // - to get log info
//        initiator.delegate = self // - to be informed about current state and errors
//        initiator.progressDelegate = self // - to show progress bar
        // initiator.peripheralSelector = ... // the default selector is used

//        let controller = initiator.start(target: TargetPeripheral)
    }
    
    /*
    /// Start the dfu process
    func startDfuProcess(){
        
        guard TargetPeripheral != nil else {
            print("No DFU peripheral was set")
            return
        }
        
        // Create DFU initiator with some default configuration
        let dfuInitiator = DFUServiceInitiator(queue: DispatchQueue(label: "Other"))
        dfuInitiator.delegate = self
        dfuInitiator.progressDelegate = self
        dfuInitiator.logger = self
        
        // This enables the experimental Buttonless DFU feature from SDK 12.
        // Please, read the field documentation before use.
        dfuInitiator.enableUnsafeExperimentalButtonlessServiceInSecureDfu = false
        
        let fw = DFUFirmware(urlToZipFile: updatePath!)
        if(fw != nil){
            self.dfuServiceController = dfuInitiator.with(firmware: fw!).start()
            cancelButton.isEnabled = true
        }else{
            print("Error creating Zip file")
        }
    }
    
    
    func dfuStateDidChange(to state: DFUState) {
        
        self.installStateLabel?.text = state.description()
        
        if(state == .completed){
            cancelButton.isHidden = true
            mainButton.isHidden = false
            mainButton.tag = 2
            mainButton.setTitle("BACK TO DEVICES LIST", for: .normal)
        }
    }

    
    func dfuError(_ error: DFUError, didOccurWithMessage message: String) {
        print("dfu error : \(message)")
    }
    
    func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
        installProgressBar.setProgress(50 + (Float(progress)/100.0 / 2), animated: true)
    }
    
    func logWith(_ level: LogLevel, message: String) {
        print("logWith (\(level.name())) : \(message)")
    }
*/
//--------------------------------------------------------------------------
    
    
/*
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)   //陈列所有的service和旗下的characteristics
            print("Identified TargetServices \(service.uuid.uuidString)")
//            if service.uuid.isEqual(getEnvironmentServiceUUID()) { //寻找指定UUID的服务
//                print("Identified TargetServices \(service.uuid.uuidString)")
//                TargetService = service as CBService
//            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
//      guard let characteristics = TargetService.characteristics else { return }  //寻找指定UUID的服务

        print("Characteristics identified")  // 调试用

        for characteristic in characteristics {
            print(characteristic)

            // CBCharacteristicWrite
//            if characteristic.uuid.isEqual(kBLE_Characteristic_uuid_Tx){
//                TxCharacteristic = characteristic
//            }

            if characteristic.properties.contains(.read) {
                print("\(characteristic.uuid): properties contains .read")  //找到read方式的characteristics并读取
                peripheral.readValue(for: characteristic)
            }
//            if characteristic.properties.contains(.notify) {
//                print("\(characteristic.uuid): properties contains .notify")  //找到notify方式的characteristics并读取
//                peripheral.setNotifyValue(true, for: characteristic)
//            }

            // 也可以找指定UUID的characteristic特征
//            if characteristic.uuid.isEqual(getTemperatureCharacteristicUUID()) {
//                print("\(characteristic.uuid): properties contains UUID")  //找到指定UUID的特征然后下面采取read或者notify
//                peripheral.setNotifyValue(true, for: characteristic)
//                peripheral.readValue(for: characteristic)
//            }
        }
    }


    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print(characteristic)
        print(characteristic.value![0])
//        switch characteristic.uuid {
//        case getTemperatureCharacteristicUUID():
//            guard let characteristicData = characteristic.value else { return }
//            print(("Temperature_1: \(characteristicData[0])"))
//
//        case getPressureCharacteristicUUID():
//            guard let characteristicData = characteristic.value else { return }
//            print(("Pressure____2: \(characteristicData[0])"))
//
//        default:
//            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
//        }
    }
*/
    
}
