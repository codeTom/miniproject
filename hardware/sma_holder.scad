use <threadlib/threadlib.scad>
//Ext. 	1/4-36 UNS 	2A 	0.0009 	0.2491 	0.2436 	- 	0.2311 	0.2280 	0.2161
MY_THREAD_TABLE = [
    ["special-ext",
    [0.706, 2.7126, 5.4320, [
        [0, -0.2977], [0, 0.2977], [0.4296, 0.0496], [0.4296, -0.0496]
   ]]]];

module sma_holder(extra_height = 3.5, base_r = 6)
{
    difference()
    {
        union()
        {
            translate([0,0,0.706/2+extra_height]) bolt("special", turns=5,  table=MY_THREAD_TABLE);
            cylinder(r=base_r, h=0.5+extra_height, $fn=100);
        }
        translate([0,0,-1])cylinder(r=2.2, h=10, $fn=100);
    }
}