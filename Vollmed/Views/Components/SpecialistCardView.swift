//
//  SpecialistCardView.swift
//  Vollmed
//
//  Created by Giovanna Moeller on 12/09/23.
//

import SwiftUI

struct SpecialistCardView: View {
    
    let service = WebService()
    var specialist: Specialist
    
    @State private var image: UIImage? = nil
    
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
                    Text(specialist.name)
                        .font(.title3)
                        .bold()
                    Text(specialist.specialty)
                }
            }
            
            NavigationLink(destination: ScheduleAppointmentView(specialist: specialist)) {
                ButtonView(text: "Agendar consulta")
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

#Preview {
    NavigationStack {
        SpecialistCardView(
            specialist: Specialist.mockItem
        )
    }
}
