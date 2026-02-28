<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

In this project, I use a Wallace tree multiplier to quickly compute the multipication of two 6 bit numbers. This algorithm parallelizes multiplication by adding shifted versions of inputs together 3 inputs at a time, effectively reducing the number of stages you need to perform for multiplication from n stages to a function of log(n) stages. The first step of the Wallace tree takes in 2 sets of 3 rows of the 6 bit input, doing addition to convert them into two sets of a sum and a carry out string each. Now that we have 4 rows, we compress this into 3 rows by repeating the above step of adding a shifted input, the carry out, and the sum together to obtain a new sum and a new carry out, as well as the unused row from the previous step. Finally, we repeat this step a last time to turn the 3 rows into 2, then add the remaining rows together to obtain our final output. This description does obfuscate some of the innerworkings of the shifting mechanics, but this is the general picture.

## How to test

cd test
make

All testing for this project was done in cocotb, simply change the values of ui_in and uio_in to match the corresponding values of a and b and p. ui_in is mapped to {b[1:0], a[5:0]}, and uio_in is mapped to {4'bxxxx, b[5:2]}. uo_out is mapped to p[7:0] and uio_out is mapped to {p[11:8], 4'bxxxx}. So for example, to test 63 * 63 (6'b111111 * 6'b111111) = 3969 (12'b111110000001), you would set ui_in to 255, uio_in to 15, and check to see if uo_out = 129 and uio_out = 240.

