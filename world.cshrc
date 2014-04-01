# pkg_* tools
complete '{pkg_info,pkg_delete,pkg_validate,pkg_libchk}' \
	'n,-W,f,' \
	'C,*,`ls /var/db/pkg`,'

# pkgng tools
alias _comp_pkg_jails \
	jls -N \| awk 'NR\>1\{print\ \$1\}'
alias _comp_pkg_cmds \
	pkg help \|\& awk '/^\\\t/\{print\ \$1\}'
complete pkg \
	'n,-*j,`_comp_pkg_jails`,' \
	'n,-*c,d,' \
	'n,-*C,f,' \
	'p,1,`_comp_pkg_cmds`,' \
	'C,*,`pkg info -aE`,'

# SSH
alias _comp_ssh_hosts cut -d\\\  -f1 ~/.ssh/known_hosts \| sed \"s/\[\]\[\]//g\"
complete 'ssh*' \
	'n,-[iF],f,' 'c,-[iF],f,' \
	'c,*@,`_comp_ssh_hosts`,' \
	'C,*,`_comp_ssh_hosts`,'

# Manuals
alias _comp_man_whatis awk '\{sub\(/\ -\ .\*/,\"\"\)\}1' \
	/usr/share/man/whatis /usr/local/man/whatis
alias _comp_man_sect \(set COMMAND_LINE=\$COMMAND_LINE:s/man\ //:as/\ /./:ar \
	\; awk '/\\\(\[^\ \]\*$COMMAND_LINE\[^\ \]\*\\\)/\|\|\"$COMMAND_LINE\"!~/^.\$/'\)
alias _comp_man_pages awk \
	'\{gsub\(/,\ /,\"\\n\"\)\;gsub\(/\\\(\[\[:alnum:\]\]+\\\)/,\"\"\)\;gsub\(/\ /,\"\"\)\}1'
complete 'man' \
	'p,1,`_comp_man_whatis | _comp_man_pages`,' \
	'C,*,`_comp_man_whatis | _comp_man_sect | _comp_man_pages`,'

# Compilers
complete '{cc,c++,cpp,sdcc,clang*,gcc*,g++*}' \
	'c,-[IL],d,'

# usbconfig
alias _comp_usbconfig_cmds usbconfig help \
	\|\& awk '/commands:/\{p=1\;next\}p\{print\ \$1\}'
alias _comp_usbconfig_devs usbconfig list \| cut -d: -f1
complete 'usbconfig' \
	'n,-d,`_comp_usbconfig_devs`,' \
	'C,*,`_comp_usbconfig_cmds`,'

# make
set _comp_make_args=(B e i k N n q r s t W w X C D d f I J j m T V)
alias _comp_make_targets \$COMMAND_LINE:ags/-V// -V.ALLTARGETS
alias _comp_make_vars \$COMMAND_LINE:ags/-V// -qd g1 \
	\|\& awk '\{sub\(/=/,\"\ =\"\)\}\$2==\"=\"\{print\ \$1\}'
complete 'make' \
	'c,-f,f,' 'c,-[CIm],d,' 'c,-E,e,' \
	'c,-V,`_comp_make_vars`,' \
	'c,-,$_comp_make_args,' \
	'C,*,`_comp_make_targets`,'

# sysctl
complete 'sysctl' \
	'C,-,(-b -d -e -h -i -N -n -o -q -x -a),' \
	'C,*,`sysctl -aN`,'

# kldload
alias _comp_kld_files \
	find /boot/kernel /boot/modules -name \\\*.ko \
	\| sed -e 's,.\*/,,' -e 's,.ko\$,,'
complete 'kldload' \
	'C,-,(-n -v -q),' \
	'C,*,`_comp_kld_files`,'

# kldunload
alias _comp_kld_loaded_files \
	kldstat \| awk 'NR\>1\{sub\(/.ko\$/,\"\"\)\;print\ \$5\}'
alias _comp_kld_loaded_ids \
	kldstat \| awk 'NR\>1\{print\ \$1\}'
complete 'kldunload' \
	'C,-,(-f -v -i -n),' \
	'n,-i,`_comp_kld_loaded_ids`,' \
	'C,*,`_comp_kld_loaded_files`,'

# kldstat
alias _comp_kld_loaded_modules \
	kldstat -v \| awk '/\^\\t\\t\[0-9\]+/\{print\ \$2\}'
complete 'kldstat' \
	'c,-*i,`_comp_kld_loaded_ids`,' \
	'c,-*n,`_comp_kld_loaded_files`,' \
	'c,-*m,`_comp_kld_loaded_modules`,' \
	'n,-*i,`_comp_kld_loaded_ids`,' \
	'n,-*n,`_comp_kld_loaded_files`,' \
	'n,-*m,`_comp_kld_loaded_modules`,' \
	'C,*,(-v -i -n -q -m),'

# service
complete 'service' \
	'C,-,(-e -R -v -l -r),' \
	'p,1,`service -l`,' \
	'p,2,(start stop restart rcvar poll status onestart onestop onerestart onercvar onepoll onestatus),'

# Signals
alias _comp_signals \
	kill -l \| sed -E 's\/\(\^\|\ \)\(\[A-Z\]\)/\\1-\\2/g'
# kill
alias _comp_kill_procs \
	procstat -a \| awk 'NR\>1\{print\ \$1\}'
complete 'kill' \
	'C,-,`echo -s -l; _comp_signals`,' \
	'n,-*s,`kill -l`,' \
	'n,-*l,(),' \
	'C,*,`_comp_kill_procs`,'
# killall
alias _comp_killall_procs \
	procstat -a \| awk 'NR\>1\&\&\\!b\[\$11\]++\{print\ \$11\}'
alias _comp_killall_jails \
	jls \| awk 'NR\>1\{print\ \$1\}'
alias _comp_killall_users \
	procstat -a \| awk 'NR\>1\&\&\$7\\!\=\"-\"\&\&\\!k\[\$7\]++\{print\ \$7\}'
complete 'killall' \
	'c,-*j,`_comp_killall_jails`,' \
	'c,-*u,`_comp_killall_users`,' \
	'c,-*t,(),' \
	'c,-*c,`_comp_killall_procs`,' \
	'C,-,`echo -d -e -l -m -s -v -z -help -j -u -t -c; _comp_signals`,' \
	'n,-*j,`_comp_killall_jails`,' \
	'n,-*u,`_comp_killall_users`,' \
	'n,-*t,(),' \
	'n,-*c,`_comp_killall_procs`,' \
	'C,*,`_comp_killall_procs`,'

