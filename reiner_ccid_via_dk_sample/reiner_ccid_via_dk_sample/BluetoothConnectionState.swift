//
//  BluetoothConnectionState.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 02.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation

public enum BluetoothConnectionState {
    
    /** The Disconnected. */
    case disconnected
    
    /** The Connecting. */
    case connecting
    
    /** The Connected. */
    case connected
    
    /** The Stable connected. */
    case stableConnected
    
    /** The Disconnecting. */
    case disconnecting
    
    /** The Bonding. */
    case bonding
    
    /** The Scanning. */
    case scanning
    
}
