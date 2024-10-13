import SwiftUI

struct NoteView: View {
    // Accessing the persisted color for Note background
    @AppStorage("NotesBG") private var noteBGHex: String = "#FFC0CB" // Default color as a hex string
    
    var noteText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Note icon with a linear gradient from green to blue
                Image(systemName: "note")
                    .font(.title)
                    .foregroundStyle(
                        LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )
                
                Text("Note")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(.bottom)
            
            Text(noteText)
                .font(.body)
        }
        .padding()
        .background(
            
            ZStack {
                Color(hex: noteBGHex).opacity(0.2)
                // Apply the color with blur
                // Add your NotesBG color here with slight opacity
                VisualEffectBlur(blurStyle: .systemMaterial) // Blur layer over the color
                
            }
        )
        .cornerRadius(8)
        .padding(.horizontal)
        .lineSpacing(5)
    }
}

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        view.layer.cornerRadius = 10 // Optional: Add rounded corners
        view.clipsToBounds = true
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}


#Preview {
    NoteView(noteText: "This is a test text for note to see how it appears on app screen to be used on")
}
