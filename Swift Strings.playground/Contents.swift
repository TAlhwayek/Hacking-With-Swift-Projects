import UIKit

let name = "Taylor"

for letter in name {
    print("Give me a \(letter)!")
}

// Prints the fourth letter
let letter = name[name.index(name.startIndex, offsetBy: 3)]

// This allows the subscript operator to work on strings
extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

//
let letter2 = name[3]
print(letter2)



// Part 2

let password = "12345"
password.hasPrefix("123")
password.hasSuffix("456")

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}


let weather = "It's going to rain"
print(weather.capitalized)

let input = "Swift is like Obj-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}

input.containsAny(of: languages)

// Check if something in the string exists in the array
// It checks the entire array
// i.e. checks for python, and gets false
// checks for ruby and gets false
// checks for swift and gets true, therefore it returns true
languages.contains(where: input.contains)

let string = "This is a test string"

let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSAttributedString(string: string, attributes: attributes)

let string2 = "This is a test string"

let attributedString2 = NSMutableAttributedString(string: string2)

attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))


// Challenge #1
extension String {
    mutating func withPrefix(_ prefix: String) -> String {
        if self.contains(prefix) {
            return self
        }
        else {
            self = prefix + self
            return self
        }
    }
}

var pet = "pet"
pet.withPrefix("car")
print(pet)


// Challenge #2
extension String {
    func isNumeric() -> Bool {
        if let doubleString = Double(self) {
            return true
        } else {
            return false
        }
    }
}

pet.isNumeric()
var num = "849239"
num.isNumeric()

// Challenge #3
extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}
let string22 = "this\nis\na\ntest"
print(string22.lines)
