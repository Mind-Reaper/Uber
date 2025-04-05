import SwiftUI

struct BottomSheet<Content: View, Footer: View>: View {
    @Binding var isPresented: Bool
    @GestureState private var dragState: CGFloat = 0
    @State private var position: BottomSheetPosition = .middle
    @State private var allowScroll: Bool = false
  

    
    
    private let minHeight: CGFloat
    private let maxHeight: CGFloat
    private let content: Content
    private let footer: Footer?
    private let backgroundOpacity: Double = 0
    private let cornerRadius: CGFloat = 16
    private let handleHeight: CGFloat = 30
    
    private let handleBarWidth: CGFloat = 40
    private let handleBarHeight: CGFloat = 5
    
    enum BottomSheetPosition {
        case hidden, middle, full
    }
    
    init(isPresented: Binding<Bool>,
         minHeight: CGFloat = 300,
         maxHeight: CGFloat = UIScreen.main.bounds.height * 0.8,
         onPresented: (() -> Void)? = nil,
         @ViewBuilder content: () -> Content, @ViewBuilder footer: () -> Footer) {
        self._isPresented = isPresented
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.content = content()
        self.footer = footer()
    }
    
    init(isPresented: Binding<Bool>,
         minHeight: CGFloat = 300,
         maxHeight: CGFloat = UIScreen.main.bounds.height * 0.8,
         @ViewBuilder content: () -> Content) where Footer == EmptyView {
        self._isPresented = isPresented
        self.minHeight = minHeight
        self.maxHeight = maxHeight
        self.content = content()
        self.footer = nil
    }
    
    private var currentHeight: CGFloat {
        switch position {
        case .hidden:
            return 0
        case .middle:
            return minHeight
        case .full:
            return maxHeight
        }
    }
    
    private var backgroundOpacityValue: Double {
        isPresented ? backgroundOpacity : 0
    }
    
    var body: some View {
        ZStack {
            // Background overlay
            if isPresented {
                Color.black
                    .opacity(backgroundOpacityValue)
                    .animation(.easeInOut(duration: 0.25), value: backgroundOpacityValue)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented = false
                    }
            }
            
            // Bottom sheet
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 0) {
                    // Handle
                    HStack {
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: handleBarHeight / 2)
                            .fill(Color.gray.opacity(0.6))
                            .frame(width: handleBarWidth, height: handleBarHeight)
                        
                        Spacer()
                    }
                    .frame(height: handleHeight)
                    .contentShape(Rectangle())
                   
                    
                    // Content with coordinated scrolling
                    ScrollView(.vertical, showsIndicators: true) {
                        content.padding(.bottom, 200)
                    }
                
                           
                    .environment(\.isScrollEnabled, allowScroll)
                    .simultaneousGesture(
                        // This gesture modifier helps coordinate between dragging and scrolling
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let isDraggingDown = value.translation.height > 0
                                
                             
                                
                                
                                // Only allow sheet dragging when scrolled to top and dragging down
                                if isDraggingDown {
                                    // User is dragging down and at the top of content
                                    allowScroll = true
                                } else if position != .full {
                                    // Dragging up and not at full position yet
                                    allowScroll = false
                                } else {
                                    // In full position and trying to scroll content
                                    allowScroll = true
                                }
                            }
                      
                    )
                   
                }
                .gesture(
                    DragGesture()
                        .updating($dragState) { value, state, _ in
                            state = value.translation.height
                        }
                        .onEnded { value in
                            handleDragEnd(value)
                        }
                )
                .background(.thickMaterial)
                .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -5)
                .offset(y: calculateOffset())
                // Only apply the drag gesture to the background, not the content
                // This allows scrolling to work properly
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: position)
                .animation(.spring(response: 0.3, dampingFraction: 0.8), value: dragState)
                
                
                if isPresented {
                    if let footer = footer {
                        footer
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
    
    private func calculateOffset() -> CGFloat {
        guard isPresented else {
            return UIScreen.main.bounds.height
        }
        
        let baseOffset = dragState
        
        switch position {
        case .hidden:
            return UIScreen.main.bounds.height + baseOffset
        case .middle:
            return UIScreen.main.bounds.height - minHeight + baseOffset
        case .full:
            return UIScreen.main.bounds.height - maxHeight + baseOffset
        }
    }
    
    // Add this function to coordinate scrolling with dragging
    private func scrollOffset(_ offset: CGFloat) -> CGFloat {
        if position == .full && offset < 0 {
            // Already at full height, allow scrolling
            return 0
        }
        return offset
    }
    
    private func handleDragEnd(_ value: DragGesture.Value) {
        let dragThreshold: CGFloat = 100
        let velocity = value.predictedEndLocation.y - value.location.y
        
        // Don't process drag if we're allowing content to scroll
        if allowScroll && position == .full && value.translation.height < 0 {
            return
        }
        
        // Determine whether to change position based on drag distance and velocity
        if abs(value.translation.height) > dragThreshold || abs(velocity) > 100 {
            if value.translation.height > 0 || velocity > 100 {
                // Dragging down
                switch position {
                case .full:
                    position = .middle
                case .middle:
                    isPresented = false
                case .hidden:
                    break
                }
            } else if value.translation.height < 0 || velocity < -100 {
                // Dragging up
                switch position {
                case .hidden:
                    position = .middle
                case .middle:
                    position = .full
                    // When we reach full position, allow scrolling
                    allowScroll = true
                case .full:
                    break
                }
            }
        }
    }
}



struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// Example usage
struct BottomSheetExample: View {
    @State private var showBottomSheet = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Button("Show Bottom Sheet") {
                    showBottomSheet = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                
                Spacer()
            }
            
            BottomSheet(isPresented: $showBottomSheet) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("SwiftUI Bottom Sheet")
                        .font(.title)
                        .bold()
                    
                    Text("This is a scrollable bottom sheet component built with SwiftUI. You can drag it up, down, or tap outside to dismiss it.")
                        .font(.body)
                    
                    Divider()
                    
                    // Demo content
                    ForEach(1...20, id: \.self) { item in
                        HStack {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(
                                    hue: Double(item) / 20.0,
                                    saturation: 0.8,
                                    brightness: 0.9
                                ))
                                .frame(width: 40, height: 40)
                            
                            Text("Item \(item)")
                                .font(.system(size: 18))
                            
                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }
            } footer: {
                Button {
                    
                } label: {
                    
                    VStack {
                        Text("Dismis")
                        Text("Dismis")
                        Text("Dismis")
                        Text("Dismis")
                    }
                    
                    }
            }
        }
    }
}

struct BottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetExample()
    }
}
