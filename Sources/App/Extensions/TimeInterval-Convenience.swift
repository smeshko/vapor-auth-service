import Foundation

public extension Int {
    var seconds: TimeInterval {
        time
    }
    
    var minutes: TimeInterval {
        time * 60
    }
    
    var hours: TimeInterval {
        minutes * 60
    }
    
    var days: TimeInterval {
        hours * 24
    }
    
    var weeks: TimeInterval {
        days * 7
    }
}

public extension Int {
    var time: TimeInterval {
        TimeInterval(self)
    }
}
