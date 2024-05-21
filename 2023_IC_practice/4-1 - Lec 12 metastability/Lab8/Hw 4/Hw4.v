module reference_hw();

//Design into 3 states, IDLE INPUT OUTDATA

    always@(*)
    begin
        case(current_state)
            IDLE:
            begin
                if(in_valid)
                    next_state =INPUT;
                else
                    next_state = IDLE;
            end
            INPUT: 
            begin
                if(input_count == 1032)
                    next_state = OUTDATA;
                else
                    next_state = INPUT;
            end
            OUTDATA:
            begin
                if(out_count == 8)
                    next_state = IDLE;
                else
                    next_state = OUTDATA;
            end
            default:
            begin
                next_state = current_state;
            end
        endcase
    end


    //8 registers
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            tran_data_1 <= 0;
            tran_data_2 <= 0;
            tran_data_3 <= 0;
            tran_data_4 <= 0;
            tran_data_5 <= 0;
            tran_data_6 <= 0;
            tran_data_7 <= 0;
            tran_data_8 <= 0;
        end
        else if(in_valid)begin
            case(input_count)
                0:trans_data_1 <= in_image;
                1:trans_data_2 <= in_image;
                2:trans_data_3 <= in_image;
                3:trans_data_4 <= in_image;
                4:trans_data_5 <= in_image;
                5:trans_data_6 <= in_image;
                6:trans_data_7 <= in_image;
                7:trans_data_8 <= in_image;
            endcase
        end
    end

    //用一層register切開的方式:
    assign out_temp2 = out_temp*937;
    assign out = (out_tmp2_reg/4093) - 1;

    always@(posedge clk or negedge rst_n)
    begin
        if(rst_n)begin
            oout_temp2_reg <= 0;
        end
        else 
        begin
            out_temp2_reg <= out_temp2;
        end
    end

    //Calculate cdf
    always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)begin
            count_1<=0;
        end
        else if(in_valid)begin
            if(input_count > 7 || in_image <= trans_data_1)
                count_1 <= count_1+1;
        end
        else if(current_state = IDLE)begin
            count_1<=0;
        end
    end

    always@(posdge clk or negedge rst_n)
    begin
        if(!rst_n)begin
            count_2 <=0;
        end
        else if(in_valid)begin
            if(input_count >7 || in_image <= tran_data_2)
            count_2 <= count_2+1;
        end
        else if(current_state == IDLE)
        begin
            count_2 <= 0;
        end
    end


    always(posedge clk or negedge rst_n)begin
        if(!rst_n)
            out_image<=0;
                else if(current_state == IDLE)
            out_image <= 0;
            else if(current_state == OUTDATA && out = 2047)
                out_image <=0;
            else if(current_state == OUTDATA)
                out_image <= out;
    end

    always@(*)
    begin
        case(out_count)
        0:out_temp= count_1;
        1:out_temp= count_2;
        2:out_temp= count_3;
        3:out_temp= count_4;
        4:out_temp= count_5;
        5:out_temp= count_6;
        6:out_temp= count_7;
        7:out_temp= count_8;
        default: out_temp = 0;
        endcase
    end
endmodule