import SwiftUI

struct TextView: View {
    var text: String
    
    var body: some View {
        HStack {
            Text(text)
            Spacer()
        }
        .padding()
        
        .cornerRadius(8)
        .padding(.horizontal)
        
        .lineSpacing(5)
    }
}



#Preview {
    TextView(text: "This is dummy text preview")
}
