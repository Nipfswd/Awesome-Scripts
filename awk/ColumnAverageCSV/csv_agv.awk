BEGIN {
    FS = ",";          # Set field separator to comma
    col = 2;           # Column to average (change as needed)
    sum = 0;
    count = 0;
}

NR > 1 {               # Skip header row (if present)
    if ($col ~ /^[0-9]+(\.[0-9]+)?$/) {
        sum += $col;
        count++;
    }
}

END {
    if (count > 0) {
        avg = sum / count;
        print "Average of column " col ": " avg;
    } else {
        print "No valid numeric data found in column " col ".";
    }
}
