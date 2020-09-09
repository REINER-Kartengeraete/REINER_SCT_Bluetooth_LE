//
//  BluetoothProtocolError.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 11.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation

class BluetoothProtocolError: NSObject
{
    var level: Int = 0
    var message: String = ""
    var errorData: [CUnsignedChar] = []
    var block: Int = 0

    
    init(message: String)
    {
        self.message = message
    }
    
    init (message: String, level: Int)
    {
        self.message = message
        self.level = level
    }
    
    init(message: String , level: Int, errorData: [CUnsignedChar] )
    {
        self.message = message
        self.level = level
        self.errorData = errorData
    }
    
    init(message: String, errorData: [CUnsignedChar])
    {
        self.message = message
        self.errorData = errorData
    }
    
    
    init( level: Int, errorData: [CUnsignedChar] )
    {
        self.level = level
        self.errorData = errorData
    }
    
    
    init(errorData: [CUnsignedChar] )
    {
        self.errorData = errorData
    }
    
    init(message: String, block: Int)
    {
        self.message = message
        self.block = block
    }
    
    init (message: String, level: Int, block: Int)
    {
        self.message = message
        self.level = level
        self.block = block
    }
    
    init(message: String , level: Int, errorData: [CUnsignedChar], block: Int )
    {
        self.message = message
        self.level = level
        self.errorData = errorData
        self.block = block
    }
    
    init(message: String, errorData: [CUnsignedChar], block: Int)
    {
        self.message = message
        self.errorData = errorData
        self.block = block
    }
    
    
    init( level: Int, errorData: [CUnsignedChar], block: Int )
    {
        self.level = level
        self.errorData = errorData
        self.block = block
    }
    
    
    init(errorData: [CUnsignedChar], block: Int )
    {
        self.errorData = errorData
        self.block = block
    }

    
}
protocol BluetoothProtocolErrorCallback
{
    func BluetoothProtocolErrorAccured(_ error: BluetoothProtocolError)

}

