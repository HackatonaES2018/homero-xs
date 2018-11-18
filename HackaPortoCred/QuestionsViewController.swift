//
//  QuestionsViewController.swift
//  HackaPortoCred
//
//  Created by Eduardo Fornari on 18/11/18.
//  Copyright © 2018 HomeroXS. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController {

    var openCell = -1
    var questions = [("1. O que preciso saber antes de inciar minha solicitação de crédito no aplicativo Consignado Privado Portocred?",
                      "R: Você deve:\n. Pertencer à classe profissional \"assalariado\" de uma empresa conveniada Portocred;\n. Apresentar CPF regular na Receita federal;\n. Possuir Alfabetização;\n. Possuir idade mínima de 18 anos;\n. Possuir renda igual ou superior ao salário mínimo nacional;\n. Possuir nacionalidade \"Brasileiro Nato\" ou \"Brasileiro Naturalizado\"."),
                     
                     ("2. Já possuo um contrato ativo no Consignado Privado com a Portocred, conseguirei refinanciá-lo via aplicativo?",
                      "R: Nessa versão do aplicativo a opção de refinanciamento de contratos ainda não está disponível, a disponibilidade é somente para solicitação de novos contratos.\n\nO financiamento  poderá ser solicitado via Central de Vendas pelos telefones:\n0800-600-0772 ou 3004-7084 (para ligações a partir de celulares em Capitais e Regiões Metropolitanas). Atendimento dias úteis, de 2ª a 6ª feira, das 09h  às 19h."),
                     
                     ("3. Após minha solicitação do Consignado Privado Portocred via aplicativo, será necessário ir até uma Loja ou Parceiro autorizado Portocred para finalizar a contratação?",
                        "R: Não. Para sua comodidade e agilidade, toda a contratação é feita 100% via aplicativo."),
                     
                     ("4. Como faço para solicitar meu Consignado Privado Portocred via aplicativo?",
                      "R: É muito fácil!\n\nPrimeiro é necessário que sua empresa seja uma conveniada Portocred.\nSe sim, basta inserir algumas informações na tela principal do aplicativo para realizarmos a confirmação positiva dos dados na base de cadastro Portocred.\nSendo as informações validadas, você receberá um código de acesso e estará pronto para simular e contratar o Consignado privado Portocred.")]
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension QuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath)
        cell.textLabel?.text = questions[indexPath.row].0
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.textLabel?.textColor = #colorLiteral(red: 0.09803921569, green: 0.168627451, blue: 0.3647058824, alpha: 1)
        if openCell == indexPath.row {
            cell.detailTextLabel?.text = questions[indexPath.row].1
        } else {
            cell.detailTextLabel?.text = ""
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if openCell != indexPath.row {
            if openCell != -1 {
                let indexPath1 = IndexPath(row: openCell, section: 0)
                tableView.reloadRows(at: [indexPath1], with: .automatic)
            }
            openCell = indexPath.row
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            openCell = -1
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
    }
}
