//
//  SecoderReaderQuallifiers.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation

class SecoderReaderQuallifiers{
    

/** ReaderHasFullNumericKeyPad. */
private var ReaderHasFullNumericKeyPad:Bool = false

/**
* Gets the reader has full numeric key pad.
*
* @return the reader has full numeric key pad
*/
 func getReaderHasFullNumericKeyPad()-> Bool
{
    return ReaderHasFullNumericKeyPad;
}

/**
* Sets the reader has full numeric key pad.
*
* @param value the new reader has full numeric key pad
*/
 func setReaderHasFullNumericKeyPad(_ value: Bool)
{
    ReaderHasFullNumericKeyPad = value;
}

/** ReaderHasTwoColumnDisplay. */
private var ReaderHasTwoColumnDisplay: Bool = false

/**
* Gets the reader has two column display.
*
* @return the reader has two column display
*/
func getReaderHasTwoColumnDisplay()->Bool
{
    return ReaderHasTwoColumnDisplay;
}

/**
* Sets the reader has two column display.
*
* @param value the new reader has two column display
*/
    func setReaderHasTwoColumnDisplay(_ value: Bool)
{
    ReaderHasTwoColumnDisplay = value;
}

/** ReaderSupportsUSB. */
private var ReaderSupportsUSB: Bool = false

/**
* Gets the reader supports usb.
*
* @return the reader supports usb
*/
func getReaderSupportsUSB()-> Bool
{
    return ReaderSupportsUSB;
}

/**
* Sets the reader supports usb.
*
    * @param value the new reader supports usb
*/
func setReaderSupportsUSB(_ value: Bool)
{
    ReaderSupportsUSB = value;
}

/** ReaderSupportsBluetooth. */
private var ReaderSupportsBluetooth: Bool = false

/**
* Gets the reader supports bluetooth.
*
* @return the reader supports bluetooth
*/
func getReaderSupportsBluetooth() ->Bool
{
    return ReaderSupportsBluetooth;
}

/**
* Sets the reader supports bluetooth.
*
* @param value the new reader supports bluetooth
*/
func setReaderSupportsBluetooth(_ value: Bool)
{
    ReaderSupportsBluetooth = value;
}

/** ReaderHasOpticalInterface. */
    private var ReaderHasOpticalInterface:Bool = false

/**
* Gets the reader has optical interface.
*
* @return the reader has optical interface
*/
func getReaderHasOpticalInterface() ->Bool
{
    return ReaderHasOpticalInterface;
}

/**
* Sets the reader has optical interface.
*
* @param value the new reader has optical interface
*/
    func setReaderHasOpticalInterface(_ value: Bool)
{
    ReaderHasOpticalInterface = value;
}

/** ReaderSupportsManualEntryOfTransactionData. */
    private var ReaderSupportsManualEntryOfTransactionData: Bool = false

/**
* Gets the reader supports manual entry of transaction data.
*
* @return the reader supports manual entry of transaction data
*/
func getReaderSupportsManualEntryOfTransactionData() ->Bool
{
    return ReaderSupportsManualEntryOfTransactionData;
}

/**
* Sets the reader supports manual entry of transaction data.
*
* @param value the new reader supports manual entry of transaction data
*/
    func setReaderSupportsManualEntryOfTransactionData(_ value: Bool)
{
    ReaderSupportsManualEntryOfTransactionData = value;
}

/** last byte. */
    private var LastByte:Bool = false

/**
* Gets the last byte.
*
* @return the last byte
*/
func getLastByte() -> Bool
{
    return LastByte;
}

/**
* Sets the last byte.
*
* @param value the new last byte
*/
func setLastByte(_ value: Bool)
{
    LastByte = value;
}

/** NextToLastByte. */
private var NextToLastByte: Bool  = false

/**
* Gets the next to last byte.
*
* @return the next to last byte
*/
func getNextToLastByte() -> Bool
{
    return NextToLastByte;
}

/**
* Sets the next to last byte.
*
* @param value the new next to last byte
*/
    func setNextToLastByte(_ value: Bool)
{
    NextToLastByte = value;
}

/**
* constructor for SecoderReaderQuallifiers .
*
* @param info the info
*/
    init(info: byte)
{
    var bools = getBitsFromByte(info);
    
    if (bools[0])
    {
        self.setReaderHasFullNumericKeyPad(bools[0]);
    }
    if (bools[1])
    {
        self.setReaderHasTwoColumnDisplay(bools[1]);
    }
    if (bools[2])
    {
        self.setReaderSupportsUSB(bools[2]);
    }
    if (bools[3])
    {
        self.setReaderSupportsBluetooth(bools[3]);
    }
    if (bools[4])
    {
        self.setReaderHasOpticalInterface(bools[4]);
    }
    if (bools[5])
    {
        self.setReaderSupportsManualEntryOfTransactionData(bools[5]);
    }
    if (bools[6])
    {
        self.setLastByte(bools[6]);
    }
    if (bools[7])
    {
        self.setNextToLastByte(bools[7]);
    }
}
}
