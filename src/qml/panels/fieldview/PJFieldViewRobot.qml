import QtQuick

Item {
    id: fieldViewRobot

    // Image scaling factors
    property double imageScale: 1;
    property int originalWidth: 0;
    property int originalHeight: 0;
    readonly property double currentWidth: originalWidth*scalingRatio;
    readonly property double currentHeight: originalHeight*scalingRatio;
    readonly property double scalingRatio: imageScale*fieldView.currentWidth/fieldView.originalWidth;
    readonly property double pixelsPerInch: fieldView.currentWidth/144.0; // Image width (pixels) / Real width (inches)

    // Biases for positioning the robot relative to the field image
    readonly property double offsetX: (fieldView.width-fieldView.currentWidth-currentWidth)/2;
    readonly property double offsetY: (fieldView.height-fieldView.currentWidth-currentHeight)/2;
    readonly property double originPixelX: fieldView.currentWidth/2;
    readonly property double originPixelY: fieldView.currentWidth/2;

    // Boundaries for positioning the robot image
    readonly property double boundPixelsLowerX: 0;
    readonly property double boundPixelsUpperX: fieldView.currentWidth;
    readonly property double boundPixelsLowerY: 0;
    readonly property double boundPixelsUpperY: fieldView.currentWidth;
    readonly property double boundInchesLowerX: (boundPixelsLowerX-fieldView.currentWidth/2) / pixelsPerInch
    readonly property double boundInchesUpperX: (boundPixelsUpperX-fieldView.currentWidth/2) / pixelsPerInch
    readonly property double boundInchesLowerY: (boundPixelsLowerY-fieldView.currentWidth/2) / pixelsPerInch
    readonly property double boundInchesUpperY: (boundPixelsUpperY-fieldView.currentWidth/2) / pixelsPerInch
    function bound(x, lower, upper) {
        return Math.max(lower, Math.min(upper, x));
    }

    // Robot field position in inches
    property double inchesX: 0
    property double inchesY: 0
    onInchesXChanged: inchesX = bound(inchesX, boundInchesLowerX, boundInchesUpperX);
    onInchesYChanged: inchesY = bound(inchesY, boundInchesLowerY, boundInchesUpperY);

    // Translation & Scaling calculations
    width: currentWidth
    height: currentHeight
    x: offsetX + bound(originPixelX + inchesX*pixelsPerInch, boundPixelsLowerX, boundPixelsUpperX)
    y: offsetY + bound(originPixelY - inchesY*pixelsPerInch, boundPixelsLowerY, boundPixelsUpperY)

    // Move the robot display to the given coordinates in inches, relative to the center of the field.
    function moveTo(x, y) {
        fieldViewRobot.inchesX = x;
        fieldViewRobot.inchesY = y;
    }
    function setX(x) {
        fieldViewRobot.inchesX = x;
    }
    function setY(y) {
        fieldViewRobot.inchesY = y;
    }
    function changeX(dx) {
        moveTo(inchesX+dx, inchesY);
    }
    function changeY(dy) {
        moveTo(inchesX, inchesY+dy);
    }

    Image {
        anchors.fill: parent
        source: "qrc:/Images/src/assets/DRIVE.png"

        // Save original image dimensions
        asynchronous: true
        onStatusChanged: {
            if (status == Image.Ready) {
                fieldViewRobot.originalWidth = sourceSize.width;
                fieldViewRobot.originalHeight = sourceSize.height;
            }
        }

    }

}
