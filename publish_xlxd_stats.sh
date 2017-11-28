#!/bin/sh

OUTPUT="/var/www"

for time in 24h 1w 1m 1y; do

   date=$(date "+%H\\:%M\\:%S %d.%m.%Y")
   
   rrdtool graph $OUTPUT/nodes_$time.png \
      --start "-$time" \
      --step 60 \
      --pango-markup \
      --title "XLX518 Statistics" \
      --vertical-label "Number of Nodes/Peers" \
      "DEF:nodes=/usr/share/xlxd/statistics.rrd:nodes:AVERAGE" \
      "DEF:peers=/usr/share/xlxd/statistics.rrd:peers:AVERAGE" \
      "VDEF:nodes_min=nodes,MINIMUM" \
      "VDEF:nodes_avg=nodes,AVERAGE" \
      "VDEF:nodes_max=nodes,MAXIMUM" \
      "VDEF:nodes_last=nodes,LAST"   \
      "VDEF:peers_min=peers,MINIMUM" \
      "VDEF:peers_avg=peers,AVERAGE" \
      "VDEF:peers_max=peers,MAXIMUM" \
      "VDEF:peers_last=peers,LAST"   \
      "COMMENT: \\n" \
      "COMMENT:                      Min     Average     Max     Last\\n" \
      "LINE2:nodes#FF000090:Number of Nodes" \
      "GPRINT:nodes_min:  %3.0lf" \
      "GPRINT:nodes_avg:     %3.0lf" \
      "GPRINT:nodes_max:    %3.0lf" \
      "GPRINT:nodes_last:    %3.0lf\\n" \
      "LINE2:peers#0000FF90:Number of Peers" \
      "GPRINT:peers_min:  %3.0lf" \
      "GPRINT:peers_avg:     %3.0lf" \
      "GPRINT:peers_max:    %3.0lf" \
      "GPRINT:peers_last:    %3.0lf\\n" \
      "COMMENT: \\n" \
      "TEXTALIGN:right" \
      "COMMENT:<span foreground='#808080' size='small'>As of\: $date</span>" \
      > /dev/null
done
exit 0
