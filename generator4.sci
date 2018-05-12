//////////////////////////////////////////////////////////////////////////////
//
// Morse sound file generator
//
// Generate a .wav file playing user text in morse
//
//                  Copyright (C) 2012 Christophe DAVID (ON6ZQ)
//                    http://www.on6zq.be/Scilab/MorseSoundFileGenerator
//
//  This program is free software; you  can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 2 as published
//  by the Free Software Foundation (http://www.gnu.org/licenses/gpl.html).
//
//  Modifications to original script made by Olof Tångrot (SA2KAA) 2018
//  - Changed for command line execution
//  - Uses precomputed sound fonts to speed up execution.
//  - Migrated to Scilab 6.0.1
//
//////////////////////////////////////////////////////////////////////////////
//
//                This program was last tested with Scilab 6.0.1
//                            http://www.scilab.org
//
//////////////////////////////////////////////////////////////////////////////

// A semicolon at the end of an instruction causes the result not to be displayed.

errclear;         // clear all errors
clear;            // kill variables
clearglobal       // kill global variables
//clc;              // clear command window
//tohome;           // move the cursor to the upper left corner of the Command Window
//clf;              // clear or reset the current graphic figure (window) to default values

// stacksize('max'); // increase the size of this stack to the maximum.
//stacksize(1e8);   //stacksize('max') does not appear to work on my system ;-(


scilab_wavwrite_fix = 160000000; // FIXME OLTA not required 6.0.1
//////////////////////////////////////////////////////////////////////////////

// text                 = "PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS PARIS "; // 1 minute at 12 WPM
// text                 = "The Quick Brown Fox Jumps Over The Lazy Dog 1234567890";  // all alphanumerical characters
//text = input( "Give word", "string")

argv = sciargs()
argc_offset = find( argv == "-args" )
if ( argc_offset > 3 ) then
	printf( "Using input file %s.txt.\n", argv( argc_offset + 1 ) )
	infile = sprintf( "%s.txt", argv( argc_offset + 1 ) )
	outfile = argv( argc_offset + 1 )
else
	infile = res.txt
	outfile = "new"
end

fd = mopen( infile, 'rt');           // open file as text with read mode
text = mgetstr(1000, fd);          // read 33 characters from fd
mclose(fd);
                  
WordsPerMinute          =    12;

OutputDirectory         = '~/tmp/';
ToneFrequency           =   600; // hertz
SamplingRate            = 22500; // samples per second
BitDepth                =    16; // 8, 16, 24, 32 bits. number of bits each sample

EnvelopeSmoothingMethod = 2 // 0: none, 1: cosine, 2: Gaussian
RiseTime                = 0.010 // second
FallTime                = 0.010 // second

[fI, err] = fileinfo( OutputDirectory )
if ( err ~= 0 ) then
	printf( "\nPath %s does not exist!\nScilab script temintated.\n", OutputDirectory )
	quit
end
//////////////////////////////////////////////////////////////////////////////
SoundFont = list()

   morse = [         //     ASCII values and meanings
            ''       //     1
            ''       //     2
            ''       //     3
            ''       //     4
            ''       //     5
            ''       //     6
            ''       //     7
            ''       //     8
            ''       //     9
            ''       //    10
            ''       //    11
            ''       //    12
            ''       //    13
            ''       //    14
            ''       //    15
            ''       //    16
            ''       //    17
            ''       //    18
            ''       //    19
            ''       //    20
            ''       //    21
            ''       //    22
            ''       //    23
            ''       //    24
            ''       //    25
            ''       //    26
            ''       //    27
            ''       //    28
            ''       //    29
            ''       //    30
            ''       //    31
            ''       //    32
            ''       //    33 !
            ''       //    34 "
            ''       //    35 #
            ''       //    36 $
            ''       //    37 %
            ''       //    38 &
            ''       //    39 '
            ''       //    40 (
            ''       //    41 )
            '-...-'  //    42 *
            '.-.-.'  //    43 +
            '--..--' //    44 ,
            '-.....-' //    45 -
            '.-.-.-' //    46 .
            '-..-.'   //    47 /
            '-----'  //    48 0
            '.----'  //    49 1
            '..---'  //    50 2
            '...--'  //    51 3
            '....-'  //    52 4
            '.....'  //    53 5
            '-....'  //    54 6
            '--...'  //    55 7
            '---..'  //    56 8
            '----.'  //    57 9
            ''       //    58 :
            ''       //    59 ;
            ''       //    60 <
            '-...-'  //    61 =
            ''       //    62 >
            ''       //    63 ?
            '...-.-'       //    64 @ Procedurtecken
            '.-'     //    65 A
            '-...'   //    66 B
            '-.-.'   //    67 C
            '-..'    //    68 D
            '.'      //    69 E
            '..-.'   //    70 F
            '--.'    //    71 G
            '....'   //    72 H
            '..'     //    73 I
            '.---'   //    74 J
            '-.-'    //    75 K
            '.-..'   //    76 L
            '--'     //    77 M
            '-.'     //    78 N
            '---'    //    79 O
            '.--.'   //    80 P
            '--.-'   //    81 Q
            '.-.'    //    82 R
            '...'    //    83 S
            '-'      //    84 T
            '..-'    //    85 U
            '...-'   //    86 V
            '.--'    //    87 W
            '-..-'   //    88 X
            '-.--'   //    89 Y
            '--..'   //    90 Z
            '.--.-'       //    91 [
            '.-.-'       //    92 \
            '---.'       //    93 ]
            ''       //    94 ^
            ''       //    95 _
            ''       //    96 `
            '.-'     //    97 a
            '-...'   //    98 b
            '-.-.'   //    99 c
            '-..'    //   100 d
            '.'      //   101 e
            '..-.'   //   102 f
            '--.'    //   103 g
            '....'   //   104 h
            '..'     //   105 i
            '.---'   //   106 j
            '-.-'    //   107 k
            '.-..'   //   108 l
            '--'     //   109 m
            '-.'     //   110 n
            '---'    //   111 o
            '.--.'   //   112 p
            '--.-'   //   113 q
            '.-.'    //   114 r
            '...'    //   115 s
            '-'      //   116 t
            '..-'    //   117 u
            '...-'   //   118 v
            '.--'    //   119 w
            '-..-'   //   120 x
            '-.--'   //   121 y
            '--..'   //   122 z
            ''       //   123 {
            ''       //   124 |
            ''       //   125 }
            ''       //   126 ~
            ''       //   127
           ];


//////////////////////////////////////////////////////////////////////////////

function f = GaussDistribution(x, mu, s)
   p1 = -.5 * ((x - mu) / s) .^ 2;
   p2 = (s * sqrt(2 * %pi));
   f = exp(p1) ./ p2;
endfunction

//////////////////////////////////////////////////////////////////////////////

// http://www.kent-engineers.com/codespeed.htm
// http://www.arrl.org/files/file/Technology/x9004008.pdf

UnitsPerDit            = 1;
UnitsPerDah            = 3;
UnitsBetweenElements   = 1;
UnitsBetweenCharacters = 3;
UnitsBetweenWords      = 7;

UnitDuration           = 1.2 / WordsPerMinute;  // = 60 seconds/ 50 di in PAris/ wmp

InterElements   = zeros(1, (UnitsBetweenElements   * UnitDuration * SamplingRate))
InterCharacters = zeros(1, (UnitsBetweenCharacters * UnitDuration * SamplingRate))
InterWords      = zeros(1, (UnitsBetweenWords      * UnitDuration * SamplingRate))

Dit = 0 : 1 : (UnitsPerDit * UnitDuration * SamplingRate);
Dah = 0 : 1 : (UnitsPerDah * UnitDuration * SamplingRate);

Dit = sind((Dit / SamplingRate) * ToneFrequency * 360);
Dah = sind((Dah / SamplingRate) * ToneFrequency * 360);


if EnvelopeSmoothingMethod > 0 then
   // http://www.w8ji.com/cw_bandwidth_described.htm
   // http://fermi.la.asu.edu/w9cf/articles/click/index.html

   SmoothRise = 1 : 1 : (RiseTime * SamplingRate);
   SmoothFall = (FallTime * SamplingRate) : -1 : 1;

   select EnvelopeSmoothingMethod

      case 1 then
         SmoothRise = sind((SmoothRise / SamplingRate) * (1 / RiseTime)  * 90);
         SmoothFall = sind((SmoothFall / SamplingRate) * (1 / FallTime)  * 90);

      case 2 then
         mu =  RiseTime * SamplingRate;
         s  = (RiseTime * SamplingRate) / 2;

         SmoothRise = GaussDistribution(SmoothRise, mu, s);
         SmoothFall = GaussDistribution(SmoothFall, mu, s);

         SmoothRise = SmoothRise * (1 / max(SmoothRise));
         SmoothFall = SmoothFall * (1 / max(SmoothFall));

      else abort;
   end

//   plot(SmoothRise, 'g')
//   plot(SmoothFall, 'r')
//   legend(['SmoothRise';'SmoothFall']);

//   FileName = sprintf("%sMorseSoundFileGenerator_Envelope_%da.jpg", OutputDirectory, EnvelopeSmoothingMethod);
//   xs2jpg(gcf(), FileName); // Export to a JPG file.

//   input('Check the graphic window then press enter to continue.')
//   clf;

   [_rows, _columns] = size(SmoothRise);
   Dit(1:_columns)  = Dit(1:_columns) .* SmoothRise;
   Dah(1:_columns)  = Dah(1:_columns) .* SmoothRise;

   [_rows, _columns] = size(SmoothFall);
   Dit($ - _columns + 1 : $) = Dit($ - _columns + 1 : $) .* SmoothFall;
   Dah($ - _columns + 1 : $) = Dah($ - _columns + 1 : $) .* SmoothFall;
end

//plot(Dit)

//FileName = sprintf("%sMorseSoundFileGenerator_Dit_%db.jpg", OutputDirectory, EnvelopeSmoothingMethod);
//xs2jpg(gcf(), FileName); // Export to a JPG file.

//input('Check the graphic window then press enter to continue.')
//clf;
printf( "Generate sound font\n" )
SoundFont(0) = zeros(0)
M = asciimat( text )

for i = 1 : size( morse,'r' )
 	SoundFont(i) = []
//	printf( "%d  # %d\n", i, length ( morse(i) ) )
    for j = 1 : length( morse( i ) )
//    	printf("\n%03d %03d %s", i, j, part(morse(i), j:j));
   		select part(morse (i), j:j)
        	case '-' then SoundFont(i) = [SoundFont(i), Dah],
        	case '.' then SoundFont(i) = [SoundFont(i), Dit],
        	else printf("\nCannot send %s", part(MorseText(i), j:j));
      	end
      	if ( j < length( morse( i ) ) ) then
        	SoundFont(i) = [SoundFont(i), InterElements]
      	end
    end
 end

printf("Generate sound data.\n" )
SoundData = [];
utf8 = 0;
for i = 1 : length(M)
  // printf("\n%s", MorseText(i));
  select utf8
	case 0 then
      if M(i) == '' then
	    if ( length(SoundData) < scilab_wavwrite_fix ) then
          SoundData = [SoundData, InterWords];
	    end
      elseif ( 195 == M(i) ) then // UTF-8 char
	    utf8 = 1
      elseif ( M(i) <= 127 ) then
        if ( length(SoundData) < scilab_wavwrite_fix ) then
//      printf("\n%03d %s %s", M(i), ascii(M(i)),  morse(M(i)));
          SoundData = [SoundData, InterCharacters]
          SoundData = [SoundData, SoundFont( M(i ) )]
        end    
      else
        if ( length(SoundData) < scilab_wavwrite_fix ) then
        end
      end
    case 1 then
      if ( length(SoundData) < scilab_wavwrite_fix ) then
        if ( 133 == M(i) ) then // Convert UTF-8 to oscaralphar in ascii
          SoundData = [SoundData, InterCharacters]
          SoundData = [SoundData, SoundFont(91)]
        elseif ( 132 == M(i) ) then // Convert UTF-8 to alphaecho in ascii
          SoundData = [SoundData, InterCharacters]
          SoundData = [SoundData, SoundFont(92)]
        elseif ( 150 == M(i) ) then // Convert UTF-8 to oscarecho in ascii
          SoundData = [SoundData, InterCharacters]
          SoundData = [SoundData, SoundFont(93)]
	    elseif ( 137 == M(i) ) then // Convert UTF-8 É to E ascii
          SoundData = [SoundData, InterCharacters]
          SoundData = [SoundData, SoundFont(63)]
		else
		  printf( "Unknown UTF-8 character %xh @ %d \n", M(i), i+1 )
        end
      end
	  utf8 = 0
    else abort
  end
end
//analyze(SoundData, ToneFrequency - 300, ToneFrequency + 300, SamplingRate, 8192);
//FileName = sprintf("%sMorseSoundFileGenerator_Analysis_%dc.jpg", OutputDirectory, EnvelopeSmoothingMethod);
//xs2jpg(gcf(), FileName); // Export to a JPG file.

// wavwrite expects data arranged with one channel per column
printf ( "Generating PCM output file...\n" );


//FileName = sprintf("%s%s_%d.wav", OutputDirectory, outfile, EnvelopeSmoothingMethod);

FileName = sprintf("%s%s.wav", OutputDirectory, outfile );
printf( "Length %d\n", length(SoundData));
wavwrite(SoundData', SamplingRate, BitDepth, FileName);

printf('Check the %s directory.', OutputDirectory)

quit

//////////////////////////////////////////////////////////////////////////////
