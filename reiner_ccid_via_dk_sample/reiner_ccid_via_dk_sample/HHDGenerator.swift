//
//  HHDGenerator.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 08.09.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation


public class HHDGenerator {
    
    /**
    * Gets the HHD command.
    *
    * @param start_code the start_code
    * @param bde1 the bde1
    * @param bde2 the bde2
    * @param bde3 the bde3
    * @param control the control
    * @return the HHD command
    */
    func getHHDCommand (_ start_code: String,  bde1: String,  bde2: String,  bde3: String, control: String) -> String{
        var control = control
    
    if (control.isEmpty)
    {
        control = "01"; // ASSUMING GERMAN CUNTRY CODE
    }
    
    var bde1_length = 12;
    var bde2_length = 12;
    var bde3_length = 12;
        
    if (bde1.characters.count > 12) {
    bde1_length = 36;
    } else if (bde2.characters.count > 12) {
    bde2_length = 36;
    } else if (bde3.characters.count > 12) {
    bde3_length = 36;
    }
    
    
    let hhd_start_code = toData(start_code, max_length: 12, cb: true)
    var hhd_bde1 = toData(bde1, max_length: bde1_length,cb: false)
    var hhd_bde2 = toData(bde2, max_length: bde2_length,cb: false)
    var hhd_bde3 = toData(bde3, max_length: bde3_length,cb: false)
    
    
    // strip last components if empty
    if (bde3.isEmpty || bde3_length == 0  ) {
    hhd_bde3 = "";
    }
    if (bde2.isEmpty || bde2_length == 0   && bde3.isEmpty || bde3_length == 0  ) {
    hhd_bde2 = "";
    }
    if (bde1.isEmpty || bde1_length == 0  && bde2.isEmpty || bde2_length == 0   && bde3.isEmpty || bde3_length == 0  ) {
    hhd_bde1 = "";
    }
    
    let str = hhd_start_code + hhd_bde1 + hhd_bde2 + hhd_bde3
    let lc = IntToHEXString(str.characters.count / 2 + 1 , padding: 2, littleEndian: false)
     
        
    var luhn_str:String = hhd_start_code[2...hhd_start_code.length - 1]
        
    
        if (hhd_bde1.characters.count > 2)
        {
            let len = hhd_bde1.length - 1
            luhn_str = luhn_str + hhd_bde1[2...len]
        }
    
        if (hhd_bde2.characters.count > 2)
        {
            luhn_str = luhn_str + hhd_bde2[2...hhd_bde2.length - 1 ]
        }
    
        if (hhd_bde3.characters.count > 2)
        {
            luhn_str =  luhn_str + hhd_bde3[2...hhd_bde3.length - 1 ]
        }
    
    let luhn = comp_luhn(luhn_str);
    let xor_mask = comp_xor(lc + str);
    var returnVal =  lc  + str + luhn + xor_mask;
    let lc2 = IntToHEXString((returnVal.characters.count / 2 ), padding: 2, littleEndian: false)
        
    returnVal = "00000000010000" + lc2 + returnVal

    return returnVal
    }
    
    /**
    * Ord.
    *
    * @param str the str
    * @return the int
    */
    func  ord(_ str: String) -> Int {
        let temp: Character = str[0] as Character
        return  Int(temp.utf8Value)
    }
    
    /**
    * Bcd ok.
    *
    * @param input the input
    * @return the boolean
    */
    func bcdOk( _ input: String) -> Bool
    {
        for i in 0 ..< input.characters.count
        {
            if ((ord(input[i]) < 48) || (ord(input[i]) > 57))
            {
                return false
            }
        }
        
        return true
    }
    
    /**
    * To data.
    *
    * @param input the input
    * @param max_length the max_length
    * @param cb the cb
    * @return the string
    */
    func toData( _ input: String,  max_length: Int,  cb: Bool)-> String
    {
        if (input.isEmpty)
        {
            return "";
        }
        if (input.characters.count > max_length)
        {
            return "";
        }
        else
        {
            return bcdOk(input) ? toBcd(input, cb: cb) : toAscii(input, cb: cb);
        }
    }
    
    /**
    * Rpad.
    *
    * @param data the data
    * @param c the c
    * @return the string
    */
    func rpad(_ data: String, c: Character) -> String
    {
        var data = data
    
        if ((data.characters.count % 2) != 0)
        {
            data = data + String(c)
        }
        return data;
    }
    
    /**
    * To bcd.
    *
    * @param data the data
    * @param cb the cb
    * @return the string
    */
    func  toBcd( _ data: String,  cb: Bool) -> String{
        var data = data
        
        data = rpad(data, c: "F");
        return comp_lde(data, asc: false, cb: cb) + comp_cb(cb) + data;
}

/**
* To ascii.
*
* @param data the data
* @param cb the cb
* @return the string
*/
    func toAscii( _ data : String,  cb: Bool)-> String
    {
        return comp_lde(data, asc: true, cb: cb) + comp_cb(cb) + toHex(data)
    }

/**
* To hex.
*
* @param input the input
* @return the string
*/
    func toHex( _ input: String) -> String {
    var tmp = ""
    for i in 0 ..< input.characters.count
    {
        if (ord(input[i]) < 128)
        {
            let t = IntToHEXString(ord(input[i]), padding: 2, littleEndian: false)
            tmp += t
        }
    }
    return tmp
}

/**
* Comp_cb.
*
* @param cb the cb
* @return the string
*/
    func comp_cb( _ cb: Bool) -> String
    {
   
    if  (cb == true)
    {
        return "01"
    }
    else
    {
        return ""
    }
    
}

/**
* Comp_lde.
*
* @param input the input
* @param asc the asc
* @param cb the cb
* @return the string
*/
    func comp_lde( _ input: String,  asc: Bool, cb: Bool) -> String{
    var f = 0;
    f += asc ? 64 : 0; // ASC or BCD
    f += cb ? 128 : 0; // ControlByte?
        if (asc)
        {
            f += input.characters.count
        }
        else{
            f += input.characters.count / 2
        }
    
    return IntToHEXString(f,padding: 2,littleEndian: false)
}

/**
* Comp_luhn.
*
* @param str the str
* @return the string
*/
    func comp_luhn( _ str: String) -> String {
    if(str.characters.count != 0)
    {
        var sum = 0
        
        
        for i in 0 ..< str.characters.count
        {
            if(i + 1 < str.characters.count){
                
                if (i%2 != 0)
                {
                    sum += sumOfDigits(2 * hexdec(str[i...i+1 ]))
                } else {
                    sum += sumOfDigits(hexdec(str[i...i+1 ]))
                }
            }
        }
        sum = sum % 10
        if (sum != 0){
        sum = 10 - sum
        }
        
        return String(hexdec(String(sum)))
        
    }else{
        
        return "";
    }
    
}

/**
* Comp_xor.
*
* @param str the str
* @return the string
*/
func comp_xor(_ str: String) -> String
{
    var tmp = 0
    
    for i in 0 ..< str.characters.count
    {
        
        tmp ^= hexdec(str[i])

    }
    
    return IntToHEXString(tmp,padding: 1,littleEndian: false)
}

/**
* Sum of digits.
*
* @param i the i
* @return the int
*/
    func sumOfDigits( _ i: Int)->Int
    {
        if (i < 10)
        {
            return i;
        }
        return sumOfDigits((i/10)) + i % 10
    }

/**
* Hexdec.
*
* @param str the str
* @return the int
*/
    func hexdec( _ str: String)-> Int
{
    if(str.isEmpty || str == "." || str == ",")
    {
        return 0
    }
    return Int(str, radix: 16)!
}

}
