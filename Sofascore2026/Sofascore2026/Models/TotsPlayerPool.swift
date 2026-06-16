import Foundation

enum TotsPlayerPool {
    static let all: [TotsPlayer] = [
        // GK
        TotsPlayer(id: 1,  name: "Donnarumma",      line: .goalkeeper, number: 25, club: .manCity),
        TotsPlayer(id: 2,  name: "Raya",            line: .goalkeeper, number: 22, club: .arsenal),
        TotsPlayer(id: 3,  name: "Roefs",           line: .goalkeeper, number: 1,  club: .sunderland),
        // DEF
        TotsPlayer(id: 4,  name: "Lewis Hall",      line: .defense, number: 20, club: .newcastle),
        TotsPlayer(id: 5,  name: "Gabriel",         line: .defense, number: 6,  club: .arsenal),
        TotsPlayer(id: 6,  name: "Saliba",          line: .defense, number: 2,  club: .arsenal),
        TotsPlayer(id: 7,  name: "O'Reilly",        line: .defense, number: 24, club: .manCity),
        TotsPlayer(id: 8,  name: "Mukiele",         line: .defense, number: 12, club: .sunderland),
        TotsPlayer(id: 9,  name: "Senesi",          line: .defense, number: 25, club: .bournemouth),
        TotsPlayer(id: 10, name: "Timber",          line: .defense, number: 12, club: .arsenal),
        TotsPlayer(id: 11, name: "Cucurella",       line: .defense, number: 3,  club: .chelsea),
        // MID
        TotsPlayer(id: 12, name: "Elliott Anderson", line: .midfield, number: 8,  club: .nottinghamForest),
        TotsPlayer(id: 13, name: "Bruno Fernandes",  line: .midfield, number: 8,  club: .manUtd),
        TotsPlayer(id: 14, name: "Enzo Fernández",   line: .midfield, number: 8,  club: .chelsea),
        TotsPlayer(id: 15, name: "Rice",             line: .midfield, number: 41, club: .arsenal),
        TotsPlayer(id: 16, name: "Szoboszlai",       line: .midfield, number: 8,  club: .liverpool),
        TotsPlayer(id: 17, name: "Xhaka",            line: .midfield, number: 34, club: .sunderland),
        TotsPlayer(id: 18, name: "Harry Wilson",     line: .midfield, number: 8,  club: .fulham),
        TotsPlayer(id: 19, name: "Adam Wharton",     line: .midfield, number: 20, club: .crystalPalace),
        // ATT
        TotsPlayer(id: 20, name: "Haaland",         line: .attack, number: 9,  club: .manCity),
        TotsPlayer(id: 21, name: "Gyökeres",        line: .attack, number: 14, club: .arsenal),
        TotsPlayer(id: 22, name: "Semenyo",         line: .attack, number: 24, club: .bournemouth),
        TotsPlayer(id: 23, name: "Saka",            line: .attack, number: 7,  club: .arsenal),
        TotsPlayer(id: 24, name: "João Pedro",      line: .attack, number: 20, club: .chelsea)
    ]
}
