// 2019 IC Design Contest Preliminary(107)
module ICC(
 clk        ,   // posedge trigger      H:In/Out
 rst        ,   // a-asynchronous rst   H:
 ready      ,   // Image in,            H:Ready -> Conv sending address to testfixture
 in_idata   ,   // 4 bits MSB + 16 bits (Floating)LSB, Input pixels color signal. 
 in_cdata_rd,   // 4 bits MSB + 16 bits (Floating)LSB, Memory Read signal, testure transfer memory signal to CONV circ
 busy       ,    // H: CONV ready signal  L: Every processing done.                    H:CONV ready signal, L: Output End->testfixture
 iaddr      ,    // input pixel address, which pixel address.output [1:0]    
 crd        ,    // Memory Read signal, If (crd = high & clk = posedge){memory = read}, testfeature put caddr_rd address to cdata-rd.
 caddr_rd   ,    // Memory address Read signal, looking for the address in memory. 
 cwr        ,    // Memory Write signal, If(cwr = high & clk = posedge)
 cdata_wr   ,    // Memory Write_out signal, signed 4 bits MSB + 16 bits (float)LSB. All layers result output to testfixture.
 caddr_wr   ,    // Memory address Write_in signal, All layers result output to testfixture. 
 csel           // hotfix code:??3'b000 : No select, 
// 3'b001: Write/Read L0 and process Convolutional, 
// 3'b010: Write/Read L0, proceed Convolutional. 
// 3'b011 Write/Read Layer 1, Kernal 0 convolutional then max-pooling. 
// 3'b100: Write/Read Layer 1, Kernal 1 convolutional then max-pooling
// 3'b101: Write/Read Layer 2, Flatten the result
);
//I/O
input  [1:0]    clk       ;  // posedge trigger      H:In/Out
input  [1:0]    rst       ;  // a-asynchronous rst   H:
input  [1:0]    ready     ;  // Image in,            H:Ready -> Conv sending address to testfixture
input  [20:0]   in_idata     ;  // 4 bits MSB + 16 bits (Floating)LSB, Input pixels color signal. 
input  [20:0]   in_cdata_rd  ;  // 4 bits MSB + 16 bits (Floating)LSB, Memory Read signal, testure transfer memory signal to CONV circuit. 
output [1:0]    busy      ;  // H: CONV ready signal  L: Every processing done.                    H:CONV ready signal, L: Output End->testfixture
output [12:0]   iaddr     ;  // input pixel address, which pixel address.output [1:0]    
output [1:0]    crd       ;  // Memory Read signal, If (crd = high & clk = posedge){memory = read}, testfeature put caddr_rd address to cdata-rd.
output [12:0]   caddr_rd  ;  // Memory address Read signal, looking for the address in memory. 
output [1:0]    cwr       ;  // Memory Write signal, If(cwr = high & clk = posedge)
output [20:0]   cdata_wr  ;  // Memory Write_out signal, signed 4 bits MSB + 16 bits (float)LSB. All layers result output to testfixture.
output [12:0]   caddr_wr  ;  // Memory address Write_in signal, All layers result output to testfixture. 
output [3:0]    csel      ;  // hotfix code:??3'b000 : No select, 

//Reg declaration
reg [20:0] idata;
reg [20:0] cdata_rd;
reg [12:0] caddr_rd;
reg [12:0] caddr_wr;
reg [20:0] cdata_wr;
reg [5:0]CS,NS;
reg BUSY,READY;

// Parameter declaration
parameter IDLE      = 5'b0011;
parameter TESTFIX   = 5'b0100;
parameter CONV      = 5'b0101;
parameter RESTART   = 5'b0110;


//clock declaration
always@(posedge clk)begin
    if(rst)begin
        CS <= 0;
    end
    else begin
        CS <= NS;
    end
end


always@(*)begin
    case(CS)
        IDLE:
            if(rst)begin
                NS = TESTFIX;
            end
            else begin
                NS = IDLE;
            end
        TESTFIX:
            if(READY == 1)begin
                NS = CONV;
            end
            else if(READY == 0)begin
                NS = TESTFIX;
            end
            else begin
                NS = IDLE;
            end
        CONV:
            if(BUSY == 0)begin
                NS = RESTART;
            end
            else if(BUSY == 1)begin
                NS = TESTFIX;
            end
            else begin
                NS = CONV;
            end
        RESTART:
            if (rst) begin
                NS = IDLE;
            end
            else begin
                NS = RESTART;
            end
        default:
            NS = IDLE;
    endcase
end


//* Input data
always@(*)begin
    if(rst)begin
        
    end
    else begin
    end
end

// Register array: 32 registers each 32 bits wide
reg [31:0] reg_array [31:0];
// Write logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Initialize all registers to zero on reset
        integer i;
        for (i = 0; i < 32; i = i + 1) begin
            reg_array[i] <= 0;
        end
    end 
    else if (we) begin
        // Write data to the specified register if write enable is high
        reg_array[write_addr] <= write_data;
    end
end

    // Read logic
    assign read_data1 = reg_array[read_addr1];
    assign read_data2 = reg_array[read_addr2];
//* RF address
always@(posedge clk)begin
    if(rst)begin
        write_out <= 0;
    end
    else begin
        if (TESTFIX)begin
            write_out <= data;
        end
        else if(READY)begin
            write_out <= ;
        end
        else begin
            write_out <= write_out;
        end
    end
end





endmodule


module testfixture(
iaddr     ,          
busy      ,      
csel      ,      
crd       ,  
caddr_d   ,      
cwr       ,  
cdata_wr  ,          
ca        ,  
cdata_rd  ,          
idata     ,      
clk       ,  
rst         
);
input [12:0] iaddr   ;           
input busy           ;   
input [3:0] csel     ;           
input crd            ;   
input caddr_d        ;       
input cwr            ;   
input cdata_wr       ;       
input caddr_w        ;     

output cdata_rd      ;       
output [20:0] idata  ;           
output clk           ;   
output rst           ;               

//Gate to start the program.
always@(posedge clk)begin
    if(rst)begin
    end
    else begin
        if(TESTFIX)begin
        end
        else begin

        end
    end
end

endmodule


module CONV(
iaddr   ,    
busy    ,    
csel    ,    
crd     ,
caddr_d ,    
cwr     ,
cdata_wr,        
caddr_w ,    
cdata_rd,        
idata   ,    
clk     ,            
rst                     

);

output [12:0] iaddr;
output busy;
output [3:0] csel;
output crd;
output caddr_d;
output cwr;
output cdata_wr;
output caddr_w;

input cdata_rd;
input [20:0] idata;
input clk;
input rst;




endmodule