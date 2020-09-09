//
//  ByteOperations.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation


/// The C 'unsigned char' type.
public typealias Byte = UInt8

/// The C 'unsigned char' type.
public typealias byte = UInt8



//public class Range
//{
//    var startIndex:Int = 0
//    var endIndex: Int  = 0
//    
//    init(start: Int, end: Int)
//    {
//        startIndex = start
//        endIndex = end
//    }
//}

public extension UInt {
    
    func toBool () ->Bool? {
        
        switch self {
            
        case 0:
            
            return true
            
            
        default:
            
            return false
            
        }
        
    }
    
}

extension Character {
    var integerValue:Int {
        
        let t = Int(String(self))
        return t ?? 0
    }
    
    var utf8Value: UInt8 {
        for s in String(self).utf8 {
            return s
        }
        return 0
    }
    
    var utf16Value: UInt16 {
        for s in String(self).utf16 {
            return s
        }
        return 0
    }
    
    var unicodeValue: UInt32 {
        for s in String(self).unicodeScalars {
            return s.value
        }
        return 0
    }
}

public extension String {
    
   
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> Int {
        return Int(self[self.characters.index(self.startIndex, offsetBy: i)].hashValue)
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    subscript (r: Range<Int>) -> String {
        return substring(with: (characters.index(startIndex, offsetBy: r.lowerBound) ..< characters.index(startIndex, offsetBy: r.upperBound)))
    }
    
    subscript (r: CountableClosedRange<Int>) -> String {
        return substring(with: (characters.index(startIndex, offsetBy: r.lowerBound) ..< characters.index(startIndex, offsetBy: r.upperBound)))
    }
    
    var length: Int { return self.characters.count }
    
    func contains(_ compare :String, casesensitive: Bool) -> Bool
    {
        if(casesensitive)
        {
            if self.range(of: compare) != nil
            {
                return true
            }
        }
        
        if self.lowercased().range(of: compare.lowercased()) != nil
        {
           return true
        }
        return false
    
    }
    
    func contains(_ compare :String) -> Bool
    {
        return self.contains(compare, casesensitive: false)
        
    }
    
    func replace(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
    
   static func fromCString (_ cString:[byte])-> String
    {
        let data = Data(cString)
        if let str = String(data: data  , encoding: String.Encoding.utf8) {
           return str
        }
        return ""
    }

}

public extension Int {
    init?(_ string: String, radix: UInt) {
        let digits = "0123456789abcdef"
        var result = UInt(0)
        for digit in string.lowercased().characters {
            if let range = digits.range(of: String(digit)) {
                let val = UInt(digits.characters.distance(from: digits.startIndex, to: range.lowerBound))
                if val >= radix {
                    return nil
                }
                result = result * radix + val
            } else {
                return nil
            }
        }
        self = Int(result)
    }
    
    static func uInt32FromByteArray (_ bytes:[byte])-> UInt32
    {
        var x: [UInt8] = [0x01, 0x02, 0x03, 0x04]
        var y: UInt32 = 0
        y += UInt32(x[3]) << 0o30
        y += UInt32(x[2]) << 0o20
        y += UInt32(x[1]) << 0o10
        y += UInt32(x[0]) << 0o00
        
        return y
    }

}



public func nsDataToByteArray(_ data : Data ) -> [byte]
{
    var array = [UInt8](repeating: 0x00, count: data.count)
    
    for i:Int in 0 ..< data.count
    {
        array.append( UInt8(data[i]) )
    }
    return array
}

public func getStringFromASCIIBytes(_ bytes:[byte], maxLength:Int) -> String
{
    
    //let r = bytes as [UInt8]
    //let (int8s: Int8...) = r          // int8s == [Int8]
    let uint8s = bytes.map { UInt8($0) }
    let ret:String = String(bytes: uint8s, encoding: String.Encoding.ascii)!
    
    return ret
//    var swiftString = String()
//    var workingCharacter:UnicodeScalar = UnicodeScalar(bytes[0])
//    var count:Int = 0
//    
//    for wc in bytes
//    {
//        workingCharacter = UnicodeScalar(wc)
//        swiftString.append(workingCharacter)
//    }
//
//    while swiftString.length != count - 1              {
//        workingCharacter = UnicodeScalar(bytes[count])
//        swiftString.append(workingCharacter)
//        count++
//        
//        if count > maxLength
//        {
//           return swiftString
//        }
//    }
    
   // return swiftString
}




public func SplitArray<T>(_ array: [T], range: Range<Int>) -> [T]
{
    var returnVal: [T] = []
    let start:Int = range.lowerBound
    let end:Int = range.upperBound
    
    for index in start ..< end 
    {
        returnVal.append(array[index])
    }
    return returnVal
}


func getBitsFromByte(_ data: byte) -> [Bool]
{

    var ret: [Bool] = [false,false,false,false,false,false,false,false]
    
    for x in 0 ..< 8
    {
        ret[x] = UInt(data<<1).toBool()!
    }
    
    return ret
}

func strToChar ( _ str: String) -> byte
{
    return byte(Int(str, radix: 16)!)
}


func hexStringToByteArray(_ value: String) -> [Byte]
{
    var value = value
    
    value = value.removeWhitespace()
    
    if (value.length % 2 != 0){
        return [byte]()
    }
   
    var bytes = [byte]()
    for char in value.utf8{
        bytes += [char]
    }
    
    //var bytes: [byte] = value.cStringUsingEncoding( NSUTF8StringEncoding)
    
    let length: Int = bytes.count
    var ret:[byte] = []
    
    for x in (0..<length) where x % 2 == 0
    {
        let slice:[byte] = Array(bytes[x...x+1])
        let temp = String.fromCString( slice )
        ret.append(strToChar(temp))
    }

    return ret
}


func byteArrayToHexString(_ bytes:[byte]) -> String
{
    let hexString = NSMutableString()
    
    for byte in bytes {
        hexString.appendFormat("%02x", UInt8(byte))
        hexString.append(" ")
    }
    return hexString as String
}



    func byteArrayToInt(_ x:[byte]) ->UInt
{
    var y: UInt32 = 0
    y += UInt32(x[3]) << 0o30
    y += UInt32(x[2]) << 0o20
    y += UInt32(x[1]) << 0o10
    y += UInt32(x[0]) << 0o00
    return UInt(y)
}

func IntToByteArray(_ value: Int) -> [UInt8] {
    let count = 4
    let Ints: [Int] = [value]
    let data = Data(bytes: Ints  , count: count)
    var result = [UInt8](repeating: 0, count: count)
    (data as NSData).getBytes(&result, length: count)
    return result
}


func reverseByteArray(_ array: [byte])-> [byte]
{
    var array = array
    var end = array.count-1
    
    for i in 0..<end
    {
        let aux = array[i]
        array[i] = array[end]
        array[end] = aux
        end -= 1
    }
    return array;
}

func IntToHEXString(_ value: Int,  padding: Int, littleEndian: Bool) -> String
        {
            
            var ret = NSMutableString()
            
            ret .appendFormat( String(value, radix: 16, uppercase: false) as NSString)
            
            
            let littlePadding = NSMutableString()
            
            var x = 0
           
            if(value < 16 && padding > 2)
            {
                ret = NSMutableString()
                ret.appendFormat("0")
                ret.appendFormat( String(value, radix: 16, uppercase: false) as NSString)
            }
            
            while ( padding != ret.length)
            {
                
                if(littleEndian)
                {
                    
                    
                    ret.append("0")
                    x = (ret as String).characters.count + 1 
                    
                    if(x == padding){
                        break
                    }

                }
                else
                {
                    littlePadding.append("0")
                    x = (littlePadding as String).characters.count + 1
                    
                    if(x == padding){
                        break
                    }
                }
                
            }
            
            if(!littleEndian)
            {
                let temp =  (littlePadding as String) + (ret as String)
                return temp
            }
         
            return ret as String;
        }

