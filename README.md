# A script run as a service to restart serial-getty@ttyUSB[0-9] service

Sometimes a serial getty service for the devices /dev/ttyUSB0 through /dev/ttyUSB9 fails to restart
after the USB serial adaptor is removed and reinserted into the USB port.

This script, which is run as a systemd service, monitors the output of the dmesg command
looking for messages that indicate when a USB serial adaptor has been inserted
and then restarts the appropriate serial-getty service.

Written and tested on and for a Raspberry Pi Model B but could well work on other Raspberry Pi versions.

## Quick start

Run:

```
sudo ./Install.sh
```

Insert a USB serial adaptor.

Attach a serial port terminal emulator and press return a few times.

A login prompt should be displayed.

Login to the Raspberry Pi.

Finished :-]

## Trouble shooting tips

Connect the serial port terminal emulator at 9600 baud.

Check the service is running:

```
sudo systemctl status serial-getty-restarter.service
```

Check the getty process is running:

```
ps aux | grep ttyUSB
```

Try rebooting the Raspberry Pi.

## Why did I write this?

The Raspberry Pi is a great bit of kit. Once set up and connected to a network you can ssh into them and do lots
of interesting stuff. When running a Raspberry Pi "headless" (i.e. without a monitor, keyboard or mouse attached) they
can be set up in all manner of physical locations.

This is great but sometimes due to network issues or, more commonly in my case, human error the network connection can be lost.

Without the serial console access being set up the usual recovery process is to connect a monitor and keyboard to the Raspberry Pi, login
on the console and start working out what has gone wrong.

With serial console access you just need to plug in a USB serial adapater into a free USB port on the Raspberry Pi
and then use a serial port terminal emulator on a laptop/PC to login to the Raspberry Pi. Far less cumbersome.

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

For example of the last field was:

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
