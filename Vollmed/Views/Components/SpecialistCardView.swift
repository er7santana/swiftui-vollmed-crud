//
//  SpecialistCardView.swift
//  Vollmed
//
//  Created by Giovanna Moeller on 12/09/23.
//

import SwiftUI
import VollMedUI

struct SpecialistCardView: View {
    
    let service = WebService()
    var specialist: Specialist
    var appointment: Appointment?
    
    @State private var image: UIImage? = nil
    @State private var showTooltip = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 16.0) {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .frame(width: 64, height: 64)
                        .foregroundColor(.gray.opacity(0.3))
                }
                VStack(alignment: .leading, spacing: 8.0) {
                    HStack {
                        Text(specialist.name)
                            .font(.title3)
                            .bold()
                        
                        Button {
                            showTooltip.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                        }
                        .iOSPopover(isPresented: $showTooltip) {
                            VollmedToolTipView(title: "Dr Carlos Alberto",
                                               description: "Ele é especialista em cardiologia")
                        }
                        
                    }
                    Text(specialist.specialty)
                    if let appointment {
                        Text(appointment.date.converDateStringToReadableDate())
                    }
                }
            }
            
            if let appointment {
                HStack {
                    NavigationLink {
                        ScheduleAppointmentView(specialistId: specialist.id, appointmentId: appointment.id)
                    } label: {
                        ButtonView(text: "Remarcar")
                    }
                    
                    NavigationLink {
                        CancelAppointmentView(appointmentId: appointment.id)
                    } label: {
                        ButtonView(text: "Cancelar", buttonType: .cancel)
                    }
                }
            } else {
                
                NavigationLink(destination: ScheduleAppointmentView(specialistId: specialist.id)) {
                    ButtonView(text: "Agendar consulta")
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.lightBlue).opacity(0.15))
        .cornerRadius(16.0)
        .task {
            await downloadImage()
        }
    }
    
    func downloadImage() async {
        if let image = await service.downloadImage(from: specialist.imageUrl) {
            self.image = image
        }
    }
}

extension View {
    func iOSPopover<Content: View>(isPresented: Binding<Bool>, arrowDirection: UIPopoverArrowDirection = .any, @ViewBuilder content: () -> Content) -> some View {
        self.background(
            PopOverController(isPresented: isPresented,
                              content: content(),
                              arrowDirection: arrowDirection)
        )
    }
}

struct PopOverController<Content: View>: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    var content: Content
    var arrowDirection: UIPopoverArrowDirection
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .clear
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            
            let contentViewController = CustomHostingView(rootView: content)
            contentViewController.view.backgroundColor = UIColor(red: 230.0/255.0,
                                                               green: 243.0/255.0,
                                                                 blue: 255.0/255.0, alpha: 1.0)
            contentViewController.modalPresentationStyle = .popover
            contentViewController.popoverPresentationController?.permittedArrowDirections = arrowDirection
            contentViewController.presentationController?.delegate = context.coordinator
            contentViewController.popoverPresentationController?.sourceView = uiViewController.view
            
            uiViewController.present(contentViewController, animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UIPopoverPresentationControllerDelegate {
        let parent: PopOverController
        
        init(parent: PopOverController) {
            self.parent = parent
        }
        
        @objc func dismiss() {
            parent.isPresented = false
        }
        
        func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
            parent.isPresented = false
        }
        
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }
    }
}

class CustomHostingView<Content: View>: UIHostingController<Content> {
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = CGSize(width: view.intrinsicContentSize.width, height: view.intrinsicContentSize.height * 1.3)
    }
}

#Preview {
    NavigationStack {
        SpecialistCardView(
            specialist: Specialist.mockItem
        )
    }
}
