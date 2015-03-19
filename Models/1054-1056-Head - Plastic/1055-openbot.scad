
// Constants 
$fn = 100;

// Variables

// Functions/Modules


module bearing() {
    difference() {
        cylinder(h=10, r=5);
        translate([0, 0, -1]) cylinder(h=12, r=(2.8/2));
        //translate([0, 0, -1]) cylinder(h=12, r=(4/2));
    }
}




// Main Code
difference() {
    scale([25.5, 25.5, 25.5]) {
        import("1055-official.stl", convexity=10);
    }

    translate([-16.23, -7.28, 2.4]) bearing();
}