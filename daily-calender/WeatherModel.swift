import Foundation

struct WeatherData: Codable {
    let main: MainWeather
    let weather: [WeatherDetail]
}

struct MainWeather: Codable {
    let temp: Double
}

struct WeatherDetail: Codable {
    let description: String
    let icon: String
}

class WeatherViewModel: ObservableObject {
    @Published var temperature = ""
    @Published var description = ""
    @Published var iconURL: URL?
    @Published var errorMessage = ""
    
    private let apiKey = "ce45257614ed34b561d5037a75252988"
    
    func fetchWeather(for city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                    self?.updateWeather(with: weatherData)
                } catch {
                    self?.errorMessage = "Failed to parse data"
                }
            }
        }.resume()
    }
    
    private func updateWeather(with data: WeatherData) {
        temperature = String(format: "%.1f°C", data.main.temp)
        description = data.weather.first?.description.capitalized ?? "N/A"
        if let iconCode = data.weather.first?.icon {
            iconURL = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
        }
        errorMessage = ""
    }
}
