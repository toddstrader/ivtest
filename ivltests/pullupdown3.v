/*
 * Copyright (c) 2000 Guy Hutchison (ghutchis@pacbell.net)
 *
 *    This source code is free software; you can redistribute it
 *    and/or modify it in source code form under the terms of the GNU
 *    General Public License as published by the Free Software
 *    Foundation; either version 2 of the License, or (at your option)
 *    any later version.
 *
 *    This program is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *    GNU General Public License for more details.
 *
 *    You should have received a copy of the GNU General Public License
 *    along with this program; if not, write to the Free Software
 *    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA
 */

module pullupdown;

  // declare several bussed wires
  wire pull_up_1, pull_down_1;
  wire [7:0] pull_up_8, pull_down_8;
  reg 	     error;
  
   // assign pullups to each wire
   pullup (pull_up_1);
   pulldown (pull_down_1);
   pullup u8 [7:0] (pull_up_8);
   pulldown d8 [7:0] (pull_down_8);

  // create tristate drivers for each wire
  reg 	     driver_1;
  reg [7:0]  driver_8;

  assign     pull_up_1 = driver_1;
  assign     pull_down_1 = driver_1;
  
  assign     pull_up_8 = driver_8;
  assign     pull_down_8 = driver_8;

  initial
    begin : test_block
      integer i;
      
      // turn off all drivers
      driver_1 = 1'bz;
      driver_8 = 8'bz;
      error = 0;
      #1;

      // check default values
      if ((pull_up_1 !== 1'b1) || (pull_down_1 !== 1'b0) ||
	  (pull_up_8 !== 8'hFF) || (pull_down_8 !== 8'h00)) begin
	 $display("driver_8=%b, pull_up_8=%b, pull_down_8=%b",
		  driver_8, pull_up_8, pull_down_8);
	 $display("driver_1=%b, pull_up_1=%b, pull_down_1=%b",
		  driver_1, pull_up_1, pull_down_1);
	 error = 1;
      end


      for (i=0; i<256; i=i+1)
	begin
	  driver_1 = ~driver_1;
	  driver_8 = i;
	  $display ("Testing drivers with value %x", driver_8);
	  #1;
	  
	  check_drivers;
	  #10;
	end

      if (error)
	$display ("FAILED - pullupdown ");
      else $display ("PASSED");
    end // block: test_block

  task check_drivers;
    begin
      if ((pull_up_1 !== driver_1) || (pull_down_1 !== driver_1) ||
	  (pull_up_8 !== driver_8) || (pull_down_8 !== driver_8)) begin
	 $display("driver_8=%b, pull_up_8=%b, pull_down_8=%b",
		  driver_8, pull_up_8, pull_down_8);
	 $display("driver_1=%b, pull_up_1=%b, pull_down_1=%b",
		  driver_1, pull_up_1, pull_down_1);

	 error = 1;
      end

    end
  endtask // check_drivers
  
endmodule // pullupdown

