import QtQuick 
import QtQuick.Controls as Controls
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import dnd_dice_qt

Kirigami.ApplicationWindow {
    id: root
    title: "DnD Dice Roller"
    property string currentExpression: ""

    Kirigami.PageRow {
        anchors.fill: parent
        globalToolBar.style: Kirigami.ApplicationHeaderStyle.Auto
        initialPage: [historyPage, initPage]

        Component {
            id: initPage
            Kirigami.Page {
                title: "Dice Roller"
                GridLayout {
                    anchors.fill: parent
                    columns: 2
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
                                    Component.onCompleted: {
                                        model.topTextChange.connect((text) => result.text = text)
                                    }

                                }
                                Controls.Label {
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignHCenter
                                    id: rolls
                                    wrapMode: Text.Wrap
                                    text: ""
                                    font.pixelSize: 20
                                    Component.onCompleted: {
                                        model.bottomTextChange.connect((text) => rolls.text = text)
                                    }
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

                    Binding {
                        expressionInput.text: currentExpression
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
        Component {
            id: historyPage
            Kirigami.ScrollablePage {
                Kirigami.Theme.colorSet: Kirigami.Theme.Window
                title: "History"
                Component {
                    id: historyDelegate
                   
                    Item {
                        id: historyItemRoot
                        required property string expression
                        required property string rolls
                        required property string result
                        height: historyItem.implicitHeight
                        width:  historyView.width - historyView.leftMargin - historyView.rightMargin
                        
                        Kirigami.SwipeListItem {
                            id: historyItem
                            width: historyItemRoot.width
                            contentItem: RowLayout {
                                id: delegateLayout
    
                                Kirigami.Heading {
                                    text: historyItemRoot.result
                                }

                                Controls.Label { 
                                    text:  historyItemRoot.rolls 
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }

                                Rectangle {
                                    width: 8 * historyItem.height
                                }
                            }

                            actions: [
                                Kirigami.Action {
                                    icon.name: "text-field"
                                    text: "Edit Roll"
                                    onTriggered: currentExpression = historyItemRoot.expression
                                },

                                Kirigami.Action {
                                    icon.name: "view-refresh"
                                    text: "Reroll"
                                    onTriggered: model.processExpression(historyItemRoot.expression)
                                },
                            ]
                        }
                    }
                }
    
                ListView {
                    id: historyView
                    model: historyModel
                    delegate: historyDelegate
                }
            }
    
        }
    }

    DiceBackend {
        id: model
        historyModel: HistoryModel {
            id: historyModel
        }
    }
}
