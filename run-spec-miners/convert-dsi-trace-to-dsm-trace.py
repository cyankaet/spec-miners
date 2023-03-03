import gzip
import sys
import os

def read_trace_file(filename, string_traces):
    traces = {}
    with gzip.open(filename, "rt") as f:
        print("===Reading from " + filename)
        trace = f.readlines()
        for event_line in trace:
            event = event_line.split()[2]
            spl = event.split(".")
            event_class = ".".join(spl[:-1])
            event_name = spl[-1].strip()
            if not event_class in traces:
                traces[event_class] = ["<START>"]
            else:
                traces[event_class].append(event_name)

    for class_name in traces:
        if (len(traces[class_name]) == 1): # if we have no events other than <START>
            continue
        traces[class_name].append("<END>")
        trace_str = " ".join(traces[class_name])
        if not class_name in string_traces:
            string_traces[class_name] = [trace_str]
        else:
            string_traces[class_name].append(trace_str)
    
def main(dirname, out_dir):
    if not os.path.isdir(out_dir):
        print("Directory " + out_dir + " does not exist. Making new directory...")
        os.mkdir(out_dir)

    string_traces = {}
    acc = 0
    for filename in os.listdir(dirname): # assume we are reading the "traces" directory created by dsi:collect.
        if (not "-method-names.txt.gz" in filename) and (".txt.gz" in filename):
            read_trace_file(os.path.join(dirname, filename), string_traces)
    
    for classname in string_traces:
        print("writing traces of class " + classname)
        class_out = os.path.join(out_dir, classname, "input_traces")
        os.mkdir(os.path.join(out_dir, classname))
        os.mkdir(class_out)
        with open(os.path.join(class_out, "input.txt"), "w") as out:
            out.write('\n'.join(string_traces[classname]))

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("USAGE: python3 convert-trace.py traces_directory out_dir")
        exit(1)
    main(sys.argv[1], sys.argv[2])
