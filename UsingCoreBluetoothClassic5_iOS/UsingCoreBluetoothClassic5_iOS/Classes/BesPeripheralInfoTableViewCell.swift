//
//  BesPeripheralInfoTableViewCell.swift
//  CoreBluetoothClassicSample
//
//  Created by max on 2019/10/21.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol BesPeripheralInfoTableViewCellDelegate: class {
    
    func notifyPeripheral(enabled: Bool, characteristic: CBCharacteristic)
    
    func readPeripheral(characteristic: CBCharacteristic)
    
    func writePerpheral(data: Data, characteristic: CBCharacteristic, type: CBCharacteristicWriteType)
    
}

class BesPeripheralInfoTableViewCell: UITableViewCell {
    
    /// MARK: - Properties
    weak var delegate: BesPeripheralInfoTableViewCellDelegate!
    var characteristic: CBCharacteristic! {
        didSet {
            
            titleLabel.numberOfLines = 0
            infoLabel.numberOfLines = 0
            detailLabel.numberOfLines = 0
            valueLabel.numberOfLines = 0
            descriptorsLabel.numberOfLines = 0
            
            detailLabel.text = "UUID  \(characteristic.uuid.uuidString)"
            infoLabel.text = "Properties  \(propertiesString(properties: characteristic.properties) ?? " ")"
            if characteristic.descriptors == nil {
                descriptorsLabel.text = "Descriptors  None"
            } else {
                descriptorsLabel.text = "Descriptors  \(characteristic.descriptors!.count) descriptor"
            }
            
            attributesText(label: detailLabel, fullText: detailLabel.text!, subText: "UUID")
            attributesText(label: infoLabel, fullText: infoLabel.text!, subText: "Properties")
            attributesText(label: descriptorsLabel, fullText: descriptorsLabel.text!, subText: "Descriptors")

            
            /// configButton isHidden
            if (characteristic.properties.rawValue & CBCharacteristicProperties.notify.rawValue) != 0 {
                configButton.isHidden = false
            } else {
                configButton.isHidden = true
            }
            
            /// readButton isHidden
            if (characteristic.properties.rawValue & CBCharacteristicProperties.read.rawValue) != 0 {
                readButton.isHidden = false
            } else {
                readButton.isHidden = true
            }
            
            /// value label
            guard let value = characteristic.value as NSData? else {
                valueLabel.text = "\nValue  N/A"
                attributesText(label: valueLabel, fullText: valueLabel.text!, subText: "Value")

                return
            }
            valueLabel.text = "Value  \(String(describing: value.description))"
            attributesText(label: valueLabel, fullText: valueLabel.text!, subText: "Value")

        }
    }
    
    /// MARK: - UI
    @IBOutlet weak var titleLabel: UILabel! /// name
    @IBOutlet weak var detailLabel: UILabel! /// uuid
    @IBOutlet weak var infoLabel: UILabel! /// Properties
    @IBOutlet weak var valueLabel: UILabel! /// value
    @IBOutlet weak var descriptorsLabel: UILabel!
    
    @IBOutlet weak var configButton: UIButton!
    @IBOutlet weak var readButton: UIButton!
    
    @IBAction func notifyDidClick(_ sender: UIButton) {
        delegate?.notifyPeripheral(enabled: true, characteristic: characteristic)
//        configButton.setTitle("configured", for: UIControl.State.normal)
//        configButton.adjustsImageSizeForAccessibilityContentSizeCategory = true
        configButton.layer.borderColor = UIColor.blue.cgColor
        configButton.layer.borderWidth = 1
    }
    
    @IBAction func readDidClick(_ sender: UIButton) {
        delegate?.readPeripheral(characteristic: characteristic)
    }
    
}

private extension BesPeripheralInfoTableViewCell {
    
    /// atribut
    func attributesText(label: UILabel, fullText: String, subText: String) {
        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:fullText)

        let str = NSString(string: fullText)

        let theRange = str.range(of: subText)

        attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: theRange)

        label.attributedText = attrstring
    }
    
    /// properties
    func propertiesString(properties: CBCharacteristicProperties) -> (String)! {
        var propertiesReturn : String = " "
        
        if (properties.rawValue & CBCharacteristicProperties.broadcast.rawValue) != 0 {
            propertiesReturn += "broadcast,"
        }
        if (properties.rawValue & CBCharacteristicProperties.read.rawValue) != 0 {
            propertiesReturn += "read,"
        }
        if (properties.rawValue & CBCharacteristicProperties.writeWithoutResponse.rawValue) != 0 {
            propertiesReturn += "write without response,"
        }
        if (properties.rawValue & CBCharacteristicProperties.write.rawValue) != 0 {
            propertiesReturn += "write,"
        }
        if (properties.rawValue & CBCharacteristicProperties.notify.rawValue) != 0 {
            propertiesReturn += "notify,"
        }
        if (properties.rawValue & CBCharacteristicProperties.indicate.rawValue) != 0 {
            propertiesReturn += "indicate,"
        }
        if (properties.rawValue & CBCharacteristicProperties.authenticatedSignedWrites.rawValue) != 0 {
            propertiesReturn += "authenticated signed writes,"
        }
        if (properties.rawValue & CBCharacteristicProperties.extendedProperties.rawValue) != 0 {
            propertiesReturn += "indicate,"
        }
        if (properties.rawValue & CBCharacteristicProperties.notifyEncryptionRequired.rawValue) != 0 {
            propertiesReturn += "notify encryption required,"
        }
        
        return propertiesReturn
    }
    
}
