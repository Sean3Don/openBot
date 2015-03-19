use <teardrops.scad>
use <roundCornersCube.scad>
use <polyhole.scad>

module standoff(outer_diam, inner_diam, height, hole_depth) {
	/* Generates a standoff for mounting something e.g. a PCB */
	difference() {
		cylinder(r=outer_diam/2, h=height, $fn=50);
		translate([0,0, height - hole_depth]) polyhole(hole_depth + 1, inner_diam); 
	}
}

module cylindrical_lip(outer_diameter, height, wall_thickness) {	
	/* Generates a hollow cylindrical lip, quartered. */
	difference() {
		cylinder(r=outer_diameter/2, h = height);
		//Core it out
		translate([0,0,-0.5])  cylinder(r=(outer_diameter/2) - wall_thickness, h = height+1, $fn=50);	
		//Cut it into a quarter.
		translate([-outer_diameter/2,0,-0.5]) cube([outer_diameter + 1, outer_diameter/2,height + 1]);
		translate([0, -outer_diameter/2, -0.5]) cube([outer_diameter + 1, outer_diameter/2,height + 1]);
	}
}

module rounded_cube_case (generate_box = true, generate_lid = false, generate_standoffs = false) 
{
	//Case details (these are *outer* diameters of the case 
	sx = 160; 			    //X dimension
	sy = 98;			    //Y dimension
	sz = 30;			    //Z dimension
	r = 2;				    //The radius of the curves of the box walls.
	wall_thickness = 2.4;   //Thickness of the walls of the box (and lid)


    // PCB stand-off size, all will be calculated from the centre of the box
    st_x = 142;  // x dimensions
    st_y = 77.5;  // y dimensions
    st_z = 5;  // stand-off height, be sure to factor this when calculating the box height

    st_centres = [ 
        [(sx/2)+(st_x/2), (sy+st_y)/2, 0],
        [(sx/2)+(st_x/2), (sy+-st_y)/2, 0],
        [(sx/2)+(-st_x/2), (sy+-st_y)/2, 0],
        [(sx/2)+(-st_x/2), (sy+st_y)/2, 0]
     ];
    


	//Screw hole details
	screw_hole_dia = 2;  	//Diameter of the screws you want to use
	screw_hole_depth = 20;	//Depth of the screw hole

	screw_head_dia = 4.5;	//Diameter of the screw head (for the recess)
	screw_head_depth = 1.0;	//Depth of the recess to hold the screw head

	screw_hole_centres = [ [wall_thickness*2, wall_thickness*2,0 ], 
					[sx - ( wall_thickness*2), wall_thickness*2, 0],
					[sx - ( wall_thickness*2), sy - ( wall_thickness*2), 0], 
					[wall_thickness*2, sy - (wall_thickness*2), 0] ];

	corner_lip_dia = screw_hole_dia * 3.8;
	corner_standoff_dia = screw_hole_dia * 3;
    margin_bottom = st_z+2;

	if (generate_lid == true) 
	{
			translate([0, sy+10, 0])
			difference() 
			{
				union() {
					translate([sx/2, sy/2, wall_thickness/2]) roundCornersCube(sx,sy,wall_thickness,r); //Create the cube
					//Create the reinforcing lip.
					translate([corner_lip_dia+(wall_thickness/2),wall_thickness,wall_thickness]) cube([(sx-corner_lip_dia * 2)-wall_thickness,wall_thickness,wall_thickness]);
					translate([wall_thickness,corner_lip_dia+(wall_thickness/2),wall_thickness]) cube([wall_thickness,(sy-corner_lip_dia * 2)-wall_thickness,wall_thickness]);
					translate([sx - wall_thickness*2,corner_lip_dia+(wall_thickness/2), wall_thickness]) cube([wall_thickness,(sy-corner_lip_dia * 2)-wall_thickness,wall_thickness]);	
					translate([corner_lip_dia+(wall_thickness/2),sy - wall_thickness*2,wall_thickness]) cube([(sx-corner_lip_dia * 2)-wall_thickness,wall_thickness,wall_thickness]);
					

					//Fit the reinforcing lip around the corner standoffs
						translate([0,0,wall_thickness]) translate(screw_hole_centres[0]) rotate(180)  
							cylindrical_lip(corner_lip_dia + (wall_thickness*2), 
								wall_thickness,wall_thickness);
						translate([0,0,wall_thickness]) translate(screw_hole_centres[1]) rotate(270)  
								cylindrical_lip(corner_lip_dia + (wall_thickness*2),
								wall_thickness,wall_thickness);
						translate([0,0,wall_thickness]) translate(screw_hole_centres[2]) 
								cylindrical_lip(corner_lip_dia + (wall_thickness*2),	
								wall_thickness, wall_thickness);
						translate([0,0,wall_thickness]) translate(screw_hole_centres[3]) rotate(90)  
								cylindrical_lip(corner_lip_dia + (wall_thickness*2),
								wall_thickness, wall_thickness);
				}
                
				for (i = screw_hole_centres) 
				{
					/*	Drill two holes in the lid - the screw-hole, and the countersink 
						The screw-hole is made 25% larger here, as the idea is for the screw
						to pass through the lid without biting into it */
		
	 				translate([0,0,-0.5]) translate(i) polyhole(wall_thickness + 1, screw_hole_dia * 1.25);  //The screw hole.
					translate([0, 0, -1]) translate(i) polyhole(screw_head_depth + 1, screw_head_dia); //The countersink
				}
                
                
                // Limit switches
                translate([30, 51, -1]){
                  #cube([22, 12, 4]);
                }
                // Aux Access
                translate([18, 6, -1]){
                  #cube([75, 12, 4]);
                }
                
                
                
			}
	}

	if (generate_box == true)  
	{
		//The 'box' part of the case.
		union() 
		{
			difference() 
			{
				translate([sx/2, sy/2,sz/2 ]) roundCornersCube(sx,sy,sz, r);
				//cut off the 'lid' of the box
				translate([-0.1,-0.1, sz - wall_thickness]) cube([sx+1,sy+1,wall_thickness + 1]);
				//hollow it out
				translate([sx/2, sy/2, sz/2 + wall_thickness]) roundCornersCube(sx - (wall_thickness*2) , sy - (wall_thickness*2) , sz, r);
                
                
                
                
                // Stepper Cable Access
                translate([13, -1, margin_bottom]){
                  #cube([115, 4, 8]);
                }
                // Power In Cable Access
                translate([sx-wall_thickness-1, 15, margin_bottom]){
                  #cube([4, 14, 8]);
                }
                // Power Out Cable Access
                translate([sx-wall_thickness-1, sy/2.5, margin_bottom]){
                  #cube([4, 43, 8]);
                }
                
                // Reset Button
                translate([sx-8.5-35, sy+wall_thickness-1, margin_bottom+3]){
                    rotate([90, 0, 0])
                        #cylinder(r=3, h=5);
                }
                // USB out cable
                translate([sx-8.5-35-26, sy-3, st_z]){
                  #cube([15, 4, 14]);
                }
                
                // LCD Cable Access
                translate([-1, 10.5+25, st_z+8]){
                  #cube([4, 43, 10]);
                }
                
                // Lower vent
                for (i = [0 : 15]) {
                    translate([40+i*5, (sy-45)/2, -1]){
                        #cube([2, 45, 4]);
                    }
                }
                
			}
			
			//Put in the pillars for the screws to go into.
			for (i = screw_hole_centres)  
			{
				translate([0,0,wall_thickness]) translate(i) 
					standoff(corner_standoff_dia, screw_hole_dia, sz - (wall_thickness * 2), 
						screw_hole_depth);
			}

            if (generate_standoffs == true) {
			  
			  //Put in the pillars for the screws to go into.
			    for (i = st_centres) {
				  translate(i) 
					  standoff(corner_standoff_dia, screw_hole_dia, st_z, st_z/2);
			    }
            }
            
		}
	}

}
//$fa = 50;

// Render Bottom
//rounded_cube_case(true, false, true);
// Render Top
rounded_cube_case(false, true, true);

