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
                columns: 3

                DiceBackend {
                    id: model
                    historyModel: HistoryModel {
                        id: historyModel
                    }
                    onTopTextChange: (text) => result.text = text
                    onBottomTextChange: (text) => rolls.text = text
                }

                
                Component {
                    id: historyDelegate
                    Item {
                        id: item
                        required property string expression
                        required property string rolls
                        required property string result
                        width: 200 
                        height: 60
                        Column {
                            Controls.Label { text: '<b>Expr:</b> ' + item.expression }
                            Controls.Label { text: '<b>Rolls:</b> ' + item.rolls }
                            Controls.Label { text: '<b>Result:</b> ' + item.result }
                        }
                    }
                }

                ListView {
                    width:200
                    Layout.rowSpan: 2
                    Layout.fillHeight: true

                    model: historyModel
                    delegate: historyDelegate

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
                            text: ""
                            font.pixelSize: 50
                        }
                        Controls.Label {
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter

                            id: rolls
                            wrapMode: Text.Wrap
                            text: ""
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
