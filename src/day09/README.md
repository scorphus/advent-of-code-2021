## \--- [Day 9](https://adventofcode.com/2021/day/9): Smoke Basin ---

These caves seem to be [lava tubes](https://en.wikipedia.org/wiki/Lava_tube). Parts are even still volcanically active; small hydrothermal vents release smoke into the caves that slowly settles like rain.

If you can model how the smoke flows through the caves, you might be able to avoid it and be that much safer. The submarine generates a heightmap of the floor of the nearby caves for you (your puzzle input).

Smoke flows to the lowest point of the area it's in. For example, consider the following heightmap:

<pre><code>2<u>1</u>9994321<u>0</u>
3987894921
98<u>5</u>6789892
8767896789
989996<u>5</u>678
</code></pre>

Each number corresponds to the height of a particular location, where `9` is the highest and `0` is the lowest a location can be.

Your first goal is to find the _low points_ - the locations that are lower than any of its adjacent locations. Most locations have four adjacent locations (up, down, left, and right); locations on the edge or corner of the map have three or two adjacent locations, respectively. (Diagonal locations do not count as adjacent.)

In the above example, there are _four_ low points, all highlighted: two are in the first row (a `1` and a `0`), one is in the third row (a `5`), and one is in the bottom row (also a `5`). All other locations on the heightmap have some lower adjacent location, and so are not low points.

The _risk level_ of a low point is _1 plus its height_. In the above example, the risk levels of the low points are `2`, `1`, `6`, and `6`. The sum of the risk levels of all low points in the heightmap is therefore _`15`_.

Find all of the low points on your heightmap. _What is the sum of the risk levels of all low points on your heightmap?_

Your puzzle answer was `537`.

## \--- Part Two ---

Next, you need to find the largest basins so you know what areas are most important to avoid.

A _basin_ is all locations that eventually flow downward to a single low point. Therefore, every low point has a basin, although some basins are very small. Locations of height `9` do not count as being in any basin, and all other locations will always be part of exactly one basin.

The _size_ of a basin is the number of locations within the basin, including the low point. The example above has four basins.

The top-left basin, size `3`:

<p></p>
<pre><code><u>21</u>99943210
<u>3</u>987894921
9856789892
8767896789
9899965678
</code></pre>

The top-right basin, size `9`:

<pre><code>21999<u>43210</u>
398789<u>4</u>9<u>21</u>
985678989<u>2</u>
8767896789
9899965678
</code></pre>

The middle basin, size `14`:

<pre><code>2199943210
39<u>878</u>94921
9<u>85678</u>9892
<u>87678</u>96789
9<u>8</u>99965678
</code></pre>

The bottom-right basin, size `9`:

<pre><code>2199943210
3987894921
9856789<u>8</u>92
876789<u>678</u>9
98999<u>65678</u>
</code></pre>

Find the three largest basins and multiply their sizes together. In the above example, this is _`9 * 14 * 9 = 1134`_.

_What do you get if you multiply together the sizes of the three largest basins?_

Your puzzle answer was `1142757`.

Both parts of this puzzle are complete! They provide two gold stars: \*\*
