# portmaster
complete 'portmaster' \
	'n,-*x,`pkg info -qoa | cut -d/ -f2`,' \
	'C,*/*,`pkg info -qoa`,' \
	'C,*,`pkg info -Ea`,'

# Mercurial commands and options
alias _comp_hg_options hg -v help \$COMMAND_LINE:s/hg\ //:as/\ /./:ar \
	\|\& awk '/options:/\{p=1\;next\}p'
complete 'hg' \
	'p,1,`hg help | awk \/^\ /\{print\ \$1\}`,' \
	'n,help,`hg help | awk \/^\ /\{print\ \$1\}`,' \
	'n,--rev,`hg log | awk \/^changeset:/\{print\ \$2\}`,' \
	'n,-r,`hg log | awk \/^changeset:/\{print\ \$2\}`,' \
	'C,-,`_comp_hg_options`,'

# SVN commands and options
alias _comp_svn_options svn help \$COMMAND_LINE:s/svn\ //:as/\ /./:ar \
	\|\& awk '/\^\ \ -.\*\ :\ /\{print\ \$1\;if\(\$2~/^\\\[-.\*\\\]\$/\)\{gsub\(/\[\]\[\]/,\"\",\$2\)\;print\ \$2\}\}'
alias _comp_svn_cmds \
	svn help \| awk '/\^\ \ \ \[\[:alnum:\]\]+\(\ \\\(.\*\\\)\)\?\$/\{print\ \$1\}'
complete svn \
	'p,1,`echo --version;_comp_svn_cmds`,' \
	'n,help,`_comp_svn_cmds`,' \
	'n,--version,(--quiet),' \
	'C,-,`_comp_svn_options`,'

