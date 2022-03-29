import Foundation
import Commands

func carregarJSON(nomeArquivo: String, caminho: URL) throws -> [String: [String]]? {
    let caminhoFinal = caminho.appendingPathComponent(nomeArquivo)
    let dados = try Data(contentsOf: caminhoFinal)
    let dadosJSON = try JSONSerialization.jsonObject(with: dados, options: [.mutableLeaves, .mutableContainers]) as? [String: [String]]
    return dadosJSON
}

func salvarJSON(objetoJSON: Any, nomeArquivoJSON: String, caminho: URL) throws{
    let caminhoFinal = caminho.appendingPathComponent(nomeArquivoJSON)
    let dados = try JSONSerialization.data(withJSONObject: objetoJSON, options: [.prettyPrinted])
    try dados.write(to: caminhoFinal, options: [.atomic])
}


let fmanager = FileManager.default
let arquivoAgenda = "agenda.json"
let caminhoAgenda = "Documents/.Agenda"
let caminhoPadrao = fmanager.homeDirectoryForCurrentUser
let caminhofinal = caminhoPadrao.appendingPathComponent(caminhoAgenda)

if !fmanager.fileExists(atPath: caminhofinal.path){
    try fmanager.createDirectory(at: caminhofinal, withIntermediateDirectories: true, attributes: nil)
    let agenda: [String: [String]] = [
        "segunda": [""],
        "terca": [""],
        "quarta": [""],
        "quinta": [""],
        "sexta": [""],
        "sabado": [""],
        "domingo": [""]
        ]
    try salvarJSON(objetoJSON: agenda, nomeArquivoJSON: arquivoAgenda, caminho: caminhofinal)

}

print(menssagemInicio)

var opcaoSemana = true

while opcaoSemana { // while precisa de tipo Bool.
print(menuTexto)
let menu = readLine()!
    
switch menu {

    case "1":
        clear()
        print(agendaCompleta())
    
    case "2":
        clear()
        print(escolherDia())
        
    case "3":
        clear()
        let dados = try? carregarJSON(nomeArquivo: arquivoAgenda, caminho: caminhofinal)
        if var dado = dados {
            print("Digite o dia da semana:")
            let dia = readLine()
            if var res = dia{
                res = res.lowercased().replacingOccurrences(of: "ç", with: "c").trimmingCharacters(in: .whitespacesAndNewlines)
                print("Digite o compromisso:")
                let compromisso = readLine()
                if let compromisso = compromisso {
                    dado[res]?.append(compromisso)
                    try salvarJSON(objetoJSON: dado, nomeArquivoJSON: arquivoAgenda, caminho: caminhofinal)
                }
            }
        }
        
    case "4":
    clear()
    let dados = try carregarJSON(nomeArquivo: arquivoAgenda, caminho: caminhofinal)
    if var dado = dados{
        agendaCompleta()
        print("Digite o dia para remover a entrada")
        let dia = readLine()
        if var dia = dia {
            dia = dia.lowercased().replacingOccurrences(of: "ç", with: "c").trimmingCharacters(in: .whitespacesAndNewlines)
            print("Digite o número da entrada que você quer remover:")
            var i = 1
            for valor in dado[dia]!{
                print("\(i): \(valor)")
                i+=1
            }
            let numero = Int(readLine()!)
            if let numero = numero {
                dado[dia]?.remove(at: numero-1)
                try salvarJSON(objetoJSON: dado, nomeArquivoJSON: arquivoAgenda, caminho: caminhofinal)
            }
            else{
                print("Entrada inválida")
            }
        }
    }
    
    case "0":
        print("Até logo!")
        opcaoSemana = false
    default:
    clear()
        print("Escolha uma opção válida")
}
}

//Funcao para escolher o dia da semana a ser exibido
func escolherDia() {
print("digite o dia da semana")
let dados = try? carregarJSON(nomeArquivo: arquivoAgenda, caminho: caminhofinal)

if let dados = dados {
    
    var opcaoDia = true
        
    while opcaoDia {
        
        let menuDia = readLine()!
        
        switch menuDia {

            case "segunda":
            printaDia(dia: "segunda", programacao: dados["segunda"]!)
                
                opcaoDia = false
            
            case "terca":
            printaDia(dia: "terca", programacao: dados["terca"]!)
            
                opcaoDia = false

            case "quarta":
            printaDia(dia: "quarta", programacao: dados["quarta"]!)
            
                opcaoDia = false

            case "quinta":
            printaDia(dia: "quinta", programacao: dados["quinta"]!)
                
                opcaoDia = false

            case "sexta":
            printaDia(dia: "sexta", programacao: dados["sexta"]!)
                opcaoDia = false
            
            default:
                print("\nDigite um valor existente")
                       
        }
     }
}
}


//funcao para exibicao da agenda completa

func agendaCompleta() {
let dados = try? carregarJSON(nomeArquivo: arquivoAgenda, caminho: caminhofinal)
if let dados = dados {
    
    print("=================== SEGUNDA =====================\n")
    for valor in dados["segunda"]!{
        print(valor, "\n")
    }
    
    print("=================== TERÇA  ======================\n")
    for valor in dados["terca"]!{
        print(valor, "\n")
    }
    print("=================== QUARTA ======================\n")
    for valor in dados["quarta"]!{
        print(valor, "\n")
    }
    
    print("=================== QUINTA ======================\n")
    for valor in dados["quinta"]!{
        print(valor, "\n")
    }

    print("=================== SEXTA =======================\n")
    for valor in dados["sexta"]!{
        print(valor, "\n")
    }
    print("=================================================\n")
}
}


//funcao para exibicao de cada dia da semana separadamente
func printaDia(dia: String, programacao: [String]) {
print("\n=======================================\n")
print("         Compromissos - \(dia)\n")
for entrada in programacao{
    print(entrada, "\n")
}

print("\n=======================================\n")

}

func clear() -> Void {
Commands.Bash.system("clear")
}
