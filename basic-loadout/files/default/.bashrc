#
# Aliases
#

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ..='cd ..'

#
# Custom functions
#

mygrants () {
		# Displays all grant imygrantsnformation
		# Usage: mygrants [-h -u -p]
		mysql -B -N $@ -e "SELECT DISTINCT CONCAT(
		'SHOW GRANTS FOR ''', user, '''@''', host, ''';'
		) AS query FROM mysql.user" |   mysql $@ |   sed 's/\(GRANT .*\)/\1;/;s/^\(Grants for .*\)/## \1 ##/;/##/{x;p;x;}'; }

myspace() {
    	# Displays disk usage of tables
        # Usage: myspace [ -h -u -p ]
        mysql -B -N $@ -e "SELECT table_schema, count(*) TABLES,
        concat(round(sum(table_rows)/1000000,2),'M')
        rows,concat(round(sum(data_length)/(1024*1024*1024),2),'G')
        DATA,concat(round(sum(index_length)/(1024*1024*1024),2),'G')
        idx,concat(round(sum(data_length+index_length)/(1024*1024*1024),2),'G')
        total_size,round(sum(index_length)/sum(data_length),2) idxfrac
        FROM information_schema.TABLES group by table_schema;"; }
 
runforonly() {
    	# Runs a command for a specified number of seconds
        # Usage: runforonly [number of seconds] [command]
        runtime=${1:-1m}
        mypid=$$
        shift
        $@ &
        cpid=$!
        sleep $runtime
        kill -s SIGTERM $cpid ;}
 
getextip() {
    	wget -qO- icanhazip.com; }

eh () { 
	    # Edit history list
	    history -a; vi ~/.bash_history; history -r; }

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

