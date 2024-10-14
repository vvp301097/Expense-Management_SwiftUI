//
//  LockView.swift
//  Expense Management
//
//  Created by Phat Vuong Vinh on 13/10/24.
//

import SwiftUI
import LocalAuthentication

struct LockView<Content: View>: View {
    
    // Lock Properties
    var lockType: LockType
    var lockPin: String
    var isEnabled: Bool
    var lockWhenAppGoesToBackground: Bool = true
    
    @ViewBuilder var content: Content
    var forgotPin: () -> Void = { }
    
    @State private var pin: String = ""
    @State private var animatedField = false
    @State private var isUnlocked: Bool = false
    @State private var noBiometricAccess: Bool = false
    
    
    // scene phase
    @Environment(\.scenePhase) private var scenePhase
    
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            content
                .frame(width: size.width, height: size.height)
            
            if isEnabled && !isUnlocked {
                

                ZStack {
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()

                    if (lockType == .both && !noBiometricAccess) || lockType == .biometric {
//                        Rectangle()
                        
                        Group {
                            if noBiometricAccess {
                                Text("Enable biometric authentication in Settings to unlock the view.")
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                                    .padding(60)
                            } else {
                                // Bio Metric // Pin unlock
                                VStack(spacing: 12) {
                                    VStack(spacing: 6) {
                                        Image(systemName: "lock")
                                            .font(.largeTitle)
                                        
                                        Text("Tap to Unlock")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                        
                                        
                                    }
                                    .frame(width: 100, height: 100)
                                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        unlockView()
                                    }
                                    
                                    if lockType == .both {
                                        Text("Enter pin")
                                            .frame(width: 100, height: 40)
                                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 12))
                                            .contentShape(.rect)
                                            .onTapGesture {
                                                noBiometricAccess = true
                                            }
                                    }
                                }
                            }
                        }
                    } else {
                        // Custom Number Pad to type View LOck Pin
                        
                        NumberPadPinView()
                    }
                }
                .environment(\.colorScheme, .dark)
                .transition(.offset(y: size.height + 100))
            }
        }
        .onChange(of: isEnabled, initial: true) { oldValue, newValue in
            if newValue {
                unlockView()
            }
        }
        // Locking when app goes background
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue != .active && lockWhenAppGoesToBackground {
                isUnlocked = false
                pin = ""
            }
        }
    }
    
    private func unlockView() {
        // Checking and unlocking view
        // Lock context
        let context: LAContext = LAContext()

        Task {
            if isBiometricAvailable && lockType != .number {
                // requesting Biometric unlock
                if let result = try? await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,localizedReason: "Unlock the view") {
                    print("Unlocking view: \(result)")
                    
                    
                }
                
            }
            // No bio metric Permission || Lock type must set as keypad
            // updating Biometric Status
            
            noBiometricAccess = !isBiometricAvailable
            
        }
    }
    
    private var isBiometricAvailable: Bool {
        // Lock context
        let context: LAContext = LAContext()

        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    @ViewBuilder
    private func NumberPadPinView() -> some View {
        VStack(spacing: 16) {
            Text("Enter your Pin")
                .font(.title.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    // Back button only for both lock type
                    if lockType == .both && isBiometricAvailable {
                        Button(action: {
                            pin = ""
                            
                            noBiometricAccess = false
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .contentShape(.rect)
                        }
                        .tint(.white)
                        
                        .padding(.leading)
                    }
                }
            
            // Adding wiggling animation for wrong password with keyframe Animator
            HStack(spacing: 8) {
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 12)
                        .frame(width: 50, height: 55)
                        .overlay {
                            if pin.count > index {
                                let index = pin.index(pin.startIndex, offsetBy: index)
                                let string = String(pin[index])
                                
                                Text(string)
                                    .font(.title.bold())
                                    .foregroundStyle(.black)
                            }
                        }
                }
            }
            .keyframeAnimator(initialValue: .zero, trigger: animatedField, content: { content, value in
                content.offset(x: value)
            }, keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(30, duration: 0.07)
                    CubicKeyframe(-30, duration: 0.07)
                    CubicKeyframe(20, duration: 0.07)
                    CubicKeyframe(-20, duration: 0.07)
                    CubicKeyframe(0, duration: 0.07)

                }
            })
            .padding(.top, 16)
            .overlay(alignment: .bottomTrailing) {
                Button("Forget Pin?", action: forgotPin)
                    .font(.callout)
                    .foregroundStyle(.white)
                    .offset(y: 40)
            }
            .frame(maxHeight: .infinity)
            
            
            GeometryReader { _ in
                LazyVGrid(columns: Array(repeating: GridItem(), count: 3)) {
                    ForEach(1...9, id: \.self) { number in
                        Button {
                            // adding number to Pin
                            // max limit - 4
                            
                            if pin.count < 4 {
                                pin.append("\(number)")
                            }
                        } label: {
                            Text("\(number)")
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .containerShape(.rect)
                        }
                        .tint(.white)

                    }
                    
                    Button {
                        if !pin.isEmpty {
                            pin.removeLast()
                        }
                    } label: {
                        Image(systemName: "delete.backward")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .containerShape(.rect)
                    }
                    .tint(.white)
                    
                    Button {
                        if pin.count < 4 {
                            pin.append("0")
                        }
                    } label: {
                        Text("0")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .containerShape(.rect)
                    }
                    .tint(.white)
                }
                .vSpacing(.bottom)
            }
            .onChange(of: pin) { oldPin, newPin in
                if newPin.count == 4 {
                    // validate pin
                    
                    if lockPin == pin {
                        print("Unlocked")
                        withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                            isUnlocked = true

                        } completion: {
                            // Clear pin
                            
                            pin = ""
                            noBiometricAccess = !isBiometricAvailable
                        }

                    } else {
                        print("Invalid Pin")
                        
                        pin = ""
                        animatedField.toggle()
                    }
                }
            }
        }
        .padding()
        .environment(\.colorScheme, .dark)
    }
    // Lock Type
    
    enum LockType: String {
        case biometric = "Bio Metric Auth"
        case number = "Custom Number Lock"
        case both = "First preference will be biometric, and if it's not available, then password"
    }
}

#Preview {
    LockView(lockType: .biometric, lockPin: "0000", isEnabled: true) {
        VStack {
            Text("Hello, World!")
        }
    }
}
