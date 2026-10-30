//
//  GeometryReaderView1.swift
//  SwiftBeginner
//
//  Created by ghy on 2026/10/28.
//

import SwiftUI

struct GeometryReaderView1: View {
    var body: some View {
        Example5()
    }
}

struct Example5: View {
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Group {
                    Text("大圣，")
                        .font(.title2)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .background(RoundedCornersView(color: .green,
                                                       topLeading: 0,
                                                       topTrailing: 30,
                                                       bottomLeading: 30,
                                                       bottomTrailing: 0))
                    Text("此去欲何？")
                        .font(.title2)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .background(RoundedCornersView(color: .green,
                                                       topLeading: 30,
                                                       topTrailing: 0,
                                                       bottomLeading: 0,
                                                       bottomTrailing: 30))
                    Text("踏南天，")
                        .font(.title2)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .background(RoundedCornersView(color: .red,
                                                       topLeading: 0,
                                                       topTrailing: 30,
                                                       bottomLeading: 30,
                                                       bottomTrailing: 0))
                    Text("碎凌霄。")
                        .font(.title2)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .background(RoundedCornersView(color: .red,
                                                       topLeading: 30,
                                                       topTrailing: 0,
                                                       bottomLeading: 0,
                                                       bottomTrailing: 30))
                }
                
            }
            
            HStack(spacing: 0) {
                Group {
                    Text("若一去不回……？ ")
                        .font(.title2)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .background(RoundedCornersView(color: .green,
                                                       topLeading: 30,
                                                       topTrailing: 0,
                                                       bottomLeading: 0,
                                                       bottomTrailing: 30))
                    Text("便一去不回！")
                        .font(.title2)
                        .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .background(RoundedCornersView(color: .red,
                                                       topLeading: 0,
                                                       topTrailing: 30,
                                                       bottomLeading: 30,
                                                       bottomTrailing: 0))
                }

            }
        }
        
    }
}

struct RoundedCornersView: View {
    var color: Color = .black
    var topLeading: CGFloat = 0.0
    var topTrailing: CGFloat = 0.0
    var bottomLeading: CGFloat = 0.0
    var bottomTrailing: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                
                let w = geometry.size.width
                let h = geometry.size.height
                
                let tr = min(min(self.topTrailing, h/2), w/2)
                let tl = min(min(self.topLeading, h/2), w/2)
                let bl = min(min(self.bottomLeading, h/2), w/2)
                let br = min(min(self.bottomTrailing, h/2), w/2)
                
                path.move(to: CGPoint(x: w / 2.0, y: 0))
                path.addLine(to: CGPoint(x: w - tr, y: 0))
                path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: w, y: h - br))
                path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: bl, y: h))
                path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: tl))
                path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                }
                .fill(self.color)
        }
    }
}

struct Example4: View {
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                Text("举个例子🌰, \(proxy.size.width)")
//                    .layoutPriority(1)
                
                MyRectangle()
            }
            .border(Color.green, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        }

    }

    struct MyRectangle: View {
        var body: some View {
            Rectangle().fill(Color.green)
        }
    }
}


struct Example3: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("举个例子🌰")

            MyRectangle()
        }
        .frame(width: 200, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .border(Color.green, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }

    struct MyRectangle: View {
        var body: some View {
            Rectangle().fill(Color.green)
        }
    }
}

struct Example2: View {
    let img = ["1", "2", "3", "4", "5"]

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                // 可以使用img.indices替代0..<img.count的写法
                ForEach(0..<img.count, id: \.self) { index in
                    GeometryReader { proxy in
                        Image(img[index])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .rotation3DEffect(self.rotateAngle(proxy), axis: (x: 0, y: 11, z: 0))
                    }
                    .frame(width: 600.0 / 3, height: 600.0 / 3 * (425 / 640))
                }
            }
        }
        .frame(width: 600)
        .coordinateSpace(name: "ScrollViewSpace")
    }

    func rotateAngle(_ proxy: GeometryProxy) -> Angle {
        let dif = 600 * 0.5 - proxy.frame(in: .named("ScrollViewSpace")).midX
        let pct = min(dif / proxy.size.width * 0.5, 1)
        return .degrees(Double(30 * pct))
    }
}

struct Example1: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("GeometryReader")
                .padding(.vertical, 5)
            myCustomView()
        }
        .frame(width: 200, height: 150)
        .border(Color.green, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
    }

    struct myCustomView: View {
        var body: some View {
            GeometryReader { proxy in
                Circle()
                    .path(in: CGRect(x: 10,
                                     y: 10,
                                     width: circleWidth(proxy),
                                     height: circleWidth(proxy)))
                    .fill(Color.green)

                Circle()
                    .path(in: CGRect(x: proxy.size.width - 10 - circleWidth(proxy),
                                     y: 10,
                                     width: circleWidth(proxy),
                                     height: circleWidth(proxy)))
                    .fill(Color.green)

                Circle()
                    .path(in: CGRect(x: proxy.size.width / 2.0 - circleWidth(proxy) / 2.0,
                                     y: proxy.size.height - 20 - circleWidth(proxy),
                                     width: circleWidth(proxy),
                                     height: circleWidth(proxy)))
                    .trim(from: 0, to: 0.5)
                    .stroke(Color.green, lineWidth: 5)
            }
            .background(Color.orange)
        }

        func circleWidth(_ proxy: GeometryProxy) -> CGFloat {
            proxy.size.width / 4.0
        }
    }
}

#Preview {
    GeometryReaderView1()
}
