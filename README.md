MATLAB version 2014b (System: Intel Core i5-7200U @ 2.5GHz, 64-bit, 8 GB RAM) 

## Note
	This code requires VL Feat.
	Download VL Feat compressed file from http://www.vlfeat.org/download/vlfeat-0.9.21-bin.tar.gz. Extract the file into the same directory of the code in a folder named vlfeat-0.9.21-bin.
	Now vlfeat-0.9.21-bin folder should contain folder named vlfeat-0.9.21 and pax_global_header named file.( vlfeat-0.9.21-bin ----> pax_global_header and vlfeat-0.9.21 ----> subfolders and files)

- Initially run('vlfeat-0.9.21-bin/vlfeat-0.9.21/toolbox/vl_setup') everytime after MATLAB starts.

## Data
	5 stereo pairs have been provided from this dataset: http://vision.middlebury.edu/stereo/submit3/zip/MiddEval3-data-Q.zip

## Code
	The main file is stereo.m. Run this file to see matched points, an example of point being mapped to its corresponding epipolar line and finally the reconstructed image.

	Variables: In the Read Images section, one can input I1 = 'imX.png' and I2 = 'imY.png' where X can be 0,2,4,6,8 and Y=X+1. bin_size can also be changed in Dense SIFT section.