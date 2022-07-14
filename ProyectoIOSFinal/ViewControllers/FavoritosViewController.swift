//
//  ComprasViewController.swift
//  ProyectoIOSFinal
//
//  Created by Victor Mollocondo Asillo on 1/07/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class FavoritosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tablaEscodigos: UITableView!
    
    
    var libros:[books] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libros.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let product = libros[indexPath.row]
        cell.textLabel?.text = product.libro
        cell.detailTextLabel?.text = product.precio
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaEscodigos.delegate = self
        tablaEscodigos.dataSource = self
        Database.database().reference().child("Usuarios").child(Auth.auth().currentUser!.uid).child("compras").observe(DataEventType.childAdded, with: {(snapshot) in print("este es el snapppp:\(snapshot)")
            let libross = books()
            print("valor:\((snapshot.value as! NSDictionary)["Precio"] as! String)")
            libross.libro = (snapshot.value as! NSDictionary)["Producto"] as! String
            libross.precio = (snapshot.value as! NSDictionary)["Precio"] as! String
            
            self.libros.append(libross)
            self.tablaEscodigos.reloadData()
        })
        
    }
    
    @IBAction func enviarSugerencia(_ sender: Any) {
        performSegue(withIdentifier: "segueSugerencia", sender: nil)
    }
    
}
