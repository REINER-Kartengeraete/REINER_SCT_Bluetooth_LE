//
//  TLV.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation


public class TLV {
    

/** The Constant TAG_TOPLEVEL. */
public class var TAG_TOPLEVEL: Int {return  0xFFFF}

/** The m value. */
private var mValue : [byte]

/** The m index. */
private var mIndex: Int

/** The m length. */
private var mLength: Int

/** The m tag. */
private var mTag: Int

/** The m children. */
private var mChildren: [TLV] = [TLV]()
    
    
private var children:[TLVINFO] = [TLVINFO]()

    
    public convenience init(value: [byte])
    {
  

        if (value.count <= 0)
        {
            self.init(value: [], index: 0 , length: 0 , tag: 0x00, children: nil)

            //Fehler
        }
        else
        {
            self.init(value: value, index: 0 , length: value.count , tag: TLV.TAG_TOPLEVEL, children: nil)
            mValue = value
            mIndex = 0
            mLength = value.count
            mTag = TLV.TAG_TOPLEVEL

            
        }
    }

    

/**
* Constructor TLV.
*
* @param value the value
* @param index the index
* @param length the length
* @param tag the tag
* @throws TLVException the TLV exception
*/
private init(value: [byte], index: Int, length: Int, tag: Int, children: [TLV]! )
  {
    self.children = [TLVINFO]()
    
    mValue = value
    mIndex = index
    mLength = length
    mTag = tag
    
    if(children == nil)
    {
        mChildren = [TLV]()
    }
    else
    {
        mChildren = children
    }
    
    if (value.count <= 0)
    {
     //Fehler
    }else{
        
    if (isConstructed()) {
        //   var x = parse()
        simpleParse()
        }
    }
}
    

/**
* gets the tag.
*
* @return the tag
*/

func getTag() -> Int {
    return mTag;
}

/**
* gets the value.
*
* @return the value
*/
func getValue() -> [byte]
{
    let data = Data(bytes: UnsafePointer<UInt8>(mValue),count: mValue.count-1)
    return nsDataToByteArray(data);
}

    
/**
* gets all children.
*
    
* @return the children
*/
func getChildren() -> [TLVINFO] {
    
      return children
}

/**
* if is constructed.
*
* @return true, if is constructed
*/
func isConstructed() -> Bool{
    let CONSTRUCTED_BIT:byte = 0x20;
    return (Int(getFirstTagByte(mTag))  & Int(CONSTRUCTED_BIT)) != 0 ? true : false ;
}

/**
* parses the tlv structure.
*
* @throws TLVException the TLV exception
*/
private func parse() -> Int {
    var index = mIndex;
    let endIndex = mIndex + mLength;
    
    while (index < endIndex) {
        var tag = getNext(index + 1)
    
        if(tag < 0)
        {
            return 1
        }
        
        if (tag == 0x00 || tag == 0xFF){
            continue;
        }
        if (tagHasMultipleBytes(tag)) {
            tag <<= 8
            tag |= getNext(index + 1 )
            
            if(tag < 0)
            {
                return 1
            }

            if (tagHasAnotherByte(tag)) {
                tag <<= 8;
                tag |= getNext(index + 1)
                
                if(tag < 0)
                {
                    return 1
                }

            }
            if (tagHasAnotherByte(tag)){
                return 1
            }
        }
        
        var length = getNext(index + 1)
        
        if(length < 0)
        {
            return 1
        }

        
        if (length >= 0x80) {
            let numLengthBytes = (length & 0x80);
            
            if (numLengthBytes > 3)
            {
                return 2
            }
            length = 0;
            for _ in 0 ..< numLengthBytes
            {
                length <<= 8;
                length |= getNext(index + 1)
               
                if(length < 0)
                {
                    return 1
                }

            }
        }
        let tlv =  TLV(value: mValue, index: index, length: length, tag: tag, children: mChildren)
        mChildren.append(tlv)
        index += tlv.getLength()
    }
    return 0
}
    
    
    func simpleParse2()
    {
        
        let len: Int = (mValue.count - 1)
        var index = 0
        
        
        
        
        while len > index
        {
            
            let cLen:Int = Int(mValue[index]) + (index )
            let currentTag = mValue[(index + 1 )...cLen]
            
            var t:[byte] = [byte]()
            for b in currentTag
            {
                t.append(b)
            }

            children.append(TLVINFO(tag: Int(mValue[index]), len: mValue[index + 1], value: t ))
            index = cLen
            index = index + 1
        }
    }
    
    func simpleParse()
    {
        
        var values: [UInt8] = mValue;
        
        while (values[0] == 0x00){
            values = Array(values.dropFirst(1))
        }
        var sValues: [byte] = values;
        
        
        var lenAll: Int = sValues.count;
        lenAll = lenAll - 1;
        
        var pointer:Int = 0
        
     
        
        while (pointer < lenAll - 1)
        {
          
                let tag: Int = Int(sValues[pointer])
                pointer += 1
                let len: Int = Int(sValues[pointer])
                pointer += 1
            
                let val = sValues[pointer...((pointer + (len - 1)))]
            
                var value:[byte] = [byte]()
            
                for b in val
                {
                    value.append(b)
                }
                pointer += len ;
            
                let info = TLVINFO(tag: tag, len:byte(len ), value: value)
            
                self.children.append(info)
            
            
        
        }
        
}


/**
* gets the length.
*
* @return the length
*/
    func getLength() -> Int {
    return mLength;
}

/**
* gets the next child.
*
* @param index the index
* @return the next
* @throws TLVException the TLV exception
*/
    func getNext(_ index: Int) -> Int {
        if (index < mIndex || (index >= (mIndex + mLength ) && (mLength != 1)))
        {
            return -1
        }

        let max: UInt8 = 0xFF
        let current: UInt8  = mValue[index] as UInt8
        let temp = current & max
        return Int(temp)
}

/**
* gets the first tag.
*
* @param tag the tag
* @return the first tag byte
*/
    private func getFirstTagByte(_ tag: Int) -> Int {
        var tag = tag
    
    while (tag > 0xFF)
    {
     tag = tag >> 8;
    }
    return tag;
}

/**
* check if has multiple bytes.
*
* @param tag the tag
* @return true, if successful
*/
    private func tagHasMultipleBytes(_ tag: Int) -> Bool {
    let MULTIBYTE_TAG_MASK = 0x1F;
    return (tag & MULTIBYTE_TAG_MASK) == MULTIBYTE_TAG_MASK;
}

/**
* check if tag has an other byte.
*
* @param tag the tag
* @return true, if successful
*/
private func tagHasAnotherByte(_ tag: Int) -> Bool{
    let NEXT_BYTE = 0x80;
    return (tag & NEXT_BYTE) != 0;
 }
}
