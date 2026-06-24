import QtQuick 
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import dnd_dice_qt

Kirigami.ApplicationWindow {
    id: root
    title: "DnD Dice Roller"
    width: 600
    height: 600
    pageStack.initialPage: initPage

    Component {
        id: initPage
        Kirigami.Page {
            title: "Dice Roller"
            GridLayout {
                anchors.fill: parent
                columns: 2

                DiceBackend {
                    id: model
                    onTopTextChange: (text) => result.text = text
                    onBottomTextChange: (text) => rolls.text = text
                }
                Kirigami.AbstractCard {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.columnSpan: 2

                    contentItem: Controls.Pane {
                        ColumnLayout {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                        Controls.Label {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                            id: result
                            text: "10"
                            font.pixelSize: 50
                        }
                        Controls.Label {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter

                            id: rolls
                            wrapMode: Text.Wrap
                            text: "1d20 [10] + 2d12 [8, 7]"
                            font.pixelSize: 20
                        }
                        }
                    }
                }
                Controls.TextField {
                    id: expressionInput
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignBottom
                    placeholderText: "Enter Expression..."

                    function accept() {
                        model.processExpression(expressionInput.text)
                        expressionInput.clear();

                    }

                    onAccepted: accept()
                }
                Controls.Button {
                    id: rollBtn
                    Layout.alignment: Qt.AlignBottom
                    text: "Roll"
                    onClicked: expressionInput.accepted()
                    
               }
            }
        }
    }
}
