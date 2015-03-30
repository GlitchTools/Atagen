import sys, os, math
filename = sys.argv[1]
freq = float(sys.argv[2])
amp = float(sys.argv[3])
src = int(sys.argv[4])
dst = int(sys.argv[5])
outname = sys.argv[6]
outfile = open(outname, "w+")
with open(filename) as infile:
    for line in infile:
        result = ""
        if "," in line:
            spl = line.split(" ")
            for x in spl:
                if "," in x:
                    coords = x.split(",")
                    coords[src] = str(float(coords[src]) + ((amp * math.sin(float(coords[dst]) * freq)) \
                                                     * (amp * math.cos(float(coords[dst]) * freq)))) # it's more fun to multiply
                    result = result + coords[0] + "," + coords[1] + " "
                else:
                    result = result + x + " "
        else:
            result = line
        outfile.write(result)
outfile.close()
