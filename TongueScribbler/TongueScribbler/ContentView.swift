//
//  ContentView.swift
//  TongueScribbler
//
//  Created by Maksim Gaiduk on 17/09/2023.
//

import SwiftUI

struct MyIcon: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.3418*width, y: 0.55762*height))
        path.addQuadCurve(to: CGPoint(x: 0.43848*width, y: 0.59961*height), control: CGPoint(x: 0.37109*width, y: 0.5791*height))
        path.addQuadCurve(to: CGPoint(x: 0.45703*width, y: 0.6084*height), control: CGPoint(x: 0.4541*width, y: 0.60059*height))
        path.addQuadCurve(to: CGPoint(x: 0.44727*width, y: 0.62793*height), control: CGPoint(x: 0.45996*width, y: 0.61816*height))
        path.addQuadCurve(to: CGPoint(x: 0.38672*width, y: 0.65234*height), control: CGPoint(x: 0.42871*width, y: 0.64063*height))
        path.addQuadCurve(to: CGPoint(x: 0.36133*width, y: 0.65625*height), control: CGPoint(x: 0.37207*width, y: 0.6582*height))
        path.addQuadCurve(to: CGPoint(x: 0.35449*width, y: 0.6416*height), control: CGPoint(x: 0.35449*width, y: 0.65234*height))
        path.addQuadCurve(to: CGPoint(x: 0.19531*width, y: 0.51465*height), control: CGPoint(x: 0.35547*width, y: 0.60645*height))
        path.addQuadCurve(to: CGPoint(x: 0.19629*width, y: 0.50391*height), control: CGPoint(x: 0.19141*width, y: 0.50586*height))
        path.addQuadCurve(to: CGPoint(x: 0.2832*width, y: 0.5332*height), control: CGPoint(x: 0.20801*width, y: 0.50391*height))
        path.addQuadCurve(to: CGPoint(x: 0.30859*width, y: 0.54297*height), control: CGPoint(x: 0.2959*width, y: 0.53711*height))
        path.addLine(to: CGPoint(x: 0.3418*width, y: 0.55762*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.57031*width, y: 0.45508*height))
        path.addQuadCurve(to: CGPoint(x: 0.7168*width, y: 0.48535*height), control: CGPoint(x: 0.65039*width, y: 0.47363*height))
        path.addQuadCurve(to: CGPoint(x: 0.73633*width, y: 0.49902*height), control: CGPoint(x: 0.72852*width, y: 0.48438*height))
        path.addQuadCurve(to: CGPoint(x: 0.71191*width, y: 0.52051*height), control: CGPoint(x: 0.7373*width, y: 0.51172*height))
        path.addQuadCurve(to: CGPoint(x: 0.60742*width, y: 0.51465*height), control: CGPoint(x: 0.67676*width, y: 0.54102*height))
        path.addQuadCurve(to: CGPoint(x: 0.56152*width, y: 0.49902*height), control: CGPoint(x: 0.58398*width, y: 0.50781*height))
        path.addLine(to: CGPoint(x: 0.52441*width, y: 0.4873*height))
        path.addQuadCurve(to: CGPoint(x: 0.48828*width, y: 0.47656*height), control: CGPoint(x: 0.50586*width, y: 0.4834*height))
        path.addQuadCurve(to: CGPoint(x: 0.37695*width, y: 0.44629*height), control: CGPoint(x: 0.43164*width, y: 0.46094*height))
        path.addLine(to: CGPoint(x: 0.3291*width, y: 0.43555*height))
        path.addQuadCurve(to: CGPoint(x: 0.1748*width, y: 0.40625*height), control: CGPoint(x: 0.31934*width, y: 0.43555*height))
        path.addQuadCurve(to: CGPoint(x: 0.16895*width, y: 0.38281*height), control: CGPoint(x: 0.14453*width, y: 0.39941*height))
        path.addQuadCurve(to: CGPoint(x: 0.23535*width, y: 0.36719*height), control: CGPoint(x: 0.20703*width, y: 0.35645*height))
        path.addQuadCurve(to: CGPoint(x: 0.33105*width, y: 0.39453*height), control: CGPoint(x: 0.28027*width, y: 0.37988*height))
        path.addLine(to: CGPoint(x: 0.37793*width, y: 0.40625*height))
        path.addQuadCurve(to: CGPoint(x: 0.53223*width, y: 0.44629*height), control: CGPoint(x: 0.44922*width, y: 0.42773*height))
        path.addLine(to: CGPoint(x: 0.57031*width, y: 0.45508*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.37695*width, y: 0.44629*height))
        path.addQuadCurve(to: CGPoint(x: 0.38867*width, y: 0.50488*height), control: CGPoint(x: 0.37793*width, y: 0.48145*height))
        path.addQuadCurve(to: CGPoint(x: 0.38086*width, y: 0.53516*height), control: CGPoint(x: 0.39551*width, y: 0.52246*height))
        path.addQuadCurve(to: CGPoint(x: 0.3418*width, y: 0.55762*height), control: CGPoint(x: 0.3623*width, y: 0.55078*height))
        path.addCurve(to: CGPoint(x: 0.30859*width, y: 0.54297*height), control1: CGPoint(x: 0.31543*width, y: 0.56934*height), control2: CGPoint(x: 0.2959*width, y: 0.56934*height))
        path.addQuadCurve(to: CGPoint(x: 0.30859*width, y: 0.54199*height), control: CGPoint(x: 0.30762*width, y: 0.54297*height))
        path.addQuadCurve(to: CGPoint(x: 0.3291*width, y: 0.4668*height), control: CGPoint(x: 0.33008*width, y: 0.50684*height))
        path.addQuadCurve(to: CGPoint(x: 0.3291*width, y: 0.43555*height), control: CGPoint(x: 0.3291*width, y: 0.45117*height))
        path.addLine(to: CGPoint(x: 0.33105*width, y: 0.39453*height))
        path.addQuadCurve(to: CGPoint(x: 0.33105*width, y: 0.28223*height), control: CGPoint(x: 0.33203*width, y: 0.33496*height))
        path.addLine(to: CGPoint(x: 0.33008*width, y: 0.23535*height))
        path.addQuadCurve(to: CGPoint(x: 0.32617*width, y: 0.12988*height), control: CGPoint(x: 0.3291*width, y: 0.17578*height))
        path.addQuadCurve(to: CGPoint(x: 0.31543*width, y: 0.10645*height), control: CGPoint(x: 0.3252*width, y: 0.1123*height))
        path.addQuadCurve(to: CGPoint(x: 0.24414*width, y: 0.11621*height), control: CGPoint(x: 0.30957*width, y: 0.10254*height))
        path.addQuadCurve(to: CGPoint(x: 0.2334*width, y: 0.11133*height), control: CGPoint(x: 0.23242*width, y: 0.11914*height))
        path.addQuadCurve(to: CGPoint(x: 0.24316*width, y: 0.09766*height), control: CGPoint(x: 0.23438*width, y: 0.10547*height))
        path.addQuadCurve(to: CGPoint(x: 0.32031*width, y: 0.00586*height), control: CGPoint(x: 0.30176*width, y: 0.04102*height))
        path.addQuadCurve(to: CGPoint(x: 0.34863*width, y: 0.00293*height), control: CGPoint(x: 0.33301*width, y: -0.00977*height))
        path.addQuadCurve(to: CGPoint(x: 0.38086*width, y: 0.12305*height), control: CGPoint(x: 0.38086*width, y: 0.03516*height))
        path.addQuadCurve(to: CGPoint(x: 0.37793*width, y: 0.25879*height), control: CGPoint(x: 0.37793*width, y: 0.16504*height))
        path.addLine(to: CGPoint(x: 0.37793*width, y: 0.29883*height))
        path.addQuadCurve(to: CGPoint(x: 0.37793*width, y: 0.40625*height), control: CGPoint(x: 0.37793*width, y: 0.34668*height))
        path.addLine(to: CGPoint(x: 0.37695*width, y: 0.44629*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.33105*width, y: 0.28223*height))
        path.addQuadCurve(to: CGPoint(x: 0.15723*width, y: 0.22363*height), control: CGPoint(x: 0.24805*width, y: 0.25488*height))
        path.addQuadCurve(to: CGPoint(x: 0.09863*width, y: 0.21582*height), control: CGPoint(x: 0.13574*width, y: 0.2168*height))
        path.addQuadCurve(to: CGPoint(x: 0.08301*width, y: 0.20215*height), control: CGPoint(x: 0.08398*width, y: 0.21484*height))
        path.addQuadCurve(to: CGPoint(x: 0.0918*width, y: 0.17969*height), control: CGPoint(x: 0.08203*width, y: 0.1875*height))
        path.addQuadCurve(to: CGPoint(x: 0.15332*width, y: 0.14355*height), control: CGPoint(x: 0.11621*width, y: 0.16211*height))
        path.addQuadCurve(to: CGPoint(x: 0.17773*width, y: 0.15039*height), control: CGPoint(x: 0.16504*width, y: 0.14063*height))
        path.addQuadCurve(to: CGPoint(x: 0.33008*width, y: 0.23535*height), control: CGPoint(x: 0.2334*width, y: 0.19434*height))
        path.addLine(to: CGPoint(x: 0.37793*width, y: 0.25879*height))
        path.addQuadCurve(to: CGPoint(x: 0.47266*width, y: 0.31055*height), control: CGPoint(x: 0.46582*width, y: 0.30664*height))
        path.addQuadCurve(to: CGPoint(x: 0.48633*width, y: 0.3291*height), control: CGPoint(x: 0.4873*width, y: 0.31934*height))
        path.addQuadCurve(to: CGPoint(x: 0.46777*width, y: 0.33203*height), control: CGPoint(x: 0.48047*width, y: 0.33496*height))
        path.addQuadCurve(to: CGPoint(x: 0.37793*width, y: 0.29883*height), control: CGPoint(x: 0.42383*width, y: 0.31641*height))
        path.addLine(to: CGPoint(x: 0.33105*width, y: 0.28223*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.62012*width, y: 0.19043*height))
        path.addQuadCurve(to: CGPoint(x: 0.77832*width, y: -0.01367*height), control: CGPoint(x: 0.67383*width, y: 0.07324*height))
        path.addQuadCurve(to: CGPoint(x: 0.87695*width, y: -0.0459*height), control: CGPoint(x: 0.85547*width, y: -0.06055*height))
        path.addQuadCurve(to: CGPoint(x: 0.89258*width, y: 0.00293*height), control: CGPoint(x: 0.89844*width, y: -0.03613*height))
        path.addQuadCurve(to: CGPoint(x: 0.87793*width, y: 0.14844*height), control: CGPoint(x: 0.88379*width, y: 0.0332*height))
        path.addQuadCurve(to: CGPoint(x: 0.87305*width, y: 0.17383*height), control: CGPoint(x: 0.87891*width, y: 0.16992*height))
        path.addQuadCurve(to: CGPoint(x: 0.86328*width, y: 0.15625*height), control: CGPoint(x: 0.86914*width, y: 0.1748*height))
        path.addQuadCurve(to: CGPoint(x: 0.81836*width, y: 0.05859*height), control: CGPoint(x: 0.83691*width, y: 0.07324*height))
        path.addQuadCurve(to: CGPoint(x: 0.7666*width, y: 0.08594*height), control: CGPoint(x: 0.80371*width, y: 0.05469*height))
        path.addQuadCurve(to: CGPoint(x: 0.6543*width, y: 0.2207*height), control: CGPoint(x: 0.69336*width, y: 0.15137*height))
        path.addLine(to: CGPoint(x: 0.62891*width, y: 0.27246*height))
        path.addQuadCurve(to: CGPoint(x: 0.57031*width, y: 0.45508*height), control: CGPoint(x: 0.58496*width, y: 0.37207*height))
        path.addLine(to: CGPoint(x: 0.56152*width, y: 0.49902*height))
        path.addQuadCurve(to: CGPoint(x: 0.5625*width, y: 0.73438*height), control: CGPoint(x: 0.53418*width, y: 0.64355*height))
        path.addQuadCurve(to: CGPoint(x: 0.53027*width, y: 0.78613*height), control: CGPoint(x: 0.57227*width, y: 0.76074*height))
        path.addQuadCurve(to: CGPoint(x: 0.47754*width, y: 0.80566*height), control: CGPoint(x: 0.49707*width, y: 0.80762*height))
        path.addQuadCurve(to: CGPoint(x: 0.46777*width, y: 0.77637*height), control: CGPoint(x: 0.45898*width, y: 0.80469*height))
        path.addQuadCurve(to: CGPoint(x: 0.49512*width, y: 0.69043*height), control: CGPoint(x: 0.49121*width, y: 0.73438*height))
        path.addQuadCurve(to: CGPoint(x: 0.52441*width, y: 0.4873*height), control: CGPoint(x: 0.50488*width, y: 0.58691*height))
        path.addLine(to: CGPoint(x: 0.53223*width, y: 0.44629*height))
        path.addQuadCurve(to: CGPoint(x: 0.59766*width, y: 0.23926*height), control: CGPoint(x: 0.55957*width, y: 0.32617*height))
        path.addLine(to: CGPoint(x: 0.62012*width, y: 0.19043*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.59766*width, y: 0.23926*height))
        path.addQuadCurve(to: CGPoint(x: 0.44141*width, y: 0.13477*height), control: CGPoint(x: 0.54492*width, y: 0.19238*height))
        path.addQuadCurve(to: CGPoint(x: 0.4375*width, y: 0.125*height), control: CGPoint(x: 0.43164*width, y: 0.12891*height))
        path.addQuadCurve(to: CGPoint(x: 0.45703*width, y: 0.12305*height), control: CGPoint(x: 0.44434*width, y: 0.12109*height))
        path.addQuadCurve(to: CGPoint(x: 0.56055*width, y: 0.15625*height), control: CGPoint(x: 0.51074*width, y: 0.13184*height))
        path.addQuadCurve(to: CGPoint(x: 0.62012*width, y: 0.19043*height), control: CGPoint(x: 0.59375*width, y: 0.1709*height))
        path.addLine(to: CGPoint(x: 0.6543*width, y: 0.2207*height))
        path.addQuadCurve(to: CGPoint(x: 0.72949*width, y: 0.30957*height), control: CGPoint(x: 0.68945*width, y: 0.25391*height))
        path.addQuadCurve(to: CGPoint(x: 0.75977*width, y: 0.3457*height), control: CGPoint(x: 0.74414*width, y: 0.32813*height))
        path.addQuadCurve(to: CGPoint(x: 0.7666*width, y: 0.36523*height), control: CGPoint(x: 0.76953*width, y: 0.35254*height))
        path.addQuadCurve(to: CGPoint(x: 0.73535*width, y: 0.40039*height), control: CGPoint(x: 0.7627*width, y: 0.37695*height))
        path.addQuadCurve(to: CGPoint(x: 0.70605*width, y: 0.41797*height), control: CGPoint(x: 0.7168*width, y: 0.41797*height))
        path.addQuadCurve(to: CGPoint(x: 0.69043*width, y: 0.40137*height), control: CGPoint(x: 0.69141*width, y: 0.41699*height))
        path.addQuadCurve(to: CGPoint(x: 0.62891*width, y: 0.27246*height), control: CGPoint(x: 0.68457*width, y: 0.3457*height))
        path.addLine(to: CGPoint(x: 0.59766*width, y: 0.23926*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.6709*width, y: 0.65332*height))
        path.addQuadCurve(to: CGPoint(x: 0.73633*width, y: 0.6084*height), control: CGPoint(x: 0.70117*width, y: 0.63281*height))
        path.addQuadCurve(to: CGPoint(x: 0.76758*width, y: 0.60059*height), control: CGPoint(x: 0.75195*width, y: 0.59863*height))
        path.addQuadCurve(to: CGPoint(x: 0.78223*width, y: 0.61719*height), control: CGPoint(x: 0.7793*width, y: 0.60352*height))
        path.addQuadCurve(to: CGPoint(x: 0.77051*width, y: 0.66211*height), control: CGPoint(x: 0.7832*width, y: 0.63281*height))
        path.addQuadCurve(to: CGPoint(x: 0.72852*width, y: 0.69141*height), control: CGPoint(x: 0.76172*width, y: 0.68066*height))
        path.addQuadCurve(to: CGPoint(x: 0.63574*width, y: 0.69824*height), control: CGPoint(x: 0.64941*width, y: 0.70898*height))
        path.addQuadCurve(to: CGPoint(x: 0.63574*width, y: 0.68066*height), control: CGPoint(x: 0.63184*width, y: 0.69434*height))
        path.addQuadCurve(to: CGPoint(x: 0.6709*width, y: 0.65332*height), control: CGPoint(x: 0.63965*width, y: 0.6709*height))
        path.closeSubpath()
        return path
    }
}

struct ContentView: View {
    @State private var drawProgress = 1.0
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            MyIcon()
                .trim(from: 0, to: drawProgress)
                .rotation3DEffect(.degrees(180), axis: (x: 1, y: 0, z: 0))
                .frame(width: 256, height: 256)
                .border(.red)
            Button("Animate") {
                drawProgress = 0.0
                withAnimation(.linear(duration: 2)) {
                    drawProgress = 1.0
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
