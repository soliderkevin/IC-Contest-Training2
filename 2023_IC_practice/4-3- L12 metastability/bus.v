// Don't code like this in hw
module busint(cr_valid, cr_ready, cr_addr, cr_data, ct_valid, ct_data, br_addr, br_data, br_valid, arb_req, arb_grant, my_addr);

parameter aw = 2;
parameter dw = 4;
input cr_valid, arb_grant, bt_valid; //address width
output cr_ready, ct_valid, arb_req, br_valid; // data width.
input [aw-1:0] cr_Addr, bt_addr, my_addr;
output [aw-1:0] br_addr;
input[dw-1:0] cr_data, bt_data;
output[dw-1:0] br_data, ct_data;
//arbitration
wire arb_req = cr_valid;
wire cr_ready = arb_grant;

//bus drive
// assumes bus ORs these signals with those from other interfaces.
wire br_valid = arb_grant; //client get grant to send data.
wire[aw-1:0] br_addr = arb_grant ? cr_addr:0; //addresss
wire[dw-1:0] br_data = arb_grant? cr_data:0;  //data
//buss receive
wire ct_valid = bt_valid &(bt_addr == my_addr); //if bus address == my address
wire [dw-1:0] ct_data = bt_data;
endmodule