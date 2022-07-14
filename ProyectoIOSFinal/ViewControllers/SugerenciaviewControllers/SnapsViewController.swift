//
//  SnapsViewController.swift
//  ProyectoIOSFinal
//
//  Created by Victor Mollocondo Asillo on 4/07/22.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0{
            return 1
        }else{
            return snaps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if snaps.count == 0 {
            cell.textLabel?.text = "No Tienes Sugerencias :( "
        }else{
            let snap = snaps[indexPath.row]
            cell.textLabel?.text = snap.from
           
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        self.performSegue(withIdentifier: "segueVer", sender: snap)
    }
    
    @IBOutlet weak var tablaSnaps: UITableView!
    var snaps:[Snap] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaSnaps.delegate = self
        tablaSnaps.dataSource = self
        
        Database.database().reference().child("Usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with: { (snapshot) in
            let snap = Snap()
            snap.imagenURL = (snapshot.value as! NSDictionary)["imagenURL"] as! String
            snap.from = (snapshot.value as! NSDictionary)["from"] as! String
            snap.mensaje = (snapshot.value as! NSDictionary)["mensaje"] as! String
            snap.id = snapshot.key
            snap.imagenID = (snapshot.value as! NSDictionary)["imagenID"] as! String
            self.snaps.append(snap)
            self.tablaSnaps.reloadData()
        })
        
        Database.database().reference().child("Usuarios").child((Auth.auth().currentUser?.uid)!).child("snaps").observe(DataEventType.childAdded, with: { (snapshot) in
            var iterator = 0
            for snap in self.snaps{
                if snap.id == snapshot.key{
                    self.snaps.remove(at: iterator)
                }
                iterator += 1
            }
            self.tablaSnaps.reloadData()
        })

        
    }
    @IBAction func nuevoMensaje(_ sender: Any) {
        performSegue(withIdentifier: "segueMensaje", sender: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueVer" {
            let siguienteVC = segue.destination as! verSugerenciaViewController
            siguienteVC.snap = sender as! Snap
        }
    }

}
