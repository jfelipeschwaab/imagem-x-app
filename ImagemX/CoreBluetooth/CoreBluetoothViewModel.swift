//
//  CoreBluetoothViewModel.swift
//  ImagemX
//
//  Created by Débora Cristina Silva Ferreira on 17/10/25.
//

import Foundation
import CoreBluetooth
internal import Combine

class CoreBluetoothViewModel: NSObject, ObservableObject {
    @Published var bleMode: BLEMode?
    @Published var discoveredPeripherals: [CBPeripheral] = []
    @Published var connectedPeripheral: CBPeripheral?
    @Published var connectedCentrals: [CBCentral] = []
    @Published var centralManager: CBCentralManager
    @Published var peripheralManager: CBPeripheralManager
    
    var peripheral: CBPeripheral?
    var characteristic: CBCharacteristic?
    
    var characteristicUUID = CBUUID(string: "890aa912-c414-440d-88a2-c7f66179589b")
    var serviceUUID = CBUUID(string: "9f37e282-60b6-42b1-a02f-7341da5e2eba")
    
    override init() {
        self.centralManager = CBCentralManager(delegate: nil, queue: nil)
        self.peripheralManager = CBPeripheralManager(delegate: nil, queue: nil)
        super.init()
        self.centralManager.delegate = self
        self.peripheralManager.delegate = self
    }
    
    func setMode(newMode: BLEMode) {
        bleMode = newMode
        switch newMode {
        case .send:
            startAdvertising()
        case .receive:
            startScanning()
        }
    }
        
    func startScanning() {
        discoveredPeripherals.removeAll()
        centralManager.scanForPeripherals(withServices: [self.serviceUUID], options: nil)
    }
    
    func startAdvertising() {
        let characteristic = CBMutableCharacteristic(type: self.characteristicUUID,
                                                                          properties: [.write, .notify],
                                                                          value: nil,
                                                                          permissions: .writeable)
        
        let service = CBMutableService(type: self.serviceUUID, primary: true)
        service.characteristics = [characteristic]
        
        peripheralManager.add(service)
        
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [serviceUUID],
                                                       CBAdvertisementDataLocalNameKey: "Device Information"])
    }
    
    func connect(peripheral: CBPeripheral) {
        centralManager.connect(peripheral)
        self.peripheral = peripheral
        connectedPeripheral = peripheral
    }
    
    func disconnect(peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
        
        if self.peripheral?.identifier == peripheral.identifier {
            self.peripheral = nil
            connectedPeripheral = nil
        }
        connectedCentrals.removeAll()
    }
}

extension CoreBluetoothViewModel: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn, bleMode == .receive {
            startScanning()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        central.stopScan()
        peripheral.delegate = self
        peripheral.discoverServices([self.serviceUUID])
    }
}

extension CoreBluetoothViewModel: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        guard peripheral.state == .poweredOn, bleMode == .send else { return }

//        let characteristic = CBMutableCharacteristic(type: self.characteristicUUID,
//                                                     properties: [.write, .notify],
//                                                     value: nil,
//                                                     permissions: .writeable)
//        
//        let service = CBMutableService(type: self.serviceUUID, primary: true)
//        service.characteristics = [characteristic]
//        
//        peripheralManager.add(service)
//        
//        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey: serviceUUID,
//                                                        CBAdvertisementDataLocalNameKey: "Device Information"])
    }
}

extension CoreBluetoothViewModel: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Não é possível descobir nada: \(error.localizedDescription)")
            if let peripheral = self.peripheral {
                centralManager.cancelPeripheralConnection(peripheral)
            }
            self.peripheral = nil
            centralManager.stopScan()
            
            return
        }
        
        peripheral.services?.forEach { service in
            peripheral.discoverCharacteristics([characteristicUUID], for: service)
            
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        if !connectedCentrals.contains(where: {$0.identifier == central.identifier}) {
            connectedCentrals.append(central)
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        connectedCentrals.removeAll() {$0.identifier == central.identifier}
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Não é possível descobir nada: \(error.localizedDescription)")
            if let peripheral = self.peripheral {
                centralManager.cancelPeripheralConnection(peripheral)
            }
            self.peripheral = nil
            centralManager.stopScan()
            
            return
        }
        
        service.characteristics?.forEach{ characteristic in
            guard characteristic.uuid ==  self.characteristicUUID else { return}
            
            peripheral.setNotifyValue(true, for: characteristic)
            
            self.characteristic = characteristic
    
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: (any Error)?) {
        if let error = error {
            print("Erro de notificação da carcterística: \(error.localizedDescription)")
            return
        }
        
        guard characteristic.uuid == self.characteristicUUID else {return}
        
        if characteristic.isNotifying {
            print("As notificações de características começaram")
        } else {
            print("As notificações de características pararam, Desconectando")
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
}

enum BLEMode{
    case send
    case receive
}
