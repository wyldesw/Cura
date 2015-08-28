// Copyright (c) 2015 Ultimaker B.V.
// Cura is released under the terms of the AGPLv3 or higher.

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Layouts 1.1

import UM 1.1 as UM

Item
{
    id: base;

    anchors.fill: parent;
    anchors.leftMargin: UM.Theme.sizes.default_margin.width;
    anchors.rightMargin: UM.Theme.sizes.default_margin.width;

    property Action configureSettings;

    property variant minimumPrintTime: PrintInformation.minimumPrintTime;
    property variant maximumPrintTime: PrintInformation.maximumPrintTime;

    Component.onCompleted: PrintInformation.enabled = true
    Component.onDestruction: PrintInformation.enabled = false
    UM.I18nCatalog { id: catalog; name:"cura"}
    ColumnLayout
    {
        anchors.fill: parent;

        Item
        {
            Layout.fillWidth: true;
            Layout.preferredHeight: UM.Theme.sizes.section.height;

            Label
            {
                anchors.left: parent.left;
                anchors.verticalCenter: parent.verticalCenter;
                text: base.minimumPrintTime.valid ? base.minimumPrintTime.getDisplayString(UM.DurationFormat.Short) : "??:??";
                font: UM.Theme.fonts.timeslider_time;
                color: UM.Theme.colors.primary;
            }
            Label
            {
                anchors.centerIn: parent;
                text: //: Sidebar configuration label
                {
                    if (UM.Backend.progress < 0)
                    {
                        return catalog.i18nc("@label","No Model Loaded");
                    }
                    else if (!base.minimumPrintTime.valid || !base.maximumPrintTime.valid)
                    {
                        return catalog.i18nc("@label","Calculating...")
                    }
                    else
                    {
                        return catalog.i18nc("@label","Estimated Print Time");
                    }
                }
                color: UM.Theme.colors.text;
                font: UM.Theme.fonts.default;
            }
            Label
            {
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter;
                text: base.maximumPrintTime.valid ? base.maximumPrintTime.getDisplayString(UM.DurationFormat.Short) : "??:??";
                font: UM.Theme.fonts.timeslider_time;
                color: UM.Theme.colors.primary;
            }
        }

        Slider
        {
            Layout.fillWidth: true;
            Layout.preferredHeight: UM.Theme.sizes.section.height;

            minimumValue: 0;
            maximumValue: 100;

            value: PrintInformation.timeQualityValue;
            onValueChanged: PrintInformation.setTimeQualityValue(value);

            style: UM.Theme.styles.slider;
        }

        Item
        {
            Layout.fillWidth: true;
            Layout.preferredHeight: UM.Theme.sizes.section.height;

            Label
            {
                anchors.left: parent.left;
                anchors.verticalCenter: parent.verticalCenter;

                //: Quality slider label
                text: catalog.i18nc("@label","Minimum\nDraft");
                color: UM.Theme.colors.text;
                font: UM.Theme.fonts.default;
            }

            Label
            {
                anchors.right: parent.right;
                anchors.verticalCenter: parent.verticalCenter;

                //: Quality slider label
                text: catalog.i18nc("@label","Maximum\nQuality");
                horizontalAlignment: Text.AlignRight;
                color: UM.Theme.colors.text;
                font: UM.Theme.fonts.default;
            }
        }

        CheckBox
        {
            Layout.fillWidth: true;
            Layout.preferredHeight: UM.Theme.sizes.section.height;

            //: Setting checkbox
            text: catalog.i18nc("@action:checkbox","Enable Support");

            style: UM.Theme.styles.checkbox;

            checked: Printer.getSettingValue("support_enable");
            onCheckedChanged: Printer.setSettingValue("support_enable", checked);
        }

        Item { Layout.fillWidth: true; Layout.fillHeight: true; }
    }
}
