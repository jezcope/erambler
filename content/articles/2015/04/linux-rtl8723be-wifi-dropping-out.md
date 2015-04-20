---
title: "Problems with connection dropping with RTL8723BE wifi card on Linux"
kind: article
created_at: Mon 20 Apr 2015 21:04:42 BST
tags:
  - Linux
  - Wifi
  - Troubleshooting
  - Technical
---

I run Linux on my laptop, and I've had some problems with the wifi intermittently dropping out.  I think I've found the solution to this, so I just wanted to record it here so I don't forget, and in case anyone else finds it useful.

What I found was that any time the wifi was idle for too long it just stopped working and the connection needed to be manually restarted.  Worse, after a while even that didn't work and I had to reboot to fix it.

The problem seems to be with the power-saving features of the wifi card, which is identified by `lspci` as:

```
01:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8723BE PCIe Wireless Network Adapter
```

What appears to happen is that the card goes into power-saving mode, goes to sleep and never wakes up again.

It makes use of the `rtl8723be` driver, and the solution appears to be to disable the power-saving features by passing some parameters to the relevant kernel module.  You can do this by passing the parameters on the command line if manually loading the module with `modprobe`, but the easiest thing is to create a file in `/etc/modprobe.d` (which can be called anything) with the following contents:

```conf
# Prevents the WiFi card from automatically sleeping and halting connection
options rtl8723be fwlps=0 swlps=0
```

This seems to be working for me now.  It's possible that only one out of the parameters `fwlps` and `swlps` are needed, but I haven't had chance to test this yet.

The following pages helped me figure this out:

- [Thread: RTL8723BE wifi dropping connection on Ubuntu 14.04][Ubuntu forum]
- [Github: lwfinger/rtl8723be - Occasional Connection Drops #1 ][github issue]

[Ubuntu forum]: http://ubuntuforums.org/showthread.php?t=2243978

[github issue]: https://github.com/lwfinger/rtl8723be/issues/1


