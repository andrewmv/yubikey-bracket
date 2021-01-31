// 2021/01 Andrew Villeneuve
// andrewmv@gmail.com
// 
// Model for printing around a YubiKey Nano 5C to make the device
// easier to insert/remove from devices without needing tools, 
// and ideally somewhat harder to lose.

// All units in mm

// *** Fixed Mechanical dimentions ***
// Names are hard. I'll attach a scan or something later.
A = 12;
B = 3.25;
C = 7;
D = 8.7;
E = 2.4;
F = 6.4;
G = 1.0;

// *** Configurable dimentions ***
H = 2;
I = 1;
K = 3;
J = 1;

// Adjust for thermal expansion and printer precision
tolerance = 0.25;

// *** Gemoetry computations ***

// Convienence constants
x_size = H + B + G;
y_size = (2*I) + A + (2*K); 
z_size = F;
y_size_bot = (2 * J) + (2 * I) + A;

// Extruded polyhedron geometry
points = [
	[0, 0],
	[0, (2*I) + A + (2*K)],
	[H + B + G, K + (2*I) + A + J],
	[H + B + G, K - J]
];
paths = [[0, 1, 2, 3]];

// geometry of interior compartment
cut1_corner = [H - tolerance,
			   K + I - tolerance, 
			   -tolerance];
cut1_size = [B + 2 * tolerance, 
			 A + 2 * tolerance,
			 F + 2 * tolerance];

// geometry of USB-C slot
cut2_corner = [F/2,
			   y_size / 2,
			   0];
cut2_size = [G + C + ( 2 * tolerance ),
			 D + ( 2 * tolerance ),
			 E + ( 2 * tolerance )];

// *** Support modules ***

// Cross-section of USB-C slot
module c_slot_cs(size) {
	s=size;
	r=s[2] / 2;
	hull() {
		translate([0, -s[1]/2 + r, 0])	circle(r, $fn=20);
		translate([0, s[1]/2 - r, 0])	circle(r, $fn=20);
	}
}

// Conically extruded USB-C slot
// The scaling factor helps ensure stringing in support
// structure won't obstruct part insertion
module c_slot(size) {
	s=size;
	c=[0, s[2] / 2, 0];
	sc=1.5;

	rotate([0, 180, 0]) {
		linear_extrude(s[0], scale=sc) {
			c_slot_cs(s);
		}
	}
	linear_extrude(G) {
		c_slot_cs(s);
	}
} 

// extrude polygon into the functional section of
// the model
module mod1() {
	// How much wider than the model should the support structure be?
	support_base_setback = 3;
	// How tall should the support strcuture be?
	support_base_thickness = C + 1;
	linear_extrude(F) {
		polygon(points, paths, convexity = 1);
	}
	translate([x_size,
			   K - I - support_base_setback / 2,
			   -support_base_setback / 2])
	cube(size=[support_base_thickness,
			   y_size_bot + support_base_setback,
			   z_size + support_base_setback]);
}

// *** Draw shapes ***

difference() {
	translate([0, 0, H + B + G ])
	rotate([0, 90, 0]) {
		difference() {
			// Main structure of model
			mod1();
			// Hollow out section for the YubiKey to insert
			translate(cut1_corner) {
				cube(size=cut1_size);
			}
		}
	}
	translate(cut2_corner) {
		// HOllow out the USB-C slot
		c_slot(size=cut2_size);
	}
}
