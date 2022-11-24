import UIKit
import Foundation

protocol HomeViewControllerDelegate: AnyObject {
    func homeViewControllerDidTapOnAddButton(_ homeViewController: HomeViewController)
}

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var CardCollectionView: UICollectionView!
    @IBOutlet private weak var MovementsCollectionView: UITableView!
    @IBOutlet private weak var fullName: UILabel!
    @IBOutlet private weak var balance: UILabel!
    
    weak var delegate: HomeViewControllerDelegate?
    
    private var parsedData: FinalObject!
    
    func setup() {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
    }
    
    struct UserInfo: Codable {
        let nome: String
        let cognome: String
        let saldo: String
    }

    struct Cards: Codable {
        let circuito: String
        let coloreHex: String
    }

    struct Movements: Codable {
        let esercente: String
        let descrizione: String
        let importo: String
    }

    struct FinalObject: Codable {
        let infoPrincipali: UserInfo
        let carte: [Cards]
        var listaMovimenti: [Movements]
    }

    private func readLocalFile(forName name: String) -> Data? {
        do {
            guard let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                  let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8)
            else { return nil }
                
            return jsonData
            
        } catch {
            print(error)
            return nil
        }
    }

    private func parse(jsonData: Data) -> FinalObject? {
        do {
            let decodedData = try JSONDecoder().decode(FinalObject.self, from: jsonData)
            return decodedData
        } catch {
            print("Decode error")
        }
        
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CardCollectionView.dataSource = self
        CardCollectionView.delegate = self
        
        MovementsCollectionView.dataSource = self
        MovementsCollectionView.delegate = self
        
        if let localData = self.readLocalFile(forName: "bankingData") {
            parsedData = self.parse(jsonData: localData)
            
            fullName.text = "\(parsedData.infoPrincipali.nome)"
            balance.text = "Saldo: \(parsedData.infoPrincipali.saldo) €"
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        
//        guard let addViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "addViewController") as? AddMovementViewController else { return }
        
        delegate?.homeViewControllerDidTapOnAddButton(self)
    }
    
    func addMovement(with importo: String, and name: String) {
        let newMovement = Movements(esercente: name, descrizione: "Transazione", importo: importo)
        parsedData.listaMovimenti.insert(newMovement, at: 0)
        MovementsCollectionView.reloadData()
        // tableView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parsedData.carte.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath) as! CardCollectionViewCell
        let section = parsedData.carte[indexPath.item]
        
        cell.cardLabel.text = section.circuito
        cell.cardColor.backgroundColor = UIColor.blue
        
        return cell
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parsedData.listaMovimenti.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = MovementsCollectionView.dequeueReusableCell(withIdentifier: "MovementCell", for: indexPath) as? MovementsTableCell
        else { return UITableViewCell() }
        
        let movement = parsedData.listaMovimenti[indexPath.row]
        let firstOccurrenceIndex = movement.importo.index(movement.importo.startIndex, offsetBy: 0)
        let color: UIColor = movement.importo[firstOccurrenceIndex] == "-" ? .red : .systemGreen
        
        cell.titleLabel.text = movement.esercente
        cell.descriptionLabel.text = movement.descrizione
        cell.amountLabel.text = "\(movement.importo) €"
        cell.amountLabel.textColor = color
        
        return cell
    }
}

extension HomeViewController: AddMovementViewControllerDelegate {
    func addMovementViewController(_ addMovementViewController: AddMovementViewController, didTapConfirmWithAmout amount: String!, and name: String!) {
        addMovement(with: amount, and: name)
    }
}
