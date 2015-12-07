#!/bin/sh

hostname=$1
ipaddr=$2
dns_ipaddr=$3

echo *** Configure internal network...

nmcli general hostname ${hostname}
nmcli connection add type ethernet con-name eth1 ifname eth1
nmcli connection modify eth1 ipv4.addresses ${ipaddr}/24
nmcli connection modify eth1 ipv4.method manual
nmcli connection modify eth1 ipv4.dns ${dns_ipaddr}
nmcli connection down eth1 && nmcli connection up eth1

echo *** Ensuring non-interactive host access...

mkdir -m 0700 /root/.ssh

cat <<-EOF >/root/.ssh/private_key
	-----BEGIN RSA PRIVATE KEY-----
	MIIEowIBAAKCAQEAv8XOOgAU0AQ+a9CffIinvOh+sSDUWrhHp7GQw6qD4BKoMj6V
	gGIf1BN4FaeEvQsqA1jdeKho2zMqda47tAxlvqye91C7tc4LNRtwh1Tah265i+c9
	XnAxhAe/Nusf3vNHizDex3yh4wMAeBkD4XzxN/L8cFbBvVWzlSySaixdAFrjpuDl
	u0TJiGWlg6cgw7XtCmmB/pAK4BlLoWu0Tb/GOXEM7sjCgG3EZs9uALXEHeWg6jDb
	2OvyDzEjARuOljRAOIsG+SIprzedVY65q4oh5libcZAipqRHp56Wfw7d/TsCe0eH
	mDqRmSgz3P0ZvMs4WkSCryqietukaoQ/DRu46wIDAQABAoIBAAdFg9VVLXTZxFgo
	N/Pr5phWJH+o5ARwml70b63LqGZ1rqUBFIAiuFw9RL9lc7YLV1N7KiKqGBe/r+t4
	aNEh6zW4q+pqyENThb9ExBaNlB+whh6U7RHIpUgBVzHI5pN4nAzeFIRx6F2IPptP
	L4N8TlU1xHaqA3yfZEjSwNZ/yiL6Pnt5RhH4PciIlQu0Ld1IK78YQM262BoFs7C0
	tK1JspH3o2ncPc82k3DGw3tHXtdgUf/SbRXi/ZVgN8VAjt1sNOlr1BUO23pdd3U0
	H24JMu49qZSlC40cc+fSosGkZa1uGOOcTsDQ/1Kz5+l2WOreND5CnInkjwTkJfYE
	eIdwpEECgYEA4QEgGuTCFgleUXWYpp9wM210IrrOBugt5dCa7vlwo/47pVP0wEfp
	jPHZsFuEdqgztEzvWyrKbD+yl8v1L5tz8G5qj/sc1GreQf74X4li+ss3KlAZtgKd
	s4GDvCJhtx5nYBm2ZoR6S5ADUZJ+jgKNTFbgjt5Wx8YravrJmTy77IsCgYEA2jC/
	6YMjBdSzuJI0o2eKIEt4oK7UeR0hGYpPcZOGDpbfjSewgF8Ba1d5yI+S840QQAtW
	oYLAoyIIQ4/Fn/xkYpPCkD5Pc22qPobyLdG76hLuXQKy4DYAf7kOU/9t3aRwSr4o
	8L+2yBNRvIxmMcVAlsT5962wOBjOAwabK78nESECgYA05HzVlZ0CbSVc5NYDpUtM
	65f3ag5wlTfk5Ernjn+qLWN8E+ZfJQiD936C9KCI/DVbVxKVTdPT6o1jHbD/hf2V
	MX+fZRp73LturC9a1gMMjaTkL3w7yxWjUvjSywpJb75BWwoDw3S0OqBtFpDldTge
	D/Yt35pqz+z48wddHGfYzQKBgQC/REDXiJdpAx5QzAnMvHT+/mnOIbQsP3bGltIx
	c+ruWx+483Pr9FygJlyhjgp56cy297mHd8E6wBiScTQCnRO6vmCuZZDsVNQKX+1o
	cRTTiqjdbAI2PeCOFkETLTS4OPAe9TeaY9Ts6tKaAFGNi6alBCNEFUQGyOe/C0l3
	PegXQQKBgGYoby3QA90DESkXUj9NTRr/eUIiBT8FJjS3W9i/rMjuyXbaUytvqSyB
	Gh/nC2U+PpNCuFfkDNqrss604T3+QYjNhCtr6ZBMw3vVhmm772I0Q9A0yM5ufkEr
	zp3ns28eCM5x/DsXImsvgaFWSv39igIhAGuFuoLNR0mX7b7osZVB
	-----END RSA PRIVATE KEY-----
EOF

cat <<-EOF >/root/.ssh/authorized_keys
	ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/xc46ABTQBD5r0J98iKe86H6xINRauEensZDDqoPgEqgyPpWAYh/UE3gVp4S9CyoDWN14qGjbMyp1rju0DGW+rJ73ULu1zgs1G3CHVNqHbrmL5z1ecDGEB7826x/e80eLMN7HfKHjAwB4GQPhfPE38vxwVsG9VbOVLJJqLF0AWuOm4OW7RMmIZaWDpyDDte0KaYH+kArgGUuha7RNv8Y5cQzuyMKAbcRmz24AtcQd5aDqMNvY6/IPMSMBG46WNEA4iwb5IimvN51VjrmriiHmWJtxkCKmpEennpZ/Dt39OwJ7R4eYOpGZKDPc/Rm8yzhaRIKvKqJ626RqhD8NG7jr vagrant-openshift
EOF

cat <<-EOF >/root/.ssh/config
	Host *.internal
	  UserKnownHostsFile /dev/null
	  StrictHostKeyChecking no
	  PasswordAuthentication no
	  IdentityFile ~/.ssh/private_key
	  IdentitiesOnly yes
	  LogLevel FATAL
EOF

chmod 0600 /root/.ssh/private_key /root/.ssh/authorized_keys /root/.ssh/config
