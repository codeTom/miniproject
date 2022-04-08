include <sma_holder.scad>

base_r = 37.4/2.0;


module sma_conn(h, r, g)
{
    if (!g)
    {
        sma_holder(h, r);
    }
    else
    {
            hull() sma_holder(h,r);
    }
}

module sma_grid(use_hull = false)
{
    shifts = [-7.5,-15, 7.5, 15];
    sma_conn(4, 4, use_hull);
    for(shift = shifts)
    {
        translate([shift, 0, 0])sma_conn(4, 3.5, use_hull);
        translate([0, shift, 0])sma_conn(4, 3.5, use_hull);
    }
}

module base_plate_holes()
{
    intersection()
    {
        cylinder(h=3.5, r=base_r, $fn=150);
        sma_grid(true);
    }
}

module base_plate()
{
        difference()
{
    translate([0,0,0.001])cylinder(h=3.3, r=base_r, $fn=150);
    base_plate_holes();
}
}

module lip()
{
    difference()
    {
        translate([0,0,1])cylinder(r=base_r+1.5, h=2, $fn=150);
        hull() base_plate();
    }
}

sma_grid();
base_plate();
lip();