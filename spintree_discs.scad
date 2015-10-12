//Number of spinners
spinners=1;			// [3:1:20]

// Rotation preview
rotatePreview=40;		//[8,-45]

/* Hidden */
startDist=45;			//initial distance for spinner. Minimum of (ballWidth+connectorWidth)/2
distStep=0;				//increment in distance for each spinner
ballWidth=14;			//width of balls on each spinner
ballHeight=3;			//height of balls on each spinner
barHeight=3;			
barWidth=4;
connectorWidth=17;		//width of connector in middle of spinner
indent=2.5;				//depth of indentation in connector
extrude=1.5;				//depth of extrusion from connector
margin=1;				//extra height between balls
dowel=7.1;				//dowel diameter

module spinner(dist){
	//central holder for dowel
	difference(){
		//main section
		union(){
			//cylinder
			translate([0,0,0]) cylinder(h=ballHeight+margin, r=connectorWidth/2, $fn=50);
			//bar
			translate([-dist,-barWidth/2,margin+ballHeight-barHeight]) cube(size=[dist*2,barWidth,barHeight]);
			//balls on ends
			translate([dist,0,margin]) cylinder(h=ballHeight, r=ballWidth/2, $fn=50);
			translate([-dist,0,margin]) cylinder(h=ballHeight,r=ballWidth/2, $fn=50);
			//male connector
			translate([0,0,-extrude]) 
			intersection(){
				cylinder(h=ballHeight+margin, r=connectorWidth/2-2, $fn=50);
				translate([13,0,0]) cube(size=[20,6,10], center=true);
			}
		}
		//indented space on top
		//first group allows for 8 degree twist one way
		translate([0,0,ballHeight+margin-indent]) 
		intersection(){
			cylinder(h=ballHeight+1, r=connectorWidth/2-1, $fn=50);
			rotate([0,0,-8]) cube(size=[20,8,10], center=true);
		}
		//second group allows 40 degree twist other way
		translate([0,0,ballHeight+margin-indent]) 
		intersection(){
			cylinder(h=ballHeight+1, r=connectorWidth/2-1, $fn=50);
			rotate([0,0,40]) cube(size=[20,8,10], center=true);
		}
		//cylinder to cut out middle for dowel
		translate([0,0,-25]) cylinder(h=50, r=dowel/2, $fn=50);
	}
}

//top cap
 difference(){
	union(){	
		//main section
		translate([0,0,(ballHeight+margin+extrude+3)]) cylinder(h=ballHeight+margin, r=connectorWidth/2, $fn=50);
		//male connector
		translate([0,0,(ballHeight+margin+extrude+3)-extrude]) 
		intersection(){
			cylinder(h=ballHeight, r=connectorWidth/2-2, $fn=50);
			cube(size=[20,8,ballHeight], center=true);
		}
	}
	translate([0,0,-100]) cylinder(h=200, r=dowel/2,  $fn=50);
}

//spinners
for (i = [0:spinners-1]) {
	translate([0,0,-i*(ballHeight+margin+extrude+3)])rotate([0,0,rotatePreview*i]) spinner(i*distStep+startDist);
}

//bottom cap
rotate ([0,0,0]) translate([0,0,-(ballHeight+margin+extrude+3)*spinners-3])
	difference(){
		//main section
		translate([0,0,-(ballHeight/2+1)/2]) cylinder(h=ballHeight+margin, r=connectorWidth/2,  $fn=50);
		//indented space on top
		//first group allows for 8 degree twist one way
		translate([0,0,ballHeight/2-indent+margin/2]) 
		intersection(){
			cylinder(h=ballHeight+1, r=connectorWidth/2-1,  $fn=50);
			rotate([0,0,-8]) cube(size=[20,8,10], center=true);
		}
		//second group allows 45 degree twist other way
		translate([0,0,ballHeight/2-indent+margin/2]) 
		intersection(){
			cylinder(h=ballHeight+1, r=connectorWidth/2-1,  $fn=50);
			rotate([0,0,40]) cube(size=[20,8,10], center=true);
		}
		//dowel cutout
		translate([0,0,-180]) cylinder(h=200, r=dowel/2,  $fn=50);
	}
	
	