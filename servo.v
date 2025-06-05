   module servo #(
    parameter CLK_FREQ = 25_000_000,
    parameter PERIOD = 40 
) (
    input wire clk,
    input wire rst_n,
    output wire servo_out
);
    localparam integer DUTY_MIN = 2; // 5% de 40
    localparam integer DUTY_MAX = 4; // 10% de 40

    localparam integer TOGGLE_TIME = 200;

    reg [31:0] time_counter = 0;
    reg position_select = 0;
    reg [31:0] duty_cycle = DUTY_MIN;

    always @(posedge clk) begin
        if (!rst_n) begin
            time_counter <= 0;
            position_select <= 0;
            duty_cycle <= DUTY_MIN;
        end else begin
            if (time_counter < TOGGLE_TIME - 1)
                time_counter <= time_counter + 1;
            else begin
                time_counter <= 0;
                position_select <= ~position_select;
                duty_cycle <= (position_select == 1'b0) ? DUTY_MAX : DUTY_MIN;
            end
        end
    end

    PWM pwm_inst (
        .clk(clk),
        .rst_n(rst_n),
        .duty_cycle(duty_cycle),
        .period(PERIOD),
        .pwm_out(servo_out)
    );

endmodule