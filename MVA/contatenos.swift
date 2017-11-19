//
//  contatenos.swift
//  MVA
//
//  Created by Cleyton Souza on 26/04/16.
//  Copyright © 2016 Cleyton Souza. All rights reserved.
//

import UIKit
import MessageUI

class Contatenos: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate {
    
    var photoImageView = UIImageView(frame: CGRectMake(115, 347, 90, 142))
  
    @IBOutlet weak var body: UITextView!
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText     text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    @IBAction func adicionar(sender: AnyObject) {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .PhotoLibrary
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoImageView.backgroundColor = UIColor.clearColor()

        self.view.addSubview(photoImageView)
        
   
  

    }
    

    
    
    @IBAction func sendmail(sender:AnyObject) {
    
        
        let Messagebody = body
        let toRecipients = ["c.soouza@icloud.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        mc.setSubject("CONTATE-NOS MVA")
        mc.setMessageBody(Messagebody.text!, isHTML: false)
            mc.setToRecipients(toRecipients)

        self.presentViewController(mc, animated: true, completion: nil)
        
        
    
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result {
        case MFMailComposeResultCancelled:
            NSLog("Email cancelado")
        case MFMailComposeResultSaved:
            NSLog("Email salvado")
        case MFMailComposeResultSent:
            NSLog("Email enviado")
        default:
            break
            
            
        }
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

   
 
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
         self.view.endEditing(true)
    }
  
  
    }
    
    

