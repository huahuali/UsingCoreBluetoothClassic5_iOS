/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 A class to view details of a CBPeripheral.
 */

import CoreBluetooth
import UIKit
import os.log

class PeripheralViewController: UIViewController {
    @IBOutlet internal var pTableView: UITableView!
    var cbManager: CBCentralManager?
    var selectedPeripheral: CBPeripheral?
    
    private var peripheralInfo = [CBCharacteristic]()

    private var peripheralConnectedState = false
    
    var headerlabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pTableView.dataSource = self
        pTableView.reloadData()
        pTableView_addHeaderAndFooter()

        // Set peripheral delegate
        selectedPeripheral?.delegate = self
        cbManager?.delegate = self
        
        cbManager?.connect(selectedPeripheral!, options: nil)
    }
}

private extension PeripheralViewController {
    
    /// shadow
    func applyCurvedShadow(view: UIView) {
        let size = view.bounds.size
        let width = size.width
        let height = size.height
        let path = UIBezierPath()
        path.move(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width, y: height-1.5))
        path.addLine(to: CGPoint(x: 0, y: height-1.5))
        path.addLine(to: CGPoint(x:0, y: height))
        path.close()
        let layer = view.layer
        layer.shadowPath = path.cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 3)
        
//        //先边框
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 5
    }
    
    func pTableView_addHeaderAndFooter() {
        //footerView
        let headerView:UIView = UIView(frame:
            CGRect(x:10, y:0, width:UIScreen.main.bounds.size.width-15, height:60))
        headerlabel = UILabel(frame: headerView.frame)
        headerlabel.font = UIFont.systemFont(ofSize: 15)
        headerlabel.numberOfLines = 0
        headerView.addSubview(headerlabel)
        pTableView?.tableHeaderView = headerView
        
        /// shadow
        applyCurvedShadow(view: headerView)
    }
    
    func p_readPeripheral(characteristic: CBCharacteristic) {
        selectedPeripheral?.readValue(for: characteristic)
    }
    
    func p_writePerpheral(data: Data, characteristic: CBCharacteristic, type: CBCharacteristicWriteType) {
        selectedPeripheral?.writeValue(data, for: characteristic, type: type)
    }
    
    func p_notifyPeripheral(enabled: Bool, characteristic: CBCharacteristic) {
        selectedPeripheral?.setNotifyValue(enabled, for: characteristic)
    }
    
}

// MARK: - UITableViewDataSource
extension PeripheralViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripheralInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! BesPeripheralInfoTableViewCell
        
        let index = peripheralInfo.count - (indexPath.row + 1)

        cell.characteristic = peripheralInfo[index]
        
        cell.delegate = self
        
        return cell
        
    }
}

extension PeripheralViewController: BesPeripheralInfoTableViewCellDelegate {
    
    func notifyPeripheral(enabled: Bool, characteristic: CBCharacteristic) {
        p_notifyPeripheral(enabled: enabled, characteristic: characteristic)
    }
    
    func readPeripheral(characteristic: CBCharacteristic) {
        p_readPeripheral(characteristic: characteristic)
    }
    
    func writePerpheral(data: Data, characteristic: CBCharacteristic, type: CBCharacteristicWriteType) {
        p_writePerpheral(data: data, characteristic: characteristic, type: type)
    }
    
}

extension PeripheralViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        os_log("peripheral: %@ connected", peripheral)
        
        let btName = "\(peripheral.name ?? "CBPeripheral"): cononected"
        
        headerlabel.text = btName
        
        pTableView.reloadData()
        
        peripheral.discoverServices([BTConstants.sampleServiceUUID])
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        os_log("peripheral: %@ failed to connect", peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        os_log("peripheral: %@ disconnected", peripheral)
        
        let btName = "\(peripheral.name ?? "CBPeripheral"): disconnected"

        headerlabel.text = btName

        pTableView.reloadData()
        // Clean up cached peripheral state
    }
}

extension PeripheralViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let service = peripheral.services?.first else {
            if let error = error {
                os_log("Error discovering service: %@", "\(error)")
            }
            return
        }
        os_log("Discovered services %@", peripheral.services ?? [])
        headerlabel.text = headerlabel.text! + "\nService UUID: " + service.uuid.uuidString

        pTableView.reloadData()
        
        peripheral.discoverCharacteristics([BTConstants.bisto_control_rx_char_val_uuid_128_content, BTConstants.bisto_control_tx_char_val_uuid_128_content, BTConstants.bisto_audio_rx_char_val_uuid_128_content, BTConstants.bisto_audio_tx_char_val_uuid_128_content], for: service)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else {
            if let error = error {
                os_log("Error discovering characteristic: %@", "\(error)")
            }
            return
        }
        os_log("Discovered characteristics %@", characteristics)
        
        for characteristic in characteristics {
            
            peripheralInfo.insert(characteristic, at: 0)

        }
        pTableView.reloadData()

    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        pTableView.reloadData()

        guard let value = characteristic.value as NSData? else {
            os_log("1Unable to determine the characteristic's value. uuid %@ nofity %d", characteristic.uuid.uuidString, characteristic.isNotifying)
            return
        }
        
        os_log("1Value for peripheral %@ updated to: %@ UUID %@ notify %d", peripheral, value, characteristic.uuid.uuidString, characteristic.isNotifying)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        pTableView.reloadData()

        guard let value = characteristic.value as NSData? else {
            os_log("2Unable to determine the characteristic's value. UUID %@ notify %d", characteristic.uuid.uuidString, characteristic.isNotifying)
            return
        }
        
        os_log("2Value for peripheral %@ updated to: %@ UUId: %@ notify %d", peripheral, value, characteristic.uuid.uuidString, characteristic.isNotifying)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        // Accessory's GATT database has updated. Refresh your local cache (if any)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        pTableView.reloadData()

        guard let value = characteristic.value as NSData? else {
            os_log("3Unable to determine the characteristic's value. UUID %@ notify %d", characteristic.uuid.uuidString, characteristic.isNotifying)
            return
        }
        
        os_log("3Value for peripheral %@ updated to: %@ UUID %@ notify %d", peripheral, value, characteristic.uuid.uuidString, characteristic.isNotifying)
    }
    
}
