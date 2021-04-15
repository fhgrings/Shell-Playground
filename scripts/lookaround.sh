# Normal
echo "cebbrito cabbrito" | grep "cab"     # *cab*rito
echo "cebbrito cabbrito" | grep -oP "cab" # cab


# Lookbehind
echo "cebbrito cabbrito" | grep -oP "(?<=cab)rito" # rito
echo "cebbrito cabbrito" | grep -oP '(?<!TESTE)brito'

# Lookahead
echo "cebbrito cabbrito" | grep -oP 'b(?=brito)'    # b \n b
echo "cebbrito cabbrito" | grep -oP 'cab(?!TESTE)'    # cab


