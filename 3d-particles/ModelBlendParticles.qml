// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick3D
import QtQuick3D.Particles3D
import QtQuick3D.Helpers
import QtQuick.Timeline
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: mainWindow

    anchors.fill: parent

    Timeline {
        id: timeline
        enabled: true
        startFrame: 0
        endFrame: 100
        animations: [
            TimelineAnimation {
                id: timelineAnimation
                running: true
                duration: (100 - timeline.currentFrame) * 100
                from: timeline.currentFrame
                to: 100
            }
        ]
        keyframeGroups: [
            KeyframeGroup {
                target: psystem
                property: "time"
                Keyframe { frame: 0; value: 0 }
                Keyframe { frame: 100; value: 15000 }
            },
            KeyframeGroup {
                target: cameraRotation
                property: "rot"
                Keyframe { frame: 0; value: 0 }
                Keyframe { frame: 100; value: 180 }
            },
            KeyframeGroup {
                target: actNode
                property: "y"
                Keyframe { frame: 0; value: 50 }
                Keyframe { frame: 100; value: -100 }
            }
        ]
    }

    View3D {
        anchors.fill: parent
        camera: camera

        environment: SceneEnvironment {
            clearColor: "#404040"
            backgroundMode: SceneEnvironment.Color
            antialiasingMode: settings.antialiasingMode
            antialiasingQuality: settings.antialiasingQuality
        }

        Node {
            id: cameraRotation
            property real rot: 0.0
            eulerRotation: Qt.vector3d(0, rot, 0)
            PerspectiveCamera {
                id: camera
                position: Qt.vector3d(0, 0, 150)
                clipFar: 2000
            }
        }

        DirectionalLight {
            brightness: 50
            eulerRotation: Qt.vector3d(-90, -90, 0)
            castsShadow: true
            shadowFactor: 25
            shadowMapQuality: Light.ShadowMapQualityHigh
        }
        DirectionalLight {
            eulerRotation: Qt.vector3d(180, 0, 0)
            brightness: 25
        }
        DirectionalLight {
            brightness: 25
        }

        Model {
            source: "#Rectangle"
            eulerRotation: Qt.vector3d(-90, 0, 0)
            y: -30
            scale: Qt.vector3d(3, 3, 1)
            receivesShadows: true
            materials: [
                DefaultMaterial {
                    diffuseColor: "#0c100c"
                }
            ]
        }

        ParticleSystem3D {
            id: psystem
            running: false
            x: -100

            Node {
                id: actNode
                eulerRotation: Qt.vector3d(-90, 0, 0)

                Model {
                    visible: particle.emitMode === ModelBlendParticle3D.Activation
                    source: "#Rectangle"
                    scale: Qt.vector3d(0.5, 0.5, 1)
                    receivesShadows: false
                    materials: [
                        DefaultMaterial {
                            lighting: DefaultMaterial.NoLighting
                            cullMode: Material.NoCulling
                            opacity: 0.25
                        }
                    ]
                }
            }

            Component {
                id: modelComponent
                Model {
                    source: preload("meshes/oldqtlogo.mesh")
                    scale: Qt.vector3d(10, 10, 10)
                    receivesShadows: false
                    materials: [
                        PrincipledMaterial {
                            baseColor: "#41cd52"
                            metalness: 0.8
                            roughness: 0.1
                            specularAmount: 1
                            cullMode: cullingModelBox.checked ? Material.BackFaceCulling : Material.NoCulling
                        }
                    ]
                }
            }

            Node {
                id: translateNode
                x: 150
            }

            ModelBlendParticle3D {
                id: particle
                delegate: modelComponent
                endNode: translateNode
                modelBlendMode: blendModeSelectionBox.selection
                endTime: 1500
                activationNode: actNode
                emitMode: emitModeSelectionBox.selection
            }

            ParticleEmitter3D {
                id: emitter
                system: psystem
                particle: particle
                lifeSpan: particle.modelBlendMode === ModelBlendParticle3D.Explode ? 40000 : 4000
                emitRate: particle.maxAmount / 10
                velocity: VectorDirection3D {
                    direction: Qt.vector3d(50, 10, 0)
                    directionVariation: Qt.vector3d(0, 10, 10)
                }
                particleRotation: Qt.vector3d(20, 0, 3)
                particleRotationVariation: Qt.vector3d(4, 0, 1)
                particleScale: 1.0
                particleEndScale: 1.0
            }
        }
    }

    SettingsView {
        id: settingsView
        CustomCheckBox {
            id: cullingModelBox
            text: "Enable culling"
            checked: false
        }
        CustomSelectionBox {
            id: blendModeSelectionBox
            text: "Blend Mode"
            values: ["Explode", "Construct", "Transfer"]
            parentWidth: settingsView.width
            onSelectionChanged: {
                timeline.currentFrame = 0
                psystem.reset()
            }
        }
        CustomSelectionBox {
            id: emitModeSelectionBox
            text: "Emit Mode"
            values: ["Sequential", "Random", "Activation"]
            parentWidth: settingsView.width
            onSelectionChanged: {
                timeline.currentFrame = 0
                psystem.reset()
            }
        }
    }

    Frame {
        id: toolbar
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 80
        height: 60
        padding: 0
        background: Rectangle {
            color: "#ffffff"
            radius: 4
            opacity: 0.2
        }

        RowLayout {
            anchors.fill: parent
            Button {
                
                property string iconPause: preload("images/icon_pause.png")
                property string iconPlay: preload("images/icon_play.png")
                
                id: playButton
                Layout.leftMargin: 14
                icon.source: timelineAnimation.running ? iconPause : iconPlay
                icon.width: toolbar.height - 10
                icon.height: toolbar.height - 10
                icon.color: "transparent"
                background: Rectangle {
                    color: "transparent"
                }
                onClicked: {
                    // If we are close to end, start from the beginning
                    if (timeline.currentFrame >= timeline.endFrame - 1.0)
                        timeline.currentFrame = 0;

                    timelineAnimation.running = !timelineAnimation.running;
                }
            }

            CustomSlider {
                id: sliderTimelineTime
                Layout.fillWidth: true
                sliderValue: timeline.currentFrame
                sliderEnabled: !timelineAnimation.running || timelineAnimation.paused
                fromValue: 0.0
                toValue: 100.0
                onSliderValueChanged: timeline.currentFrame = sliderValue;
            }
        }
    }

    LoggingView {
        id: loggingView
        anchors.bottom: parent.bottom
        particleSystems: [psystem]
    }
}
