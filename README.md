# A script run as a service to restart serial-getty@ttyUSB[0-9] service on a Raspberry Pi

Sometimes a serial getty service for the devices /dev/ttyUSB0 through
/dev/ttyUSB9 fails to restart after the USB serial adaptor is removed
and reinserted into the USB port.

This script, which is run as a systemd service, monitors the output of the
dmesg command looking for messages that indicate when a USB serial adaptor
has been inserted and then restarts the appropriate serial-getty service.

Written and tested on and for a Raspberry Pi Model B but could well work
on other Raspberry Pi versions.

With a few tweaks it could probably run on just about any Linux that
has support for a USB serial port dongle.

## Quick start

Run:

```
sudo ./Install.sh
```

Insert a USB serial adaptor to a spare USB port on the Raspberry Pi.

Attach a serial port terminal emulator to the USB serial adapter's 9-pin
connector and then press return a few times.

A login prompt should be displayed.

If no login prompt is displayed try sending a BREAK from the serial port
terminal emulatipn program and pressing return a few times again.

Login to the Raspberry Pi.

Finished :-]

## Sending a BREAK from the terminal emulation program! What do you mean?

With serial connections sending a break means dropping the connection for a short time. This
can (hopefully) have the effect of getting the device at the other end of the serial link
to reset and autodetect the baud rate. It does not always work but is `ALWAYS` worth a try.

Here are the methods to send a break with various serial port terminal emulation programs:

### MobaXterm on Windows

Press and hold down the control key.

Press and release the pause/[break] key.

Release the control key.


## Trouble shooting tips

Try the following baud rates with your terminal emulation program:

+ 115200
+ 57600
+ 38400
+ 9600

Check the serial-getty-restarter service is running:

```
sudo systemctl status serial-getty-restarter.service
```

Check the getty process is running for the USB serial adapter:

```
ps aux | grep ttyUSB
```

Try rebooting the Raspberry Pi.

## Why did I write this?

The Raspberry Pi is a great bit of kit. Once set up and connected to
a network you can ssh into them and do lots of interesting stuff. When
running a Raspberry Pi "headless" (i.e. without a monitor, keyboard or
mouse attached) they can be set up in all manner of physical locations.

This is great but sometimes due to network issues or, more commonly in
my case, human error the network connection can be lost.

Without the serial console access being set up the usual recovery process
is to connect a monitor and keyboard to the Raspberry Pi, login on the
console and start working out what has gone wrong.

With serial console access you just need to plug in a USB serial adapater
into a free USB port on the Raspberry Pi and then use a serial port
terminal emulator on a laptop/PC to login to the Raspberry Pi. Far
less cumbersome.

## More details if you are interested

The service is just a script which feeds a never ending loop the output of the command:

```
dmesg -W
```

It looks at lines which contain the string:

```
now attached to
```

It extracts the last field of those lines and if they match the regular expression:

```
ttyUSB[0-9]
```

the script runs the command to restart the appropriate service.

For example if the last field was:

```
ttyUSB0
```

then the script would run:

```
systemctl restart serial-getty@ttyUSB0.service
```

which would restart the getty process and, hopefully, display a login prompt on the serial port terminal emulator.

----------------
End of README.md
