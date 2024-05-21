module Traffic_Light_Controller(
    input[4:0] TL, 
    input clk,      
    output reg[7:0] LC_state, //00:Nothing, 01: Red, 10:Yellow, 11:Green 
    output reg[1:0] counter_sel
);

// Yellow only appear in Green->Yellow->Red
//Parameter declare
parameter IDLE = 9'b0000001;
parameter NS = 9'b0000010;
parameter S_M_S = 9'b0000100;
parameter SM_IT = 9'b0001000;
parameter S_M_It  = 9'b0010000;
parameter S_It_M = 9'b0100000;
parameter S_It_It = 9'b1000000;
parameter Default = 9'b10000000;
parameter READY = 9'b100000000;

reg [1:0] state;
reg[2:0] state_TL;
always @(posedge clk)begin
    state <= IDLE;
    state <= NS;
end

always @(*) //Traffic Controller Countdown
    begin
        case(state)
            IDLE: 
                //No light
                LC_state <= 2'b00;
            READY: //The stage of counter is ready for next one.
                counter_sel <= 0;
            S_M_S: 
                begin//M
                    LC_state <= 2'b01;
                    state <= 1;
                    counter_sel <= 1; 
                end
            S_M_It: //Yellow
                LC_state <= 4'b0010;   
            S_It_M: //Green Light 
                LC_state <= 4'b0011;
            S_It_It:
                LC_state <= 4'b0011;
            Default: //OoO, Light goes Red.
                LC_state <=  2'b00;                           

        endcase
    end

always @(*) // Picking Next state
    begin
        if(state_TL == 0)
            begin
                state = IDLE;
            end
        else
            begin
                state = NS;
            end
    end
endmodule

module counter_reg(
    input clk,
    input rst,
    input [8:0] NtO_Mux,
    output reg [8:0] count
);
    always@(posedge clk or posedge rst)
        begin
            if(rst == 0) 
                count <= 5'b00000;
            else 
                count = NtO_Mux+1;
        end
endmodule

module T_t_O_multiplexor( 
    input [8:0]program,
    input [8:0]controller,  // 
    input [1:0]counter_sel, //selection : Down pass = 0, Up pass = 1;
    output [8:0] out
);
    wire t0,t1;
    assign t0 = ~(counter_sel[1]&program[0]);
    assign t1 = ~(counter_sel[1]&controller[0]);
    assign out = ~((t0 & counter_sel[0])|(~t1 & counter_sel[0]));
endmodule

module program(
    input[3:0] car_m_s,
    input[3:0] car_m_it,
    input[3:0] car_it_s,
    input[3:0] car_it_it,
    input clk,
    output reg[15:0] program
);
    always@(posedge clk) 
    begin
        if(car_m_s & car_m_it)
            program[15:12] <= car_m_s;

        else if(car_m_s)
            program[11:8] <= car_m_it;


        else if(car_m_it)
            program[7:4] <= car_it_s;
        else if(car_it_s)
            program[3:0] <= car_it_it;
        else
            program[15:0] <= 0;
    end



endmodule

module Decoder(
    input[7:0] LC_state, //00:Nothing, 01: Red, 10:Yellow, 11:Green 
    output reg[2:0] light_main,
    output reg[2:0] light_side,
    input clk
);

always@(posedge clk)
        begin
            case(LC_state[7:4])
                4'b00: light_main <= 2'b00;
                4'b01: light_main <= 2'b01;
                4'b10: light_main <= 2'b10;
                4'b11: light_main <= 2'b11;
            endcase
            case(LC_state[3:0])
                4'b00: light_side = 2'b00;
                4'b01: light_side = 2'b01;
                4'b10: light_side = 2'b10;
                4'b11: light_side = 2'b11;
            endcase
        end
endmodule