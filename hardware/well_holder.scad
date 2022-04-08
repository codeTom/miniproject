separation = 15;
holder_height = 6.5;
screw_length = 12;
extra_screw = 4; //screw extends beyond plastic

module wells()
{
    linear_extrude(height=separation, convexity=50) import("wells.svg", center=true);
    //I'm dumb and put capacitors outside the wells, so need a ~5mmx5mmx1.5mm 
    //x=12,y=17.71
    for(j=[0,1])
    {
        for(i=[-1,0,1])
        {
            translate([13.3+i*40-1,38.3-j*40,1])
                cube([7,7,2], center=true);
        }
    }
    translate([13-40+3-1,38.6-2,1])
        cube([7,7,2], center=true);
    
}

module screws()
{
    linear_extrude(height=separation, convexity=10) import("screws.svg", center=true);
}

module holder()
{
    difference()
    {
        scale([1.05,1.05,1]) translate([0,0,0])
        {
            hull() linear_extrude(height=holder_height, convexity=10) import("outline.svg", center=true);
        }
        scale([1.003,1.008,1])
        hull() linear_extrude(height=holder_height, convexity=10) import("outline.svg", center=true);
    }
}

module attachment()
{
    difference()
    {
        scale([1.05,1.05,1]) translate([0,0,0])
        {
            hull() linear_extrude(height=separation, convexity=10) import("outline.svg", center=true);
        }
        wells();
        translate([0.5,0.3,0])//this should not be needed
        {
            screws();
            translate([0, 0, screw_length-extra_screw])
                linear_extrude(height=20, convexity=10)
                    import("screws_inset.svg", center=true);
        }
    }
}

module cover()
{
    difference()
    {
        scale([1.04,1.05,4.5]) hull() holder();
        scale([1.01,1.01,4.35]) hull() holder();

    }
}

module plate_holder()
{
    attachment();
    translate([0,0,separation])
         holder();
}

cover();
//plate_holder();

