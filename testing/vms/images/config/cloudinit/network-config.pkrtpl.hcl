version: 2
renderer: "networkd"
ethernets:
  all-en:
    match:
      name: "en*"
    dhcp4: true
    #optional: true
  all-veth:
    match:
      name: "veth*"
    dhcp4: true
    #optional: true
