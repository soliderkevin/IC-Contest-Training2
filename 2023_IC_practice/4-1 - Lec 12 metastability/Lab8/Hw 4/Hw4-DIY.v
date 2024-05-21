//input outpput
module Hw4-DIY(
    in_image,
    out_image,
    rst,
    clk

);

    input [8:0] in_image;
    output[8:0] out_image;

always@(posedge clk)
begin
    CS<=NS;
end
//Control
always@(*)
begin
    case(CS)
        IDLE:
            NS = (in_valid)?IN1:IDLE;

        IN1:
            NS =  (counter[2:0] == 'd7)?IN2:IN1;
        IN2:
            NS = (counter == 'd1023)?OUT:IN2;
        OUT:
            NS = (counter[2:0] == 'd7)?IDLE:OUT;
    endcase
end
//Counter
always@(*)begin
    case(CS)
        IDLE:
        begin
           if(in_valid)counter_next ='d0;
           else counter_next = 'dx;
        end
        IN1:
        begin
           if(counter == 'd1023)counter_next ='d0;
           else counter_next = counter +'d1;
        end
        IN2:
        begin
            if(counter == 'd1023)counter_next ='d0;
            else counter_next = counter +'d1;
        end
        OUT:
        begin
            if(counter == 'd7)counter_next ='d0;
            else counter_next = counter +'d1;
        end
    endcase
end

//Controller controlling first input and last input
always@(*)
begin
    pixel_in[7] = pixel[6];
    pixel_in[6] = pixel[5];
    pixel_in[5] = pixel[4];
    pixel_in[4] = pixel[3];
    pixel_in[3] = pixel[2];
    pixel_in[2] = pixel[1];
    pixel_in[1] = pixel[0];
    case(ctrl_next)
        IN1:
        begin
            pixel_in[0] = in_image;
        end
        IN2:begin
            pixel_in[0]= pixel[7];
        end
        IDLE,OUT:pixel_in[0] = 'dx;
    endcase
end


always@(*)begin
    check_add = (8(ctrl_next == IN2)&(in_image<-pixel[7]),in_image-pixel[6],in_image-pixel[5],in_image-pixel[4],in_image-pixel[3],in_image-pixel[2],in_image-pixel[1],in_image-pixel[0]);
    histogram_in[7] = histogram[6] +check_add[6];
    histogram_in[6] = histogram[5] +check_add[5];
    histogram_in[5] = histogram[4] +check_add[4];
    histogram_in[4] = histogram[3] +check_add[3];
    histogram_in[3] = histogram[2] +check_add[2];
    histogram_in[2] = histogram[1] +check_add[1];
    histogram_in[1] = histogram[0] +check_add[0];
    histogram_in[0] = ((histogram[7] +check_add[7])&(11{ctrl_next == IN2}));
end
endmodule

module out_CL(histogram,out_reg_in)
input[10:0]histogram;
output logic[7:] out_reg_in;
reg[4:0] tmp;
reg[7:0] sub_result;
always@(*)begin
    case(histogram[9:0])
    endcase
end
assign sub_result = histogram[9:2] - tmp;
assign out_reg_in = (histogram[10])?'d233:subresult;

endmodule
