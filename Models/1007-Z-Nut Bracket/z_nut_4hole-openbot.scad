
// Constants 
$fn = 100;

// Variables



// Functions/Modules


module nut() {
    translate ([0, 0, 0])
        cylinder(h=15, r=5);
    
        translate([0, 0, 2])
            cylinder(h=6, r=12);
            
            
        translate([-8, 0, 2])
            cylinder(h=13, r=1.6);
        translate([8, 0, 2])
            cylinder(h=13, r=1.6);
        rotate([0, 0, 90]) {
            translate([-8, 0, 2])
                cylinder(h=13, r=1.6);
            translate([8, 0, 2])
                cylinder(h=13, r=1.6);
        }
    
}




// Main Code

difference() { 
    rotate([180, 0, 0]) {
        translate([-31.95, 26.2, -24.05]) {
            import("1007_single_z_nut_bracket-open_fixed.stl", convexity=60);
        } 
    }
    translate([-12,-10, 0]) {
        cube([24, 20, 30]);
    }
    
}

translate([-12,-5, 0]) {

    difference () {
        cube([24, 9.5, 25]);

        translate([12, -4, 10.2]) 
            rotate([-90, 0, 0])
            nut();       
            
        
    }
}
