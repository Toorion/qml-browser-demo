import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
 
Rectangle {
    id: root
    anchors.fill: parent
    color: "#f0f0f0"
    visible: true
    
    property string title: 'QML Browser Demo'
    property string favicon: 'favicon.ico'
    
    property real defaultSize: 220
    
    Pane {
        id: flick
    
        Repeater {
            model: ListModel {
                id: previewsModel
                objectName: "previewsModel"
                ListElement {
                    previewName: "Calculator"
                    previewUrl: "calc/preview.png"
                    folder: "calc"
                }
                ListElement {
                    previewName: "Custom Material"
                    previewUrl: "3d-material/preview.png"
                    folder: "3d-material"
                }
                ListElement {
                    previewName: "Charts"
                    previewUrl: "charts/preview.png"
                    folder: "charts"
                }
                ListElement {
                    previewName: "Axes"
                    previewUrl: "axes/preview.png"
                    folder: "axes"
                }
                ListElement {
                    previewName: "Boxplot"
                    previewUrl: "boxplot/preview.png"
                    folder: "boxplot"
                }
                ListElement {
                    previewName: "Customizations"
                    previewUrl: "customizations/preview.png"
                    folder: "customizations"
                }
                ListElement {
                    previewName: "Polar Chart"
                    previewUrl: "polarchart/preview.png"
                    folder: "polarchart"
                }
                ListElement {
                    previewName: "3D Antialiasing"
                    previewUrl: "3d-antialiasing/preview.png"
                    folder: "3d-antialiasing"
                }
                ListElement {
                    previewName: "3D Baked Light Map"
                    previewUrl: "3d-bakedlightmap/preview.png"
                    folder: "3d-bakedlightmap"
                }
                ListElement {
                    previewName: "3D Custom Material"
                    previewUrl: "3d-custommaterial/preview.png"
                    folder: "3d-custommaterial"
                }
                ListElement {
                    previewName: "3D Instancing"
                    previewUrl: "3d-instancing/preview.png"
                    folder: "3d-instancing"
                }
                ListElement {
                    previewName: "3D Lights"
                    previewUrl: "3d-lights/preview.png"
                    folder: "3d-lights"
                }
                ListElement {
                    previewName: "3D Morphing"
                    previewUrl: "3d-morphing/preview.png"
                    folder: "3d-morphing"
                }
                ListElement {
                    previewName: "3D Practicles"
                    previewUrl: "3d-particles/preview.png"
                    folder: "3d-particles"
                }
                ListElement {
                    previewName: "3D Custom Effect"
                    previewUrl: "3d-customeffect/preview.png"
                    folder: "3d-customeffect"
                }
                ListElement {
                    previewName: "3D Quick Ball"
                    previewUrl: "3d-quickball/preview.png"
                    folder: "3d-quickball"
                }
                ListElement {
                    previewName: "3D Screen Effect"
                    previewUrl: "3d-screeneffect/preview.png"
                    folder: "3d-screeneffect"
                }
                ListElement {
                    previewName: "3D Screen Space Reflection"
                    previewUrl: "3d-ssreflection/preview.png"
                    folder: "3d-ssreflection"
                }
                ListElement {
                    previewName: "3D Simple Fog"
                    previewUrl: "3d-simplefog/preview.png"
                    folder: "3d-simplefog"
                }
                ListElement {
                    previewName: "Candle Stick"
                    previewUrl: "candlestick/preview.png"
                    folder: "candlestick"
                }
                ListElement {
                    previewName: "Clocks"
                    previewUrl: "clocks/preview.png"
                    folder: "clocks"
                }
                ListElement {
                    previewName: "Custome Legend"
                    previewUrl: "customlegend/preview.png"
                    folder: "customlegend"
                }
                ListElement {
                    previewName: "Same Game"
                    previewUrl: "samegame/preview.png"
                    folder: "samegame"
                }
                ListElement {
                    previewName: "Stock"
                    previewUrl: "stock/preview.png"
                    folder: "stock"
                }
                ListElement {
                    previewName: "Stock"
                    previewUrl: "stock/preview.png"
                    folder: "stock"
                }
                ListElement {
                    previewName: "3D Character Controller"
                    previewUrl: "3d-charactercontroller/preview.png"
                    folder: "3d-charactercontroller"
                }
                ListElement {
                    previewName: "3D Custom Shapes"
                    previewUrl: "3d-customshapes/preview.png"
                    folder: "3d-customshapes"
                }
                ListElement {
                    previewName: "3D Quick Items"
                    previewUrl: "3d-quickitems/preview.png"
                    folder: "3d-quickitems"
                }
                ListElement {
                    previewName: "3D Reflection"
                    previewUrl: "3d-reflection/preview.png"
                    folder: "3d-reflection"
                }
                ListElement {
                    previewName: "3D Lod Helper"
                    previewUrl: "3d-lodhelper/preview.png"
                    folder: "3d-lodhelper"
                }
            }
            delegate: Rectangle {
                required property string previewName
                required property string previewUrl
                required property string folder
                id: previewFrame
                objectName: "frame-" + previewName
                width: image.width * (1 + 0.10 * image.height / image.width)
                height: image.height * 1.1 + 30
                //scale: root.defaultSize / Math.max(image.sourceSize.width, image.sourceSize.height)
                border.color: pinchHandler.active || dragHandler.active ? "darkturquoise"
                                                                        : mouse.hovered ? "darkseagreen"
                                                                                       : "saddlebrown"
                border.width: 3 / scale
                antialiasing: true
                Component.onCompleted: {
                    //x = window.width - defaultSize * 2
                    //console.log(width)
                    x = Math.max(defaultSize / 10, Math.random() * window.width - defaultSize)
                    //x = 0
                    y = Math.max(defaultSize / 10, Math.random() * window.height - defaultSize)
                    rotation = Math.random() * 13 - 6
                }
                
                
                MouseArea {
                    anchors.fill: parent
                    onDoubleClicked: { 
                        window.open(window.location + '/' + folder);
                    }
                }

                Image {
                    id: image
                    anchors.top: parent.top
                    anchors.topMargin: 10

                    //anchors.centerIn: parent
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                    source: previewFrame.previewUrl
                    antialiasing: true
                }

                Text {
                    text: previewName
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    font.pixelSize: (parent.height - image.height) / 3
                    anchors {
                        left: parent.left
                        right: parent.right
                        bottom: parent.bottom
                        margins: font.pixelSize / 5
                    }
                }

                MomentumAnimation {
                    id: anim
                    target: previewFrame
                    onFinished: {
                        flick.contentWidth = Math.max(previewFrame.x + previewFrame.width, flick.contentWidth)
                        flick.contentHeight = Math.max(previewFrame.y + previewFrame.height, flick.contentHeight)
                    }
                }

                PinchHandler {
                    id: pinchHandler
                    minimumRotation: -360
                    maximumRotation: 360
                    minimumScale: 0.1
                    maximumScale: 10
                    grabPermissions: PointerHandler.CanTakeOverFromAnything // and never gonna give it up
                    onActiveChanged: if (active) previewFrame.z = ++flick.highestZ
                }

                DragHandler {
                    id: dragHandler
                    onActiveChanged: {
                        if (active) {
                            //previewFrame.z = ++flick.highestZ - for Scroll
                        } else
                            anim.restart(centroid.velocity)
                    }
                }

                HoverHandler { id: mouse }

                WheelHandler {
                    acceptedModifiers: Qt.ControlModifier
                    property: "rotation"
                    onActiveChanged: if (active) previewFrame.z = ++flick.highestZ
                }

                WheelHandler {
                    acceptedModifiers: Qt.ShiftModifier
                    property: "scale"
                    onActiveChanged: if (active) previewFrame.z = ++flick.highestZ
                }
            }
        }
    
    }
}
