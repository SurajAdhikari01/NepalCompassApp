import SwiftUI

struct RecommendationView: View {
    var recommendationText: String // Dynamic text variable

    // Accessing the persisted color for Recommendation background
    @AppStorage("RecommendationBG") private var recommendationBGHex: String = "#0000FF" // Default color as a hex string

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // Star icon with a diagonal gradient
                Image(systemName: "star.circle")
                    .font(.title)
                    .foregroundStyle(
                        LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                    )

                Text("Our Recommendation")
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
            }
            .padding(.bottom) // Spacing below the header
            
            Text(recommendationText) // Dynamic unbolded text
                .font(.body)
        }
        .padding()
        .background(
            ZStack {
                // Apply the recommendation background color with slight opacity
                Color(hex: recommendationBGHex).opacity(0.2)

                // Blur layer over the color
                VisualEffectBlur(blurStyle: .systemMaterial)
            }
            .cornerRadius(8) // Ensure rounded corners for the ZStack
        )
        .cornerRadius(8) // Outer corner radius
        .padding(.horizontal)
        .lineSpacing(5)
    }
}



#Preview {
    RecommendationView(recommendationText: "This is our recommendation text test. This is text just to ensure that it displays correctly for a larger body of text.")
}
