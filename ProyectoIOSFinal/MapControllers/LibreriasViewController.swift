//
//  LibreriasViewController.swift
//  ProyectoIOSFinal
//
//  Created by Victor Mollocondo Asillo on 3/07/22.
//



import UIKit

class LibreriasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let libros:Libros
        if indexPath.section == 0{
            libros = librosAtrapados[indexPath.row]
        }else{
            libros = librosNoAtrapados[indexPath.row]
        }
        let cell = UITableViewCell()
        cell.textLabel?.text = libros.nombre
        cell.imageView?.image = UIImage(named: libros.imagenNombre!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return librosAtrapados.count
        }else{
            return librosNoAtrapados.count
        }
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    
    var librosAtrapados:[Libros] = []
    var librosNoAtrapados:[Libros] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        librosAtrapados = obtenerLibreriasAtrapados()
        librosNoAtrapados = obtenerLibreriasNoAtrapados()
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }else{
            return "Lista de Librerias"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    


}
