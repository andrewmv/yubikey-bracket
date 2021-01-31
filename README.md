## YubiKey Nano 5C Bracket

OpenSCAD model for printing directly around a YubiKey Nano 5C for ease of inserting/removing the device from a laptop or phone without needing tools, and hopefully making it harder to lose.

### Slicing

Place on build surface with the USB port facing down.

No supports are necessary, but you may wish to add a brim or a raft based on the adhesion of the material you're printing with.

### Printing preparation

Printing happens in three phases. After slicing, some g-code modification will be necessary to allow for taping and part insertion between phases.

My Monoprice Select Mini doesn't support interactively pausing from code, so I'm using a 60-second wait, during which time I manually pause the job in OctoPrint.

If your printer's Y-axis involves a moving extruder instead of a moving bed, you'll probably want to retract the head in the opposite direction.

* After the last layer of the support structure, approximately 8mm up, insert a pause and a retraction of the print head. Do this right before the last G0 command of the layer.

		;DELAY FOR TAPE APPLICATION
		G0 X0 Y120;(Stick out the part)
		G4 S60;(Delay for tape application)

* After the last layer of the sides of the model structure (before the first top layer), do this again:

		;DELAY FOR PART INSERTION
		G0 X0 Y120;(Stick out the part)
		G4 S60;(Delay for tape application)


### Printing

* Print up to the first g-code inserted delay, and pause the print job. Ensure the USB opening is clean enough of stringing, etc, to allow the YubiKey to fit in easily, but don't yet insert the part.
* Apply a square of Kapton tape to the top of the support base, and cut a slit in it for the USB port to fit through later. If you're using adhesion chemicals for your bed (glue, ABS juice), apply some to the tape as well.
* Resume the print.
* After the second delay, insert the YubiKey into the slot. It should be flush with the sides of the bracket, so the extruder can print directly onto the top surface of the YubiKey.