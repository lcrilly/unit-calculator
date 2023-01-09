package com.calculator.multiply;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestBody;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;

@SpringBootApplication
@RestController

public class MultiplyApplication {

	public static void main(String[] args) {
		SpringApplication.run(MultiplyApplication.class, args);
	}

	@PostMapping("/multiply")
	public String multiply(@RequestBody JsonNode body) {
		Double product = 1.0;
        JsonNode operands = body.path("operands");
		for(JsonNode operand : operands) {
            product = product * operand.asDouble();
		}

		if(product % 1 == 0)
			return String.format("{\"result\": %.0f}\n", product);
		else
			return String.format("{\"result\": %s}\n", product);
	}
}
