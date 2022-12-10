import Foundation

final class ShortDateFormatter: DateFormatter {
    
    override init() {
        super.init()
        dateFormat = DateFormatter.dateFormat(
            fromTemplate: "dd/MMM/yyyy",
            options: 0,
            locale: Locale.current
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

final class RatingFormatter: NumberFormatter {
    
    override init() {
        super.init()
        numberStyle = .decimal
        self.maximumFractionDigits = 1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

