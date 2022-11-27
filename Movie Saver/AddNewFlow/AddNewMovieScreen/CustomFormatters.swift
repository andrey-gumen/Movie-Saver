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
