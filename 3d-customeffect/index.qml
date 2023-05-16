// Copyright (C) 2019 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import QtQuick3D.Effects
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: window
    width: 1280
    height: 720
    visible: true
    property string title: "Custom Post-Processing Effect Example"
    color: "#848895"

    View3D {
        id: view3d

        //! [eff1]
        Effect {
            id: eff1
            property TextureInput tex: TextureInput {
                id: qtLogo
                texture: Texture { source: preload("qt_logo_rect.png") }
            }
            passes: Pass {
                shaders: Shader {
                    id: fs1
                    stage: Shader.Fragment
                    shader: preload("effect.frag")
                }
            }
        }
        //! [eff1]

        //! [eff2]
        Effect {
            id: eff2
            property real uRed: 0.0
            SequentialAnimation on uRed {
                running: radioEff2.checked || radioEff3.checked
                loops: -1
                NumberAnimation { from: 0; to: 1; duration: 2000 }
                NumberAnimation { from: 1; to: 0; duration: 2000 }
            }
            property real uGreen: 1.0
            Shader {
                id: vs2
                stage: Shader.Vertex
                shader: preload("effect2.vert")
            }
            Shader {
                id: fs2
                stage: Shader.Fragment
                shader: preload("effect2.frag")
            }
            passes: Pass {
                shaders: [ vs2, fs2 ]
            }
        }
        //! [eff2]

        Effect {
            id: eff3

            property TextureInput tex: qtLogo
            property real uRed: 1.0
            property real uGreen: 0.0
            SequentialAnimation on uGreen {
                running: radioEff4.checked
                loops: -1
                NumberAnimation { from: 0; to: 1; duration: 2000 }
                NumberAnimation { from: 1; to: 0; duration: 2000 }
            }

            Buffer {
                id: intermediateTexture
                name: "intermediateTexture"
                format: Buffer.RGBA8
                textureFilterOperation: Buffer.Linear
                textureCoordOperation: Buffer.ClampToEdge
                sizeMultiplier: 2 // just for fun upscale and then downscale
            }

            passes: [
                Pass {
                    shaders: [ fs1 ]
                    output: intermediateTexture
                },
                Pass {
                    shaders: [ vs2, fs2 ]
                    commands: [
                        BufferInput {
                            buffer: intermediateTexture
                        }
                    ]
                }
            ]
        }

        anchors.fill: parent
        renderMode: View3D.Offscreen

        environment: SceneEnvironment {
            id: env
            clearColor: "skyblue"
            backgroundMode: SceneEnvironment.Color
            effects: []
        }

        PerspectiveCamera {
            id: camera
            position: Qt.vector3d(0, 200, 300)
            eulerRotation.x: -20
        }

        DirectionalLight {
            eulerRotation.x: -20
            eulerRotation.y: 20
            ambientColor: Qt.rgba(0.8, 0.8, 0.8, 1.0);
        }

        Texture {
            id: checkers
            source: preload("checkers2.png")
            scaleU: 20
            scaleV: 20
            tilingModeHorizontal: Texture.Repeat
            tilingModeVertical: Texture.Repeat
        }

        Model {
            source: "#Rectangle"
            scale.x: 10
            scale.y: 10
            eulerRotation.x: -90
            materials: [ DefaultMaterial { diffuseMap: checkers } ]
        }

        Model {
            source: "#Cone"
            position: Qt.vector3d(100, 0, -200)
            scale.y: 3
            materials: [ DefaultMaterial { diffuseColor: "green" } ]
        }

        Model {
            id: sphere
            source: "#Sphere"
            position: Qt.vector3d(-100, 200, -200)
            materials: [ DefaultMaterial { diffuseColor: "#808000" } ]
        }

        Model {
            source: "#Cube"
            position.y: 50
            eulerRotation.y: 20
            materials: [ DefaultMaterial { diffuseColor: "gray" } ]
        }
    }

    WasdController {
        controlledObject: camera
    }

    ColumnLayout {
        Label {
            text: "Use WASD and mouse to navigate"
            font.bold: true
        }
        ButtonGroup {
            buttons: [ radioEff1, radioEff2, radioEff3, radioEff4, radioEff5 ]
        }
        RadioButton {
            id: radioEff1
            text: "No effects"
            checked: true
            focusPolicy: Qt.NoFocus
            onCheckedChanged: {
                if (checked)
                    env.effects = [];
            }
        }
        RadioButton {
            id: radioEff2
            text: "Custom effect with vertex and fragment shaders"
            checked: false
            focusPolicy: Qt.NoFocus
            onCheckedChanged: {
                if (checked)
                    env.effects = [ eff2 ];
            }
        }
        RadioButton {
            id: radioEff3
            text: "Both effects chained"
            checked: false
            focusPolicy: Qt.NoFocus
            onCheckedChanged: {
                if (checked)
                    env.effects = [ eff1, eff2 ];
            }
        }
        RadioButton {
            id: radioEff4
            text: "As one single, multi-pass effect"
            checked: false
            focusPolicy: Qt.NoFocus
            onCheckedChanged: {
                if (checked)
                    env.effects = [ eff3 ];
            }
        }
        RadioButton {
            id: radioEff5
            text: "Custom effect with fragment shader only"
            checked: false
            focusPolicy: Qt.NoFocus
            onCheckedChanged: {
                if (checked)
                    env.effects = [ eff1 ];
            }
        }
    }
}
