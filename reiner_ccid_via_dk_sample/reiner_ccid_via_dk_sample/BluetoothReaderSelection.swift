//
//  BluetoothReaderSelection.swift
//  reiner_ccid_via_dk_sample
//
//  Created by Prakti_E on 08.09.15.
//  Copyright (c) 2015 Reiner SCT. All rights reserved.
//

import Foundation
import UIKit



class BluetoothReaderSelection : UIViewController, SecoderReaderCallbacks, UITableViewDelegate,  UITableViewDataSource , UIActionSheetDelegate{
    
    class var  SAVEDDEVICES: String {return  "savedDevices"}
    class var  FILENAME: String {return  "savedcyberJacks.cyberJack"}
    class var  PREFEREDREADERFILENAME: String {return  "preferedcyberJack.cyberJack"}
    class var  PREFEREDREADER: String {return  "preferedcyberJack"}
    
    class var  ActionSheetTitle: String {return  "Aktion"}
    class var  Verwenden: String {return  "Use"}
    class var  Loeschen: String {return  "Delete"}
    class var  Entfernen: String {return  "Remove"}
    class var  Abbrechen: String {return  "Cancel"}
    
    
    @IBOutlet var suchenButton: UIButton?
    @IBOutlet var tableView: UITableView?
    @IBOutlet var _activityIndicator: UIActivityIndicatorView?
    
    @IBOutlet var koppelnLabel: UILabel?
    @IBOutlet var suchenLabel: UILabel?

    
    
    var _reader: SecoderBluetoothReader?
    
    var _cyberJacksFound = [BluetoothReaderInfo]()
    var _cyberJacksSaved =  [BluetoothReaderInfo]()
    var _cyberJackInUse = BluetoothReaderInfo ()

    
    
    
    var _savedIndex = 0
    var _searched = 0
    var _savedSection = 0
    
    var dum = BluetoothReaderInfo()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView!.dataSource=self
        tableView!.delegate=self
        
        _reader = SecoderBluetoothReader(callbacks: self, type: [BluetoothReaderType.Secoder_3, BluetoothReaderType.DK_Reader])
        
        // init values for the tableview
        _cyberJacksSaved = [BluetoothReaderInfo]()
        _cyberJacksFound  = [BluetoothReaderInfo]()
        
        
        //BluetoothReaderSelection.getPreveredReader()
        
        _cyberJackInUse = BluetoothReaderSelection.getPreveredReader()

        _cyberJacksSaved.append(dum)
        _cyberJacksFound.append(dum)

        _cyberJacksSaved = getSavedReaders()
        
        tableView?.reloadData()


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        tableView = UITableView()
        _activityIndicator = UIActivityIndicatorView()
        super.init(coder: aDecoder)
    }

    
    @IBAction func scanForReaders()
    {
            suchenLabel!.isHidden = false
            _activityIndicator!.startAnimating()
            _reader!.scanReaders(TimeInterval(99999999.9))
    }
    
    

    func deviceHasBeenFoundBefore(_ device: BluetoothReaderInfo)-> Bool
    {
        for x in 0 ..< _cyberJacksFound.count
        {
            if(_cyberJacksFound[x].getReaderID() == device.getReaderID() )
            {
                return true
            }
        }
        return false
    }

    func Bonded(_ info: BluetoothReaderInfo)
    {
        koppelnLabel!.isHidden = false
        suchenLabel!.isHidden = true
        saveReader(info)
        setPreveredReader(info)
        _reader?.disConnect()
        self.navigationController?.popViewController(animated: true)
        
    }

    func onScanningFinished()
    {
        koppelnLabel!.isHidden = true
        suchenLabel!.isHidden = true
        _activityIndicator!.stopAnimating()
        _activityIndicator!.isHidden = true
    }

    func readyToSend()
    {
        
    }

    func didSend()
    {
    
    }

    func didRecieveBlock(_ block: [CUnsignedChar])
    {
    
    }

    func didRecieveError(_ errorMessage: BluetoothErrors, block: [CUnsignedChar])
    {
        
    }

    func disconnected()
    {
        
    }


    func didRecieveApdu(_ answer: String)
    {
    }
    

    func didRecieveSecoderInfo(_ info: SecoderInfoData)
    {
        koppelnLabel!.isHidden = false
        suchenLabel!.isHidden = true
        saveReader(_cyberJackInUse)
        setPreveredReader(_cyberJackInUse)
        _reader?.disConnect()
        self.navigationController!.popViewController(animated: true)

    }
    

    func didRecieveResponseError(_ errorMessage: BluetoothErrors,  block: [byte])
    {
    
    }
    
    
  
    func didFindReaders(_ devices: [BluetoothReaderInfo]){ if(_cyberJacksFound[0].getReaderID() == "")
    {
        _cyberJacksFound.remove(at: 0)
        }
        
        for x in 0 ..< devices.count
        {
            if(!deviceHasBeenFoundBefore(devices[x]))
            {
                _cyberJacksFound.append(devices[x])
            }
        }
        tableView!.reloadData()
    }
    
    

    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch section
        {
            
        case 0:
            return 1
        case 1:
            return _cyberJacksSaved.count
        case 2:
            return _cyberJacksFound.count
        default:
            return _cyberJacksFound.count
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let section = (indexPath as NSIndexPath).section
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "ReaderTableCell")
        cell.backgroundColor = UIColor( red:(45/255.0), green:(206/255.0), blue:(255/255.0), alpha:1 )
        
        if(section==0)
        {
            
            cell.textLabel?.textColor = UIColor.gray
            _cyberJackInUse = BluetoothReaderSelection.getPreveredReader()
            
            if(_cyberJackInUse.getReaderName().isEmpty)
            {
                cell.textLabel?.text = "no reader found"
                cell.detailTextLabel?.text = ""
            }
            else
            {
                cell.textLabel?.text = _cyberJackInUse.getReaderName()
                cell.detailTextLabel?.text = _cyberJackInUse.getReaderID()
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.gray
            return cell

        }
        cell.textLabel?.textColor = UIColor.black


        if(section==1)
        {
            cell.textLabel?.text = _cyberJacksSaved[(indexPath as NSIndexPath).row].getReaderName()
            cell.detailTextLabel?.text = _cyberJacksSaved[(indexPath as NSIndexPath).row].getReaderID()
        }
        
        if(section==2)
        {
            cell.textLabel?.text = _cyberJacksFound[(indexPath as NSIndexPath).row].getReaderName()
            cell.detailTextLabel?.text = _cyberJacksFound[(indexPath as NSIndexPath).row].getReaderID()
        }

        return cell
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? // fixed font style. use custom view (UILabel) if you want something different
    {
        switch section
        {
            
        case 0:
            return "used Reader"
        case 1:
            return "saved Reader"
        case 2:
            return "found Reader"
        default:
            return "some Reader"
        
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if((indexPath as NSIndexPath).section == 0 )
        {
            _savedSection = (indexPath as NSIndexPath).section
            openActionSheetSimple()
        }
        
        if((indexPath as NSIndexPath).section == 1)
        {
            _savedSection = (indexPath as NSIndexPath).section
            _savedIndex = (indexPath as NSIndexPath).row;
            openActionSheet()
        }
        
        if( (indexPath as NSIndexPath).section == 2 )
        {
            if(_cyberJacksFound[(indexPath as NSIndexPath).row].getReaderID().length > 10)
            {
                _reader!.bondReader(_cyberJacksFound[(indexPath as NSIndexPath).row].getReaderID())
                _reader?.requestSecoderInfo();
            }
        }

    }
    
   func openActionSheet()
   {
        let actionSheet = UIActionSheet(title: BluetoothReaderSelection.ActionSheetTitle, delegate: self, cancelButtonTitle: BluetoothReaderSelection.Abbrechen, destructiveButtonTitle: BluetoothReaderSelection.Loeschen)
        actionSheet.addButton(withTitle: BluetoothReaderSelection.Verwenden)
        actionSheet.show(in: self.view)
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
    
        let buttonTitle = actionSheet.buttonTitle(at: buttonIndex)
    
    
        if(_savedSection == 1 )
        {
    
            if (buttonTitle == BluetoothReaderSelection.Verwenden) {
                setPreveredReader(_cyberJacksSaved[_savedIndex])
                tableView!.reloadData()
            }
    
            if ( buttonTitle == BluetoothReaderSelection.Loeschen) {
    
                deleteReaderFromSaved(_savedIndex)
                tableView!.reloadData()
            }
        }
    
        if(_savedSection == 0 )
        {
            if ( buttonTitle == BluetoothReaderSelection.Entfernen)
            {
                UserDefaults.standard.removeObject(forKey: BluetoothReaderSelection.PREFEREDREADER)
                _cyberJackInUse = dum
                tableView!.reloadData()
            }

        }
    }
    
    
   func openActionSheetSimple()
   {
      let actionSheet = UIActionSheet(title: BluetoothReaderSelection.ActionSheetTitle, delegate: self, cancelButtonTitle: BluetoothReaderSelection.Abbrechen, destructiveButtonTitle: BluetoothReaderSelection.Entfernen)
      actionSheet.show(in: self.view)
    }


    
    func getIndexOfStoredDevice (_ reader:BluetoothReaderInfo ,list: [BluetoothReaderInfo]) -> Int
    {
    
        var index = -1;
    //    getSavedReaders()
    
        if(list.count > 0){
            for x in 0 ..< _cyberJacksSaved.count
            {

    
                if(reader.getReaderName() == _cyberJacksSaved[x].getReaderName() && reader.getReaderID() == _cyberJacksSaved[x].getReaderID())
                {
                    index=x;
                    break;
                }
            }
        }
    return index;
    
    }

    
    func saveReader(_ reader: BluetoothReaderInfo){
       
       // getSavedReaders()
    
        if (!reader.getReaderID().isEmpty){
           
                
                if(_cyberJacksSaved.count > 0 )
                {
                    if(_cyberJacksSaved[0].getReaderName().contains("no reader found", casesensitive: false))
                    {
                            _cyberJacksSaved.remove(at: 0)
                    }
                }
            
                if( getIndexOfStoredDevice(reader, list: _cyberJacksSaved) >= 0 )
                {
                    return
                }
                else
                {
                    
                    
                    _cyberJacksSaved.append(reader)
                }
            
            let dataSave:Data = NSKeyedArchiver.archivedData(withRootObject: _cyberJacksSaved)
            UserDefaults.standard.set(dataSave, forKey: BluetoothReaderSelection.SAVEDDEVICES)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    func getSavedReaders() ->[BluetoothReaderInfo]
    {
       
        let data: AnyObject? = UserDefaults.standard.object(forKey: BluetoothReaderSelection.SAVEDDEVICES) as AnyObject?
        
        if(data != nil)
        {
            var temp =  NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! [BluetoothReaderInfo]

            if(temp.count != 0)
            {
                if(temp.count > 1)
                {
                    if(temp[0].getReaderName().contains("no reader found", casesensitive: false))
                    {
                        temp.remove(at: 0)
                    }
                }

                _cyberJacksSaved = temp
            }

        }
        return _cyberJacksSaved
    }
    
    func setPreveredReader(_ preveredReader: BluetoothReaderInfo)
    {
       
        if(!preveredReader.getReaderID().isEmpty)
        {
            let dataSave:Data = NSKeyedArchiver.archivedData(withRootObject: preveredReader)
            UserDefaults.standard.set(dataSave, forKey: BluetoothReaderSelection.PREFEREDREADER)
            UserDefaults.standard.synchronize()
        }
        tableView?.reloadData()
    
    }
    
    
    class func getPreveredReader() -> BluetoothReaderInfo{
    
        let data: AnyObject?  =  UserDefaults.standard.object(forKey: PREFEREDREADER) as AnyObject?
        
        if(data != nil)
        {
            return  NSKeyedUnarchiver.unarchiveObject(with: data as! Data) as! BluetoothReaderInfo
        }
        
        return BluetoothReaderInfo()
        
    
    }
    
    func deleteReaderFromSaved(_ readerToDelete: Int)
    {
        _cyberJacksSaved.remove(at: readerToDelete)
        let dataSave:Data = NSKeyedArchiver.archivedData(withRootObject: _cyberJacksSaved)
        UserDefaults.standard.set(dataSave, forKey: BluetoothReaderSelection.SAVEDDEVICES)
        UserDefaults.standard.synchronize()

    }

    
}
