version: 2
renderer: "networkd"
ethernets:
  en:
    match:
      name: "en*"
    dhcp4: true
    #optional: true
  veth:
    match:
      name: "veth*"
    dhcp4: true
    #optional: true
