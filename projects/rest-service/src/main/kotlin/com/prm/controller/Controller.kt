package com.prm.controller

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("prm")
class Controller {

    @GetMapping("/hello")
    fun hello(): String = "Hello K8s"

}