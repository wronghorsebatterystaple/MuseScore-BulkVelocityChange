/* Thanks to the makers of the Articulation and Ornamentation Control plugin
 (https://github.com/BernardGreenberg/MuseScorePlugins) for code reference */

import QtQuick 2.0
import MuseScore 3.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1

MuseScore {
      menuPath: "Plugins.BulkVelocityChange"
      description: "This plugin allows increasing of notes' velocities in bulk."
      version: "1.0"
      pluginType: "dialog" // required to allow GridLayout to show
      requiresScore: true
      
      width: 240
      height: 80
      property int margin: 10
      
      onRun: {
            // Note stuff seems to only work on MuseScore 3.3 and above,
            // so check for that
            if ((mscoreMajorVersion < 3) || (mscoreMinorVersion < 3)) {
	           versionError.open();
                  Qt.quit();
            }
            console.log("Bulk Velocity Change says hello world!");
      }
      
      function applyChanges() {
            // get user input from text field
            var offset = parseInt(velocityChangeInput.text)
            // check if input is valid
            if (isNaN(offset)) {
                  invalidVelocityInput.open();
                  Qt.quit();
            }
            
            // get selection in MuseScore
            var selection = curScore.selection;
            var elements = selection.elements;
            // apply velocity offset to all notes in selection
            for (var i = 0; i < elements.length; i++) {
                  var element = elements[i];
                  if (element.type === Element.NOTE) {
                        element.veloOffset += offset;
                        // clamp note velocities to -127 to 127,
                        // which is the max allowed by MuseScore offset velocity
                        if (element.veloOffset > 127) {
                              element.veloOffset = 127;
                        } else if (element.veloOffset < -127) {
                              element.veloOffset = -127;
                        }
                  }
            }
            
            Qt.quit();
      }
      
      // UI: main window
      GridLayout {
            id: "mainLayout"
            anchors.fill: parent
            anchors.margins: 10
            columns: 2

            Label {
                  id: velocityChangeLabel
                  text:  "Velocity Change:"
            }
            TextField {
                  id: velocityChangeInput
                  implicitHeight: 24
                  placeholderText: "0"
                  Keys.onReturnPressed: {
                        applyChanges();
                  }
                  Keys.onEscapePressed: {
                        Qt.quit();
                  }
            }

            Button {
                  id: applyButton
                  Layout.columnSpan:1
                  text: qsTranslate("PrefsDialogBase", "Apply")
                  onClicked: {
                        applyChanges();
                  }
            }

             Button {
                  id: cancelButton
                  Layout.columnSpan: 1
                  text: qsTranslate("InsertMeasuresDialogBase", "Cancel")
                  onClicked: {
                        Qt.quit();
                  }
            }
      }
    
      // UI: version error popup
      MessageDialog {
            id: versionError
            visible: false
            title: qsTr("Unsupported MuseScore Version")
            text: qsTr("This plugin needs MuseScore 3.3 or later")
            onAccepted: {
                  Qt.quit();
            }
      }
      
      // UI: invalid velocity input popup
      MessageDialog {
            id: invalidVelocityInput
            visible: false
            title: qsTr("Invalid Velocity Input")
            text: qsTr("Enter an integer value")
            onAccepted: {
                  Qt.quit();
            }
      }
}
