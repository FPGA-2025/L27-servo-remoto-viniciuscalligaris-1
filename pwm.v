module PWM (
    input wire clk,
    input wire rst_n,
    input wire [31:0] duty_cycle, // duty cycle final = duty_cycle / period
    input wire [31:0] period, // pwm_freq = clk_freq / period
    output reg pwm_out
);

    reg [31:0] counter;
    reg pwm_next;

    always @(posedge clk) begin
        if (!rst_n) begin
            counter <= 32'd0;
            pwm_out <= 1'b0;
        end else begin
            if (counter >= period - 1)
                counter <= 32'd0;
            else
                counter <= counter + 32'd1;
                pwm_next = (counter < duty_cycle) ? 1'b1 : 1'b0;
                pwm_out  <= pwm_next;
        end
    end
    
endmodule