## \--- [Day 11](https://adventofcode.com/2021/day/9): Dumbo Octopus ---

You enter a large cavern full of rare bioluminescent [dumbo octopuses](https://www.youtube.com/watch?v=eih-VSaS2g0)! They seem to not like the Christmas lights on your submarine, so you turn them off for now.

There are 100 octopuses arranged neatly in a 10 by 10 grid. Each octopus slowly gains _energy_ over time and _flashes_ brightly for a moment when its energy is full. Although your lights are off, maybe you could navigate through the cave without disturbing the octopuses if you could predict when the flashes of light will happen.

Each octopus has an _energy level_ - your submarine can remotely measure the energy level of each octopus (your puzzle input). For example:

    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526

The energy level of each octopus is a value between `0` and `9`. Here, the top-left octopus has an energy level of `5`, the bottom-right one has an energy level of `6`, and so on.

You can model the energy levels and flashes of light in _steps_. During a single step, the following occurs:

- First, the energy level of each octopus increases by `1`.
- Then, any octopus with an energy level greater than `9` _flashes_. This increases the energy level of all adjacent octopuses by `1`, including octopuses that are diagonally adjacent. If this causes an octopus to have an energy level greater than `9`, it _also flashes_. This process continues as long as new octopuses keep having their energy level increased beyond `9`. (An octopus can only flash _at most once per step_.)
- Finally, any octopus that flashed during this step has its energy level set to `0`, as it used all of its energy to flash.

Adjacent flashes can cause an octopus to flash on a step even if it begins that step with very little energy. Consider the middle octopus with `1` energy in this situation:

<pre><code>Before any steps:
11111
19991
19191
19991
11111

After step 1:
34543
4<u>000</u>4
5<u>000</u>5
4<u>000</u>4
34543

After step 2:
45654
51115
61116
51115
45654
</code></pre>

An octopus is <u>highlighted</u> when it flashed during the given step.

Here is how the larger example above progresses:

<pre><code>Before any steps:
5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526

After step 1:
6594254334
3856965822
6375667284
7252447257
7468496589
5278635756
3287952832
7993992245
5957959665
6394862637

After step 2:
88<u>0</u>7476555
5<u>0</u>89<u>0</u>87<u>0</u>54
85978896<u>0</u>8
84857696<u>00</u>
87<u>00</u>9<u>0</u>88<u>00</u>
66<u>000</u>88989
68<u>0000</u>5943
<u>000000</u>7456
9<u>000000</u>876
87<u>0000</u>6848

After step 3:
<u>00</u>5<u>0</u>9<u>00</u>866
85<u>00</u>8<u>00</u>575
99<u>000000</u>39
97<u>000000</u>41
9935<u>0</u>8<u>00</u>63
77123<u>00000</u>
791125<u>000</u>9
221113<u>0000</u>
<u>0</u>421125<u>000</u>
<u>00</u>21119<u>000</u>

After step 4:
2263<u>0</u>31977
<u>0</u>923<u>0</u>31697
<u>00</u>3222115<u>0</u>
<u>00</u>41111163
<u>00</u>76191174
<u>00</u>53411122
<u>00</u>4236112<u>0</u>
5532241122
1532247211
113223<u>0</u>211

After step 5:
4484144<u>000</u>
2<u>0</u>44144<u>000</u>
2253333493
1152333274
11873<u>0</u>3285
1164633233
1153472231
6643352233
2643358322
2243341322

After step 6:
5595255111
3155255222
33644446<u>0</u>5
2263444496
2298414396
2275744344
2264583342
7754463344
3754469433
3354452433

After step 7:
67<u>0</u>7366222
4377366333
4475555827
34966557<u>0</u>9
35<u>00</u>6256<u>0</u>9
35<u>0</u>9955566
3486694453
8865585555
486558<u>0</u>644
4465574644

After step 8:
7818477333
5488477444
5697666949
46<u>0</u>876683<u>0</u>
473494673<u>0</u>
474<u>00</u>97688
69<u>0000</u>7564
<u>000000</u>9666
8<u>00000</u>4755
68<u>0000</u>7755

After step 9:
9<u>0</u>6<u>0000</u>644
78<u>00000</u>976
69<u>000000</u>8<u>0</u>
584<u>00000</u>82
5858<u>0000</u>93
69624<u>00000</u>
8<u>0</u>2125<u>000</u>9
222113<u>000</u>9
9111128<u>0</u>97
7911119976

After step 10:
<u>0</u>481112976
<u>00</u>31112<u>00</u>9
<u>00</u>411125<u>0</u>4
<u>00</u>811114<u>0</u>6
<u>00</u>991113<u>0</u>6
<u>00</u>93511233
<u>0</u>44236113<u>0</u>
553225235<u>0</u>
<u>0</u>53225<u>0</u>6<u>00</u>
<u>00</u>3224<u>0000</u>
</code></pre>

After step 10, there have been a total of `204` flashes. Fast forwarding, here is the same configuration every 10 steps:

<pre><code>After step 20:
3936556452
56865568<u>0</u>6
449655569<u>0</u>
444865558<u>0</u>
445686557<u>0</u>
568<u>00</u>86577
7<u>00000</u>9896
<u>0000000</u>344
6<u>000000</u>364
46<u>0000</u>9543

After step 30:
<u>0</u>643334118
4253334611
3374333458
2225333337
2229333338
2276733333
2754574565
5544458511
9444447111
7944446119

After step 40:
6211111981
<u>0</u>421111119
<u>00</u>42111115
<u>000</u>3111115
<u>000</u>3111116
<u>00</u>65611111
<u>0</u>532351111
3322234597
2222222976
2222222762

After step 50:
9655556447
48655568<u>0</u>5
448655569<u>0</u>
445865558<u>0</u>
457486557<u>0</u>
57<u>000</u>86566
6<u>00000</u>9887
8<u>000000</u>533
68<u>00000</u>633
568<u>0000</u>538

After step 60:
25333342<u>00</u>
274333464<u>0</u>
2264333458
2225333337
2225333338
2287833333
3854573455
1854458611
1175447111
1115446111

After step 70:
8211111164
<u>0</u>421111166
<u>00</u>42111114
<u>000</u>4211115
<u>0000</u>211116
<u>00</u>65611111
<u>0</u>532351111
7322235117
5722223475
4572222754

After step 80:
1755555697
59655556<u>0</u>9
448655568<u>0</u>
445865558<u>0</u>
457<u>0</u>86557<u>0</u>
57<u>000</u>86566
7<u>00000</u>8666
<u>0000000</u>99<u>0</u>
<u>0000000</u>8<u>00</u>
<u>0000000000</u>

After step 90:
7433333522
2643333522
2264333458
2226433337
2222433338
2287833333
2854573333
4854458333
3387779333
3333333333

After step 100:
<u>0</u>397666866
<u>0</u>749766918
<u>00</u>53976933
<u>000</u>4297822
<u>000</u>4229892
<u>00</u>53222877
<u>0</u>532222966
9322228966
7922286866
6789998766
</code></pre>

After 100 steps, there have been a total of _`1656`_ flashes.

Given the starting energy levels of the dumbo octopuses in your cavern, simulate 100 steps. _How many total flashes are there after 100 steps?_

Your puzzle answer was `1755`.

## \--- Part Two ---

It seems like the individual flashes aren't bright enough to navigate. However, you might have a better option: the flashes seem to be _synchronizing_!

In the example above, the first time all octopuses flash simultaneously is step _`195`_:

<pre><code>After step 193:
5877777777
8877777777
7777777777
7777777777
7777777777
7777777777
7777777777
7777777777
7777777777
7777777777

After step 194:
6988888888
9988888888
8888888888
8888888888
8888888888
8888888888
8888888888
8888888888
8888888888
8888888888

After step 195:
<u>0000000000</u>
<u>0000000000</u>
<u>0000000000</u>
<u>0000000000</u>
<u>0000000000</u>
<u>0000000000</u>
<u>0000000000</u>
<u>0000000000</u>
<u>0000000000</u>
<u>0000000000</u>
</code></pre>

If you can calculate the exact moments when the octopuses will all flash simultaneously, you should be able to navigate through the cavern. _What is the first step during which all octopuses flash?_

Your puzzle answer was `212`.

Both parts of this puzzle are complete! They provide two gold stars: \*\*
