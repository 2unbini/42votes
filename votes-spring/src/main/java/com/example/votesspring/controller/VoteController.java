package com.example.votesspring.controller;

import io.swagger.annotations.*;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Api
@RestController
@RequestMapping("/v1")
public class VoteController {

    @PostMapping("/answers/{userId}")
    @Operation(summary = "투표를 진행합니다.",
            description = "User의 정보를 통해서 선택한 answer_id가 중복으로 진행되었는지 확인하고 answer의 count를 증가시킵니다.")
    public ResponseEntity<String> postAnswer(@PathVariable Long userId,
                                             @RequestBody(required = true) Long answerId) {
        return ResponseEntity.ok(userId + "가 " + answerId + "에 투표했습니다.");
    }
}
