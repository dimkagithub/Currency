import UIKit

struct Information: Decodable {
    let date, previousDate: String
    let previousURL: String
    let timestamp: String
    let valute: [String: Currency]

    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case previousDate = "PreviousDate"
        case previousURL = "PreviousURL"
        case timestamp = "Timestamp"
        case valute = "Valute"
    }
}

struct Currency: Decodable {
    let id, numCode, charCode: String
    let nominal: Int
    let name: String
    let value, previous: Double

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case numCode = "NumCode"
        case charCode = "CharCode"
        case nominal = "Nominal"
        case name = "Name"
        case value = "Value"
        case previous = "Previous"
    }
}

enum CurrencyName: String {
    case All = ""
    case AUD = "AUD"
    case AZN = "AZN"
    case GBP = "GBP"
    case AMD = "AMD"
    case BYN = "BYN"
    case BGN = "BGN"
    case BRL = "BRL"
    case HUF = "HUF"
    case HKD = "HKD"
    case DKK = "DKK"
    case USD = "USD"
    case EUR = "EUR"
    case INR = "INR"
    case KZT = "KZT"
    case CAD = "CAD"
    case KGS = "KGS"
    case CNY = "CNY"
    case MDL = "MDL"
    case NOK = "NOK"
    case PLN = "PLN"
    case RON = "RON"
    case XDR = "XDR"
    case SGD = "SGD"
    case TJS = "TJS"
    case TRY = "TRY"
    case TMT = "TMT"
    case UZS = "UZS"
    case UAH = "UAH"
    case CZK = "CZK"
    case SEK = "SEK"
    case CHF = "CHF"
    case ZAR = "ZAR"
    case KRW = "KRW"
    case JPY = "JPY"
}

extension Double {
      var roundTo: Double { (self * 100).rounded() / 100 }
}

func getRates(_ currency: String) {
    let urlString = "https://www.cbr-xml-daily.ru/daily_json.js"
    guard let url = URL(string: urlString) else { return }
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else { return }
        guard error == nil else { return }
        if currency == "" {
            do {
                let information = try JSONDecoder().decode(Information.self, from: data)
                print("Курсы валют ЦБ РФ на \(information.date)\n")
                for currency in information.valute.values {
                    let changes = (currency.value - currency.previous).roundTo
                    print(currency.numCode, currency.charCode, currency.nominal, currency.name, currency.value, "руб.", "(\(changes))")
                }
            } catch let error {
                print(error)
            }
        } else {
            do {
                let information = try JSONDecoder().decode(Information.self, from: data)
                
                print("Курс ЦБ РФ на \(information.date)\n")
                if let currencyName = information.valute[currency] {
                    let changes = (currencyName.value - currencyName.previous).roundTo
                    print(currencyName.numCode, currencyName.charCode, currencyName.nominal, currencyName.name, currencyName.value.roundTo, "руб.", "(\(changes))")
                } else {
                    print("Валюта не найдена")
                }
            } catch let error {
                print(error)
            }
        }
    }.resume()
}

getRates(CurrencyName.All.rawValue)
