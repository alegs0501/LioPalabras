//
//  MainTableViewController.swift
//  LioPalabras
//
//  Created by CICE on 13/7/18.
//  Copyright © 2018 alegs0501. All rights reserved.
//

import UIKit
import GameplayKit

class MainTableViewController: UITableViewController {
    
    //Properties
    var allWords = [String]()
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

       //Accessing to start.txt
        if let filePath = Bundle.main.path(forResource: "start", ofType: "txt"){
            //Put txt content in to string
            if let startWords = try? String.init(contentsOfFile: filePath){
                //Save words in array allWords
                allWords = startWords.components(separatedBy: "\n")
            }else{
                allWords = ["epic fail"]
            }
        }
        //Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(preguntarRespuesta))
        
        startGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usedWords.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "palabra", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = usedWords[indexPath.row]

        return cell
    }
    
    //MARK: - Game functions
    func startGame(){
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        title = allWords[0]
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
        
    }
    
    @objc func preguntarRespuesta(){
        let alerta = UIAlertController(title: "Introduce tu respuesta", message: nil, preferredStyle: .alert)
        alerta.addTextField(configurationHandler: nil)
        let enviarAction = UIAlertAction(title: "Enviar", style: .default) { (accion) in
            let respuesta = alerta.textFields![0]
            //Send answer
            self.enviarRespuesta(respuesta: respuesta.text!)
        }
        alerta.addAction(enviarAction)
        present(alerta,animated: true, completion: nil)
    }
    
    func enviarRespuesta(respuesta: String){
        //verifyng answer
        if(esPosible(palabra: respuesta.lowercased())
            && esOriginal(palabra: respuesta.lowercased())
            && esReal(palabra: respuesta.lowercased())
            && respuesta != "")
        {
            //add word to usedwords
            usedWords.insert(respuesta, at: 0)
            //Reload table view
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }
    }
    
    //MARK: - Verifying words
    func esPosible(palabra: String) ->  Bool{
        var palabraPpal = title?.lowercased()
        for letra in palabra{
            if let position = palabraPpal?.range(of: String(letra)){
                palabraPpal?.remove(at: position.lowerBound)
            }
            else{
                return false
            }
        }
        return true
    }
    
    func esOriginal(palabra: String) ->  Bool{
        return !usedWords.contains(palabra)
    }
    
    func esReal(palabra: String) ->  Bool{
        let checker = UITextChecker()
        let range = NSMakeRange(0, palabra.utf16.count)
        
        let palabraMalEscrita = checker.rangeOfMisspelledWord(in: palabra, range: range, startingAt: 0, wrap: false, language: "en")
        return palabraMalEscrita.location == NSNotFound
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
