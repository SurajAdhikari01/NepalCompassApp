// Persist the selected theme
import SwiftUI

struct SettingsView: View {
@AppStorage("selectedTheme") private var selectedTheme: String = "System"
    
    // Persist the color variables for different views
    @AppStorage("RecommendationBG") private var savedRecommendationBGHex: String = "#0000FF"
    @AppStorage("NotesBG") private var savedNotesBGHex: String = "#FF0000"
    @AppStorage("AccentColor") private var savedAccentColorHex: String = "#FFC0CB"
    @AppStorage("TableBG") private var savedTableBGHex: String = "#800080"
    
    // Temporary variables to store selected palette colors before applying
    @State private var recommendationBGHex: String = "#0000FF"
    @State private var notesBGHex: String = "#FF0000"
    @State private var accentColorHex: String = "#FFC0CB"
    @State private var tableBGHex: String = "#800080"
    
    // Dynamic color binding to store selected palette colors
    @State private var recommendationBG: Color = Color.blue
    @State private var notesBG: Color = Color.red
    @State private var accentColor: Color = Color.pink
    @State private var tableBG: Color = Color.purple
    
    // Pastel color palette (each item is a group of 4 colors)
    let colorPalette: [[Color]] = [
        [.blue.opacity(0.4), .red.opacity(0.4), .pink.opacity(0.4), .purple.opacity(0.4)],
        [.green.opacity(0.4), .yellow.opacity(0.4), .orange.opacity(0.4), .mint.opacity(0.4)],
        [.cyan.opacity(0.4), .teal.opacity(0.4), .indigo.opacity(0.4), .green.opacity(0.4)],
        [.pink.opacity(0.4), .purple.opacity(0.4), .yellow.opacity(0.4), .blue.opacity(0.4)]
    ]
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    // Title
                    Text("Appearance")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                        .padding()
                    
                    // Theme Selection
                    ThemeSelectionView(selectedTheme: $selectedTheme)
                        .padding()
                    
                    // Color Palette Selection
                    ColorPaletteView(
                        recommendationBGHex: $recommendationBGHex,
                        notesBGHex: $notesBGHex,
                        accentColorHex: $accentColorHex,
                        tableBGHex: $tableBGHex,
                        colorPalette: colorPalette,
                        recommendationBG: $recommendationBG,
                        notesBG: $notesBG,
                        accentColor: $accentColor,
                        tableBG: $tableBG
                    )
                        .padding()
                    
                    // Preview Section
                    PreviewSection(
                        recommendationBG: recommendationBG,
                        notesBG: notesBG,
                        accentColor: accentColor,
                        tableBG: tableBG
                    )
                    
                    Spacer()
                    
                    // Apply Button
                    ApplyButton(
                        applyChanges: applyChanges
                    )
                        .padding()
                }
            }
            .navigationTitle("Settings")
            .preferredColorScheme(getColorScheme())
        }
        .onAppear {
            // Load the colors from stored hex values initially
            updateColorsFromStorage()
        }
    }
    
    
    // Helper function to return appropriate color scheme
    func getColorScheme() -> ColorScheme? {
        switch selectedTheme {
        case "Light":
            return .light
        case "Dark":
            return .dark
        default:
            return nil  // System default
        }
    }
    
    func updateColorsFromStorage() {
            recommendationBGHex = savedRecommendationBGHex
            notesBGHex = savedNotesBGHex
            accentColorHex = savedAccentColorHex
            tableBGHex = savedTableBGHex
            
            recommendationBG = Color(hex: recommendationBGHex)
            notesBG = Color(hex: notesBGHex)
            accentColor = Color(hex: accentColorHex)
            tableBG = Color(hex: tableBGHex)
        }
        
        // Apply the selected colors to AppStorage when Apply button is clicked
        func applyChanges() {
            savedRecommendationBGHex = recommendationBGHex
            savedNotesBGHex = notesBGHex
            savedAccentColorHex = accentColorHex
            savedTableBGHex = tableBGHex
            print(savedRecommendationBGHex)
            print(savedNotesBGHex)
        }
}

struct ThemeSelectionView: View {
    @Binding var selectedTheme: String
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(["System", "Light", "Dark"], id: \.self) { theme in
                Button(action: {
                    selectedTheme = theme
                }) {
                    Text(theme)
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedTheme == theme ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                }
            }
        }
        .cornerRadius(10)
        .padding(.bottom, 30)
    }
}

struct ColorPaletteView: View {
    @Binding var recommendationBGHex: String
    @Binding var notesBGHex: String
    @Binding var accentColorHex: String
    @Binding var tableBGHex: String
    let colorPalette: [[Color]]
    @Binding var recommendationBG: Color
    @Binding var notesBG: Color
    @Binding var accentColor: Color
    @Binding var tableBG: Color
    
    // Add a state to keep track of the selected palette
        @State private var selectedPaletteIndex: Int? = nil
    var body: some View {
        VStack(alignment: .leading) {
            Text("Select Color Palette")
                .font(.headline)
                .padding(.bottom, 10)
                
            
         //   ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(colorPalette.indices, id: \.self) { index in
                        let colorSet = colorPalette[index]
                        Button(action: {
                            applyPalette(colorSet, index: index)
                        }) {
                            VStack(spacing: 2) {
                             //   ForEach(colorSet, id: \.self) { color in
                             //       Rectangle()
                             //           .fill(color)
                              //          .frame(height: 60)
                           // }
                                Rectangle().fill(colorSet[2]).frame(height: 60) // Accent
                                Rectangle().fill(colorSet[0]).frame(height: 60) // Recommendation
                                Rectangle().fill(colorSet[1]).frame(height: 60) // Notes
                                Rectangle().fill(colorSet[3]).frame(height: 60) // Table
                                    
                                
                            }
                            
                            .overlay(
                                                            // Highlight the selected palette with a black border
                                                            RoundedRectangle(cornerRadius: 5)
                                                                .stroke(selectedPaletteIndex == index ? Color.primary : Color.gray, lineWidth: selectedPaletteIndex == index ? 2 : 1)
                                                        )                        }
                    }
                }
                .padding(.horizontal)
          //  }
            .padding(.bottom, 30)
        }
    }
    
    // Apply the selected color palette
    func applyPalette(_ colorSet: [Color],index: Int) {
        recommendationBG = colorSet[0]
        notesBG = colorSet[1]
        accentColor = colorSet[2]
        tableBG = colorSet[3]
        
        // Store the hex values
        recommendationBGHex = recommendationBG.toHex() ?? "#0000FF"
        notesBGHex = notesBG.toHex() ?? "#FF0000"
        accentColorHex = accentColor.toHex() ?? "#FFC0CB"
        tableBGHex = tableBG.toHex() ?? "#800080"
        
        selectedPaletteIndex = index
    }
}

struct PreviewSection: View {
    let recommendationBG: Color
    let notesBG: Color
    let accentColor: Color
    let tableBG: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Preview")
                .font(.headline)
                .padding(.bottom, 10)
                .padding()
            
            VStack(spacing: 20) {
                // RecommendationView Preview
                RecommendationViewPreview(recommendationText: "This is how recommendation looks", recommendationBG: recommendationBG)

                    .cornerRadius(10)
                    
                // NotesView Preview
                NoteViewPreview(noteText: "This is how notes look", noteBG: notesBG)
                    
                    .cornerRadius(10)
                
                // TextView Preview
                HStack{
                    Spacer()
                    Text("This is how accent color looks")
                        .font(.headline)
                        .foregroundColor(accentColor)
                        .padding()
                    Spacer()
                }
                
                
                // TableView Preview
              //  TableView()
              //      .background(tableBG.opacity(0.2))
              //      .cornerRadius(10)
            }
        }
    }
}

struct ApplyButton: View {
    let applyChanges: () -> Void
    
    var body: some View {
        Button(action: {
            applyChanges()
            print("Changes applied.")
        }) {
            Text("Apply")
                .font(.title2)
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.top, 30)
    }
}

// Helper function to convert Color to Hex String
extension Color {
    func toHex() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let hexString = String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(red) * 255),
            lroundf(Float(green) * 255),
            lroundf(Float(blue) * 255)
        )
        return hexString
    }
}

// Helper function to initialize Color from Hex String
extension Color {
    init(hex: String) {
        let hexValue = hex.replacingOccurrences(of: "#", with: "")
        var int = UInt64()
        Scanner(string: hexValue).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hexValue.count {
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = ((int >> 24) & 0xff, (int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct RecommendationViewPreview: View {
    var recommendationText: String // Dynamic text variable
    var recommendationBG: Color

   

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
                Color(recommendationBG.opacity(0.2))

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

struct NoteViewPreview: View {
    // Accessing the persisted color for Note background
    
    var noteText: String
    var noteBG: Color
    
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
                Color(noteBG.opacity(0.2))
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




struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
