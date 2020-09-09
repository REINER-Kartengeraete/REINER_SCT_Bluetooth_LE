//
//  BluetoothErrors.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 02.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation


public enum BluetoothErrors {
    
    /** The Connection ended unexpected. */
    case connectionEndedUnexpected
    
    /** The not connected. */
    case notConnected
    
    /** The No reader found in shared preferances. */
    case noReaderFoundInSharedPreferances
    
    /** The No reader bonded in android system. */
    case noReaderBondedInAndroidSystem
    
    /** The No reader found. */
    case noReaderFound
    
    /** The Bluetooth pairing corrupted. */
    case bluetoothPairingCorrupted
    
    /** The Bluetooth pairing failed. */
    case bluetoothPairingFailed
    
    /** The Card related error. */
    case cardRelatedError
    
    /** The No reader set. */
    case noReaderSet
    
    /** The Did disconnect unexpected. */
    case didDisconnectUnexpected
    
    /** The Transaction was canceled by the user. */
    case transactionWasCanceledByTheUser
    
    /** The Protocoll error. */
    case protocollError
    
    /** The Bluetooth le not supported. */
    case bluetoothLENotSupported
    
    /** The Could not connect to device. */
    case couldNotConnectToDevice
    
    /** The no bluetooth Permission. */
    case noBluetoothPermission
    
    /** The bluetooth not enabled. */
    case bluetoothNotEnabled
}
