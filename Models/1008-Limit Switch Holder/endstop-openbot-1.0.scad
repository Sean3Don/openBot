
// Variables

screwSpace = 19;



// Constants 
$fn = 50;

//translate([40.7, 0, 17.6]) import("endstop-official.stl", convexity=60);


// Functions/Modules
module mount() {
    difference() {
        cylinder(h=12, r1=4.5, r2=3); 
        translate([0, 0, -1]) {
            cylinder(h=14, r=1.5);
        }        
    }
}
module mainSection() {
    // Bott Cylinder
    difference() {
        union() {
            cylinder(h=8, r=4.5);
            // Center Cylinder
            translate([0, 6, 11]) {
                rotate([90, 0, 0]) {
                    cylinder(h=12, r=6.5);
                }
            }
        }
        translate([0, 0, -1]) cylinder(h=10, r=1.5);
    }
    // Centre plane
    translate([-16, -6, 9]) {
        cube([32, 12, 3]);
    }
}


// Main Code
rotate([90, 0, 0]) {
    difference() {
        mainSection();
        translate([0, 16, 11]) rotate([90, 0, 0]) cylinder(h=34, r=4.2);
    }
    translate([screwSpace/2, 0, 12]) { 
        mount();
    }
    translate([-(screwSpace/2), 0, 12]) { 
        mount();
    }
}