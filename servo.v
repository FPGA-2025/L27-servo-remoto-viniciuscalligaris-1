   module servo #(
    parameter CLK_FREQ = 25_000_000,
    parameter PERIOD = 500_000 
) (
    input wire clk,
    input wire rst_n,
    output wire servo_out
);
    localparam integer DUTY_MIN = PERIOD / 20; // 5% duty cycle
    localparam integer DUTY_MAX = PERIOD / 10; // 10% duty cycle

    localparam integer TOGGLE_TIME = 5*CLK_FREQ; // 5 segundos (5 * 25_000_000)

    reg [31:0] time_counter;
    reg state;
    reg [31:0] duty_cycle;

    localparam pulse_width_MAX = 1'b1;
    localparam pulse_width_MIN = 1'b0;

    always @(posedge clk) begin
        if (!rst_n) begin
            time_counter <= 0;
            duty_cycle <= DUTY_MIN;
            state <= pulse_width_MIN;
        end else begin
            if (time_counter < TOGGLE_TIME - 1)
                time_counter <= time_counter + 1;
            else begin
                time_counter <= 0;
                if (state == pulse_width_MIN) begin
                    duty_cycle <= DUTY_MAX;
                end else begin
                    duty_cycle <= DUTY_MIN;
                end
                state <= ~state;
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