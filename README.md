# Assembly Language Clock
## An interrupt-driven 24-Hour clock written in the Motorola 68000 Assembly language.

### Running the Clock:

1. Download the [EASy68K](http://www.easy68k.com/) IDE for the Motorola Assembly language. This can be used on Windows natively or on
other systems using [Wine](https://www.winehq.org/)
2. Open the source code file using EASy68K and click the play button located at the top of the window (*outlined in teal*)
3. Click `Execute`
4. A new window will pop up with the same source code all in uniform colour.  Click the same play button that you clicked
in step 2
5. 2 new windows will open.  One is completely black and can be ignored, the other is titled "EASy68K Hardware" and is 
where the actual clock is located
6. in the Hardware window you located in step 5 click the drop-down menu under "Auto Interval" and set it to 6
7. Now, change the auto interval from 1000ms to 16ms.  This can be done by clicking the box that says "00001000"ms and
making sure it says "00000016"ms instead
8. To the left of the "Auto Interval" panel you will see 7 buttons with the label "Interrupt" on top.  Click the checkbox under button
number 6
9. The clock should now be working
