//
//  ViewController.swift
//  UITextView
//
//  Created by IFCE on 05/06/17.
//  Copyright © 2017 IFCE. All rights reserved.
//
//  sandBox
//

import UIKit

class ViewController: UIViewController {
    // [1]
    var fileManager: FileManager = FileManager.default
    var docsDir: String?
    var dataFilePath: String?
    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var salvar: UIButton!
    @IBOutlet weak var apaga: UIButton!
    @IBOutlet weak var recupera: UIButton!
    
    @IBAction func salva(_ sender: UIButton) {
        
        do {
            try self.textView.text!.write(toFile: dataFilePath!, atomically: true, encoding: String.Encoding.utf8)
            self.error.text = "OK"
        } catch {
            print(error)
        }
        
//        // converte o texto do textView num NSData
//        let dataBuffer = (self.textView.text! as NSString).data (using: String.Encoding.utf8.rawValue)
//        // grava o arquivo no caminho criado em viewDidLoad
//        self.fileManager.createFile(atPath: dataFilePath!, contents: dataBuffer, attributes: nil)
        
    }
    
    
    @IBAction func apagar(_ sender: UIButton) {
        do {
            try self.fileManager.removeItem(atPath: dataFilePath!)
            print("Remove successful")
            self.error.text = "Remove successful"
        } catch {
            print("Remove failed with error: \(error)")
            self.error.text = "Remove failed with error: \(error)"
        }
    }
    
    // Le arquivo - FileHandle
    @IBAction func recuperar(_ sender: UIButton) {
        // Abre o arquivo e associa o handle
        let file: FileHandle? = FileHandle(forReadingAtPath: dataFilePath!)
        if file == nil {
            print("File open failed!")
            self.error.text = "File open failed!"
        } else {
            // le todo o arquivo num NSData
            let dataBuffer = file?.readDataToEndOfFile()
            
            file?.closeFile()
            // coloca a String na View
            self.textView.text = NSString(data: dataBuffer!, encoding: String.Encoding.utf8.rawValue)! as String
            self.error.text = ""
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // [4] recupera o caminho pra descobrir a pasta
        self.docsDir = self.getDocumentDirectory()
        
        // monsta e concatena string com caminho e nome do arquivo
        self.dataFilePath = String(format: "%@/textfile.txt", docsDir!)
        
        if fileManager.fileExists(atPath: dataFilePath!) {
            // obtem dados do arquivo
            let dataBuffer = fileManager.contents(atPath: dataFilePath!)
            // converte dados do arquivo em NSString
            let dataString = NSString(data: dataBuffer!, encoding: String.Encoding.utf8.rawValue)
            self.textView.text = String(dataString!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // [2] Retorna o diretorio de documentos do App
    // command + shift + g na pasta command + v e enter
    func getDocumentDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // [3]
    override func viewDidAppear(_ animated: Bool) {
        print(self.getDocumentDirectory())
    }
}

