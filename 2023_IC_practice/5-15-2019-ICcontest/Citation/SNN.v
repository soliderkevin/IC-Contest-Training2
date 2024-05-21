//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   ICLAB 2023 Fall
//   Lab04 Exercise		: Siamese Neural Network
//   Author     		:　Yeh-Shun Liang (maggie8905121@gmail.com)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : SNN.v
//   Module Name : SNN
//   Release version : V1.0 (Release Date: 2023-09)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
module SNN(
    //Input Port

    clk,
    rst_n,
    in_valid,
    Img,
    Kernel,
	Weight,
    Opt,

    //Output Port
    out_valid,
    out
    );

//---------------------------------------------------------------------
//   PARAMETER
//---------------------------------------------------------------------
localparam FP_ONE  = 32'h3f800000;

// IEEE floating point parameter
parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
parameter inst_arch = 0;
parameter inst_faithful_round = 0;

input rst_n, clk, in_valid;
input [inst_sig_width+inst_exp_width:0] Img, Kernel, Weight;
input [1:0] Opt;

output reg	out_valid;
output reg [inst_sig_width+inst_exp_width:0] out;

parameter DATA_WIDTH = inst_sig_width + inst_exp_width + 1;

parameter en_ubr_flag  = 0;
parameter faithful_round = 0;

//---------------------------------------------------------------------
//      STATES
//---------------------------------------------------------------------
reg[2:0] p_cur_st, p_next_st;
reg[7:0] mm_cur_st,mm_next_st;

localparam  P_IDLE = 3'b001;
localparam  P_RD_DATA = 3'b010;
localparam  P_PROCESSING = 3'b100;

localparam  MM_IDLE = 8'b0000_0001;
localparam  MM_MAX_POOLING = 8'b0000_0010;
localparam  MM_FC = 8'b0000_0100;
localparam  MM_NORM_ACT = 8'b0000_1000;
localparam  MM_WAIT_IMG1 = 8'b0010_0000;
localparam  MM_L1_DISTANCE = 8'b0100_0000;
localparam  MM_DONE = 8'b1000_0000;

wire ST_P_IDLE = p_cur_st[0];
wire ST_P_RD_DATA = p_cur_st[1];
wire ST_P_PROCESSING = p_cur_st[2];

wire ST_MM_IDLE   = mm_cur_st[0];
wire ST_MM_MAX_POOLING   = mm_cur_st[1];
wire ST_MM_FC   = mm_cur_st[2];
wire ST_MM_NORM_ACT   = mm_cur_st[3];
wire ST_MM_WAIT_IMG1   = mm_cur_st[5];
wire ST_MM_L1_DISTANCE   = mm_cur_st[6];
wire ST_MM_DONE   = mm_cur_st[7];

reg[6:0] rd_cnt;
reg[2:0] mm_cnt,pixel_cnt;
reg  processing_f_ff;
reg  valid_d1,valid_d2,valid_d3,valid_d4;

reg img_num_cnt,img_num_cnt_d1,img_num_cnt_d2,img_num_cnt_d3,img_num_cnt_d4;
reg[DATA_WIDTH-1:0] x_min_ff,x_max_ff;

reg[1:0] kernal_num_cnt,kernal_num_cnt_d1,kernal_num_cnt_d2,kernal_num_cnt_d3,kernal_num_cnt_d4;

reg[3:0] process_xptr, process_yptr,process_xptr_d1, process_yptr_d1,process_xptr_d2,process_yptr_d2,process_xptr_d3,
process_yptr_d3,process_xptr_d4,process_yptr_d4;

reg[3:0] wr_img_xptr,wr_img_yptr;
reg mm_img_cnt;
reg[2:0] mm_cnt_d1,mm_cnt_d2,mm_cnt_d3,mm_cnt_d4;
reg norm_valid_d1;
reg[DATA_WIDTH-1:0] exp_pos_result_d3, exp_neg_result_d3, fp_sub2_act_d4,
fp_add3_act_d4;
reg[DATA_WIDTH-1:0] fp_mult_fc_d1[0:1];

reg[DATA_WIDTH-1:0] abs_in;
reg[DATA_WIDTH-1:0] abs_out_0_d1,abs_out_1_d1,abs_out_2_d1,abs_out_3_d1;

reg[DATA_WIDTH-1:0] negation_in;
reg[DATA_WIDTH-1:0] pos_exp_in;

wire[DATA_WIDTH-1:0] fp_mult_FC_out[0:1];
wire[DATA_WIDTH-1:0] fp_add0_out;


reg[DATA_WIDTH-1:0] fp_add0_in_a;
reg[DATA_WIDTH-1:0] fp_add0_in_b;

reg[DATA_WIDTH-1:0] fp_mult_fc_in_a[0:1];
reg[DATA_WIDTH-1:0] fp_mult_fc_in_b[0:1];

reg[DATA_WIDTH-1:0] fp_div0_in_a;
reg[DATA_WIDTH-1:0] fp_div0_in_b;
wire[DATA_WIDTH-1:0] fp_div0_out;

reg[DATA_WIDTH-1:0] fp_sub0_in_a;
reg[DATA_WIDTH-1:0] fp_sub0_in_b;
wire[DATA_WIDTH-1:0] fp_sub0_out;
reg[DATA_WIDTH-1:0] fp_norm_sub0_out_d1;

reg[DATA_WIDTH-1:0] fp_sub1_in_a;
reg[DATA_WIDTH-1:0] fp_sub1_in_b;
wire[DATA_WIDTH-1:0] fp_sub1_out;

reg[DATA_WIDTH-1:0] max_pooling_result_rf[0:1][0:1];
reg[DATA_WIDTH-1:0] fc_result_rf[0:3];
reg[DATA_WIDTH-1:0] norm_result_rf[0:3];
reg[DATA_WIDTH-1:0] activation_result_rf[0:3][0:1];
reg[DATA_WIDTH-1:0] l1_distance_ff;

wire[DATA_WIDTH-1:0] negation = {~negation_in[31],negation_in[30:0]};
wire[DATA_WIDTH-1:0] exp_neg_result;
wire[DATA_WIDTH-1:0] exp_pos_result;
reg[DATA_WIDTH-1:0]  fp_div0_out_d2;

reg[DATA_WIDTH-1:0] fp_div1_in_a;
reg[DATA_WIDTH-1:0] fp_div1_in_b;
wire[DATA_WIDTH-1:0] fp_div1_out;

wire fp_cmp_results[0:1][0:1];

reg[DATA_WIDTH-1:0] min_max_diff_ff;
reg[DATA_WIDTH-1:0] kernal_rf[0:2][0:2][0:2];
reg[DATA_WIDTH-1:0] img_rf[0:5][0:5];
reg[DATA_WIDTH-1:0] weight_rf[0:1][0:1];
wire start_processing_f = rd_cnt == 8;

reg[1:0]  wr_kernal_num_cnt,wr_img_channel_cnt;
reg       wr_img_num_cnt;
reg[1:0] opt_ff;
reg[1:0] wr_kernal_yptr,wr_kernal_xptr;
reg l1_valid_d1;

reg norm_act_d1,norm_act_d2,norm_act_d3,norm_act_d4;


localparam IMG_SIZE = 4;

integer i,j,k,c;

// One for img1, another for img2
reg[DATA_WIDTH-1:0] convolution_result_rf[0:3][0:3][0:1];

genvar idx,jdx;
//---------------------------------------------------------------------
//      Shared 4 SUM MAC
//---------------------------------------------------------------------
reg[DATA_WIDTH-1:0] pixels[0:8];
reg[DATA_WIDTH-1:0] kernals[0:8];
wire[DATA_WIDTH-1:0] mults_result[0:8];
wire[DATA_WIDTH-1:0] partial_sum[0:2];
wire[DATA_WIDTH-1:0] mac_result;
reg[DATA_WIDTH-1:0]  mults_result_pipe_d1[0:8];
reg[DATA_WIDTH-1:0] partial_sum_pipe_d2[0:2];

//---------------------------------------------------------------------
//      flags
//---------------------------------------------------------------------
wire rd_data_done_f = rd_cnt == 95;
wire all_convolution_done_f = img_num_cnt == 1 && kernal_num_cnt == 2 && process_xptr == 3 && process_yptr == 3;
wire channel_processed_f = process_xptr == 3 && process_yptr == 3;
wire convolution_done_f     = kernal_num_cnt == 2 && channel_processed_f;
wire max_pooling_done_f     = mm_cnt == 2 && ST_MM_MAX_POOLING;
wire fc_done_f              = mm_cnt_d1 == 3 && ST_MM_FC;
wire activation_done_f      = mm_cnt_d4 == 3 && ST_MM_NORM_ACT;
wire l1_distance_cal_f      = l1_valid_d1 && ST_MM_L1_DISTANCE;
reg  convolution_done_f_d1,convolution_done_f_d2,convolution_done_f_d3,convolution_done_f_d4;

//---------------------------------------------------------------------
//      2X DW_ADD_SUB
//---------------------------------------------------------------------
reg[DATA_WIDTH-1:0]  fp_addsub0_in_a,fp_addsub0_in_b,fp_addsub1_in_a,fp_addsub1_in_b;
reg[DATA_WIDTH-1:0]  fp_addsub2_in_a,fp_addsub2_in_b,fp_addsub3_in_a,fp_addsub3_in_b;
wire[DATA_WIDTH-1:0] fp_addsub0_out,fp_addsub1_out;
wire[DATA_WIDTH-1:0] fp_addsub2_out,fp_addsub3_out;
reg fp_addsub0_mode, fp_addsub1_mode;
reg fp_addsub2_mode, fp_addsub3_mode;

reg[DATA_WIDTH-1:0]  fp_add_tree_in_a[0:2];
reg[DATA_WIDTH-1:0]  fp_add_tree_in_b[0:2];
wire[DATA_WIDTH-1:0] fp_add_tree_out[0:2];//
reg[DATA_WIDTH-1:0]  fp_add_tree_d3[0:1];

always @(*)
begin
    // 0 addition, 1 subtraction
    fp_addsub0_in_a = 0;
    fp_addsub0_in_b = 0;

    fp_addsub1_in_a = 0;
    fp_addsub1_in_b = 0;

    fp_addsub0_mode = 0;
    fp_addsub1_mode = 0;

    fp_addsub2_in_a = 0;
    fp_addsub2_in_b = 0;

    fp_addsub3_in_a = 0;
    fp_addsub3_in_b = 0;

    fp_addsub2_mode = 0;
    fp_addsub3_mode = 0;

    fp_add_tree_in_a[0] = 0;
    fp_add_tree_in_b[0] = 0;

    fp_add_tree_in_a[1] = 0;
    fp_add_tree_in_b[1] = 0;

    fp_add_tree_in_a[2] = 0;
    fp_add_tree_in_b[2] = 0;

    // Convolution process
    fp_add_tree_in_a[0] = partial_sum_pipe_d2[0];
    fp_add_tree_in_b[0] = partial_sum_pipe_d2[1];
    fp_add_tree_in_a[1] = partial_sum_pipe_d2[2];
    fp_add_tree_in_b[1] = convolution_result_rf[process_xptr_d2][process_yptr_d2][img_num_cnt_d2];
    fp_add_tree_in_a[2] = fp_add_tree_d3[0];
    fp_add_tree_in_b[2] = fp_add_tree_d3[1];

    if(ST_MM_L1_DISTANCE && ST_P_IDLE)
    begin
        fp_addsub0_mode = 1;
        fp_addsub0_in_a = activation_result_rf[0][0];
        fp_addsub0_in_b = activation_result_rf[0][1];

        fp_addsub1_mode = 1;
        fp_addsub1_in_a = activation_result_rf[1][0];
        fp_addsub1_in_b = activation_result_rf[1][1];

        fp_addsub2_mode = 1;
        fp_addsub2_in_a = activation_result_rf[2][0];
        fp_addsub2_in_b = activation_result_rf[2][1];

        fp_addsub3_mode = 1;
        fp_addsub3_in_a = activation_result_rf[3][0];
        fp_addsub3_in_b = activation_result_rf[3][1];

        fp_add_tree_in_a[0] = abs_out_0_d1;
        fp_add_tree_in_b[0] = abs_out_1_d1;
        fp_add_tree_in_a[1] = abs_out_2_d1;
        fp_add_tree_in_b[1] = abs_out_3_d1;

        fp_add_tree_in_a[2] = fp_add_tree_out[0];
        fp_add_tree_in_b[2] = fp_add_tree_out[1];
    end

    if(ST_MM_FC)
    begin
        fp_addsub0_mode = 0 ;
        fp_addsub0_in_a = fp_mult_fc_d1[0];
        fp_addsub0_in_b = fp_mult_fc_d1[1];
    end

    if(ST_MM_NORM_ACT)
    begin
        fp_addsub0_mode = 1;
        fp_addsub0_in_a = fc_result_rf[0];
        fp_addsub0_in_b = x_min_ff;

        fp_addsub1_mode = 1;
        fp_addsub1_in_a = x_max_ff;
        fp_addsub1_in_b = x_min_ff;

        fp_addsub2_mode = 1;
        if(opt_ff == 2 || opt_ff == 3)
        begin
            fp_addsub2_in_a = exp_pos_result_d3;
            fp_addsub2_in_b = exp_neg_result_d3;
        end

        fp_addsub3_mode = 0;
        if(opt_ff == 2 || opt_ff == 3)
        begin
            // tanh
            fp_addsub3_in_a = exp_pos_result_d3;
            fp_addsub3_in_b = exp_neg_result_d3;
        end
        else
        begin
            // sigmoid
            fp_addsub3_in_a = FP_ONE;
            fp_addsub3_in_b = exp_neg_result_d3;
        end
    end
end

// Instance of DW_fp_addsub
DW_fp_addsub #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
fp_addsub0_inst ( .a(fp_addsub0_in_a), .b(fp_addsub0_in_b), .rnd(3'b000),
.op(fp_addsub0_mode), .z(fp_addsub0_out), .status() );

// Instance of DW_fp_addsub
DW_fp_addsub #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
fp_addsub1_inst( .a(fp_addsub1_in_a), .b(fp_addsub1_in_b), .rnd(3'b000),
.op(fp_addsub1_mode), .z(fp_addsub1_out), .status() );

// Instance of DW_fp_addsub
DW_fp_addsub #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
fp_addsub2_inst( .a(fp_addsub2_in_a), .b(fp_addsub2_in_b), .rnd(3'b000),
.op(fp_addsub2_mode), .z(fp_addsub2_out), .status() );

// Instance of DW_fp_addsub
DW_fp_addsub #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
fp_addsub3_inst( .a(fp_addsub3_in_a), .b(fp_addsub3_in_b), .rnd(3'b000),
.op(fp_addsub3_mode), .z(fp_addsub3_out), .status() );


//---------------------------------------------------------------------
//      PIPELINE DATAPATH
//---------------------------------------------------------------------
wire[4:0] row_00 = process_xptr;
wire[4:0] row_01 = process_xptr;
wire[4:0] row_02 = process_xptr;
wire[4:0] row_10 = process_xptr + 1;
wire[4:0] row_11 = process_xptr + 1;
wire[4:0] row_12 = process_xptr + 1;
wire[4:0] row_20 = process_xptr + 2;
wire[4:0] row_21 = process_xptr + 2;
wire[4:0] row_22 = process_xptr + 2;

wire[4:0] col_00 = process_yptr;
wire[4:0] col_01 = process_yptr+1;
wire[4:0] col_02 = process_yptr+2;
wire[4:0] col_10 = process_yptr;
wire[4:0] col_11 = process_yptr + 1;
wire[4:0] col_12 = process_yptr + 2;
wire[4:0] col_20 = process_yptr;
wire[4:0] col_21 = process_yptr + 1;
wire[4:0] col_22 = process_yptr + 2;

always @(*) begin
    pixels[0] = img_rf[row_00][col_00];
    pixels[1] = img_rf[row_01][col_01];
    pixels[2] = img_rf[row_02][col_02];
    pixels[3] = img_rf[row_10][col_10];
    pixels[4] = img_rf[row_11][col_11];
    pixels[5] = img_rf[row_12][col_12];
    pixels[6] = img_rf[row_20][col_20];
    pixels[7] = img_rf[row_21][col_21];
    pixels[8] = img_rf[row_22][col_22];

    kernals[0] = kernal_rf[0][0][kernal_num_cnt];
    kernals[1] = kernal_rf[0][1][kernal_num_cnt];
    kernals[2] = kernal_rf[0][2][kernal_num_cnt];
    kernals[3] = kernal_rf[1][0][kernal_num_cnt];
    kernals[4] = kernal_rf[1][1][kernal_num_cnt];
    kernals[5] = kernal_rf[1][2][kernal_num_cnt];
    kernals[6] = kernal_rf[2][0][kernal_num_cnt];
    kernals[7] = kernal_rf[2][1][kernal_num_cnt];
    kernals[8] = kernal_rf[2][2][kernal_num_cnt];
end

generate
    for(idx = 0; idx < 9 ; idx = idx+1)
    begin:PARRALLEL_MULTS
        DW_fp_mult_inst #(inst_sig_width,inst_exp_width,inst_ieee_compliance,en_ubr_flag)
                        u_DW_fp_mult_inst(
                            .inst_a   ( pixels[idx]         ),
                            .inst_b   ( kernals[idx]        ),
                            .inst_rnd ( 3'b000              ),
                            .z_inst   ( mults_result[idx]   ),
                            .status_inst  (   )
                        );
    end
endgenerate

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        for(i=0;i<9;i=i+1)
        begin
            mults_result_pipe_d1[i] <= 0;
        end
    end
    else
    begin
        for(i=0;i<9;i=i+1)
        begin
            mults_result_pipe_d1[i] <= mults_result[i];
        end
    end
end

// 3x 3 inputs fp adders
DW_fp_sum3_inst #(inst_sig_width,inst_exp_width,inst_ieee_compliance,inst_arch_type)
                u_DW_fp_sum3_inst1(
                    .inst_a   ( mults_result_pipe_d1[0]),
                    .inst_b   ( mults_result_pipe_d1[1]),
                    .inst_c   ( mults_result_pipe_d1[2]   ),
                    .inst_rnd ( 3'b000 ),
                    .z_inst   ( partial_sum[0]   ),
                    .status_inst  (   )
                );

DW_fp_sum3_inst #(inst_sig_width,inst_exp_width,inst_ieee_compliance,inst_arch_type)
                u_DW_fp_sum3_inst2(
                    .inst_a   ( mults_result_pipe_d1[3]),
                    .inst_b   ( mults_result_pipe_d1[4]),
                    .inst_c   ( mults_result_pipe_d1[5]   ),
                    .inst_rnd ( 3'b000 ),
                    .z_inst   ( partial_sum[1]),
                    .status_inst  (   )
                );

DW_fp_sum3_inst #(inst_sig_width,inst_exp_width,inst_ieee_compliance,inst_arch_type)
                u_DW_fp_sum3_inst3(
                    .inst_a   ( mults_result_pipe_d1[6]),
                    .inst_b   ( mults_result_pipe_d1[7]),
                    .inst_c   ( mults_result_pipe_d1[8]   ),
                    .inst_rnd ( 3'b000 ),
                    .z_inst   ( partial_sum[2]),
                    .status_inst  (   )
                );

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
    begin
        for(i=0;i<3;i=i+1)
        begin
           partial_sum_pipe_d2[i] <= 0;
        end
    end
    else
    begin
        for(i=0;i<3;i=i+1)
        begin
            partial_sum_pipe_d2[i]<=partial_sum[i];
        end
    end
end

// Lastly Replace with 4 SUM

//---------------------------------------------------------------------
//      CTRs
//---------------------------------------------------------------------
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        p_cur_st <= P_IDLE;
        mm_cur_st <= MM_IDLE;
    end
    else
    begin
        p_cur_st <= p_next_st;
        mm_cur_st <= mm_next_st;
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        img_num_cnt_d1 <= 0;
        img_num_cnt_d2 <= 0;
        img_num_cnt_d3 <= 0;

        kernal_num_cnt_d1 <= 0;
        kernal_num_cnt_d2 <= 0;
        kernal_num_cnt_d3 <= 0;

        process_xptr_d1 <= 0;
        process_yptr_d1 <= 0;

        process_xptr_d2 <= 0;
        process_yptr_d2 <= 0;

        process_xptr_d3 <= 0;
        process_yptr_d3 <= 0;

        valid_d1 <= 0;
        valid_d2 <= 0;
        valid_d3 <= 0;

        convolution_done_f_d1 <= 0;
        convolution_done_f_d2 <= 0;
        convolution_done_f_d3 <= 0;
    end
    else
    begin
        img_num_cnt_d1 <= img_num_cnt;
        img_num_cnt_d2 <= img_num_cnt_d1;
        img_num_cnt_d3 <= img_num_cnt_d2;

        kernal_num_cnt_d1 <= kernal_num_cnt;
        kernal_num_cnt_d2 <= kernal_num_cnt_d1;
        kernal_num_cnt_d3 <= kernal_num_cnt_d2;

        process_xptr_d1 <= process_xptr;
        process_xptr_d2 <= process_xptr_d1;
        process_xptr_d3 <= process_xptr_d2;

        process_yptr_d1 <= process_yptr;
        process_yptr_d2 <= process_yptr_d1;
        process_yptr_d3 <= process_yptr_d2;

        valid_d1 <= processing_f_ff;
        valid_d2 <= valid_d1;
        valid_d3 <= valid_d2;

        convolution_done_f_d1 <= convolution_done_f;
        convolution_done_f_d2 <= convolution_done_f_d1;
        convolution_done_f_d3 <= convolution_done_f_d2;
    end
end

always @(*)
begin
    p_next_st = p_cur_st;
    case(p_cur_st)
    P_IDLE:
    begin
        if(in_valid) p_next_st = P_RD_DATA;
    end
    P_RD_DATA:
    begin
        if(rd_data_done_f) p_next_st = P_PROCESSING;
    end
    P_PROCESSING:
    begin
        if(all_convolution_done_f) p_next_st = P_IDLE;
    end
    endcase
end

always @(*)
begin
    // Change to equalization done flag
    mm_next_st = mm_cur_st;
    case(mm_cur_st)
    MM_IDLE:
    begin
        if(convolution_done_f_d3) mm_next_st = MM_MAX_POOLING;
    end
    MM_MAX_POOLING:
    begin
        if(max_pooling_done_f) mm_next_st = MM_FC;
    end
    MM_FC:
    begin
        if(fc_done_f) mm_next_st = MM_NORM_ACT;
    end
    MM_NORM_ACT:
    begin
        if(activation_done_f)
        begin
            if(mm_img_cnt == 1)
                mm_next_st = MM_L1_DISTANCE;
            else
                mm_next_st = MM_WAIT_IMG1;
        end
    end
    MM_WAIT_IMG1:
    begin
        if(convolution_done_f_d3)  mm_next_st = MM_MAX_POOLING;
    end
    MM_L1_DISTANCE:
    begin
        if(l1_distance_cal_f)   mm_next_st = MM_DONE;
    end
    MM_DONE:
    begin
        mm_next_st = MM_IDLE;
    end
    endcase
end

//---------------------------------------------------------------------
//      KERNALS, IMGS, WEIGHTS
//---------------------------------------------------------------------
wire wr_boundary_reach_f = wr_img_yptr == 3 && ST_P_RD_DATA;
wire wr_channel_done_f   = wr_img_yptr == 3 && wr_img_xptr == 3 && ST_P_RD_DATA;
wire wr_img_done_f       = wr_channel_done_f && wr_img_channel_cnt == 2 && ST_P_RD_DATA;
wire wr_all_img_done_f   = wr_img_done_f && wr_img_num_cnt == 1 && ST_P_RD_DATA;

wire wr_kernal_bound_reach_f  = wr_kernal_yptr == 2  && ST_P_RD_DATA;
wire wr_kernal_done_f         = wr_kernal_yptr == 2 && wr_kernal_xptr == 2 && ST_P_RD_DATA;
wire wr_all_kernal_done_f     = wr_kernal_done_f && wr_kernal_num_cnt == 2 && ST_P_RD_DATA;

always @(posedge clk or negedge rst_n)
    if(~rst_n)
begin
    begin
        for(i=0;i<3;i=i+1)
            for(j=0;j<3;j=j+1)
                for(k=0;k<3;k=k+1)
                    kernal_rf[i][j][k] <= 0;
        for(i=0;i<6;i=i+1)
            for(j=0;j<6;j=j+1)

                img_rf[i][j] <= 0;
        for(i=0;i<2;i=i+1)
            for(j=0;j<2;j=j+1)

                    weight_rf[i][j] <= 0;
        processing_f_ff <= 0;
        // Since padding, start from (1,1)

        wr_img_xptr <= 0;
        wr_img_yptr <= 0;
        wr_img_num_cnt <= 0;
        wr_img_channel_cnt <= 0;
        opt_ff <= 0;
        // Kernals
        wr_kernal_num_cnt <= 0;

        wr_kernal_yptr <= 0;
        wr_kernal_xptr <= 0;
        rd_cnt  <= 0;
    end
    else if(ST_P_IDLE)

    begin
        // Reading in images, kernals and weight_rf
        if(in_valid)
        begin
            if(Opt == 0 || Opt == 2)
            begin
                img_rf[0][0] <= Img;
                img_rf[0][1] <= Img;
                img_rf[1][0] <= Img;
                img_rf[1][1] <= Img;
            end
            else
            begin
                img_rf[1][1] <= Img;
            end
            kernal_rf[0][0][0] <= Kernel;
            weight_rf[0][0]    <= Weight;

            opt_ff <= Opt;
            wr_img_yptr <= wr_img_yptr + 1;

            wr_kernal_yptr <= wr_kernal_yptr + 1;
            rd_cnt <= rd_cnt + 1;
        end
        else if(ST_MM_DONE)
        begin
            for(i=0;i<3;i=i+1)
                for(j=0;j<3;j=j+1)
                    for(k=0;k<3;k=k+1)
                        kernal_rf[i][j][k] <= 0;
            for(i=0;i<6;i=i+1)
                for(j=0;j<6;j=j+1)

                        img_rf[i][j] <= 0;
            for(i=0;i<2;i=i+1)
                for(j=0;j<2;j=j+1)

                    weight_rf[i][j] <= 0;
            processing_f_ff <= 0;
            // Since padding, start from (1,1)

            wr_img_xptr <= 0;
            wr_img_yptr <= 0;
            wr_img_num_cnt <= 0;
            wr_img_channel_cnt <= 0;
            opt_ff <= 0;
            // Kernals
            wr_kernal_num_cnt <= 0;

            wr_kernal_yptr <= 0;
            wr_kernal_xptr <= 0;
            rd_cnt <= 0;
        end
    end
    else if(ST_P_RD_DATA)
    begin
        case(rd_cnt)
        'd0: weight_rf[0][0] <= Weight;
        'd1: weight_rf[0][1] <= Weight;
        'd2: weight_rf[1][0] <= Weight;
        'd3: weight_rf[1][1] <= Weight;
        endcase
        // write kernals
        if(rd_cnt <= 26)

            kernal_rf[wr_kernal_xptr][wr_kernal_yptr][wr_kernal_num_cnt] <= Kernel;
        rd_cnt <= rd_cnt + 1;
        // Replication

        if(opt_ff == 0 || opt_ff == 2)
        begin
            if(wr_img_xptr == 0 && wr_img_yptr == 0)
            begin
                // (x,y,channel,img)
                img_rf[0][0] <= Img;
                img_rf[0][1] <= Img;
                img_rf[1][0] <= Img;
                img_rf[1][1] <= Img;
            end
            else if(wr_img_xptr == 0 && wr_img_yptr == IMG_SIZE-1)
            begin
                // (x,y,channel,img)
                img_rf[1][4] <= Img;
                img_rf[1][5] <= Img;
                img_rf[0][4] <= Img;
                img_rf[0][5] <= Img;
            end
            else if(wr_img_xptr == IMG_SIZE-1 && wr_img_yptr == 0)
            begin
                // (x,y,channel,img)
                img_rf[4][1] <= Img;
                img_rf[4][0] <= Img;
                img_rf[5][0] <= Img;
                img_rf[5][1] <= Img;
            end
            else if(wr_img_xptr == IMG_SIZE -1 && wr_img_yptr == IMG_SIZE-1)
            begin
                // (x,y,channel,img)
                img_rf[4][4] <= Img;
                img_rf[4][5] <= Img;
                img_rf[5][4] <= Img;
                img_rf[5][5] <= Img;
            end
            else if(wr_img_xptr == 0)
            begin
                img_rf[0][wr_img_yptr+1] <= Img;
                img_rf[1][wr_img_yptr+1] <= Img;
            end
            else if(wr_img_yptr == 0)
            begin
                img_rf[wr_img_xptr+1][0] <= Img;
                img_rf[wr_img_xptr+1][1] <= Img;
            end
            else if(wr_img_xptr == IMG_SIZE -1)
            begin
                img_rf[4][wr_img_yptr+1] <= Img;
                img_rf[5][wr_img_yptr+1] <= Img;
            end
            else if(wr_img_yptr == IMG_SIZE-1)
            begin
                img_rf[wr_img_xptr+1][4] <= Img;
                img_rf[wr_img_xptr+1][5] <= Img;
            end
            else
            begin
                img_rf[wr_img_xptr+1][wr_img_yptr+1] <= Img;
            end
        end
        else
        begin
            img_rf[wr_img_xptr+1][wr_img_yptr+1] <= Img;
        end

        // wr_ptrs
        if(wr_all_img_done_f)
        begin
            wr_img_xptr     <= 0;
            wr_img_yptr     <= 0;
            wr_img_num_cnt  <= 0;
            wr_img_channel_cnt <= 0;
        end
        else if(wr_img_done_f)
        begin
            wr_img_xptr <= 0;
            wr_img_yptr <= 0;
            wr_img_num_cnt <= wr_img_num_cnt + 1;
            wr_img_channel_cnt <= 0;
        end
        else if(wr_channel_done_f)
        begin
            wr_img_xptr <= 0;
            wr_img_yptr <= 0;
            wr_img_channel_cnt <= wr_img_channel_cnt + 1;
        end
        else if(wr_boundary_reach_f)
        begin
            wr_img_xptr <= wr_img_xptr + 1;
            wr_img_yptr <= 0;
        end
        else
        begin
            wr_img_yptr <= wr_img_yptr + 1;
        end

        //wr kernals
        if(wr_all_kernal_done_f)
        begin
            wr_kernal_xptr <= 0;
            wr_kernal_yptr <= 0;
            wr_kernal_num_cnt <= 2;
        end
        else if(wr_kernal_done_f)
        begin
            wr_kernal_xptr <= 0;
            wr_kernal_yptr <= 0;
            wr_kernal_num_cnt <= wr_kernal_num_cnt + 1;
        end
        else if(wr_kernal_bound_reach_f)
        begin
            wr_kernal_xptr <= wr_kernal_xptr + 1;
            wr_kernal_yptr <= 0;
        end
        else
        begin
            wr_kernal_yptr <= wr_kernal_yptr + 1;
        end

        // Start sending signals to MAC at 10th cycle while reading
        if(start_processing_f)
        begin
            processing_f_ff <= 1;
        end
    end
    else
    begin
        if(all_convolution_done_f)
            processing_f_ff <= 0;
    end
end

wire process_bound_reach_f = process_yptr == 3;

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        process_xptr <= 0;
        process_yptr <= 0;
        kernal_num_cnt <= 0;
        img_num_cnt <= 0;
    end
    else if(ST_P_IDLE)
    begin
        process_xptr <= 0;
        process_yptr <= 0;
        kernal_num_cnt <= 0;
        img_num_cnt <= 0;
    end
    else if((ST_P_RD_DATA || ST_P_PROCESSING) && processing_f_ff)
    begin
        if(all_convolution_done_f)
        begin
            process_xptr <= 0;
            process_yptr <= 0;
        end
        else if(convolution_done_f)
        begin
            process_xptr <= 0;
            process_yptr <= 0;
            kernal_num_cnt <= 0;
            img_num_cnt <= img_num_cnt+1;
        end
        else if(channel_processed_f)
        begin
            process_xptr <= 0;
            process_yptr <= 0;
            kernal_num_cnt <= kernal_num_cnt + 1;
        end
        else if(process_bound_reach_f)
        begin
            process_xptr <= process_xptr + 1;
            process_yptr <= 0;
        end
        else
        begin
            process_yptr <= process_yptr + 1;
        end
    end
end

//---------------------------------------------------------------------
//      CONVOLUTION RESULTS
//---------------------------------------------------------------------

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        for(i=0;i<4;i=i+1)
            for(j=0;j<4;j=j+1)
                for(k=0;k<2;k=k+1)
                    convolution_result_rf[i][j][k] <= 0;
    end
    else if(ST_MM_DONE)
    begin
        for(i=0;i<4;i=i+1)
            for(j=0;j<4;j=j+1)
                for(k=0;k<2;k=k+1)
                    convolution_result_rf[i][j][k] <= 0;
    end
    else if(valid_d3)
    begin
       convolution_result_rf[process_xptr_d3][process_yptr_d3][img_num_cnt_d3] <= fp_add_tree_out[2];
    end
end

//---------------------------------------------------------------------
//      MM DATAPATH
//---------------------------------------------------------------------
// mm_cnt delay lines
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        mm_cnt_d1 <= 0;
        mm_cnt_d2 <= 0;
        mm_cnt_d3 <= 0;
        mm_cnt_d4 <= 0;
    end
    else if(mm_cur_st != mm_next_st)
    begin
        mm_cnt_d1 <= 0;
        mm_cnt_d2 <= 0;
        mm_cnt_d3 <= 0;
        mm_cnt_d4 <= 0;
    end
    else
    begin
        mm_cnt_d1 <= mm_cnt;
        mm_cnt_d2 <= mm_cnt_d1;
        mm_cnt_d3 <= mm_cnt_d2;
        mm_cnt_d4 <= mm_cnt_d3;
    end
end

reg[DATA_WIDTH-1:0] fp_add0_FC_d2, fp_mult0_FC_d1, fp_mult1_FC_d1;

reg fc_valid_d1, fc_valid_d2;
reg act_valid_d1,act_valid_d2;

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        fc_valid_d2 <= 0;
    end
    else
    begin
        fc_valid_d2 <= fc_valid_d1;
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        for(i=0;i<2;i=i+1)
            for(j=0;j<2;j=j+1)
                max_pooling_result_rf[i][j] <= 0;

        out_valid <= 0;
        out       <= 0;
        mm_cnt    <= 0;
        mm_img_cnt<=0;
        l1_distance_ff <= 0;
        min_max_diff_ff   <= 0;
        fc_valid_d1 <= 0;
        l1_valid_d1 <= 0;
        norm_act_d1 <= 0;
    end
    else
    begin
        min_max_diff_ff  <= fp_addsub1_out;

        case(mm_cur_st)
        MM_IDLE:
        begin
            for(i=0;i<3;i=i+1)
                for(j=0;j<3;j=j+1)
                    max_pooling_result_rf[i][j] <= 0;

            out   <= 0;
            out_valid  <= 0;

            mm_cnt <= 0;
            mm_img_cnt <= 0;
            l1_distance_ff<= 0;
            min_max_diff_ff <= 0;
            fc_valid_d1 <= 0;
            act_valid_d1 <= 0;
            l1_valid_d1 <= 0;
            norm_act_d1 <= 0;
        end
        MM_MAX_POOLING:
        begin
            mm_cnt <= max_pooling_done_f ? 0 : mm_cnt + 1;
            case(mm_cnt)
            'd0:
            begin
                if(fp_cmp_results[0][0])
                begin
                    max_pooling_result_rf[0][0] <= convolution_result_rf[0][0][mm_img_cnt];
                end
                else
                begin
                    max_pooling_result_rf[0][0] <= convolution_result_rf[0][1][mm_img_cnt];
                end

                if(fp_cmp_results[0][1])
                begin
                    max_pooling_result_rf[0][1] <= convolution_result_rf[0][2][mm_img_cnt];
                end
                else
                begin
                    max_pooling_result_rf[0][1] <= convolution_result_rf[0][3][mm_img_cnt];
                end

                if(fp_cmp_results[1][0])
                begin
                    max_pooling_result_rf[1][0] <= convolution_result_rf[2][0][mm_img_cnt];
                end
                else
                begin
                    max_pooling_result_rf[1][0] <= convolution_result_rf[2][1][mm_img_cnt];
                end

                if(fp_cmp_results[1][1])
                begin
                    max_pooling_result_rf[1][1] <= convolution_result_rf[2][2][mm_img_cnt];
                end
                else
                begin
                    max_pooling_result_rf[1][1] <= convolution_result_rf[2][3][mm_img_cnt];
                end
            end
            'd1:
            begin
                // Compare conv_result > max_pooling_result
                if(fp_cmp_results[0][0])
                begin
                    max_pooling_result_rf[0][0] <= convolution_result_rf[1][0][mm_img_cnt];
                end
                else
                begin
                    max_pooling_result_rf[0][0] <= max_pooling_result_rf[0][0];
                end

                if(fp_cmp_results[0][1])
                begin
                    max_pooling_result_rf[0][1] <= convolution_result_rf[1][2][mm_img_cnt];
                end
                else
                begin
                    max_pooling_result_rf[0][1] <= max_pooling_result_rf[0][1];
                end

                if(fp_cmp_results[1][0])
                begin
                    max_pooling_result_rf[1][0] <= convolution_result_rf[3][0][mm_img_cnt];
                end
                else
                begin
                    max_pooling_result_rf[1][0] <= max_pooling_result_rf[1][0];
                end

                if(fp_cmp_results[1][1])
                begin
                    max_pooling_result_rf[1][1] <= convolution_result_rf[3][2][mm_img_cnt];
                end
                else
                begin
                    max_pooling_result_rf[1][1] <= max_pooling_result_rf[1][1];
                end
            end
            'd2:
            begin
                // Compare conv_result > max_pooling_result
                if(fp_cmp_results[0][0])
                begin
                    max_pooling_result_rf[0][0] <= convolution_result_rf[1][1][mm_img_cnt];
                end
                else
                begin
                    max_pooling_result_rf[0][0] <= max_pooling_result_rf[0][0];
                end

                if(fp_cmp_results[0][1])
                begin
                    max_pooling_result_rf[0][1] <= convolution_result_rf[1][3][mm_img_cnt];
                end
                else
                begin
                    max_pooling_result_rf[0][1] <= max_pooling_result_rf[0][1];
                end

                if(fp_cmp_results[1][0])
                begin
                    max_pooling_result_rf[1][0] <= convolution_result_rf[3][1][mm_img_cnt];
                end
                else
                begin
                    max_pooling_result_rf[1][0] <= max_pooling_result_rf[1][0];
                end

                if(fp_cmp_results[1][1])
                begin
                    max_pooling_result_rf[1][1] <= convolution_result_rf[3][3][mm_img_cnt];
                end
                else
                begin
                    max_pooling_result_rf[1][1] <= max_pooling_result_rf[1][1];
                end
            end
            endcase
        end
        MM_FC:
        begin
            mm_cnt      <= fc_done_f ? 0 : (mm_cnt == 4 ? mm_cnt : mm_cnt + 1);
            fc_valid_d1 <= mm_cnt == 4 ? 0 : 1;
        end
        MM_NORM_ACT:
        begin
            mm_cnt <= activation_done_f ? 0 :((mm_cnt == 4) ? mm_cnt : mm_cnt + 1);
            norm_act_d1 <= (mm_cnt == 4) ? 0 : 1;
        end
        MM_WAIT_IMG1:
        begin
            if(convolution_done_f_d3)
            begin
                mm_img_cnt <= mm_img_cnt + 1;
                mm_cnt <= 0;
            end
        end
        MM_L1_DISTANCE:
        begin
            l1_valid_d1 <= 1;

            if(l1_valid_d1)
                l1_distance_ff <= fp_add_tree_out[2];
        end
        MM_DONE:
        begin
            for(i=0;i<3;i=i+1)
                for(j=0;j<3;j=j+1)
                    max_pooling_result_rf[i][j] <= 0;

            mm_cnt <= 0;
            mm_img_cnt <= 0;

            out <= l1_distance_ff;
            out_valid <= 1;
        end
        endcase
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        fc_result_rf[0] <= 0;
        fc_result_rf[1] <= 0;
        fc_result_rf[2] <= 0;
        fc_result_rf[3] <= 0;
    end
    else  if(fc_valid_d1)
    begin
        fc_result_rf[0] <= fc_result_rf[1];
        fc_result_rf[1] <= fc_result_rf[2];
        fc_result_rf[2] <= fc_result_rf[3];
        fc_result_rf[3] <= fp_addsub0_out;
    end
    else if(ST_MM_NORM_ACT)
    begin
        fc_result_rf[0] <= fc_result_rf[1];
        fc_result_rf[1] <= fc_result_rf[2];
        fc_result_rf[2] <= fc_result_rf[3];
        fc_result_rf[3] <= 0;
    end
end

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        activation_result_rf[0][0] <= 0;
        activation_result_rf[1][0] <= 0;
        activation_result_rf[2][0] <= 0;
        activation_result_rf[3][0] <= 0;
        activation_result_rf[0][1] <= 0;
        activation_result_rf[1][1] <= 0;
        activation_result_rf[2][1] <= 0;
        activation_result_rf[3][1] <= 0;
    end
    else if(norm_act_d4)
    begin
        activation_result_rf[0][mm_img_cnt] <= activation_result_rf[1][mm_img_cnt];
        activation_result_rf[1][mm_img_cnt] <= activation_result_rf[2][mm_img_cnt];
        activation_result_rf[2][mm_img_cnt] <= activation_result_rf[3][mm_img_cnt];
        activation_result_rf[3][mm_img_cnt] <= fp_div1_out;
    end
end

//---------------------------------------------------------------------
//   MAX POOLING FP_CMP X4 and its input
//---------------------------------------------------------------------
// Find min max during fc calculation
always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        x_min_ff <= 0;
        x_max_ff <= 0;
    end
    else if(ST_MM_FC)
    begin
        if(fc_valid_d1)
        begin
            case(mm_cnt_d1)
            'd0:
            begin
                x_min_ff <= fp_addsub0_out;
                x_max_ff <= fp_addsub0_out;
            end
            default:
            begin
                if(~fp_cmp_results[0][0])
                    x_min_ff <= fp_addsub0_out;
                if(fp_cmp_results[0][1])
                    x_max_ff <= fp_addsub0_out;
            end
            endcase
        end
    end
end

reg[DATA_WIDTH-1:0] fp_cmp_input_a[0:1][0:1];
reg[DATA_WIDTH-1:0] fp_cmp_input_b[0:1][0:1];

always @(*)
begin
    fp_cmp_input_a[0][0] = 1;
    fp_cmp_input_a[0][1] = 1;
    fp_cmp_input_a[1][0] = 1;
    fp_cmp_input_a[1][1] = 1;

    fp_cmp_input_b[0][0] = 1;
    fp_cmp_input_b[0][1] = 1;
    fp_cmp_input_b[1][0] = 1;
    fp_cmp_input_b[1][1] = 1;
    if(ST_MM_MAX_POOLING)
    begin
        case(mm_cnt)
        'd0:
        begin
            fp_cmp_input_a[0][0] = convolution_result_rf[0][0][mm_img_cnt];
            fp_cmp_input_a[0][1] = convolution_result_rf[0][2][mm_img_cnt];
            fp_cmp_input_a[1][0] = convolution_result_rf[2][0][mm_img_cnt];
            fp_cmp_input_a[1][1] = convolution_result_rf[2][2][mm_img_cnt];

            fp_cmp_input_b[0][0] = convolution_result_rf[0][1][mm_img_cnt];
            fp_cmp_input_b[0][1] = convolution_result_rf[0][3][mm_img_cnt];
            fp_cmp_input_b[1][0] = convolution_result_rf[2][1][mm_img_cnt];
            fp_cmp_input_b[1][1] = convolution_result_rf[2][3][mm_img_cnt];
        end
        'd1:
        begin
            fp_cmp_input_a[0][0] = convolution_result_rf[1][0][mm_img_cnt];
            fp_cmp_input_a[0][1] = convolution_result_rf[1][2][mm_img_cnt];
            fp_cmp_input_a[1][0] = convolution_result_rf[3][0][mm_img_cnt];
            fp_cmp_input_a[1][1] = convolution_result_rf[3][2][mm_img_cnt];

            fp_cmp_input_b[0][0] = max_pooling_result_rf[0][0];
            fp_cmp_input_b[0][1] = max_pooling_result_rf[0][1];
            fp_cmp_input_b[1][0] = max_pooling_result_rf[1][0];
            fp_cmp_input_b[1][1] = max_pooling_result_rf[1][1];
        end
        'd2:
        begin
            fp_cmp_input_a[0][0] = convolution_result_rf[1][1][mm_img_cnt];
            fp_cmp_input_a[0][1] = convolution_result_rf[1][3][mm_img_cnt];
            fp_cmp_input_a[1][0] = convolution_result_rf[3][1][mm_img_cnt];
            fp_cmp_input_a[1][1] = convolution_result_rf[3][3][mm_img_cnt];

            fp_cmp_input_b[0][0] = max_pooling_result_rf[0][0];
            fp_cmp_input_b[0][1] = max_pooling_result_rf[0][1];
            fp_cmp_input_b[1][0] = max_pooling_result_rf[1][0];
            fp_cmp_input_b[1][1] = max_pooling_result_rf[1][1];
        end
        endcase
    end

    if(ST_MM_FC)
    // Critical path here. Try reducing it, using case statement shall makes things better
    begin
        // Since I am calculating the Min max at the same time
        // min
        fp_cmp_input_a[0][0] = fp_addsub0_out;
        fp_cmp_input_b[0][0] = x_min_ff;

        // max
        fp_cmp_input_a[0][1] = fp_addsub0_out;
        fp_cmp_input_b[0][1] = x_max_ff;
    end
end

generate
    for(idx = 0;idx<2;idx = idx+1)
        for(jdx = 0;jdx < 2;jdx=jdx+1)
        begin
            DW_fp_cmp_inst
                #(
                    .sig_width       (inst_sig_width),
                    .exp_width       (inst_exp_width),
                    .ieee_compliance (inst_ieee_compliance)
                )
                u_DW_fp_cmp_inst(
                    .inst_a         (  fp_cmp_input_a[idx][jdx]  ),
                    .inst_b         (  fp_cmp_input_b[idx][jdx]  ),
                    .inst_zctr      (           ),
                    .aeqb_inst      (           ),
                    .altb_inst      (           ),
                    .agtb_inst      ( fp_cmp_results[idx][jdx]  ),
                    .unordered_inst ( ),
                    .z0_inst        (        ),
                    .z1_inst        (        ),
                    .status0_inst   (   ),
                    .status1_inst   (   )
                );
        end
endgenerate

//---------------------------------------------------------------------
//   FULLY CONNECTED LAYERS FP_MULTS x2 , 1 ADD
//---------------------------------------------------------------------
DW_fp_mult_inst #(inst_sig_width,inst_exp_width,inst_ieee_compliance,en_ubr_flag)
                        u_DW_fp_mult_FC0(
                            .inst_a   (  fp_mult_fc_in_a[0]),
                            .inst_b   (  fp_mult_fc_in_b[0]),
                            .inst_rnd ( 3'b000              ),
                            .z_inst   (  fp_mult_FC_out[0]),
                            .status_inst  (   )
                        );
DW_fp_mult_inst #(inst_sig_width,inst_exp_width,inst_ieee_compliance,en_ubr_flag)
                        u_DW_fp_mult_FC1(
                            .inst_a   (   fp_mult_fc_in_a[1]),
                            .inst_b   (   fp_mult_fc_in_b[1]),
                            .inst_rnd ( 3'b000              ),
                            .z_inst   (  fp_mult_FC_out[1] ),
                            .status_inst  (   )
                        );

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        fp_add0_FC_d2 <= 0;
        fp_mult_fc_d1[0] <= 0;
        fp_mult_fc_d1[1] <= 0;
        fp_div0_out_d2 <= 0;

        norm_act_d2 <= 0;
        norm_act_d3 <= 0;
        norm_act_d4 <= 0;
    end
    else
    begin
        fp_div0_out_d2 <= fp_div0_out;
        fp_add0_FC_d2 <= fp_addsub0_out;
        fp_mult_fc_d1[0] <= fp_mult_FC_out[0];
        fp_mult_fc_d1[1] <= fp_mult_FC_out[1];

        norm_act_d2 <= norm_act_d1;
        norm_act_d3 <= norm_act_d2;
        norm_act_d4 <= norm_act_d3;
    end
end

always@(*)
begin
    fp_mult_fc_in_a[0] = 0;
    fp_mult_fc_in_a[1] = 0;

    fp_mult_fc_in_b[0] = 0;
    fp_mult_fc_in_b[1] = 0;

    if(ST_MM_FC)
    begin
        case(mm_cnt)
        'd0:
        begin
            fp_mult_fc_in_a[0] = max_pooling_result_rf[0][0];
            fp_mult_fc_in_a[1] = max_pooling_result_rf[0][1];

            fp_mult_fc_in_b[0] = weight_rf[0][0];
            fp_mult_fc_in_b[1] = weight_rf[1][0];
        end
        'd1:
        begin
            fp_mult_fc_in_a[0] = max_pooling_result_rf[0][0];
            fp_mult_fc_in_a[1] = max_pooling_result_rf[0][1];

            fp_mult_fc_in_b[0] = weight_rf[0][1];
            fp_mult_fc_in_b[1] = weight_rf[1][1];
        end
        'd2:
        begin
            fp_mult_fc_in_a[0] = max_pooling_result_rf[1][0];
            fp_mult_fc_in_a[1] = max_pooling_result_rf[1][1];
            fp_mult_fc_in_b[0] = weight_rf[0][0];
            fp_mult_fc_in_b[1] = weight_rf[1][0];
        end
        'd3:
        begin
            fp_mult_fc_in_a[0] = max_pooling_result_rf[1][0];
            fp_mult_fc_in_a[1] = max_pooling_result_rf[1][1];
            fp_mult_fc_in_b[0] = weight_rf[0][1];
            fp_mult_fc_in_b[1] = weight_rf[1][1];
        end
        endcase
    end
end

//---------------------------------------------------------------------------------
//   Min Max normalization, DIV , 2x Subtractions = 2x ADDERS, share it with
//---------------------------------------------------------------------------------

always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        fp_norm_sub0_out_d1 <= 0;
    end
    else if(ST_MM_NORM_ACT)
    begin
        fp_norm_sub0_out_d1  <= fp_addsub0_out;
    end
end

always @(*)
begin
    fp_div0_in_b = min_max_diff_ff;
    fp_div0_in_a = fp_norm_sub0_out_d1;

    if(opt_ff == 2 || opt_ff == 3)
    begin
        // tanh
        fp_div1_in_a = fp_sub2_act_d4;
        fp_div1_in_b = fp_add3_act_d4;
    end
    else
    begin
        fp_div1_in_a = FP_ONE;
        fp_div1_in_b = fp_add3_act_d4;
    end
end

localparam  div_sig_width = 22;
localparam  discarded_sig = inst_sig_width - div_sig_width;

wire[DATA_WIDTH-1-discarded_sig : 0] div0_temp_out;

DW_fp_div_inst
    #(
        .sig_width       (div_sig_width        ),
        .exp_width       (inst_exp_width       ),
        .ieee_compliance (inst_ieee_compliance ),
        .faithful_round  (faithful_round  ),
        .en_ubr_flag     (en_ubr_flag     )
    )
    u_DW_fp_div_0(
        .inst_a      (    fp_div0_in_a[DATA_WIDTH-1:discarded_sig] ),
        .inst_b      (    fp_div0_in_b[DATA_WIDTH-1:discarded_sig] ),
        .inst_rnd    (3'b000    ),
        .z_inst      (  div0_temp_out),
        .status_inst (  )
    );

assign fp_div0_out = {div0_temp_out,{discarded_sig{1'b0}}};


wire[DATA_WIDTH-1-discarded_sig : 0] div1_temp_out;

DW_fp_div_inst
    #(
        .sig_width       (div_sig_width        ),
        .exp_width       (inst_exp_width       ),
        .ieee_compliance (inst_ieee_compliance ),
        .faithful_round  (faithful_round  ),
        .en_ubr_flag     (en_ubr_flag     )
    )
    u_DW_fp_div_1(
        .inst_a      (    fp_div1_in_a[DATA_WIDTH-1:discarded_sig] ),
        .inst_b      (    fp_div1_in_b[DATA_WIDTH-1:discarded_sig] ),
        .inst_rnd    (3'b000    ),
        .z_inst      (  div1_temp_out),
        .status_inst (  )
    );

assign fp_div1_out = {div1_temp_out,{discarded_sig{1'b0}}};
//---------------------------------------------------------------------
//   Activation Sigmoid or tanh, 2 e^x and 1 Sub, 1 Add
//---------------------------------------------------------------------
always @(*) begin
    negation_in = 0;
    pos_exp_in  = 0;

    if(opt_ff == 0 || opt_ff == 1)
    begin
        negation_in = fp_div0_out_d2;
    end
    else
    begin
        negation_in = fp_div0_out_d2;
        pos_exp_in  = fp_div0_out_d2;
    end
end


always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
    begin
        fp_sub2_act_d4<=0;
        fp_add3_act_d4 <=0;
        exp_pos_result_d3 <= 0;
        exp_neg_result_d3 <= 0;
        act_valid_d2 <= 0;
    end
    else
    begin
        act_valid_d2 <= act_valid_d1;
        exp_pos_result_d3 <= exp_pos_result;
        exp_neg_result_d3 <= exp_neg_result;

        if(ST_MM_NORM_ACT)
        begin
            if(opt_ff == 0 || opt_ff == 1)
            begin
                //sigmoid
                fp_add3_act_d4<= fp_addsub3_out;
            end
            else
            begin
                //tanh
                fp_sub2_act_d4 <=  fp_addsub2_out;
                fp_add3_act_d4 <=  fp_addsub3_out;
            end
        end
    end
end

localparam  exp_sig_width = 19;
localparam  exp_discarded_sig = inst_sig_width - exp_sig_width;

wire[DATA_WIDTH-1-exp_discarded_sig : 0] exp_neg_result_temp;
wire[DATA_WIDTH-1-exp_discarded_sig : 0] exp_pos_result_temp;

DW_fp_exp_inst
    #(
        .inst_sig_width       (exp_sig_width       ),
        .inst_exp_width       (inst_exp_width       ),
        .inst_ieee_compliance (inst_ieee_compliance ),
        .inst_arch            (inst_arch            )
    )
    u_DW_fp_exp1(
        .inst_a      (negation[DATA_WIDTH-1:exp_discarded_sig]      ),
        .z_inst      (exp_neg_result_temp      ),
        .status_inst ( )
    );

DW_fp_exp_inst
    #(
        .inst_sig_width       (exp_sig_width       ),
        .inst_exp_width       (inst_exp_width       ),
        .inst_ieee_compliance (inst_ieee_compliance ),
        .inst_arch            (inst_arch            )
    )
    u_DW_fp_exp2(
        .inst_a      (pos_exp_in[DATA_WIDTH-1:exp_discarded_sig] ),
        .z_inst      (exp_pos_result_temp      ),
        .status_inst ( )
    );

assign exp_neg_result =  {exp_neg_result_temp , {exp_discarded_sig{1'b0}}};
assign exp_pos_result =  {exp_pos_result_temp , {exp_discarded_sig{1'b0}}};
//---------------------------------------------------------------------
//   L1 distance 1 SUB, 1 absolute, 1 ADD
//---------------------------------------------------------------------

always @(posedge clk or negedge rst_n)
begin:FP_ABS
    if(~rst_n)
    begin
        abs_out_0_d1 <= 0;
        abs_out_1_d1 <= 0;
        abs_out_2_d1 <= 0;
        abs_out_3_d1 <= 0;
    end
    else
    begin
        abs_out_0_d1 <=  (fp_addsub0_out[31] == 1) ? {1'b0,fp_addsub0_out[30:0]} : fp_addsub0_out;
        abs_out_1_d1 <=  (fp_addsub1_out[31] == 1) ? {1'b0,fp_addsub1_out[30:0]} : fp_addsub1_out;
        abs_out_2_d1 <=  (fp_addsub2_out[31] == 1) ? {1'b0,fp_addsub2_out[30:0]} : fp_addsub2_out;
        abs_out_3_d1 <=  (fp_addsub3_out[31] == 1) ? {1'b0,fp_addsub3_out[30:0]} : fp_addsub3_out;
    end
end

//---------------------------------------------------------------------
//   pipelined 3 Adders
//---------------------------------------------------------------------


always @(posedge clk or negedge rst_n)
begin
    if(~rst_n)
    begin
        fp_add_tree_d3[0] <= 0;
        fp_add_tree_d3[1] <= 0;
    end
    else
    begin
        fp_add_tree_d3[0] <= fp_add_tree_out[0];
        fp_add_tree_d3[1] <= fp_add_tree_out[1];
    end
end

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
          adder_tree0 ( .a(fp_add_tree_in_a[0]), .b(fp_add_tree_in_b[0]), .rnd(3'b000), .z(fp_add_tree_out[0]), .status() );

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
          adder_tree1 ( .a(fp_add_tree_in_a[1]), .b(fp_add_tree_in_b[1]), .rnd(3'b000), .z(fp_add_tree_out[1]), .status() );

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance)
          adder_tree2 ( .a(fp_add_tree_in_a[2]), .b(fp_add_tree_in_b[2]), .rnd(3'b000), .z(fp_add_tree_out[2]), .status() );

endmodule

 //---------------------------------------------------------------------
    //   Module Design
    //---------------------------------------------------------------------

    module DW_fp_mult_inst( inst_a, inst_b, inst_rnd, z_inst, status_inst );
parameter sig_width = 23;
parameter exp_width = 8;
parameter ieee_compliance = 1;
parameter en_ubr_flag = 0;

input [sig_width+exp_width : 0] inst_a;
input [sig_width+exp_width : 0] inst_b;
input [2 : 0] inst_rnd;
output [sig_width+exp_width : 0] z_inst;
output [7 : 0] status_inst;
// Instance of DW_fp_mult
DW_fp_mult #(sig_width, exp_width, ieee_compliance, en_ubr_flag)
           U1 ( .a(inst_a), .b(inst_b), .rnd(inst_rnd), .z(z_inst), .status(status_inst) );
endmodule

    module DW_fp_sum3_inst( inst_a, inst_b, inst_c, inst_rnd, z_inst,
                            status_inst );

parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;

input [inst_sig_width+inst_exp_width : 0] inst_a;
input [inst_sig_width+inst_exp_width : 0] inst_b;
input [inst_sig_width+inst_exp_width : 0] inst_c;
input [2 : 0] inst_rnd;
output [inst_sig_width+inst_exp_width : 0] z_inst;
output [7 : 0] status_inst;
// Instance of DW_fp_sum3
DW_fp_sum3 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type)
           U1 (
               .a(inst_a),
               .b(inst_b),
               .c(inst_c),
               .rnd(inst_rnd),
               .z(z_inst),
               .status(status_inst) );
endmodule

    module DW_fp_exp_inst( inst_a, z_inst, status_inst );
parameter inst_sig_width = 10;

parameter inst_exp_width = 5;

parameter inst_ieee_compliance = 1;

parameter inst_arch = 2;

input [inst_sig_width+inst_exp_width : 0] inst_a;
output [inst_sig_width+inst_exp_width : 0] z_inst;
output [7 : 0] status_inst;

// Instance of DW_fp_exp
DW_fp_exp #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch) U1 (
              .a(inst_a),
              .z(z_inst),
              .status(status_inst) );
endmodule


    module DW_fp_div_inst( inst_a, inst_b, inst_rnd, z_inst, status_inst );
parameter sig_width = 23;
parameter exp_width = 8;
parameter ieee_compliance = 0;
parameter faithful_round = 0;
parameter en_ubr_flag = 0;

input [sig_width+exp_width : 0] inst_a;
input [sig_width+exp_width : 0] inst_b;
input [2 : 0] inst_rnd;
output [sig_width+exp_width : 0] z_inst;
output [7 : 0] status_inst;
// Instance of DW_fp_div
DW_fp_div #(sig_width, exp_width, ieee_compliance, faithful_round, en_ubr_flag) U1
          ( .a(inst_a), .b(inst_b), .rnd(inst_rnd), .z(z_inst), .status(status_inst)
          );
endmodule

    module DW_fp_cmp_inst( inst_a, inst_b, inst_zctr, aeqb_inst, altb_inst,
                           agtb_inst, unordered_inst, z0_inst, z1_inst, status0_inst,
                           status1_inst );
parameter sig_width = 23;
parameter exp_width = 8;
parameter ieee_compliance = 0;
input [sig_width+exp_width : 0] inst_a;
input [sig_width+exp_width : 0] inst_b;
input inst_zctr;
output aeqb_inst;
output altb_inst;
output agtb_inst;
output unordered_inst;
output [sig_width+exp_width : 0] z0_inst;
output [sig_width+exp_width : 0] z1_inst;
output [7 : 0] status0_inst;
output [7 : 0] status1_inst;
// Instance of DW_fp_cmp
DW_fp_cmp #(sig_width, exp_width, ieee_compliance)
          U1 ( .a(inst_a), .b(inst_b), .zctr(inst_zctr), .aeqb(aeqb_inst),
               .altb(altb_inst), .agtb(agtb_inst), .unordered(unordered_inst),
               .z0(z0_inst), .z1(z1_inst), .status0(status0_inst),
               .status1(status1_inst) );
endmodule

    module DW_fp_add_inst( inst_a, inst_b, inst_rnd, z_inst, status_inst );
parameter sig_width = 23;
parameter exp_width = 8;
parameter ieee_compliance = 0;
input [sig_width+exp_width : 0] inst_a;
input [sig_width+exp_width : 0] inst_b;
input [2 : 0] inst_rnd;
output [sig_width+exp_width : 0] z_inst;
output [7 : 0] status_inst;
// Instance of DW_fp_add
DW_fp_add #(sig_width, exp_width, ieee_compliance)
          U1 ( .a(inst_a), .b(inst_b), .rnd(inst_rnd), .z(z_inst), .status(status_inst) );
endmodule


    module DW_fp_sub_inst( inst_a, inst_b, inst_rnd, z_inst, status_inst );
parameter sig_width = 23;
parameter exp_width = 8;
parameter ieee_compliance = 0;
input [sig_width+exp_width : 0] inst_a;
input [sig_width+exp_width : 0] inst_b;
input [2 : 0] inst_rnd;
output [sig_width+exp_width : 0] z_inst;
output [7 : 0] status_inst;
// Instance of DW_fp_sub
DW_fp_sub #(sig_width, exp_width, ieee_compliance)
          U1 ( .a(inst_a), .b(inst_b), .rnd(inst_rnd), .z(z_inst), .status(status_inst) );
endmodule

module DW_fp_addsub_inst( inst_a, inst_b, inst_rnd, inst_op, z_inst,
status_inst );
parameter sig_width = 23;
parameter exp_width = 8;
parameter ieee_compliance = 0;
input [sig_width+exp_width : 0] inst_a;
input [sig_width+exp_width : 0] inst_b;
input [2 : 0] inst_rnd;
input inst_op;
output [sig_width+exp_width : 0] z_inst;
output [7 : 0] status_inst;
// Instance of DW_fp_addsub
DW_fp_addsub #(sig_width, exp_width, ieee_compliance)
U1 ( .a(inst_a), .b(inst_b), .rnd(inst_rnd),
.op(inst_op), .z(z_inst), .status(status_inst) );
endmodule

module DW_fp_sum4_inst( inst_a, inst_b, inst_c, inst_d, inst_rnd,
z_inst, status_inst );

parameter inst_sig_width = 23;
parameter inst_exp_width = 8;
parameter inst_ieee_compliance = 0;
parameter inst_arch_type = 0;
input [inst_sig_width+inst_exp_width : 0] inst_a;
input [inst_sig_width+inst_exp_width : 0] inst_b;
input [inst_sig_width+inst_exp_width : 0] inst_c;
input [inst_sig_width+inst_exp_width : 0] inst_d;
input [2 : 0] inst_rnd;
output [inst_sig_width+inst_exp_width : 0] z_inst;
output [7 : 0] status_inst;
// Instance of DW_fp_sum4
DW_fp_sum4 #(inst_sig_width, inst_exp_width, inst_ieee_compliance, inst_arch_type)
U1 (
.a(inst_a),
.b(inst_b),
.c(inst_c),
.d(inst_d),
.rnd(inst_rnd),
.z(z_inst),
.status(status_inst) );
endmodule
