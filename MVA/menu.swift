//
//  ViewController.swift
//  MVA
//
//  Created by Cleyton Souza on 22/01/16.
//  Copyright © 2016 Cleyton Souza. All rights reserved.
//


import UIKit
import LocalAuthentication

class menu: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBAction func touchID(sender: AnyObject) {
        authenticateUser()
        
        }
    
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var avatar: UIImageView!
    
    
   
    
    @IBOutlet weak var personagem: UIImageView!
    
    override func viewDidLoad() {
        
        avatar.layer.cornerRadius = avatar.frame.width/2
        avatar.clipsToBounds = true
      
        
        personagem.animationImages = [
            UIImage(named: "mva1.png")!,
            UIImage(named: "mva1.png")!,
            UIImage(named: "mva1.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva.png")!,
            UIImage(named: "mva1.png")!,
            UIImage(named: "mva1.png")!,
            UIImage(named: "mva1.png")!,
            
            
            
        ]
        personagem.startAnimating()
        
      
        
        
        
    }
    
    
    @IBAction func cameraaction(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .Camera
        
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        avatar.image = info[UIImagePickerControllerOriginalImage] as? UIImage;
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func authenticateUser()
    {
        let context = LAContext()
        var error: NSError?
        let reasonString = "Desbloqueie somente usando TouchID"
        
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error)
        {
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, policyError) -> Void in
                
                if success
                {
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let vc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("newViewController") as! UINavigationController
                    
                    //        var vc: NewViewController = storyboard.instantiateViewControllerWithIdentifier("newView") as NewViewController
                    
                    self.presentViewController(vc, animated: true, completion: nil)
                }
                else
                {
                    switch policyError!.code
                    {
                    case LAError.SystemCancel.rawValue:
                        print("Autenticação cancelada pelo sistema!")
                    case LAError.UserCancel.rawValue:
                        print("Autenticação cancelada pelo usuario!")
                        
                    case LAError.UserFallback.rawValue:
                        print("Usuario selecionou digitação de senha.")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    default:
                        print("Autenticação Invalida!")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.showPasswordAlert()
                        })
                    }
                }
                
            })
        }
        else
        {
            print(error?.localizedDescription)
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.showPasswordAlert()
            })
        }
    }
    
    // MARK: Password Alert
    
    func showPasswordAlert()
    {
        let alertController = UIAlertController(title: "Touch ID Senha", message: "Digite a sua senha relacionada ao TouchID", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Cancel) { (action) -> Void in
            
            if let textField = alertController.textFields?.first as UITextField?
            {
                if textField.text == "7915"
                {
                    
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let vc: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("newViewController") as! UINavigationController
                    
                    //        var vc: NewViewController = storyboard.instantiateViewControllerWithIdentifier("newView") as NewViewController
                    
                    self.presentViewController(vc, animated: true, completion: nil)
                }
                else
                {
                    self.showPasswordAlert()
                }
            }
        }
        alertController.addAction(defaultAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            
            textField.placeholder = "Digite a senha para desbloquear"
            textField.secureTextEntry = true
            
        }
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
}






