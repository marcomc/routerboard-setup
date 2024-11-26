# CAP Configuration Script Documentation

This document explains the `cap-config.rsc` RouterOS script that configures Controlled Access Points (CAP) in a MikroTik network.

## Overview

The script automates the configuration of wireless access points to operate as CAPs managed by a CAPsMAN (Controller Access Point System Manager). This setup is ideal for centralized wireless network management.

## Prerequisites

- RouterOS with `dhcp` and `wireless-fp` packages installed
- At least one ethernet interface
- At least one wireless interface

## Script Operations

The script operates in two modes controlled by the `$action` variable:

### Apply Mode (`$action = "apply"`)

1. **Bridge Creation**
   - Creates a bridge interface named "bridgeLocal"
   - Sets MAC address from the first ethernet interface

2. **Interface Configuration**
   - Adds all ethernet interfaces to the bridge
   - Sets up DHCP client on the bridge interface
   - Configures all wireless interfaces as CAPs
   - Links all interfaces to the bridge

3. **Safety Measures**
   - Waits up to 30 seconds for ethernet interfaces
   - Waits up to 30 seconds for wireless interfaces
   - Additional 5-second delay to ensure wireless interfaces are fully loaded

### Revert Mode (`$action = "revert"`)

1. **Configuration Removal**
   - Disables CAP functionality
   - Removes DHCP client configuration
   - Removes bridge port configurations
   - Removes the bridge interface

### Error Handling

- The script includes error handling for common operations
- Logs warnings and errors using the system logging facility
- Prefixes log messages with "defconf:" for easy identification

## Global Variables

- `brName`: Bridge interface name (default: "bridgeLocal")
- `logPref`: Logging prefix (default: "defconf:")
- `action`: Determines operation mode ("apply" or "revert")

## Usage

### Running the Script

1. **Upload the Script**
   - Upload `cap-config.rsc` to your MikroTik device using WinBox, WebFig, or FTP

2. **Set Action Variable**
   ```routeros
   :global action "apply"    # To configure CAP
   # or
   :global action "revert"   # To remove CAP configuration
   ```

3. **Execute Script**
   ```routeros
   /import cap-config.rsc
   ```

### Common Use Cases

1. **Initial CAP Setup**
   ```routeros
   :global action "apply"
   /import cap-config.rsc
   ```

2. **Removing CAP Configuration**
   ```routeros
   :global action "revert"
   /import cap-config.rsc
   ```

3. **Reconfiguring CAP**
   ```routeros
   :global action "revert"
   /import cap-config.rsc
   :delay 2s
   :global action "apply"
   /import cap-config.rsc
   ```

### Monitoring

- Check system logs for script execution status:
  ```routeros
  /log print where message~"defconf:"
  ```
- Verify CAP status:
  ```routeros
  /interface wireless cap print
  ```
