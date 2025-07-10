BEGIN {
    sum = 0;
    count = 0;
    min = ""; max = "";
}

{
    # Check if the line is a number (integer or float)
    if ($0 ~ /^-?[0-9]+(\.[0-9]+)?$/) {
        val = $0 + 0;  # Convert to number
        sum += val;
        count++;

        if (min == "" || val < min)
            min = val;

        if (max == "" || val > max)
            max = val;
    } else {
        print "Warning: Non-numeric line skipped -> " $0 > "/dev/stderr"
    }
}

END {
    if (count > 0) {
        avg = sum / count;
        print "Statistics:";
        print "Count:", count;
        print "Sum:", sum;
        print "Average:", avg;
        print "Min:", min;
        print "Max:", max;
    } else {
        print "No numeric data found."
    }
}
