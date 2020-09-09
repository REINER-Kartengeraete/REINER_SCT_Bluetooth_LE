//
//  SecoderBluetoothReader.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation





class SecoderBluetoothReader : SecoderReaderProtocol, BluetoothReaderCallbacks , BluetoothProtocolErrorCallback
{
    /** The _card reader. */
    private var _cardReader: BluetoothReader
    
    /** The _callbacks. */
    private var  _callbacks: SecoderReaderCallbacks
    
    /** The recieved. */
    private var recieved = Array<[Byte]>()
    
    /** The send. */
    private var send = Array<[Byte]>()
    
    /** The send counter max. */
    private var sendCounterMax = 0;
    
    /** The send counter. */
    private var sendCounter = 0;
    
    
    /** The first block. */
    private var firstBlock = true;
    
    /** The first not ready to send. */
    private var firstNotReadyToSend = false;
    
    /** The blocks to wait for. */
    private var blocksToWaitFor = 0;
    
    /** The errorblock. */
    private var errorblock = -1;
    
    /** The cmd sequenz. */
    private var cmdSequenz = 1;
    
    /** The waiting for secoder info. */
    private var waitingForSecoderInfo = false;
    
    private var protocolSecoder =  SecoderProtocol()
    
    private var _type = [BluetoothReaderType]()
    
    
    init(callbacks: SecoderReaderCallbacks, type: [BluetoothReaderType])
    {
        _callbacks = callbacks
        _cardReader = BluetoothReader()
        _type = type
    }
    
    
    /**
    * Connect.
    *
    * @param id the id
    */
    func connect(_ id: String)
    {
        _cardReader = BluetoothReader(callback: self, type: _type)
        _cardReader.Connect(id)
    }
    
    func reset()
    {
        sendCounterMax = 0;
        sendCounter = 0;
        blocksToWaitFor = 0;
        errorblock = -1;
        cmdSequenz = 1;
        firstBlock = true;
        firstNotReadyToSend = false;
    }
    
    /**
    * Send apdu.
    *
    * @param data the data
    * @param transparrent the transparrent
    */
    func sendCommand(_ data: String,transparrent: Bool)
    {
        recieved = Array<[Byte]>()
        send = Array<[Byte]>()
        sendCounterMax = 0;
        sendCounter = 0
        firstBlock = true;
        blocksToWaitFor = 0;
        errorblock = -1;
        firstBlock = true;

        
        if(transparrent)
        {
                send = protocolSecoder.BuildTransParentSendBlocks(data)
        }
        else{
                send = protocolSecoder.BuildSendBlocks(data, cmdSequenz: cmdSequenz)
        }
            
        sendCounterMax = send.count
        
        if (_cardReader.GetBluetoothConnectionState() == BluetoothConnectionState.connected)
        {
            _cardReader.SendCommando(send.first!);
        }
        else
        {
            firstNotReadyToSend = true;
        }
        
    }
    
    /**
    * Send recieved callback.
    */
    func SendRecievedCallback()
    {
    let input: String = protocolSecoder.HandleInput(recieved, exception: self)
    
    if (waitingForSecoderInfo == true)
    {
        waitingForSecoderInfo = false
        if(input.length > 0)
        {
            _callbacks.didRecieveSecoderInfo(SecoderInfo(data: input).Data!);
        }
    }
    else
    {
        if(input.length > 0)
        {
            _callbacks.didRecieveApdu(input)
        }
    }

    }
    

    
    func BluetoothProtocolErrorAccured(_ error: BluetoothProtocolError)
    {
        firstBlock = true;
        
        if (error.message.contains("Packet Missing"))
        {
            
            sendCounter = error.block
            _cardReader.SendCommando(send[sendCounter])
        }
        else
        {
            _callbacks.didRecieveResponseError(BluetoothErrors.protocollError, block: error.errorData)
        }

        
    }
    
    
    
    /**
    * Request secoder info.
    */
    func requestSecoderInfo()
    {
        waitingForSecoderInfo = true;
        sendCommand(GetSecoderInfoCommandString, transparrent: false);
    }
    
    /**
    * Dis connect.
    */
    func disConnect()
    {
        reset()
        _cardReader.DisConnect()
        
    }
    
    /**
    * Scan readers.
    *
    * @param timeout the timeout
    */
    func scanReaders(_ timeout: TimeInterval)
    {
       _cardReader =  BluetoothReader(callback: self, type: _type)
        _cardReader.ScanReaders(timeout)
    }
    
    /**
    * Bond reader.
    *
    * @param readerID the reader id
    */
    func bondReader(_ readerID: String)
    {
        if _cardReader.isNil()
        {
            _cardReader = BluetoothReader(callback: self, type: _type)
        }
        _cardReader.BondReader(readerID)
    }
    
    /**
    * Stop scaning.
    */
    func stopScaning()
    {
        _cardReader.StopScaning()
    }
    
    /**
    * Le capable.
    *
    * @return true, if successful
    */
    func leCapable() -> Bool
    {
        return _cardReader.LeCapable()
    }
    
    /**
    * Gets the bluetooth connection state.
    *
    * @return the bluetooth connection state
    */
    func getBluetoothConnectionState() -> BluetoothConnectionState
    {
       return _cardReader.GetBluetoothConnectionState()
    }
    
    /// <summary>
    /// called when the reader is connected and ready to send
    /// </summary>
    func readyToSend()
    {
        _callbacks.readyToSend()
        
        if (firstNotReadyToSend)
        {
            if(send.count > 0)
            {
                _cardReader.SendCommando(send.first!)
            }
        }
    }
    
    /// <summary>
    /// called after a block was send
    /// </summary>
    func didSend()
    {
        sendCounter += 1;
        if (sendCounterMax > sendCounter)
        {
            _cardReader.SendCommando(send[sendCounter])
        }
        else
        {
            cmdSequenz += 1;
        }
        
    }
    /// <summary>
    /// called if a block was recieved from the remote device
    /// </summary>
    /// <param name="block"></param>
    func didRecieveBlock(_ block: [CUnsignedChar])
    {
        recieved.append(block)
                if (firstBlock)
                {
                    firstBlock = false;
                    blocksToWaitFor = protocolSecoder.CheckHeader(block, exception: self)
                    NSLog("Estimated Blocks: " + blocksToWaitFor.description)
                    if(blocksToWaitFor == 0)
                    {
                        firstBlock = true
                        SendRecievedCallback()
                    }
                }
                else
                {
                    if (blocksToWaitFor + 1 == recieved.count)
                    {
                        firstBlock = true
                        SendRecievedCallback()
                      
                    }
                }

    
    }
    
    
    /// <summary>
    /// called if an error accoured, errorMessage explaines some errors, the block returns a failure byte array for the error description
    /// </summary>
    /// <param name="errorMessage"></param>
    /// <param name="block"></param>
    func didRecieveError(_ errorMessage: BluetoothErrors, block: [CUnsignedChar])
    {
        _callbacks.didRecieveResponseError(errorMessage, block: block)
    }
    
    /// <summary>
    /// called after the disconnect
    /// </summary>
    /// <param name="unhingedService"></param>
    func disconnected()
    {
        _callbacks.disconnected()
    }
    
    
    /// <summary>
    /// list of devices foaund while scanning
    /// called if new device is found
    /// </summary>
    /// <param name="devices"></param>
    func onfound_BluetoothReader(_ devices: [BluetoothReaderInfo])
    {
        _callbacks.didFindReaders(devices)
    }
    
    /// <summary>
    /// called if device is bonded
    /// </summary>
    func Bonded(_ info: BluetoothReaderInfo)
    {
        _callbacks.Bonded(info)
    }
    
    /// <summary>
    /// called if scanning timeout runns out
    /// </summary>
    func onScanningFinished()
    {
        _callbacks.onScanningFinished()
    }
    
    

}
