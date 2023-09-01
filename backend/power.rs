use serde_json::Value;
use unit_wasm::rusty::*;
use std::ptr::null_mut;

// Buffer of some size to store the copy of the request
static mut REQUEST_BUF: *mut u8 = null_mut();

#[no_mangle]
pub extern "C" fn uwr_module_end_handler() {
    unsafe {
        uwr_free(REQUEST_BUF);
    }
}

#[no_mangle]
pub extern "C" fn uwr_module_init_handler() {
    unsafe {
        REQUEST_BUF = uwr_malloc(uwr_mem_get_init_size());
    }
}

#[no_mangle]
pub extern "C" fn uwr_request_handler(addr: *mut u8) -> i32 {
    // Declare a 0-initialised context structure
    let ctx = &mut UWR_CTX_INITIALIZER();
    // Initialise the context structure.
    uwr_init_ctx(ctx, addr, 4096);

    // Set where we will copy the request into
    unsafe {
        uwr_set_req_buf(ctx, &mut REQUEST_BUF, LUW_SRB_NONE);
    }

    // Deserialize the request body into a JSON object
    let json_object: Value = serde_json::from_str(uwr_get_http_content_str(ctx)).unwrap();

    // Access the "operands" field and iterate over the array of numbers.
    if let Some(operands) = json_object.get("operands") {
        if operands.is_array() {
            let mut result = 0.0;
            for number in operands.as_array().unwrap() {
                if let Some(operand) = number.as_f64() {
                	if result == 0.0 {
                		result = operand;
                	} else {
	                    result = f64::powf(result, operand);
	                }
                }
            }
            // Store the response body
            uwr_write_str!(ctx, "{{\"result\": {}}}\n", result);
        }
    }    

    // Prepare the response headers
    uwr_http_init_headers(ctx, 2, 0);
    uwr_http_add_header(ctx, "Content-Type", "application/json");
    uwr_http_add_header(ctx, "Content-Length", &format!("{}", uwr_get_response_data_size(ctx)));

    // Send the full response
    uwr_http_send_headers(ctx);
    uwr_http_send_response(ctx);
    uwr_http_response_end();

    return 0;
}
