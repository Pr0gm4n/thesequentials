# The Sequentials: D-Bugs
Code related to the project for DECO3850 at the University of Queensland in Semester 1, 2015.

Please remember to document any necessary instructions for programmers / users in this file!

## Setup
### Fiducials:
(as from Pete Worthy on http://deco3850.uqcloud.net/fileresources/lectures/fiducials_guide/assets/player/KeynoteDHTMLPlayer.html)
* download and install reacTIVision: http://reactivision.sourceforge.net/
* download the udpbridge: http://gkaindl.com/software/udp-flashlc-bridge
* rename udp-flashlc-bridge-win to "udp-flashlc-bridge.exe"

To run the application, launch reacTIVision and the udpbridge (either from command line or by double clicking the renamed .exe file).

### Arduino:
(as from http://www.instructables.com/id/Integrating-your-Arduino-With-Flash-and-Actionscri/?ALLSTEPS)
* download/install the Arduino IDE from http://www.arduino.cc/
* upload the File/Examples/Firmata/StandardFirmata to the Arduino
* download the Serproxy and ActionScript files from http://www.kasperkamperman.com/wordpress_kk/wordpress_uploads/2010/05/arduino_as3glue_bundle_v14.zip
* configure the serproxy.cfg according to your OS and the COM port the Arduino uses

To run the application, plug in the Arduino and launch the Serproxy.

## Fiducial Cube Assignment
[Direction] : [Fiducial id] 
The fiducial for the direction will be on the opposite side of the cube since the cube will be placed onto the glass.


### Red cube:
- Foward : 1
- Left : 2
- Right : 3
- Unassigned Command 1 : 4
- Unassigned Command 2 : 5
- Unassigned Command 3 : 6

### Peach cube:
- Foward : 7
- Left : 8
- Right : 9
- Unassigned Command 1 : 10
- Unassigned Command 2 : 11
- Unassigned Command 3 : 12

### Green cube:
- Foward : 13
- Left : 14
- Right : 15
- Unassigned Command 1 : 16
- Unassigned Command 2 : 17
- Unassigned Command 3 : 18

## Creating maps
### Game environments
A game environment consists of several files in a folder Maps/map#/ where # is the number of the environment. The required graphic files are:
* background.png
* base.png
* the goals (1.png, 2.png, 3.png, ...)
* the goal names in goals.txt (1.png on line 1, 2.png on line 2, ...)
* the obstacles (a.png, b.png, c.png, ...)

Please note, that __every__ line in the goals.txt needs to be ended by a newline character, even the last line. Also make sure that none of the goal names include digits.

### Map layouts
Map layouts can easily be created in the folder Maps/layouts as plain text files. They contain 8 lines of 8 characters to describe an 8x8 grid map. Please note, that __every__ line needs to be ended by a newline character, even the last line. There is 3 types of input fields:
* space: a standard field
* a letter (a, b, c, ...): an obstacle, corresponding to a.png, b.png, ... in the same folder
* a number (1, 2, 3, ...): a goal that needs to be reached
* a single capital X as the starting position

### Defining goals
Below the actual map, goals can be defined in any number of following rows with a comprehensible syntax. Separate lines are goals that all need to be achieved (logical AND), whereas comma-separated targets on the same line are achieved as soon as one of the targets is achieved (logical OR). If a line begins with an "!" (exclamation point symbol), it's meaning is inverted (logical NOT). Please note, that __every__ line needs to be ended by a newline character, even the last line. A sample input may look like this:

```
1,2
3
!4
```

and translates to "Get the 1 OR the 2, the 3 and NOT the 4". The numbers will then be replaced according to the selected game environment and the goal names defined therein (goals.txt).
