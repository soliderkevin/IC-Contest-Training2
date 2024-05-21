//when rom size is big(use assign method), (model:不能合成)
module rom_using_file_model (
    input wire [7:0] address, //Address input.
    input wire [7:0] data,    //Data output.
    input wire ce,            //Read Enable.
    input wire read_en        //Chip Enable.
);
reg [7:0] mem [0:255]; //256*8 bits

    assign data = (ce && read_en)? mem[address]: 8'b0;
    initial 
    begin
        $readmemb("memory.list",mem); //memory list is memory file. When simulation use this.
    end
endmodule

//when rom size is small( use case method)
module rom_using_file_model (
    input wire [7:0] address, //Address input.
    input wire [7:0] data,    //Data output.
    input wire ce,            //Read Enable.
    input wire read_en        //Chip Enable.
);
always@(*)  // always_comb
    begin
        case
            0: data = 10;
            1: data = 55;
            2: data = 244;
            3: data = 0;
            4: data = 1;
            5: data = 10;
            6: data = 10;
            7: data = 10;
            8: data = 10;
            9: data = 10;
            10: data = 10;
            11: data = 10;
            12: data = 10;
            13: data = 8'h90;
            14: data = 8'h70;
            15: data = 8'h90;
        endcase
    end
endmodule


