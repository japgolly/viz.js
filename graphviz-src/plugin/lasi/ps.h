const char *ps_txt[] = {
"%%BeginProlog",
"/DotDict 200 dict def",
"DotDict begin",
"",
"/setupLatin1 {",
"mark",
"/EncodingVector 256 array def",
" EncodingVector 0",
"",
"ISOLatin1Encoding 0 255 getinterval putinterval",
"EncodingVector 45 /hyphen put",
"",
"% Set up ISO Latin 1 character encoding",
"/starnetISO {",
"        dup dup findfont dup length dict begin",
"        { 1 index /FID ne { def }{ pop pop } ifelse",
"        } forall",
"        /Encoding EncodingVector def",
"        currentdict end definefont",
"} def",
"/Times-Roman starnetISO def",
"/Times-Italic starnetISO def",
"/Times-Bold starnetISO def",
"/Times-BoldItalic starnetISO def",
"/Helvetica starnetISO def",
"/Helvetica-Oblique starnetISO def",
"/Helvetica-Bold starnetISO def",
"/Helvetica-BoldOblique starnetISO def",
"/Courier starnetISO def",
"/Courier-Oblique starnetISO def",
"/Courier-Bold starnetISO def",
"/Courier-BoldOblique starnetISO def",
"cleartomark",
"} bind def",
"",
"%%BeginResource: procset graphviz 0 0",
"/coord-font-family /Times-Roman def",
"/default-font-family /Times-Roman def",
"/coordfont coord-font-family findfont 8 scalefont def",
"",
"/InvScaleFactor 1.0 def",
"/set_scale {",
"       dup 1 exch div /InvScaleFactor exch def",
"       scale",
"} bind def",
"",
"% styles",
"/solid { [] 0 setdash } bind def",
"/dashed { [9 InvScaleFactor mul dup ] 0 setdash } bind def",
"/dotted { [1 InvScaleFactor mul 6 InvScaleFactor mul] 0 setdash } bind def",
"/invis {/fill {newpath} def /stroke {newpath} def /show {pop newpath} def} bind def",
"/bold { 2 setlinewidth } bind def",
"/filled { } bind def",
"/unfilled { } bind def",
"/rounded { } bind def",
"/diagonals { } bind def",
"",
"% hooks for setting color ",
"/nodecolor { sethsbcolor } bind def",
"/edgecolor { sethsbcolor } bind def",
"/graphcolor { sethsbcolor } bind def",
"/nopcolor {pop pop pop} bind def",
"",
"/beginpage {	% i j npages",
"	/npages exch def",
"	/j exch def",
"	/i exch def",
"	/str 10 string def",
"	npages 1 gt {",
"		gsave",
"			coordfont setfont",
"			0 0 moveto",
"			(\\() show i str cvs show (,) show j str cvs show (\\)) show",
"		grestore",
"	} if",
"} bind def",
"",
"/set_font {",
"	findfont exch",
"	scalefont setfont",
"} def",
"",
"% draw text fitted to its expected width",
"/alignedtext {			% width text",
"	/text exch def",
"	/width exch def",
"	gsave",
"		width 0 gt {",
"			[] 0 setdash",
"			text stringwidth pop width exch sub text length div 0 text ashow",
"		} if",
"	grestore",
"} def",
"",
"/boxprim {				% xcorner ycorner xsize ysize",
"		4 2 roll",
"		moveto",
"		2 copy",
"		exch 0 rlineto",
"		0 exch rlineto",
"		pop neg 0 rlineto",
"		closepath",
"} bind def",
"",
"/ellipse_path {",
"	/ry exch def",
"	/rx exch def",
"	/y exch def",
"	/x exch def",
"	matrix currentmatrix",
"	newpath",
"	x y translate",
"	rx ry scale",
"	0 0 1 0 360 arc",
"	setmatrix",
"} bind def",
"",
"/endpage { showpage } bind def",
"/showpage { } def",
"",
"/layercolorseq",
"	[	% layer color sequence - darkest to lightest",
"		[0 0 0]",
"		[.2 .8 .8]",
"		[.4 .8 .8]",
"		[.6 .8 .8]",
"		[.8 .8 .8]",
"	]",
"def",
"",
"/layerlen layercolorseq length def",
"",
"/setlayer {/maxlayer exch def /curlayer exch def",
"	layercolorseq curlayer 1 sub layerlen mod get",
"	aload pop sethsbcolor",
"	/nodecolor {nopcolor} def",
"	/edgecolor {nopcolor} def",
"	/graphcolor {nopcolor} def",
"} bind def",
"",
"/onlayer { curlayer ne {invis} if } def",
"",
"/onlayers {",
"	/myupper exch def",
"	/mylower exch def",
"	curlayer mylower lt",
"	curlayer myupper gt",
"	or",
"	{invis} if",
"} def",
"",
"/curlayer 0 def",
"",
"%%EndResource",
"%%EndProlog",
"%%BeginSetup",
"14 default-font-family set_font",
"1 setmiterlimit",
"% /arrowlength 10 def",
"% /arrowwidth 5 def",
"",
"% make sure pdfmark is harmless for PS-interpreters other than Distiller",
"/pdfmark where {pop} {userdict /pdfmark /cleartomark load put} ifelse",
"% make '<<' and '>>' safe on PS Level 1 devices",
"/languagelevel where {pop languagelevel}{1} ifelse",
"2 lt {",
"    userdict (<<) cvn ([) cvn load put",
"    userdict (>>) cvn ([) cvn load put",
"} if",
"",
"%%EndSetup",
(char*)0 };
