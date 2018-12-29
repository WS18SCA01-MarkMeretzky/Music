//
//  ViewController.swift
//  Music
//
//  Created by Mark Meretzky on 12/28/18.
//  Copyright © 2018 New York University School of Professional Studies. All rights reserved.
//

import UIKit;
import AVFoundation;

class ViewController: UIViewController {
    //The inspectable properties are listed in the view controller's Attributes Inspector.
    @IBInspectable var filename: String = "";
    @IBInspectable var filenameExtension: String = "";
    var audioPlayer: AVAudioPlayer? = nil;

    override func viewDidLoad() {
        super.viewDidLoad();
        // Do any additional setup after loading the view, typically from a nib.
        print("viewDidLoad");
 
        guard let url = Bundle.main.url(forResource: filename, withExtension: filenameExtension) else {
            return;
        }
        print("url = \(url)");
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url);
        } catch {
            print("could not create AVAudioPlayer: \(error)");
            return;
        }
        
        audioPlayer!.numberOfLoops = -1;   //infinity
        let settings: [String: Any]! = audioPlayer!.settings;    //a dictionary
        
        for (key, value) in settings {
            switch key {
            case AVAudioFileTypeKey, AVFormatIDKey:
                let i: Int = value as! Int;
                var hex: String = String(i, radix: 16);          //8 hexadecimal digits
                var stringValue: String = "";
                while !hex.isEmpty {
                    let firstChar: Substring = hex.prefix(2);    //2 hexadecimal digits
                    let ascii: Int = Int(firstChar, radix: 16)!; //ASCII code
                    stringValue += String(UnicodeScalar(ascii)!);
                    hex = String(hex.dropFirst(2));
                }
                print("\(key): \(stringValue)");
            default:
                print("\(key): \(value)");
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        audioPlayer?.prepareToPlay();   //question mark is optional chaining
    }
    
    //Must play in viewDidAppear, because viewWillAppear might be called
    //before the previous view controller has disappeared.
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        audioPlayer?.play();
    }
    
    //Must pause in viewWillDisappear, because viewDidDisappear might not be called.
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        audioPlayer?.pause();
    }

}

