import Vapor

protocol Email: Content {}

struct BrevoMail: Email {
    struct Contact: Content {
        let name: String
        let email: String
    }
    
    let sender: Contact
    let to: [Contact]
    let subject: String
    let htmlContent: String
}
