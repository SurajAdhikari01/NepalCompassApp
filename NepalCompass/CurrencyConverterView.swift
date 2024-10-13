import SwiftUI

struct CurrencyConverterView: View {
    @State private var inputAmount: String = "1.00" // Default input amount
    @State private var selectedCurrencyFrom: String = "USD"
    @State private var selectedCurrencyTo: String = "NPR"
    @State private var convertedAmount: String = ""
    
    // Example currency rates (USD to others)
    let exchangeRates: [String: Double] = [
        "USD": 1.0,      // Base
        "NPR": 132.12,   // Example rate
        "EUR": 0.95,     // Example rate
        "GBP": 0.81      // Example rate
    ]
    
    // List of supported currencies
    let currencies = ["USD", "NPR", "EUR", "GBP"]
    
    var body: some View {
        VStack {
            Text("Currency Converter")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            // Input amount
            TextField("Amount", text: $inputAmount)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
                .padding()
            
            // Currency selection for "From"
            HStack {
                Text("From:")
                    .font(.headline)
                
                Picker("From Currency", selection: $selectedCurrencyFrom) {
                    ForEach(currencies, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.horizontal)
            
            // Currency selection for "To"
            HStack {
                Text("To:")
                    .font(.headline)
                
                Picker("To Currency", selection: $selectedCurrencyTo) {
                    ForEach(currencies, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }
            .padding(.horizontal)
            
            // Convert button
            Button(action: {
                convertCurrency()
            }) {
                Text("Convert")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.top, 20)
            
            // Display the result
            if !convertedAmount.isEmpty {
                Text("Converted Amount: \(convertedAmount)")
                    .font(.headline)
                    .padding(.top, 20)
            }
            
            Spacer()
        }
        .padding()
    }
    
    // Function to perform currency conversion
    func convertCurrency() {
        // Convert the input amount to a Double
        guard let amount = Double(inputAmount) else {
            convertedAmount = "Invalid amount"
            return
        }
        
        // Get the exchange rates for the selected currencies
        let rateFrom = exchangeRates[selectedCurrencyFrom] ?? 1.0
        let rateTo = exchangeRates[selectedCurrencyTo] ?? 1.0
        
        // Calculate the converted amount
        let result = amount * rateTo / rateFrom
        
        // Format the result to 2 decimal places
        let formattedResult = String(format: "%.2f", result)
        
        // Update the convertedAmount state
        convertedAmount = "\(formattedResult) \(selectedCurrencyTo)"
    }
}

#Preview {
    CurrencyConverterView()
}
