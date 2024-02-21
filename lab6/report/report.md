# Lab 6

(a) Assume you wanted to implement each filter on a simple microprocessor.
Estimate how many simple assembly instructions (and thus roughly the
number of clock cycles) each of the filters described in Table 2 would
take per pixel. Using this, estimate the total number of clock cycles
needed to process a 512x512 gray-scale image. Assuming a 50 MHz
clock, how many seconds would each filter take. Record your answers in
a table and describe how you got the number of instructions needed to
execute each of the filtering operations.

```
// Tint (4 Cycles, 0.02s)

Time = 4 * (1/5MHz) * 512 * 512 = 0.02s

f(x) = max{x-64, 0}

A:
    subi rs1, rs1, 64
    bgt rs1, x0, offset
    add rs1, x0, x0
offset:
```

```
// Invert (1 Cycles, 0.005s)

Time = 1 * (1/5MHz) * 512 * 512 = 0.005s

f(x) = 255 - x

sub rs3, 255, rs1
```

```
// Threshold (4 Cycles, 0.02s)

Time = 4 * (1/5MHz) * 512 * 512 = 0.02s

f(x) = 255 | x > 127, 0 | otherwise

A:
    bgt rs1, rs2, B
    add rs1, x0, x0
    jal x0, end
B:
    addi rs1, x0, 255
end:
```

```
// Increase Contrast (9 Cycles, 0.047s)

Time = 9 * (1/5MHz) * 512 * 512 = 0.047s

f (x) = x/2 | x < 85, 2x - 128 | 85 <= x < 171, x/2 + 128 | otherwise

A:
    blt rs1, rs2, offset
    bge rs1, rs3, otherwise
    slli rs1, rs1, 1
    subi rs1, rs1, 128
    jal x0, end
offset:
    srli rs1, rs1, 1
    jal x0, end
otherwise:
    srli rs1, rs1, 1
    addi rs1, rs1, 128
end:
```
| Type | Cycle for 1 Pixel | Total Time (s) |
| -----|------|-----|
|  Tint | 3 | 0.015 |
|  Invert | 1 | 0.005 |
|  Threshold | 4 | 0.02 |
|  Increase Contrast | 9 | 0.047 |

(b) Now, assume that each of the four filters in Table 2 can be done in two
clock cycles using an FPGA. If we did not have the transmission limitation
imposed by the serial port and again assuming a 50 MHz clock, how many
seconds will each filter take? What is the speed up relative to the
microprocessor?

| Type | Cycle for 1 Pixel | Total Time (s) | Speed Up (%) |
| -----|------|-----| ----|
|  Tint | 2 | 0.01 | 50 |
|  Invert | 2 | 0.01 | N/A |
|  Threshold | 2 | 0.01 | 50 |
|  Increase Contrast | 2 | 0.01 | 79 |
