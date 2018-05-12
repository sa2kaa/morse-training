# morse-training
Scipts useful for converting Swedish TextTV pages to Morse encoded soundfiles.

## Getting Started
The scipt has be developed on a Ubuntu 16.04 LTS machine. 

GNU Make is use to drive the conversion process

Example:

make 106
will convert page 106 into a soundfile with the content converted into Morse.

The script expects a directory with write permissions named 'tmp' to exist in the user home directory. The resulting files will end up there.

### Prerequisites
* Python 2.7 is installed
* Scilab 6.0.1 is installed (execution path is set in the Makefile)
* lame is installed (used to convert WAV files to MP3 and can be omitted)
* Create directctory 'tmp' in your home directory.

## License
* SVTtextFiler.py is licensed under the GNU GPL2.
* generator4.sci is licensed under the GNU GPL2.
* html2test.py is licensed under GNU GPL 3.
