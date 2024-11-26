# MikroTik RouterBoard Reset Instructions

## Standard Reset Procedure

1. **Power off** the router completely

2. **Locate the RESET button** 
   - Usually a small hole on the device
   - Use a thin object like a paperclip to press it

3. **Reset Process & LED Patterns**
   - Press and hold reset button
   - Power on while holding button
   - Watch for LED patterns:
     - **Fast blinking**: Device is not in protected mode
     - **1-second on/off blinking**: Device is in protected mode
   - Keep holding until appropriate LED pattern appears

4. **LED Pattern Meanings**
   - **Fast blinking + Single beep**: Normal boot process started
   - **Multiple fast beeps**: May indicate boot loop/hardware issue
   - **LED solid ON** (after ~10 seconds): CAP mode
   - **LED turns OFF** (after ~15 seconds): Netinstall mode

## Netinstall Reset Method

1. **Preparation:**
   - Download latest Netinstall from MikroTik website
   - Disable ALL network interfaces except the Ethernet you'll use
   - Set PC's IP to 192.168.88.2/24
   - Run Netinstall as Administrator
   - Place Netinstall.exe and RouterOS .npk in same folder

2. **Connection:**
   - Connect PC directly to router's Ethernet port
   - Disable antivirus/firewall (they may block BOOTP on UDP 67-68)
   - Ensure using latest Netinstall version

3. **Reset Process:**
   - Hold reset button
   - Power on while holding button
   - Keep holding until:
     - LED stays solid ON (~10 seconds) then
     - LED turns OFF (~5 more seconds)
   - Release button when LED is OFF

4. **After Reset:**
   - Default IP: 192.168.88.1
   - Username: admin
   - Password: (blank)

## Protected Mode Override

If device shows 1-second blink pattern (protected mode):
- Hold reset button for full 20 seconds
- Some devices may have configured time windows (e.g., 4:10-4:20 minutes)
- Some users report success after waiting 5 minutes

## Troubleshooting
- If device doesn't appear in Netinstall:
  - Try different Ethernet cables
  - Try multiple reboots
  - Disable Windows firewall temporarily
  - Run Netinstall as Administrator
  - Check for BOOTP requests in Wireshark

## Notes
- Backup your configuration before resetting if possible
- All configuration settings will be erased
- You'll need to reconfigure network settings after reset