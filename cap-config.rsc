#-------------------------------------------------------------------------------
# Note: script will not execute at all (will throw a syntax error) if
#       dhcp or wireless-fp packages are not installed
#-------------------------------------------------------------------------------

#| CAP configuration
#|
#|   Wireless interfaces are set to be managed by CAPsMAN.
#|   All ethernet interfaces and CAPsMAN managed interfaces are bridged.
#|   DHCP client is set on bridge interface.

# bridge port name
:global brName  "bridgeLocal";
:global logPref "defconf:";


:global action;

:log info $action

:if ($action = "apply") do={

  # wait for ethernet interfaces
  :local count 0;
  :while ([/interface ethernet find] = "") do={
    :if ($count = 30) do={
      :log warning "DefConf: Unable to find ethernet interfaces";
      /quit;
    }
    :delay 1s; :set count ($count + 1);
  }

  :local macSet 0;
  :local tmpMac "";

  :foreach k in=[/interface ethernet find] do={
    # first ethernet is found; add bridge and set mac address of the ethernet port
    :if ($macSet = 0) do={
      :set tmpMac [/interface ethernet get $k mac-address];
      /interface bridge add name=$brName auto-mac=no admin-mac=$tmpMac comment="defconf";
      :set macSet 1;
    }
    # add bridge ports
    /interface bridge port add bridge=$brName interface=$k comment="defconf"
  }

  # try to add dhcp client on bridge interface (may fail if already exist)
  :do {
    /ip dhcp-client add interface=$brName disabled=no comment="defconf"
  } on-error={ :log warning "$logPref unable to add dhcp client";}


  # try to configure caps (may fail if for example specified interfaces are missing)
  :local interfacesList "";
  :local bFirst 1;

  # wait for wireless interfaces
  :while ([/interface wireless find] = "") do={
    :if ($count = 30) do={
      :log warning "DefConf: Unable to find wireless interfaces";
      /quit;
    }
    :delay 1s; :set count ($count + 1);
  }

  # delay just to make sure that all wireless interfaces are loaded
  :delay 5s;
  :foreach i in=[/interface wireless find] do={
    if ($bFirst = 1) do={
      :set interfacesList [/interface wireless get $i name];
      :set bFirst 0;
    } else={
      :set interfacesList "$interfacesList,$[/interface wireless get $i name]";
    }
  }
  :do {
    /interface wireless cap
      set enabled=yes interfaces=$interfacesList discovery-interfaces=$brName bridge=$brName
  } on-error={ :log warning "$logPref unable to configure caps";}

}

:if ($action = "revert") do={
  :do {
    /interface wireless cap
      set enabled=no interfaces="" discovery-interfaces="" bridge=none
  } on-error={ :log warning "$logPref unable to unset caps";}

  :local o [/ip dhcp-client find comment="defconf"]
  :if ([:len $o] != 0) do={ /ip dhcp-client remove $o }

  /interface bridge port remove [find comment="defconf"]
  /interface bridge remove [find comment="defconf"]

}
