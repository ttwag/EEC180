# EEC180 Lab 3 Report

## Part I
| SW3 | SW2 | SW1 | SW0 | lzd[2] | lzd[1] | lzd[0] |
| ---:| ----:| ---:| ---:| ---:| ---:|---:| 
| 0 | 0 | 0 | 0 |  1|0|0|
| 0 | 0 | 0 | 1 |  0|1|1|
| 0 | 0 | 1 | 0 |  0|1|0|
| 0 | 0 | 1 | 1 |  0|1|0|
| 0 | 1 | 0 | 0 |  0|0|1|
| 0 | 1 | 0 | 1 |  0|0|1|
| 0 | 1 | 1 | 0 |  0|0|1|
| 0 | 1 | 1 | 1 |  0|0|1|
| 1 | 0 | 0 | 0 |  0|0|0|
| 1 | 0 | 0 | 1 |  0|0|0|
| 1 | 0 | 1 | 0 |  0|0|0|
| 1 | 0 | 1 | 1 |  0|0|0|
| 1 | 1 | 0 | 0 |  0|0|0|
| 1 | 1 | 0 | 1 |  0|0|0|
| 1 | 1 | 1 | 0 |  0|0|0|
| 1 | 1 | 1 | 1 |  0|0|0|

lzd[2] = !SW3 & !SW2 & !SW1 & !SW0

lzd[1] = (!SW3 & !SW2 & SW0) | (!SW3 & !SW2 & SW1)

lzd[0] = (!SW3 & SW2) | (!SW3 & !SW1 & SW0)

```
# Loading work.testBench
# Loading work.lzd4
run -all
# Test Begins:
# Number of Test = 16
# Error =           0

```

## Part II

To reuse the 4-bit lzd block for partIII, we need to split the 8 bit input into two parts. Bit 0 to 3 and bit 4 to 7. We can use the 4-bit lzd block on bit 4 to 7 because it's the leading term. 

However, we can only use the result of lzd block on bit 0 to 3 when the bit 4 to 7 are all 0. At the end, add up the two results and return it as a 4-bit vector.

lzd [3:0] = lzd1[3:0] + (!SW7 & !SW6 & !SW5 & !SW4) & lzd0[3:0]

Instead of using (!SW7 & !SW6 & !SW5 & !SW4), we could also use lzd1[3] as the flag.



```
# Loading work.testBench
# Loading work.lzd4
# Loading work.lzd8
# Loading work.genAdder
# Loading work.fAdder
run -all
# Number of Test =         256
# Error =           0
```

