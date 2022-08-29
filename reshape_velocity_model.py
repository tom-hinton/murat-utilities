# Open grid reference
f = open('STA_Long_Lat.txt', 'r')
f_contents = f.readlines()

output_strings = [] # prepare empty list of output strings

# For each grid point
for f_line in f_contents:
    sep_array = f_line.split()  # get code, long, lat

    # Read grid point file
    s = open(sep_array[0] + '_depth_modl.d')
    contents = s.readlines()

    # For each depth value
    for line in contents:
        sep = line.split()  # get depth, vp, vs, density

        # extract vals into dictionary
        d = { 
            "lon": float(sep_array[1]),
            "lat": float(sep_array[2]),
            "alt": -float(sep[0]) * 10**3,
            "vp": float(sep[1]),
            "vs": float(sep[2]),
        }

        # format output string
        output_string = "  {: .7e}  {: .7e}  {: .7e}  {: .7e} \n".format( #output 
            d['lat'], d['lon'], d['alt'], d['vp'],
        )
        output_strings.append(output_string)

    # Close files
    s.close()
f.close()

# Write to output file
with open('vmod_jk_p.txt', 'w') as o:
    o.writelines(output_strings)