import SwiftUI

struct TableView: View {
    var content: String // Expecting a single string for the table

    // Computed properties to parse headers and data
    private var headers: [String] {
        let rows = content.split(separator: "\n").map { String($0) }
        return rows.first?.split(separator: "|").map { String($0).trimmingCharacters(in: .whitespaces) } ?? []
    }

    private var data: [[String]] {
        let rows = content.split(separator: "\n").map { String($0) }
        return rows.dropFirst().map { row in
            row.split(separator: "|").map { String($0).trimmingCharacters(in: .whitespaces) }
        }
    }

    @State private var selectedRow: Int? // Track which row is selected
    @State private var selectedCell: Int? // Track which cell is selected
    @State private var showDetailView = false // Track the visibility of the detail view

    // Accessing the persisted color for Table background
    @AppStorage("TableBG") private var tableBGHex: String = "#FFC0CB" // Default color as a hex string

    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    // Header Row
                    HStack {
                        ForEach(headers, id: \.self) { header in
                            Text(header)
                                .font(.headline)
                                .padding()
                                .frame(minWidth: 100, maxWidth: .infinity)
                                .background(
                                    ZStack {
                                        Color(hex: tableBGHex).opacity(0.2) // Background color with opacity
                                        VisualEffectBlur(blurStyle: .systemMaterial) // Blur effect
                                    }
                                    .cornerRadius(5)
                                )
                                .lineLimit(1)
                        }
                        .lineSpacing(5)
                    }

                    // Data Rows
                    ForEach(data.indices, id: \.self) { rowIndex in
                        HStack {
                            ForEach(data[rowIndex].indices, id: \.self) { cellIndex in
                                Text(data[rowIndex][cellIndex])
                                    .font(.body)
                                    .padding()
                                    .frame(minWidth: 100, maxWidth: .infinity)
                                    .background(Color.gray.opacity(0.2)) // Accent color with slight opacity
                                    .cornerRadius(5)
                                    .lineLimit(1)
                                    .onTapGesture {
                                        selectedRow = rowIndex
                                        selectedCell = cellIndex
                                        showDetailView = true
                                    }
                            }
                        }
                        .lineSpacing(5)
                    }
                }
                .padding()
                .cornerRadius(8)
            }

            // Detail View Overlay
            if showDetailView, let selectedRow = selectedRow, let selectedCell = selectedCell {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showDetailView = false
                    }

                VStack {
                    HStack {
                        Spacer()
                        Text(data[selectedRow][selectedCell]) // Show only the selected cell's content
                            .font(.body)
                            .padding()
                            .background(Color(UIColor.systemBackground)) // Use system background color
                            .cornerRadius(8)
                            .foregroundColor(Color.primary) // Use primary color for text
                        Spacer()
                    }

                    Button(action: {
                        showDetailView = false
                    }) {
                        Image(systemName: "xmark.circle")
                            .font(.title)
                            .foregroundColor(.red)
                            .background(Color(UIColor.systemBackground).opacity(0.8)) // Use system background color
                            .clipShape(Circle())
                            .padding()
                    }
                }
                .background(Color(UIColor.systemBackground)) // Use system background color
                .cornerRadius(8)
                .shadow(radius: 10)
                .padding()
                .lineSpacing(5)
            }
        }
    }
}

#Preview {
    let content = """
    Visa Type test for long text | Fee 
    15 Days | $30 USD 
    30 Days | $50 USD
    90 Days | $125 USD
    """

    TableView(content: content)
}
