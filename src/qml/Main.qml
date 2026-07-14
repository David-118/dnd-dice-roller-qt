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
        id: pages
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
                    Controls.Pane {
                        Layout.columnSpan:2
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        ColumnLayout {
                            anchors.fill: parent
                            visible: result.text.length != 0
                            Controls.Label {
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignHCenter
                                id: result
                                font.pixelSize: 50
                                Component.onCompleted: {
                                    model.topTextChange.connect((text) => result.text = text)
                                }

                            }
                            Controls.ScrollView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Controls.TextArea {
                                    readOnly: true
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
                        ColumnLayout {
                            anchors.fill: parent
                            visible: result.text.length == 0
                            Controls.Label {
                                text:"<h2> Welcome to Dnd Dice Roller (QT)</h2>
                                <p> 
                                    For help with the sytax please refer to the tyche-rs 
                                    <a href='https://github.com/Gawdl3y/tyche-rs/blob/main/README.md#features'>README</a> file</p>
                                </p>
                                <p>
                                    To get started enter an expression such as <code>1d20</code> or <code>1d6 + 2</code>"
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
                        expressionInput.text: {
                            expressionInput.forceActiveFocus();
                            return currentExpression;
                        }
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
                                    width: 6 * historyItem.height
                                }
                            }

                            actions: [
                                Kirigami.Action {
                                    icon.name: "text-field"
                                    text: "Edit Roll"
                                    onTriggered: () => { 
                                        pages.goForward()
                                        currentExpression = historyItemRoot.expression
                                    }
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
                    Controls.Label {
                        anchors.fill: parent
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                        visible: parent.count == 0
                        text: "Nothing to See Here!"
                    }

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
