## Perl Interface for xlx statistics

This is a collection of simple perl code that queries a xlxd server via the JSON interface to collect some statistical data. Currently it collects the number of collected nodes and peers. The two values are written to a .rrd file.

# Usage

The xlxd_stats.pl script collects data and saves values to the rrd archive. This can be run from a cron job for example every minute.

The publish_xlxd_stats.sh is a simple shell script that makes nice graphs from the rrd file fed by xlxd_stats.pl. The resulting files can be created in a webserver's root directory to be served to the dashboard.

The rrd file is created by the following code:

```
rrdtool create /usr/share/xlxd/statistics.rrd --start now -s 60 \
DS:nodes:GAUGE:180:0:U \
DS:peers:GAUGE:180:0:U \
RRA:LAST:0.5:1:1440 \
RRA:LAST:0.5:60:168 \
RRA:LAST:0.5:180:240 \
RRA:LAST:0.5:1440:365 \
RRA:MIN:0.5:60:168 \
RRA:MIN:0.5:180:240 \
RRA:MIN:0.5:1440:8760 \
RRA:AVERAGE:0.5:60:168 \
RRA:AVERAGE:0.5:180:240 \
RRA:AVERAGE:0.5:1440:365 \
RRA:MAX:0.5:60:168 \
RRA:MAX:0.5:180:240 \
RRA:MAX:0.5:1440:365
```
