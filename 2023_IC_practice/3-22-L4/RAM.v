module ram_sp_sr_sw #(parameter DATA_width =8,parameter ADDR_width =8,parameter RAM_DEPTH = (1<<ADDR_WIDTH)){
    input wire clk,
    input wire [ADDR_WIDTH-1:0] address,
    input wire [DATA_WIDTH-1:0] data,
    input wire cs,
    input wire we,
    input wire oe
}

reg[DATA_WIDTH-1:0] data_out;
//Use associative array to save money footprint
typedef reg[ADDR_WIDTH=1:0] mem_addr;
reg [DATA_WIDTH-1:0] [mem_addr];

//Tri-state buffer control:
assign data = (cs&& oe && !we)? data_out: 8'bz;

//Memory Write block
//Write Operation: When we = 1, cs = 1
always@(posedge clk)
begin:MEM_WRITE
    if(cs&&we )begin
        mem[address] = data;
    end
end
//Memory Read Block
//Read Operation: when we = 0, oe =1, cs = 1
always @(posedge clk)
    begin: MEM_READ
        if(cs && !we && oe) begin
            data)out = mem[address];
        end
    end

endmodule