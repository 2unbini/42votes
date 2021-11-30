package com.example.votesspring.controller;

import io.swagger.v3.oas.annotations.Operation;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

@RestController
public class HealthController {

    @GetMapping("/")
    @Operation(summary = "서버가 정상작동하는지 확인합니다.")
    public String healthcheck() {
        return "Server Working";
    }
}
