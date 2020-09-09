
//
//  SecoderProtocol.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 03.06.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation


public class SecoderProtocol {
    
    
    /** The Constant R_HEADER_LEN. */
    private let R_HEADER_LEN = 14
    
    /** The Constant R_HEADER_C1. */
    private let R_HEADER_C1 = byte(0xC1)
    
    /** The Constant R_TRANSPARRENT_1. */
    private let R_TRANSPARRENT_1 = byte(0x80)
    
    /** The Constant R_TRANSPARRENT_2. */
    private let R_TRANSPARRENT_2 = byte(0x81)
    
    /** The Constant R_TRANSPARRENT_3. */
    private let R_TRANSPARRENT_3 = byte(0x82)
    
    /** The Constant R_ERROR. */
    private let R_ERROR:byte = 130
    
    /** The Constant R_SW1_C. */
    private let R_SW1_C = byte(0x90)
    
    /** The Constant R_SW1_E. */
    private let R_SW1_E = byte(0x91)
    
    
    
    /// <summary>
    /// disects the dkprotocoll header
    /// </summary>
    /// <param name="header"></param>
    /// <returns></returns>
    func CheckHeader(_ header: [byte], exception: BluetoothProtocolErrorCallback) -> Int
    {
   
        
    
    if (header.count == R_HEADER_LEN)
    {
    // Secoder HEADER
    if header[0] == 0x00 {
        //if  header[1] == R_HEADER_C1{
            if   header[1] == R_TRANSPARRENT_1 || header[1] == R_TRANSPARRENT_2 || header[1] == R_TRANSPARRENT_3{
                    
                    if(header[0] == 0){
                        // Fehlerblock
                        if (header[9] == R_ERROR)
                        {
                            var array = [header[10],0x00]
                            array.remove(at: 1)
                            let hex = byteArrayToHexString(array).removeWhitespace()
                            let packet = strtoul(hex, nil, 16)
                            exception.BluetoothProtocolErrorAccured(BluetoothProtocolError(message: "Packet Missing" , block: Int(packet)))
                        }
   
        
                    if (( header[1] == R_TRANSPARRENT_1 && header[0] == 0) || ( header[1] == R_TRANSPARRENT_2 && header[0] == 0) || ( header[1] == R_TRANSPARRENT_3 && header[0] == 0))
                    {
  
                        return getEstimatedBlockCount(header)
                        }
                    }
                }
    
    
                        // SW1SW2 90 00
                        if ((header[12] == R_SW1_C || header[12] == R_SW1_E) && header[13] == 0)
                        {

                            return getEstimatedBlockCount(header)
                        }
                        if(!( header[1] == R_TRANSPARRENT_1 && header[0] == 0) || ( header[1] == R_TRANSPARRENT_2 && header[0] == 0) || ( header[1] == R_TRANSPARRENT_3 && header[0] == 0)){
                            // ! SW1SW
                            if (header[12] != R_SW1_C && header[12] != R_SW1_E)
                            {
                                exception.BluetoothProtocolErrorAccured(BluetoothProtocolError(message: "Card Error"  , errorData: [header[12],header[13]]))
   
                            }
                        }
                    }

    }
    return 0
    }
    
    
    
    
    /// <summary>
    /// extracts the message block from the protocoll block
    /// </summary>
    /// <param name="values"></param>
    /// <param name="blocksEstimated"></param>
    /// <returns></returns>
    func ExtractMessageFrom(_ values: Array<[byte]>, blocksEstimated: Int, transparrent: Bool, exception: BluetoothProtocolErrorCallback  ) -> String
    {
        var values = values, blocksEstimated = blocksEstimated
       
        var blockcounter = 1;
        let response = NSMutableString()
        if(!transparrent)
        {
            values.remove(at: 0)
        }
        else
        {
            blocksEstimated = blocksEstimated + 1
        }
    
        for  r in values
        {
            if r.count > 0
            {
                blockcounter += 1;
                response.append(byteArrayToHexString(SplitArray(r, range: (1 ..< (r.count )))))
            }
        }
    
        if (blockcounter - 1 != blocksEstimated)
        {
            exception.BluetoothProtocolErrorAccured(BluetoothProtocolError(message: "no vallid sequence, maybe blocks are missing" ))
            return response as String
        }
    
        return response as String
    }
    
        
        
    func getEstimatedBlockCount(_ header: [byte]) -> Int
    {
        var blocklen = 0;
        var blocksEstimated = 0;
    
        let a = [ header[5], header[4], header[3], header[2] ]
        let hexstring = byteArrayToHexString(a);
        blocklen = Int(hexstring.removeWhitespace(), radix: 16)!
        blocksEstimated = (blocklen / 20);
        
        
        if(blocklen == 0)
        {
            return 0;
        }
        if(blocklen < 20)
        {
            return 1;
        }
        
        

        
        if ((blocksEstimated + 1) % 19 == 0 && blocksEstimated != 0) {
            blocksEstimated += 1;
        }
       
        blocksEstimated += (Int) ((Double)(blocksEstimated / 20) + 1)
        return blocksEstimated
    }
    
    
    /// <summary>
    /// add blocknumbers
    /// </summary>
    /// <param name="data"></param>
    /// <param name="blockNumber"></param>
    /// <returns></returns>
    /**
    * Builds the block.
    *
    * @param bs the bs
    * @param blockNumber the block number
    * @return the byte[]
    */
    func buildBlock(_ bs: [byte], blockNumber: Int)->[byte]
    {
    // Build one chunk for sending
        var block = [byte](repeating: 0 , count: bs.count + 1)
    
        if (blockNumber != 0)
        {
            block[0] = byte(blockNumber)
        }
    
        for i in 1 ..< block.count
        {
            block[i] = bs[i - 1];
        }
        
        return block;
    }
    
    /// <summary>
    /// bild the header block
    /// </summary>
    /// <param name="lenght"></param>
    /// <param name="cmdSequenz"></param>
    /// <returns></returns>
    func GenerateHeaderBlock(_ lenght: Int, cmdSequenz: Int) -> [byte]
    {
    
    // Building the Header for the HHD protocol
        var header = [byte](repeating: 0x00, count: 11)
            
        header[0] = 0x00
        header[1] = 0x01
        header[2] = byte((lenght & 0xFF))
        header[3] = byte(((lenght >> 8) & 0xFF))
        header[4] = byte(((lenght >> 16) & 0xFF))
        header[5] = byte(((lenght >> 24) & 0xFF))
        header[6] = 0x00
        header[7] = byte(cmdSequenz)
        header[8] = 0x10
        header[9] = 0x00
        header[10] = 0x00
       
        return header
    }
        
        
        /// <summary>
        /// build the blocks
        /// </summary>
        /// <param name="command"></param>
        /// <returns></returns>
        func CommandToSendableChunks(_ command: String, transparrent: Bool) -> Array<[byte]>
        {
            // splitting the message into chunks to send to the reader via dk
            // protocol
            
            var result =  Array<[byte]>();
            let apdu = hexStringToByteArray(command);
            
            var start = 0;
            var blocknummer = 1;
            
            while (start < apdu.count ) {
                let end = min(apdu.count, start + 19)
                if(start <= end)
                {
                    result.append(buildBlock(SplitArray(apdu, range: (start ..< end)) , blockNumber: blocknummer))
                    blocknummer += 1;
                    start += 19;
                }
            }
            
            return result
        }
        
    

        
        /// <summary>
        /// hanles the input blocks
        /// </summary>
        /// <param name="values"></param>
        /// <returns></returns>
    func HandleInput(_ values: Array<[byte]>, exception: BluetoothProtocolErrorCallback) -> String
        {
            
            
            var blocksEstimated = 0;
            var header = values[0];
            
            // Header
            if (header.count == R_HEADER_LEN)
            {
                
                if (header[1] == R_HEADER_C1 && header[0] == 0)  || ( header[1] == R_TRANSPARRENT_1 && header[0] == 0) || ( header[1] == R_TRANSPARRENT_2 && header[0] == 0) || ( header[1] == R_TRANSPARRENT_3 && header[0] == 0)                 {
                    
                    if(( header[1] == R_TRANSPARRENT_1 && header[0] == 0) || ( header[1] == R_TRANSPARRENT_2 && header[0] == 0) || ( header[1] == R_TRANSPARRENT_3 && header[0] == 0))
                    {
                        blocksEstimated = getEstimatedBlockCount(header);
                        return ExtractMessageFrom(values, blocksEstimated: blocksEstimated, transparrent: true, exception: exception)
                    }
                    
                    // Fehlerblock
                    if (header[10] == R_ERROR)
                    {
                        let array = [ header[11] ];
                        let hex = byteArrayToHexString(array);
                        let packet = Int(strtoul(hex, nil, 16))
                        exception.BluetoothProtocolErrorAccured(BluetoothProtocolError(message: "Packet Missing" , block: packet))
                        return ""
                    }
                    // SW1SW2 90 00
                    if ((header[12] == R_SW1_C || header[12] == R_SW1_E) && header[13] == 0)
                    {
                        blocksEstimated = getEstimatedBlockCount(header);
                        return ExtractMessageFrom(values, blocksEstimated: blocksEstimated, transparrent: false, exception: exception)
                    }
                    
                    // ! SW1SW
                    if (header[12] != R_SW1_C && header[12] != R_SW1_E)
                    {
                        _ = byteArrayToHexString(header);
                        exception.BluetoothProtocolErrorAccured(BluetoothProtocolError(message: "Card Error"  , errorData: [header[12],header[13]]))
                        return ""
                    }
                }
            }
        
            return ""
        }

        
        /**
        * Builds the trans parent send blocks.
        *
        * @param apdu the apdu
        * @return the list
        *
        */
        func BuildTransParentSendBlocks(_ value: String) -> Array<[byte]>
        {
            
            
           var blocks = Array<[byte]>()
            
            if (!value.isEmpty)
            {
                var apdu: String = value
                apdu = apdu.removeWhitespace()
   
               
              // let r1: Range = Range( start: 0,  end: 19)
              
               var h: String
               
               if(apdu.characters.count < 20)
               {
                   h =  "00" + apdu[0...(apdu.characters.count )]
               }
               else{
             
                   h =  "00" + apdu[0...20]
               }
                
               blocks.append(hexStringToByteArray(h))
               
               if(apdu.characters.count  > 20 ){
 
                   apdu = apdu[20...(apdu.characters.count ) ]
                   let followingBlocks = CommandToSendableChunks(apdu, transparrent: true)
                   
                   for b in followingBlocks{
                       blocks.append(b)
                   }
               }
           }
           
           return blocks;
        }
        
        /// <summary>
        /// builds the blocks wich will be send
        /// </summary>
        /// <param name="apdu"></param>
        /// <param name="cmdSequenz"></param>
        /// <returns></returns>
        func BuildSendBlocks(_ apdu: String, cmdSequenz: Int)->Array<[byte]>
        {
            var apdu = apdu
            var blocks = Array<[byte]>()
            
            if (cmdSequenz < 1)
            {
                return Array<[byte]>()
            }
            
            if (!apdu.isEmpty)
            {
              
                apdu = apdu.removeWhitespace()
                blocks.append(GenerateHeaderBlock((apdu.characters.count / 2), cmdSequenz: cmdSequenz))
                
                let followingBlocks = CommandToSendableChunks(apdu, transparrent: true)
                
                for b in followingBlocks{
                    blocks.append(b)
                }
            }
            return blocks
        }

    // 00620000 00000001 000000010000"
    }
