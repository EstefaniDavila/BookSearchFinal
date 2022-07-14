//
//  ElegirUsuarioViewController.swift
//  ProyectoIOSFinal
//
//  Created by Victor Mollocondo Asillo on 4/07/22.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class ElegirUsuarioViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let usuario = usuarios[indexPath.row]
        cell.textLabel?.text = usuario.email
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usuario = usuarios[indexPath.row]
        let snap = ["from" : Auth.auth().currentUser?.email, "mensaje": mensaje, "imagenURL": imagenURL, "imagenID" : imagenID ]
            Database.database().reference().child("Usuarios").child(usuario.uid).child("snaps").childByAutoId().setValue(snap)
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBOutlet weak var listaUsuarios: UITableView!
    var usuarios:[Users] = []
    var imagenURL = ""
    var mensaje = ""
    var imagenID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listaUsuarios.delegate = self
        listaUsuarios.dataSource = self
        Database.database().reference().child("Usuarios").observe(DataEventType.childAdded, with: {(snapshot) in
            print(snapshot)
            
            let usuario = Users()
            usuario.email = (snapshot.value as! NSDictionary)["email"] as! String
            usuario.uid = snapshot.key
            self.usuarios.append(usuario)
            self.listaUsuarios.reloadData()
        })
    }

    

}
